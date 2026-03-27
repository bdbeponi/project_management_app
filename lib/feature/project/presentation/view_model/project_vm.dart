// import 'package:flutter/material.dart';

// class ProjectVm extends ChangeNotifier {
//   // TODO: Replace with actual API data
//   List<Map<String, dynamic>> get projects => [
//     {
//       'code': '47243',
//       'name': 'website',
//       'type': 'project based',
//       'startDate': '2025-11-06',
//       'endDate': '2025-11-11',
//       'status': 'Running',
//       'payment': 'Unpaid',
//       'client': 'sk jasib',
//       'description': 'Complete website development project',
//     },
//     {
//       'code': '63406',
//       'name': 'prayas group website',
//       'type': 'project based',
//       'startDate': '2025-11-02',
//       'endDate': '2025-11-22',
//       'status': 'Running',
//       'payment': 'Unpaid',
//       'client': 'Prayas Group',
//       'description': 'Corporate website with CMS integration',
//     },
//     {
//       'code': '58921',
//       'name': 'Mobile App Development',
//       'type': 'project based',
//       'startDate': '2025-10-15',
//       'endDate': '2025-12-30',
//       'status': 'Running',
//       'payment': 'Paid',
//       'client': 'TechCorp',
//       'description': 'iOS and Android mobile application',
//     },
//     {
//       'code': '52314',
//       'name': 'E-commerce Platform',
//       'type': 'hourly based',
//       'startDate': '2025-09-01',
//       'endDate': '2025-10-31',
//       'status': 'Completed',
//       'payment': 'Paid',
//       'client': 'ShopMart',
//       'description': 'Full-stack e-commerce solution',
//     },
//     {
//       'code': '49872',
//       'name': 'Brand Identity Design',
//       'type': 'project based',
//       'startDate': '2025-08-20',
//       'endDate': '2025-09-15',
//       'status': 'On Hold',
//       'payment': 'Unpaid',
//       'client': 'StartupXYZ',
//       'description': 'Logo and brand guidelines',
//     },
//   ];

//   int get totalProjects => projects.length;

//   int get runningProjects =>
//       projects.where((p) => p['status'] == 'Running').length;

//   int get completedProjects =>
//       projects.where((p) => p['status'] == 'Completed').length;

//   // TODO: Implement API methods
//   Future<void> fetchProjects() async {
//     // Fetch from API
//     await Future.delayed(const Duration(seconds: 1));
//     notifyListeners();
//   }

//   Future<bool> createProject(Map<String, dynamic> projectData) async {
//     // Create project via API
//     await Future.delayed(const Duration(seconds: 1));
//     notifyListeners();
//     return true;
//   }

//   Future<bool> updateProject(String code, Map<String, dynamic> updates) async {
//     // Update project via API
//     await Future.delayed(const Duration(seconds: 1));
//     notifyListeners();
//     return true;
//   }

//   Future<bool> deleteProject(String code) async {
//     // Delete project via API
//     await Future.delayed(const Duration(seconds: 1));
//     notifyListeners();
//     return true;
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'package:project_management/feature/project/data/repository/get_project_list_repo.dart';
// import 'package:project_management/feature/project/model/get_project_list_response_model.dart';

// class ProjectVm extends ChangeNotifier {
//   final ProjectRepository _repository = ProjectRepository();

//   List<Item> _projects = [];
//   bool _isLoading = false;
//   bool _isLoadingMore = false;
//   String? _error;
//   bool _hasMore = true;
//   int _currentPage = 1;
//   final int _pageSize = 10;
//   String _searchQuery = '';
//   String? _statusFilter;
//   String? _roleFilter;
//   String _orderBy = 'desc';

//   // Add this to track if it's the first load
//   bool _isInitialLoad = true;

//   List<Item> get projects => _projects;
//   bool get isLoading => _isLoading;
//   bool get isLoadingMore => _isLoadingMore;
//   bool get isInitialLoad => _isInitialLoad;
//   String? get error => _error;
//   bool get hasMore => _hasMore;

//   Future<void> loadInitialProjects() async {
//     if (_isLoading) return;

//     _isLoading = true;
//     _error = null;
//     _currentPage = 1;
//     _hasMore = true;
//     notifyListeners();

