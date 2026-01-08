import 'dart:developer';

import 'package:project_management/feature/project/data/service/get_project_list_api.dart';
import 'package:project_management/feature/project/model/get_project_details_response_model.dart';

class ProjectDetailsRepository {
  final GetProjectListApi _projectApi;

  // Cache for project details
  final Map<String, Data> _projectDetailsCache = {};
  final List<String> _recentlyViewed = [];
  static const int maxCacheSize = 20;
  static const int maxRecentlyViewed = 10;

  ProjectDetailsRepository({GetProjectListApi? projectApi})
    : _projectApi = projectApi ?? GetProjectListApi.instance;

  // =============== MAIN METHODS ===============

  /// Get project details by ID with caching
  Future<GetProjectDetailsResponseModel> getProjectDetails({
    required String projectId,
    bool forceRefresh = false,
    bool addToRecentlyViewed = true,
  }) async {
    try {
      // Check cache first (if not forcing refresh)
      if (!forceRefresh && _projectDetailsCache.containsKey(projectId)) {
        final cachedData = _projectDetailsCache[projectId];
        log('Returning cached details for project: $projectId');

        // Update recently viewed if requested
        if (addToRecentlyViewed) {
          _addToRecentlyViewed(projectId);
        }

        return GetProjectDetailsResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache',
          data: cachedData,
        );
      }

      // Call API
      log('Fetching project details from API for ID: $projectId');
      final response = await _projectApi.getProjectDetails(
        projectId: projectId,
      );

      // Check response
      if (!response.success) {
        throw ProjectDetailsFailure(
          response.message ?? 'Failed to fetch project details',
        );
      }

      final detailsData = response.data;
      if (detailsData == null) {
        throw ProjectDetailsFailure('No data received from server');
      }

      // Cache the project details
      if (detailsData.data != null) {
        _projectDetailsCache[projectId] = detailsData.data!;
        _cleanupCache();

        // Update recently viewed if requested
        if (addToRecentlyViewed) {
          _addToRecentlyViewed(projectId);
        }
      }

      return detailsData;
    } catch (e) {
      // Try to return cached data if available
      if (_projectDetailsCache.containsKey(projectId)) {
        log('API failed, returning cached details: $e');
        return GetProjectDetailsResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache (offline)',
          data: _projectDetailsCache[projectId],
        );
      }

