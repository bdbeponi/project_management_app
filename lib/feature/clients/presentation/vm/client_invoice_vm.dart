import 'package:flutter/foundation.dart';
import 'package:project_management/feature/invoices/data/repository/invoice_list_repo.dart';
import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';

/// ViewModel for Invoices
class ClientInvoiceVm extends ChangeNotifier {
  final InvoiceRepository _repository;

  ClientInvoiceVm({InvoiceRepository? repository})
    : _repository = repository ?? InvoiceRepository();

  // State
  List<InvoiceItem> _invoices = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  // Pagination info
  int _currentPage = 1;
  final int _pageSize = 10;

  // Search/Filter/Sort
  String _searchQuery = '';
  String _orderBy = 'desc';
  String? _status;
  String? _clientId;
  DateTime? _startDate;
  DateTime? _endDate;

  // Getters
  List<InvoiceItem> get invoices => _invoices;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  String? get clientId => _clientId;

  /// Set client ID from UI
  void setClientId(String? clientId) {
    _clientId = clientId;
    _currentPage = 1;
    _hasMore = true;
    clear(); // clear previous data
    notifyListeners();
  }

  /// Load invoices (initial or refresh)
  Future<void> loadInvoices({bool forceRefresh = false}) async {
    if (_clientId == null) {
      _errorMessage = 'Client ID is required';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getInvoices(
        page: 1,
        pageSize: _pageSize,
        search: _searchQuery,
        orderBy: _orderBy,
        status: _status,
        clientId: _clientId,
        startDate: _startDate,
        endDate: _endDate,
        refreshCache: forceRefresh,
      );

      if (response.statusCode == 200 && response.data?.items != null) {
        _invoices = response.data!.items!;
        _currentPage = response.data!.meta?.currentPage ?? 1;
        _hasMore = _currentPage < (response.data!.meta?.lastPage ?? 1);
      } else {
        _errorMessage = response.message ?? 'Unknown error';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoading || _isLoadingMore || _clientId == null) return;

    _isLoadingMore = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.loadNextPage();

      if (response.statusCode == 200 && response.data?.items != null) {
        _invoices.addAll(response.data!.items!);
        _currentPage = response.data!.meta?.currentPage ?? nextPage;
        _hasMore = _currentPage < (response.data!.meta?.lastPage ?? nextPage);
      } else {
        _errorMessage = response.message ?? 'Unknown error';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Refresh current page
  Future<void> refreshInvoices() async {
    _currentPage = 1;
    _hasMore = true;
    await loadInvoices(forceRefresh: true);
  }

  /// Search invoices (resets to page 1)
  Future<void> searchInvoices(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    _hasMore = true;
    await loadInvoices(forceRefresh: true);
  }

  /// Filter by status
  Future<void> filterByStatus(String status) async {
    _status = status;
    _currentPage = 1;
    _hasMore = true;
    await loadInvoices(forceRefresh: true);
  }

  /// Filter by date range
  Future<void> filterByDateRange(DateTime start, DateTime end) async {
    _startDate = start;
    _endDate = end;
    _currentPage = 1;
    _hasMore = true;
    await loadInvoices(forceRefresh: true);
  }

  /// Sort
  Future<void> sortBy(String orderBy) async {
    _orderBy = orderBy;
    _currentPage = 1;
    _hasMore = true;
    await loadInvoices(forceRefresh: true);
  }

  /// Get cached stats
  Map<String, dynamic> getStats() {
    return _repository.getInvoiceStats();
  }

  /// Clear all data and reset
  void clear() {
    _invoices.clear();
    _currentPage = 1;
    _hasMore = true;
    _searchQuery = '';
    _status = null;
    _orderBy = 'desc';
    _startDate = null;
    _endDate = null;
    _errorMessage = null;
    notifyListeners();
  }
}