//     try {
//       final response = await _repository.getProjects(
//         page: 1,
//         pageSize: _pageSize,
//         search: _searchQuery,
//         orderBy: _orderBy,
//         status: _statusFilter,
//         role: _roleFilter,
//         forceRefresh: true, // Always refresh initial load
//       );

//       if (response.success == true && response.data?.items != null) {
//         _projects = response.data!.items!;

//         // Determine if there are more pages
//         final total = response.data?.meta?.total ?? 0;
//         final lastPage = response.data?.meta?.lastPage ?? 1;
//         _hasMore = _currentPage < lastPage && _projects.length < total;
//       } else {
//         _error = response.message ?? 'Failed to load projects';
//       }
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       _isInitialLoad = false;
//       notifyListeners();
//     }
//   }

//   Future<void> loadMoreProjects() async {
//     // Prevent multiple simultaneous load more requests
//     if (_isLoadingMore || !_hasMore) return;

//     _isLoadingMore = true;
//     notifyListeners();

//     try {
//       final nextPage = _currentPage + 1;
//       final response = await _repository.getProjects(
//         page: nextPage,
//         pageSize: _pageSize,
//         search: _searchQuery,
//         orderBy: _orderBy,
//         status: _statusFilter,
//         role: _roleFilter,
//       );

//       if (response.success == true && response.data?.items != null) {
//         final newItems = response.data!.items!;
//         _projects.addAll(newItems);
//         _currentPage = nextPage;

//         // Check if there are more items
//         final total = response.data?.meta?.total ?? 0;
//         final lastPage = response.data?.meta?.lastPage ?? 1;
//         _hasMore = _currentPage < lastPage && _projects.length < total;
//       }
//     } catch (e) {
//       // Silent fail for pagination - users can retry by pulling down
//       print('Error loading more projects: $e');
//     } finally {
//       _isLoadingMore = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshProjects() async {
//     if (_isLoading) return;

//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await _repository.refreshCurrentPage();