      return _handleError(e);
    }
  }


  /// Refresh project details (force API call)
  Future<GetProjectDetailsResponseModel> refreshProjectDetails(
    String projectId,
  ) async {
    return getProjectDetails(projectId: projectId, forceRefresh: true);
  }

  // =============== CACHE MANAGEMENT ===============

  /// Get project details from cache only
  Data? getCachedProjectDetails(String projectId) {
    return _projectDetailsCache[projectId];
  }

  /// Get all cached project details
  List<Data> getAllCachedProjectDetails() {
    return _projectDetailsCache.values.toList();
  }

  /// Get recently viewed projects
  List<Data> getRecentlyViewedProjects() {
    final projects = <Data>[];

    for (final projectId in _recentlyViewed.reversed) {
      final project = _projectDetailsCache[projectId];
      if (project != null) {
        projects.add(project);
      }
    }

    return projects;
  }

  /// Check if project exists in cache
  bool isCached(String projectId) {
    return _projectDetailsCache.containsKey(projectId);
  }

  /// Get cached project age (in milliseconds since cache)
  int? getCacheAge(String projectId) {
    // You could implement this if you track cache timestamps
    return null;
  }

  /// Clear all cache
  void clearAllCache() {
    _projectDetailsCache.clear();
    _recentlyViewed.clear();
  }

  /// Clear specific project from cache
  void clearProjectFromCache(String projectId) {
    _projectDetailsCache.remove(projectId);
    _recentlyViewed.remove(projectId);
  }

  /// Pre-cache project details (useful for offline support)
  void preCacheProjectDetails(Data projectData) {
    if (projectData.id != null) {
      _projectDetailsCache[projectData.id!] = projectData;
      _cleanupCache();
    }
  }

  /// Batch pre-cache project details
  void batchPreCacheProjectDetails(List<Data> projects) {
    for (final project in projects) {
      if (project.id != null) {
        _projectDetailsCache[project.id!] = project;
      }
    }
    _cleanupCache();
  }

  // =============== SEARCH & FILTER ===============

  /// Search projects in cache by name
  List<Data> searchInCache(String query) {
    final queryLower = query.toLowerCase();
    return _projectDetailsCache.values
        .where((data) => data.name?.toLowerCase().contains(queryLower) ?? false)
        .toList();
  }

  /// Filter projects by status
  List<Data> filterByPaymentStatus(String status) {
    return _projectDetailsCache.values
        .where((data) => data.cPaymentStatus == status)
        .toList();
  }

  /// Filter projects by type
  List<Data> filterByProjectType(String type) {
    return _projectDetailsCache.values
        .where((data) => data.projectType == type)
        .toList();
  }

  /// Get active projects
  List<Data> getActiveProjects() {
    return _projectDetailsCache.values
        .where((data) => data.isActive == true)
        .toList();
  }

  /// Get projects by employee ID
  List<Data> getProjectsByEmployee(String employeeId) {
    return _projectDetailsCache.values
        .where((data) => data.employeeId == employeeId)
        .toList();
  }

  /// Get projects by user ID
  List<Data> getProjectsByUser(String userId) {
    return _projectDetailsCache.values
        .where((data) => data.userId == userId)
        .toList();
  }

  // =============== STATISTICS ===============

  /// Get cache statistics
  Map<String, dynamic> getCacheStatistics() {
    final activeProjects = getActiveProjects();
    final recentlyViewed = getRecentlyViewedProjects();

    // Count by payment status
    final paidCount = _projectDetailsCache.values
        .where(
          (data) =>
              data.cPaymentStatus == 'PAID' || data.cPaymentStatus == 'paid',
        )
        .length;

    final unpaidCount = _projectDetailsCache.values
        .where(
          (data) =>
              data.cPaymentStatus == 'UNPAID' ||
              data.cPaymentStatus == 'unpaid',
        )
        .length;

    // Count by project type
    final monthlyCount = _projectDetailsCache.values
        .where(
          (data) =>
              data.projectType == 'MONTHLY' || data.projectType == 'monthly',
        )
        .length;

    final projectBasedCount = _projectDetailsCache.values
        .where(
          (data) =>
              data.projectType == 'PROJECT_BASED' ||
              data.projectType == 'project_based',
        )
        .length;

    return {
      'totalCached': _projectDetailsCache.length,
      'recentlyViewed': recentlyViewed.length,
      'activeProjects': activeProjects.length,
      'paidProjects': paidCount,
      'unpaidProjects': unpaidCount,
      'monthlyProjects': monthlyCount,
      'projectBasedProjects': projectBasedCount,
      'cacheSize': _projectDetailsCache.length,
    };
  }

  /// Get project statistics for a specific project
  Map<String, dynamic> getProjectStatistics(String projectId) {
    final project = _projectDetailsCache[projectId];

    if (project == null) {
      return {'error': 'Project not found in cache', 'projectId': projectId};
    }

    return {
      'projectId': project.id,
      'name': project.name,
      'isActive': project.isActive,
      'paymentStatus': project.cPaymentStatus,
      'projectType': project.projectType,
      'hasSocialLinks': (project.social?.isNotEmpty ?? false),
      'hasWorksheets': (project.workSheet?.isNotEmpty ?? false),
      'socialCount': project.social?.length ?? 0,
      'worksheetCount': project.workSheet?.length ?? 0,
      'isRecentlyViewed': _recentlyViewed.contains(projectId),
      'cached': true,
    };
  }

  /// Get projects with missing information
  List<Data> getProjectsWithMissingInfo() {
    return _projectDetailsCache.values
        .where(
          (data) =>
              data.name == null ||
              data.name!.isEmpty ||
              data.projectType == null ||
              data.projectType!.isEmpty ||
              data.cPaymentStatus == null ||
              data.cPaymentStatus!.isEmpty,
        )
        .toList();
  }

  // =============== PRIVATE HELPER METHODS ===============

  void _addToRecentlyViewed(String projectId) {
    // Remove if already exists
    _recentlyViewed.remove(projectId);

    // Add to beginning
    _recentlyViewed.insert(0, projectId);

    // Limit size
    if (_recentlyViewed.length > maxRecentlyViewed) {
      _recentlyViewed.removeLast();
    }
  }

  void _cleanupCache() {
    // Keep only maxCacheSize items in cache
    if (_projectDetailsCache.length > maxCacheSize) {
      // Remove items that aren't recently viewed
      final keysToRemove = <String>[];

      for (final key in _projectDetailsCache.keys) {
        if (!_recentlyViewed.contains(key) ||
            _recentlyViewed.indexOf(key) >= maxRecentlyViewed) {
          keysToRemove.add(key);

          // Stop when we've removed enough
          if (_projectDetailsCache.length - keysToRemove.length <=
              maxCacheSize) {
            break;
          }
        }
      }

      // Remove the keys
      for (final key in keysToRemove) {
        _projectDetailsCache.remove(key);
      }
    }
  }

  GetProjectDetailsResponseModel _handleError(dynamic e) {
    String errorMessage;

    if (e is ProjectDetailsFailure) {
      errorMessage = e.message;
    } else {
      final errorString = e.toString();

      if (errorString.contains('timeout') ||
          errorString.contains('SocketException')) {
        errorMessage = 'Connection timeout. Check your internet.';
      } else if (errorString.contains('401') || errorString.contains('403')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (errorString.contains('404')) {
        errorMessage = 'Project not found.';
      } else if (errorString.contains('500')) {
        errorMessage = 'Server error. Try again later.';
      } else {
        errorMessage = 'Failed to load project details. Please try again.';
      }
    }

    return GetProjectDetailsResponseModel(
      statusCode: 500,
      success: false,
      message: errorMessage,
      data: null,
    );
  }

  // =============== UTILITY METHODS ===============

  /// Validate project data
  bool validateProjectData(Data data) {
    return data.id != null &&
        data.id!.isNotEmpty &&
        data.name != null &&
        data.name!.isNotEmpty;
  }

  /// Extract project IDs from list
  List<String> extractProjectIds(List<Data> projects) {
    return projects
        .where((project) => project.id != null && project.id!.isNotEmpty)
        .map((project) => project.id!)
        .toList();
  }

  /// Check if projects exist in cache
  Map<String, bool> checkProjectsInCache(List<String> projectIds) {
    final result = <String, bool>{};

    for (final projectId in projectIds) {
      result[projectId] = _projectDetailsCache.containsKey(projectId);
    }

    return result;
  }

  /// Get projects that need refresh (older than specified time)
  List<String> getProjectsNeedingRefresh({int maxAgeInMinutes = 60}) {
    // Implement this if you track cache timestamps
    return [];
  }

  /// Compare two project data objects
  Map<String, dynamic> compareProjectData(Data oldData, Data newData) {
    final differences = <String, dynamic>{};

    if (oldData.name != newData.name) {
      differences['name'] = {'old': oldData.name, 'new': newData.name};
    }

    if (oldData.projectType != newData.projectType) {
      differences['projectType'] = {
        'old': oldData.projectType,
        'new': newData.projectType,
      };
    }

    if (oldData.cPaymentStatus != newData.cPaymentStatus) {
      differences['cPaymentStatus'] = {
        'old': oldData.cPaymentStatus,
        'new': newData.cPaymentStatus,
      };
    }

    if (oldData.isActive != newData.isActive) {
      differences['isActive'] = {
        'old': oldData.isActive,
        'new': newData.isActive,
      };
    }

    return {
      'hasChanges': differences.isNotEmpty,
      'differences': differences,
      'projectId': oldData.id,
    };
  }
}

class ProjectDetailsFailure implements Exception {
  final String message;
  ProjectDetailsFailure(this.message);

  @override
  String toString() => message;
}
