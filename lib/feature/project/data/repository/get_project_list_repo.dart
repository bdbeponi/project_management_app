// import 'dart:developer';

// import 'package:project_management/feature/project/data/service/get_project_list_api.dart';
// import 'package:project_management/feature/project/model/get_project_list_response_model.dart';

// class ProjectRepository {
//   final GetProjectListApi _projectApi;

//   // Pagination state
//   int _currentPage = 1;
//   int _totalPages = 1;
//   int _totalItems = 0;
//   int _pageSize = 10;
//   String _currentSearch = '';
//   String _currentOrderBy = 'desc';
//   String? _currentRole;
//   String? _currentStatus;

//   // Cache management
//   final Map<int, List<Item>> _pageCache = {};
//   final Map<String, List<Item>> _searchCache = {};

//   ProjectRepository({GetProjectListApi? projectApi})
//     : _projectApi = projectApi ?? GetProjectListApi.instance;

//   /// Fetch project list with pagination
//   Future<GetProjectListResponseModel> getProjects({
//     int page = 1,
//     int pageSize = 10,
//     String search = '',
//     String orderBy = 'desc',
//     String? role,
//     String? status,
//     bool forceRefresh = false,
//   }) async {
//     try {
//       // Update current parameters
//       _currentPage = page;
//       _pageSize = pageSize;
//       _currentSearch = search;
//       _currentOrderBy = orderBy;
//       _currentRole = role;
//       _currentStatus = status;

//       // Generate cache key for this specific query
//       final cacheKey = _generateCacheKey(
//         page: page,
//         search: search,
//         orderBy: orderBy,
//         role: role,
//         status: status,
//       );

//       // Check cache first (if not forcing refresh)
//       if (!forceRefresh && _searchCache.containsKey(cacheKey)) {
//         log('Returning cached data for page $page with search: "$search"');
//         return GetProjectListResponseModel(
//           statusCode: 200,
//           success: true,
//           message: 'Loaded from cache',
//           data: Data(
//             items: _searchCache[cacheKey],
//             meta: Meta(
//               currentPage: page,
//               from: ((page - 1) * pageSize) + 1,
//               lastPage: _totalPages,
//               perPage: pageSize,
//               to: page * pageSize,
//               total: _totalItems,
//             ),
//           ),
//         );
//       }

//       // Call API
//       log('Fetching projects from API - Page: $page, Search: "$search"');
//       final response = await _projectApi.getProjectList(
//         page: page,
//         pageSize: pageSize,
//         search: search,
//         orderBy: orderBy,
//         role: role,
//         status: status,
//       );

//       // Check response
//       if (!response.success) {
//         throw ProjectFailure(response.message ?? 'Failed to fetch projects');
//       }

//       final projectData = response.data;
//       if (projectData == null) {
//         throw ProjectFailure('No data received from server');
//       }

//       // Update pagination info
//       if (projectData.data?.meta != null) {
//         _totalPages = projectData.data!.meta!.lastPage ?? 1;
//         _totalItems = projectData.data!.meta!.total ?? 0;
//       } else {
//         // Default values if meta is null
//         _totalPages = 1;
//         _totalItems = projectData.data?.items?.length ?? 0;
//       }

//       // Cache the results
//       if (projectData.data?.items != null) {
//         // Cache by page number
//         _pageCache[page] = projectData.data!.items!;

//         // Cache by search query key
//         _searchCache[cacheKey] = projectData.data!.items!;

//         // Clean up old cache entries if needed
//         _cleanupCache();
//       }

//       return projectData;
//     } catch (e) {
//       // Try to return cached data if available
//       final cacheKey = _generateCacheKey(
//         page: page,
//         search: search,
//         orderBy: orderBy,
//         role: role,
//         status: status,
//       );

//       if (_searchCache.containsKey(cacheKey)) {
//         log('API failed, returning cached data: $e');
//         return GetProjectListResponseModel(
//           statusCode: 200,
//           success: true,
//           message: 'Loaded from cache (offline)',
//           data: Data(
//             items: _searchCache[cacheKey],
//             meta: Meta(
//               currentPage: page,
//               from: ((page - 1) * pageSize) + 1,
//               lastPage: _totalPages,
//               perPage: pageSize,
//               to: page * pageSize,
//               total: _totalItems,
//             ),
//           ),
//         );
//       }