//       if (response.success == true && response.data?.items != null) {
//         _projects = response.data!.items!;
//         _hasMore = true;
//         _currentPage = 1;
//       }
//     } catch (e) {
//       // Silent fail for refresh
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> searchProjects({required String query}) async {
//     if (_isLoading) return;

//     _searchQuery = query;
//     _currentPage = 1;
//     _hasMore = true;

//     await loadInitialProjects();
//   }

//   Future<void> filterByStatus({required String? status}) async {
//     if (_isLoading) return;

//     _statusFilter = status;
//     _currentPage = 1;
//     _hasMore = true;

//     await loadInitialProjects();
//   }

//   Future<void> filterByRole({required String? role}) async {
//     if (_isLoading) return;

//     _roleFilter = role;
//     _currentPage = 1;
//     _hasMore = true;

//     await loadInitialProjects();
//   }

//   Future<void> sortProjects({required String orderBy}) async {
//     if (_isLoading) return;

//     _orderBy = orderBy;
//     _currentPage = 1;
//     _hasMore = true;

//     await loadInitialProjects();
//   }

//   void clearSearch() {
//     if (_searchQuery.isNotEmpty) {
//       _searchQuery = '';
//       loadInitialProjects();
//     }
//   }

//   void clearFilters() {
//     if (_statusFilter != null || _roleFilter != null) {
//       _statusFilter = null;
//       _roleFilter = null;
//       loadInitialProjects();
//     }
//   }

//   void clearAll() {
//     _searchQuery = '';
//     _statusFilter = null;
//     _roleFilter = null;
//     _orderBy = 'desc';
//     _currentPage = 1;
//     _hasMore = true;
//     loadInitialProjects();
//   }

//   // Add this method to get current pagination info
//   Map<String, dynamic> getPaginationInfo() {
//     return {
//       'currentPage': _currentPage,
//       'totalItems': _projects.length,
//       'hasMore': _hasMore,
//       'isLoadingMore': _isLoadingMore,
//     };
//   }
// }

import 'package:project_management/app/provider/base/base_vm.dart';
import 'package:project_management/feature/project/data/repository/get_project_list_repo.dart';
import 'package:project_management/feature/project/model/get_project_list_response_model.dart';

class ProjectVm extends BaseViewModel {
  final ProjectRepository _repository = ProjectRepository();

  // ------------------------- PROJECT SPECIFIC STATE -------------------------
  List<Item> _projects = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  String _searchQuery = '';
  String? _statusFilter;
  String? _roleFilter;
  String _orderBy = 'desc';
  bool _isInitialLoad = true;

  // ------------------------- GETTERS -------------------------
  List<Item> get projects => _projects;
  bool get isLoadingMore => _isLoadingMore;
  bool get isInitialLoad => _isInitialLoad;
  bool get hasMore => _hasMore;

  // Add getters for filters if needed in UI
  String get searchQuery => _searchQuery;
  String? get statusFilter => _statusFilter;
  String? get roleFilter => _roleFilter;
  String get orderBy => _orderBy;

  // ------------------------- PUBLIC METHODS -------------------------

  /// Load initial projects (first page)
  Future<void> loadInitialProjects() async {
    // Prevent duplicate calls during loading
    if (isLoading) return;

    return executeApiCall(
      apiCall: () async {
        _resetPagination();

        final response = await _repository.getProjects(
          page: 1,
          pageSize: _pageSize,
          search: _searchQuery,
          orderBy: _orderBy,
          status: _statusFilter,
          role: _roleFilter,
          forceRefresh: true,
        );

        return _handleInitialResponse(response);
      },
      errorMessage: 'Failed to load projects',
    );
  }

  /// Load more projects (pagination)
  Future<void> loadMoreProjects() async {
    // Prevent multiple simultaneous load more requests
    if (_isLoadingMore || !_hasMore) return;

    try {
      _setLoadingMore(true);

      final nextPage = _currentPage + 1;
      final response = await _repository.getProjects(
        page: nextPage,
        pageSize: _pageSize,
        search: _searchQuery,
        orderBy: _orderBy,
        status: _statusFilter,
        role: _roleFilter,
      );

      _handleLoadMoreResponse(response, nextPage);
    } catch (e) {
      // Silent fail for pagination - users can retry by pulling down
      print('Error loading more projects: $e');
    } finally {
      _setLoadingMore(false);
    }
  }

  /// Refresh current page
  Future<void> refreshProjects() async {
    if (isLoading) return;

    return executeApiCall(
      apiCall: () async {
        final response = await _repository.refreshCurrentPage();
        return _handleRefreshResponse(response);
      },
      errorMessage: 'Failed to refresh projects',
    );
  }

  /// Search projects with query
  Future<void> searchProjects({required String query}) async {
    if (isLoading) return;

    _searchQuery = query;
    await _resetAndLoad();
  }

  /// Filter projects by status
  Future<void> filterByStatus({required String? status}) async {
    if (isLoading) return;

    _statusFilter = status;
    await _resetAndLoad();
  }

  /// Filter projects by role
  Future<void> filterByRole({required String? role}) async {
    if (isLoading) return;

    _roleFilter = role;
    await _resetAndLoad();
  }

  /// Sort projects
  Future<void> sortProjects({required String orderBy}) async {
    if (isLoading) return;

    _orderBy = orderBy;
    await _resetAndLoad();
  }

  /// Clear search query
  Future<void> clearSearch() async {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      await _resetAndLoad();
    }
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    if (_statusFilter != null || _roleFilter != null) {
      _statusFilter = null;
      _roleFilter = null;
      await _resetAndLoad();
    }
  }

  /// Clear everything (search + filters)
  Future<void> clearAll() async {
    _searchQuery = '';
    _statusFilter = null;
    _roleFilter = null;
    _orderBy = 'desc';
    await _resetAndLoad();
  }

  /// Get project by ID
  Future<Item?> getProjectById(String projectId) async {
    try {
      // First check in loaded projects
      for (final project in _projects) {
        if (project.id == projectId) {
          return project;
        }
      }

      // If not found, you could add a repository method to fetch single project
      return null;
    } catch (e) {
      print('Error getting project by ID: $e');
      return null;
    }
  }

  /// Get pagination info
  Map<String, dynamic> getPaginationInfo() {
    return {
      'currentPage': _currentPage,
      'totalItems': _projects.length,
      'hasMore': _hasMore,
      'isLoadingMore': _isLoadingMore,
    };
  }

  /// Get current filters info
  Map<String, dynamic> getFiltersInfo() {
    return {
      'search': _searchQuery,
      'status': _statusFilter,
      'role': _roleFilter,
      'orderBy': _orderBy,
    };
  }

  /// Get project statistics
  Map<String, int> getProjectStats() {
    int activeCount = 0;
    int monthlyCount = 0;
    int projectBasedCount = 0;
    int paidCount = 0;
    int unpaidCount = 0;

    for (final project in _projects) {
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
      'total': _projects.length,
      'active': activeCount,
      'inactive': _projects.length - activeCount,
      'monthly': monthlyCount,
      'projectBased': projectBasedCount,
      'paid': paidCount,
      'unpaid': unpaidCount,
    };
  }

  // ------------------------- PRIVATE METHODS -------------------------

  /// Reset pagination and reload
  Future<void> _resetAndLoad() async {
    _resetPagination();
    await loadInitialProjects();
  }

  /// Reset pagination state
  void _resetPagination() {
    _currentPage = 1;
    _hasMore = true;
    _isInitialLoad = true;
  }

  // /// Handle initial load response
  // void _handleInitialResponse(GetProjectListResponseModel response) {
  //   if (response.success == true && response.data?.items != null) {
  //     _projects = response.data!.items!;

  //     // Determine if there are more pages
  //     final total = response.data?.meta?.total ?? 0;
  //     final lastPage = response.data?.meta?.lastPage ?? 1;
  //     _hasMore = _currentPage < lastPage && _projects.length < total;

  //     _isInitialLoad = false;
  //   } else {
  //     throw Exception(response.message ?? 'Failed to load projects');
  //   }
  // }

  // /// Handle load more response
  // void _handleLoadMoreResponse(
  //   GetProjectListResponseModel response,
  //   int nextPage,
  // ) {
  //   if (response.success == true && response.data?.items != null) {
  //     final newItems = response.data!.items!;
  //     _projects.addAll(newItems);
  //     _currentPage = nextPage;

  //     // Check if there are more items
  //     final total = response.data?.meta?.total ?? 0;
  //     final lastPage = response.data?.meta?.lastPage ?? 1;
  //     _hasMore = _currentPage < lastPage && _projects.length < total;

  //     safeNotifyListeners();
  //   }
  // }

  // /// Handle refresh response
  // void _handleRefreshResponse(GetProjectListResponseModel response) {
  //   if (response.success == true && response.data?.items != null) {
  //     _projects = response.data!.items!;
  //     _hasMore = true;
  //     _currentPage = 1;
  //   } else {
  //     throw Exception(response.message ?? 'Failed to refresh projects');
  //   }
  // }

  /// Handle initial load response
  void _handleInitialResponse(GetProjectListResponseModel response) {
    if (response.success == true) {
      if (response.data?.items != null) {
        _projects = response.data!.items!;

        // Determine if there are more pages
        final total = response.data?.meta?.total ?? 0;
        final lastPage = response.data?.meta?.lastPage ?? 1;
        _hasMore = _currentPage < lastPage && _projects.length < total;
      } else {
        // Empty data but successful response
        _projects = [];
        _hasMore = false;
      }

      _isInitialLoad = false;
    } else {
      throw ProjectFailure(response.message ?? 'Failed to load projects');
    }
  }

  /// Handle load more response
  void _handleLoadMoreResponse(
    GetProjectListResponseModel response,
    int nextPage,
  ) {
    if (response.success == true) {
      if (response.data?.items != null) {
        final newItems = response.data!.items!;
        _projects.addAll(newItems);
        _currentPage = nextPage;

        // Check if there are more items
        final total = response.data?.meta?.total ?? 0;
        final lastPage = response.data?.meta?.lastPage ?? 1;
        _hasMore = _currentPage < lastPage && _projects.length < total;
      }
      safeNotifyListeners();
    } else {
      throw ProjectFailure(response.message ?? 'Failed to load more projects');
    }
  }

  /// Handle refresh response
  void _handleRefreshResponse(GetProjectListResponseModel response) {
    if (response.success == true) {
      if (response.data?.items != null) {
        _projects = response.data!.items!;
        _hasMore = true;
        _currentPage = 1;
      } else {
        // Empty data but successful response
        _projects = [];
        _hasMore = false;
      }
    } else {
      throw ProjectFailure(response.message ?? 'Failed to refresh projects');
    }
  }

  /// Set loading more state
  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
    safeNotifyListeners();
  }

  // ------------------------- OVERRIDE DISPOSE -------------------------
  @override
  void dispose() {
    // Clear any resources if needed
    super.dispose();
  }
}
