import 'package:flutter/foundation.dart';
import 'package:project_management/feature/project/data/repository/get_project_list_repo.dart';
import 'package:project_management/feature/project/model/get_project_list_response_model.dart';

/// ViewModel for Project List
class ClientProjectInvoiceVm extends ChangeNotifier {
  final ProjectRepository _repository;

  ClientProjectInvoiceVm({ProjectRepository? repository})
    : _repository = repository ?? ProjectRepository();

  // State
  List<Item> _projects = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _error = '';

  // Pagination info
  int _currentPage = 1;
  final int _pageSize = 10;

  // Search/Filter/Sort
  String _searchQuery = '';
  String _orderBy = 'desc';
  String? _role;
  String? _status;

  // User ID from UI
  String? _userId;

  // Getters
  List<Item> get projects => _projects;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get error => _error;
  int get currentPage => _currentPage;
  String? get userId => _userId;

  /// Set user ID from UI
  void setUserId(String? userId) {
    _userId = userId;
    _currentPage = 1;
    _hasMore = true;
    clear(); // Optional: clear previous data if user changes
    notifyListeners();
  }

  /// Initialize / First load
  Future<void> loadProjects({bool forceRefresh = false}) async {
    if (_userId == null) {
      _error = 'User ID is required';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _repository.getProjects(
        page: 1,
        pageSize: _pageSize,
        search: _searchQuery,
        orderBy: _orderBy,
        role: _role,
        status: _status,
        userId: _userId, // <-- pass userId
        forceRefresh: forceRefresh,
      );

      if (response.statusCode == 200 && response.data?.items != null) {
        _projects = response.data!.items!;
        _currentPage = response.data!.meta?.currentPage ?? 1;
        _hasMore = _currentPage < (response.data!.meta?.lastPage ?? 1);
      } else {
        _error = response.message ?? 'Unknown error';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoading || _userId == null) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.getProjects(
        page: nextPage,
        pageSize: _pageSize,
        search: _searchQuery,
        orderBy: _orderBy,
        role: _role,
        status: _status,
        userId: _userId, // <-- pass userId
      );

      if (response.statusCode == 200 && response.data?.items != null) {
        _projects.addAll(response.data!.items!);
        _currentPage = response.data!.meta?.currentPage ?? nextPage;
        _hasMore = _currentPage < (response.data!.meta?.lastPage ?? nextPage);
      } else {
        _error = response.message ?? 'Unknown error';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh current page
  Future<void> refresh() async {
    await loadProjects(forceRefresh: true);
  }

  /// Search projects (resets pagination)
  Future<void> searchProjects(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    _hasMore = true;
    await loadProjects(forceRefresh: true);
  }

  /// Filter by role
  Future<void> filterByRole(String role) async {
    _role = role;
    _currentPage = 1;
    _hasMore = true;
    await loadProjects(forceRefresh: true);
  }

  /// Filter by status
  Future<void> filterByStatus(String status) async {
    _status = status;
    _currentPage = 1;
    _hasMore = true;
    await loadProjects(forceRefresh: true);
  }

  /// Sort
  Future<void> sortBy(String orderBy) async {
    _orderBy = orderBy;
    _currentPage = 1;
    _hasMore = true;
    await loadProjects(forceRefresh: true);
  }

  /// Get statistics from cached projects
  Map<String, int> getStats() {
    return _repository.getProjectStats();
  }

  /// Clear all data and reset
  void clear() {
    _projects.clear();
    _currentPage = 1;
    _hasMore = true;
    _searchQuery = '';
    _role = null;
    _status = null;
    _orderBy = 'desc';
    _error = '';
    notifyListeners();
  }
}