//       // Handle specific errors with proper null safety
//       return _handleError(e);
//     }
//   }

//   /// Load next page
//   Future<GetProjectListResponseModel> loadNextPage() async {
//     final nextPage = _currentPage + 1;

//     if (nextPage > _totalPages) {
//       return GetProjectListResponseModel(
//         statusCode: 400,
//         success: false,
//         message: 'No more pages available',
//         data: null,
//       );
//     }

//     return getProjects(
//       page: nextPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       role: _currentRole,
//       status: _currentStatus,
//     );
//   }

//   /// Load previous page
//   Future<GetProjectListResponseModel> loadPreviousPage() async {
//     final prevPage = _currentPage - 1;

//     if (prevPage < 1) {
//       return GetProjectListResponseModel(
//         statusCode: 400,
//         success: false,
//         message: 'Already on first page',
//         data: null,
//       );
//     }

//     return getProjects(
//       page: prevPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       role: _currentRole,
//       status: _currentStatus,
//     );
//   }

//   /// Refresh current page
//   Future<GetProjectListResponseModel> refreshCurrentPage() async {
//     return getProjects(
//       page: _currentPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       role: _currentRole,
//       status: _currentStatus,
//       forceRefresh: true,
//     );
//   }

//   /// Search projects (resets to page 1)
//   Future<GetProjectListResponseModel> searchProjects({
//     required String query,
//     String? role,
//     String? status,
//   }) async {
//     // Clear search-specific cache when starting new search
//     _clearSearchCache();

//     return getProjects(
//       page: 1,
//       pageSize: _pageSize,
//       search: query,
//       orderBy: _currentOrderBy,
//       role: role,
//       status: status,
//     );
//   }

//   /// Filter projects by status
//   Future<GetProjectListResponseModel> filterByStatus({
//     required String status,
//   }) async {
//     return getProjects(
//       page: 1,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       role: _currentRole,
//       status: status,
//     );
//   }

//   /// Filter projects by role
//   Future<GetProjectListResponseModel> filterByRole({
//     required String role,
//   }) async {
//     return getProjects(
//       page: 1,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       role: role,
//       status: _currentStatus,
//     );
//   }

//   /// Sort projects
//   Future<GetProjectListResponseModel> sortProjects({
//     required String orderBy,
//   }) async {
//     return getProjects(
//       page: _currentPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: orderBy,
//       role: _currentRole,
//       status: _currentStatus,
//     );
//   }

//   /// Get project by ID
//   Future<Item?> getProjectById(String projectId) async {
//     try {
//       // Check all cached items first
//       for (final items in _searchCache.values) {
//         for (final item in items) {
//           if (item.id == projectId) {
//             return item;
//           }
//         }
//       }

//       // If not found in cache, you could implement a separate API call here
//       return null;
//     } catch (e) {
//       log('Error getting project by ID: $e');
//       return null;
//     }
//   }

//   /// Get all cached projects (flattened)
//   List<Item> getAllCachedProjects() {
//     final allItems = <Item>[];
//     for (final items in _searchCache.values) {
//       allItems.addAll(items);
//     }
//     return allItems;
//   }

//   /// Get cached projects for current search
//   List<Item> getCachedProjectsForCurrentSearch() {
//     final cacheKey = _generateCacheKey(
//       page: _currentPage,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       role: _currentRole,
//       status: _currentStatus,
//     );

//     return _searchCache[cacheKey] ?? [];
//   }

//   /// Clear all cache
//   void clearCache() {
//     _pageCache.clear();
//     _searchCache.clear();
//     _currentPage = 1;
//     _totalPages = 1;
//     _totalItems = 0;
//   }

//   /// Clear only search cache (keep page cache)
//   void _clearSearchCache() {
//     _searchCache.clear();
//   }

//   /// Get current pagination info
//   Map<String, dynamic> getPaginationInfo() {
//     return {
//       'currentPage': _currentPage,
//       'totalPages': _totalPages,
//       'totalItems': _totalItems,
//       'pageSize': _pageSize,
//       'hasMore': _currentPage < _totalPages,
//     };
//   }

//   /// Get current search/filter parameters
//   Map<String, dynamic> getCurrentFilters() {
//     return {
//       'search': _currentSearch,
//       'orderBy': _currentOrderBy,
//       'role': _currentRole,
//       'status': _currentStatus,
//     };
//   }

//   // Private helper methods
//   String _generateCacheKey({
//     required int page,
//     required String search,
//     required String orderBy,
//     String? role,
//     String? status,
//   }) {
//     return '${page}_${search}_${orderBy}_${role ?? ''}_${status ?? ''}';
//   }

//   void _cleanupCache() {
//     // Keep only last 10 search queries in cache
//     if (_searchCache.length > 10) {
//       final keys = _searchCache.keys.toList();
//       for (int i = 0; i < keys.length - 10; i++) {
//         _searchCache.remove(keys[i]);
//       }
//     }
//   }

//   GetProjectListResponseModel _handleError(dynamic e) {
//     String errorMessage;

//     if (e is ProjectFailure) {
//       errorMessage = e.message;
//     } else {
//       final errorString = e.toString();

//       if (errorString.contains('timeout') ||
//           errorString.contains('SocketException')) {
//         errorMessage = 'Connection timeout. Check your internet.';
//       } else if (errorString.contains('401') || errorString.contains('403')) {
//         errorMessage = 'Session expired. Please login again.';
//       } else if (errorString.contains('404')) {
//         errorMessage = 'Projects not found.';
//       } else if (errorString.contains('500')) {
//         errorMessage = 'Server error. Try again later.';
//       } else {
//         errorMessage = 'Failed to load projects. Please try again.';
//       }
//     }

//     // Return error response instead of throwing
//     return GetProjectListResponseModel(
//       statusCode: 500,
//       success: false,
//       message: errorMessage,
//       data: null,
//     );
//   }

//   /// Get statistics from cached projects
//   Map<String, int> getProjectStats() {
//     final cachedProjects = getAllCachedProjects();

//     int activeCount = 0;
//     int monthlyCount = 0;
//     int projectBasedCount = 0;
//     int paidCount = 0;
//     int unpaidCount = 0;

//     for (final project in cachedProjects) {
//       if (project.isActive == true) {
//         activeCount++;
//       }

//       if (project.projectType == ProjectType.MONTHLY) {
//         monthlyCount++;
//       } else if (project.projectType == ProjectType.PROJECT_BASED) {
//         projectBasedCount++;
//       }

//       if (project.cPaymentStatus == PaymentStatus.PAID) {
//         paidCount++;
//       } else if (project.cPaymentStatus == PaymentStatus.UNPAID) {
//         unpaidCount++;
//       }
//     }

//     return {
//       'total': cachedProjects.length,
//       'active': activeCount,
//       'monthly': monthlyCount,
//       'projectBased': projectBasedCount,
//       'paid': paidCount,
//       'unpaid': unpaidCount,
//     };
//   }
// }

// class ProjectFailure implements Exception {
//   final String message;
//   ProjectFailure(this.message);

//   @override
//   String toString() => message;
// }

import 'dart:developer';

import 'package:project_management/feature/project/data/service/get_project_list_api.dart';
import 'package:project_management/feature/project/model/get_project_list_response_model.dart';

class ProjectRepository {
  final GetProjectListApi _projectApi;

  // Pagination & filter state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _pageSize = 10;
  String _currentSearch = '';
  String _currentOrderBy = 'desc';
  String? _currentRole;
  String? _currentStatus;
  String? _currentUserId; // <-- Store userId

  // Cache management
  final Map<int, List<Item>> _pageCache = {};
  final Map<String, List<Item>> _searchCache = {};

  ProjectRepository({GetProjectListApi? projectApi})
    : _projectApi = projectApi ?? GetProjectListApi.instance;

  /// Fetch project list with pagination
  Future<GetProjectListResponseModel> getProjects({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String orderBy = 'desc',
    String? role,
    String? status,
    String? userId, // <-- Nullable userId param
    bool forceRefresh = false,
  }) async {
    try {
      // Update current state
      _currentPage = page;
      _pageSize = pageSize;
      _currentSearch = search;
      _currentOrderBy = orderBy;
      _currentRole = role;
      _currentStatus = status;
      _currentUserId = userId;

      final cacheKey = _generateCacheKey(
        page: page,
        search: search,
        orderBy: orderBy,
        role: role,
        status: status,
        userId: userId,
      );

      // Return cached data if available
      if (!forceRefresh && _searchCache.containsKey(cacheKey)) {
        log(
          'Returning cached data for page $page, search: "$search", userId: "$userId"',
        );
        return GetProjectListResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache',
          data: Data(
            items: _searchCache[cacheKey],
            meta: Meta(
              currentPage: page,
              from: ((page - 1) * pageSize) + 1,
              lastPage: _totalPages,
              perPage: pageSize,
              to: page * pageSize,
              total: _totalItems,
            ),
          ),
        );
      }

      // API call
      log(
        'Fetching projects from API - Page: $page, search: "$search", userId: "$userId"',
      );
      final response = await _projectApi.getProjectList(
        page: page,
        pageSize: pageSize,
        search: search,
        orderBy: orderBy,
        role: role,
        status: status,
        userId: userId,
      );

      if (!response.success) {
        throw ProjectFailure(response.message ?? 'Failed to fetch projects');
      }

      final projectData = response.data;
      if (projectData == null)
        throw ProjectFailure('No data received from server');

      // Update pagination info
      _totalPages = projectData.data?.meta?.lastPage ?? 1;
      _totalItems =
          projectData.data?.meta?.total ??
          (projectData.data?.items?.length ?? 0);

      // Cache results
      if (projectData.data?.items != null) {
        _pageCache[page] = projectData.data!.items!;
        _searchCache[cacheKey] = projectData.data!.items!;
        _cleanupCache();
      }

      return projectData;
    } catch (e) {
      final cacheKey = _generateCacheKey(
        page: page,
        search: search,
        orderBy: orderBy,
        role: role,
        status: status,
        userId: userId,
      );

      if (_searchCache.containsKey(cacheKey)) {
        log('API failed, returning cached data: $e');
        return GetProjectListResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache (offline)',
          data: Data(
            items: _searchCache[cacheKey],
            meta: Meta(
              currentPage: page,
              from: ((page - 1) * pageSize) + 1,
              lastPage: _totalPages,
              perPage: pageSize,
              to: page * pageSize,
              total: _totalItems,
            ),
          ),
        );
      }

      return _handleError(e);
    }
  }

  /// Load next page
  Future<GetProjectListResponseModel> loadNextPage() async {
    final nextPage = _currentPage + 1;
    if (nextPage > _totalPages) {
      return GetProjectListResponseModel(
        statusCode: 400,
        success: false,
        message: 'No more pages available',
        data: null,
      );
    }
    return getProjects(
      page: nextPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
      userId: _currentUserId,
    );
  }

  /// Load previous page
  Future<GetProjectListResponseModel> loadPreviousPage() async {
    final prevPage = _currentPage - 1;
    if (prevPage < 1) {
      return GetProjectListResponseModel(
        statusCode: 400,
        success: false,
        message: 'Already on first page',
        data: null,
      );
    }
    return getProjects(
      page: prevPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
      userId: _currentUserId,
    );
  }

  /// Refresh current page
  Future<GetProjectListResponseModel> refreshCurrentPage() async {
    return getProjects(
      page: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
      userId: _currentUserId,
      forceRefresh: true,
    );
  }

  /// Search projects
  Future<GetProjectListResponseModel> searchProjects({
    required String query,
    String? role,
    String? status,
  }) async {
    _clearSearchCache();
    return getProjects(
      page: 1,
      pageSize: _pageSize,
      search: query,
      orderBy: _currentOrderBy,
      role: role ?? _currentRole,
      status: status ?? _currentStatus,
      userId: _currentUserId,
    );
  }

  /// Filter by status
  Future<GetProjectListResponseModel> filterByStatus({
    required String status,
  }) async {
    return getProjects(
      page: 1,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: status,
      userId: _currentUserId,
    );
  }

  /// Filter by role
  Future<GetProjectListResponseModel> filterByRole({
    required String role,
  }) async {
    return getProjects(
      page: 1,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: role,
      status: _currentStatus,
      userId: _currentUserId,
    );
  }

  /// Sort projects
  Future<GetProjectListResponseModel> sortProjects({
    required String orderBy,
  }) async {
    return getProjects(
      page: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: orderBy,
      role: _currentRole,
      status: _currentStatus,
      userId: _currentUserId,
    );
  }

  /// Get project by ID
  Future<Item?> getProjectById(String projectId) async {
    try {
      for (final items in _searchCache.values) {
        for (final item in items) {
          if (item.id == projectId) return item;
        }
      }
      return null;
    } catch (e) {
      log('Error getting project by ID: $e');
      return null;
    }
  }

  /// Get all cached projects
  List<Item> getAllCachedProjects() {
    final allItems = <Item>[];
    for (final items in _searchCache.values) {
      allItems.addAll(items);
    }
    return allItems;
  }

  /// Get cached projects for current search
  List<Item> getCachedProjectsForCurrentSearch() {
    final cacheKey = _generateCacheKey(
      page: _currentPage,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
      userId: _currentUserId,
    );
    return _searchCache[cacheKey] ?? [];
  }

  /// Clear all cache
  void clearCache() {
    _pageCache.clear();
    _searchCache.clear();
    _currentPage = 1;
    _totalPages = 1;
    _totalItems = 0;
    _currentUserId = null;
  }

  /// Private helper: clear search cache
  void _clearSearchCache() => _searchCache.clear();

  /// Get pagination info
  Map<String, dynamic> getPaginationInfo() => {
    'currentPage': _currentPage,
    'totalPages': _totalPages,
    'totalItems': _totalItems,
    'pageSize': _pageSize,
    'hasMore': _currentPage < _totalPages,
  };

  /// Get current filters
  Map<String, dynamic> getCurrentFilters() => {
    'search': _currentSearch,
    'orderBy': _currentOrderBy,
    'role': _currentRole,
    'status': _currentStatus,
    'userId': _currentUserId,
  };

  // =====================
  // Helper Methods
  // =====================
  String _generateCacheKey({
    required int page,
    required String search,
    required String orderBy,
    String? role,
    String? status,
    String? userId,
  }) {
    return '${page}_${search}_${orderBy}_${role ?? ''}_${status ?? ''}_${userId ?? ''}';
  }

  void _cleanupCache() {
    if (_searchCache.length > 10) {
      final keys = _searchCache.keys.toList();
      for (int i = 0; i < keys.length - 10; i++) {
        _searchCache.remove(keys[i]);
      }
    }
  }

  GetProjectListResponseModel _handleError(dynamic e) {
    String errorMessage;

    if (e is ProjectFailure) {
      errorMessage = e.message;
    } else {
      final errorString = e.toString();
      if (errorString.contains('timeout') ||
          errorString.contains('SocketException')) {
        errorMessage = 'Connection timeout. Check your internet.';
      } else if (errorString.contains('401') || errorString.contains('403')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (errorString.contains('404')) {
        errorMessage = 'Projects not found.';
      } else if (errorString.contains('500')) {
        errorMessage = 'Server error. Try again later.';
      } else {
        errorMessage = 'Failed to load projects. Please try again.';
      }
    }

    return GetProjectListResponseModel(
      statusCode: 500,
      success: false,
      message: errorMessage,
      data: null,
    );
  }

  /// Statistics from cached projects
  Map<String, int> getProjectStats() {
    final cachedProjects = getAllCachedProjects();

    int activeCount = 0;
    int monthlyCount = 0;
    int projectBasedCount = 0;
    int paidCount = 0;
    int unpaidCount = 0;

    for (final project in cachedProjects) {
      if (project.isActive == true) activeCount++;
      if (project.projectType == ProjectType.MONTHLY) {
        monthlyCount++;
      } else if (project.projectType == ProjectType.PROJECT_BASED) {
        projectBasedCount++;
      }
      if (project.cPaymentStatus == PaymentStatus.PAID) {
        paidCount++;
      } else if (project.cPaymentStatus == PaymentStatus.UNPAID) {
        unpaidCount++;
      }
    }

    return {
      'total': cachedProjects.length,
      'active': activeCount,
      'monthly': monthlyCount,
      'projectBased': projectBasedCount,
      'paid': paidCount,
      'unpaid': unpaidCount,
    };
  }
}

class ProjectFailure implements Exception {
  final String message;
  ProjectFailure(this.message);

  @override
  String toString() => message;
}
