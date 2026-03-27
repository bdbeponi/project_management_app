// import 'package:flutter/material.dart';
// import 'package:project_management/feature/invoices/data/repository/invoice_list_repo.dart';
// import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';

// class InvoiceVm extends ChangeNotifier {
//   final InvoiceRepository _invoiceRepository = InvoiceRepository();

//   // State variables
//   List<InvoiceItem> _invoices = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//   int _currentPage = 1;
//   bool _hasMore = true;
//   bool _isRefreshing = false;

//   // Getters
//   List<InvoiceItem> get invoices => _invoices;
//   bool get isLoading => _isLoading;
//   bool get isRefreshing => _isRefreshing;
//   String? get errorMessage => _errorMessage;
//   bool get hasMore => _hasMore;

//   // Statistics getters
//   int get totalInvoices => _invoices.length;

//   int get paidCount =>
//       _invoices.where((i) => i.status?.toLowerCase() == 'paid').length;

//   int get unpaidCount =>
//       _invoices.where((i) => i.status?.toLowerCase() == 'unpaid').length;

//   double get totalRevenue => _invoices
//       .where((i) => i.status?.toLowerCase() == 'paid')
//       .fold(0.0, (sum, i) => sum + (i.totalAmount ?? 0).toDouble());

//   double get pendingRevenue => _invoices
//       .where((i) => i.status?.toLowerCase() == 'unpaid')
//       .fold(0.0, (sum, i) => sum + (i.totalAmount ?? 0).toDouble());

//   /// Fetch invoices with pagination
//   Future<void> fetchInvoices({
//     int page = 1,
//     String search = '',
//     String status = '',
//     String? clientId,
//     DateTime? startDate,
//     DateTime? endDate,
//     bool loadMore = false,
//     bool refreshCache = false,
//   }) async {
//     if (_isLoading && !loadMore) return;

//     try {
//       if (!loadMore) {
//         _isLoading = true;
//         _errorMessage = null;
//       }

//       notifyListeners();

//       final response = await _invoiceRepository.getInvoices(
//         page: page,
//         pageSize: 20,
//         search: search,
//         orderBy: 'desc',
//         status: status.isNotEmpty ? status : null,
//         clientId: clientId,
//         startDate: startDate,
//         endDate: endDate,
//         refreshCache: refreshCache,
//       );

//       if (response.success == true) {
//         if (loadMore) {
//           // Append new invoices for infinite scroll
//           _invoices.addAll(response.data?.items ?? []);
//         } else {
//           // Replace invoices for new search/filter
//           _invoices = response.data?.items ?? [];
//         }

//         // Update pagination info
//         final paginationInfo = _invoiceRepository.getPaginationInfo();
//         _currentPage = paginationInfo['currentPage'];
//         _hasMore = paginationInfo['hasMore'] ?? false;
//       } else {
//         _errorMessage = response.message;
//       }
//     } catch (e) {
//       _errorMessage = 'Failed to fetch invoices. Please try again.';
//       // Fallback to cached data if available
//       final cachedInvoices = _invoiceRepository.getCachedInvoices();
//       if (cachedInvoices != null) {
//         _invoices = cachedInvoices;
//       }
//     } finally {
//       _isLoading = false;
//       _isRefreshing = false;
//       notifyListeners();
//     }
//   }

//   /// Load more invoices (pagination)
//   Future<void> loadMoreInvoices() async {
//     if (_isLoading || !_hasMore) return;

//     await fetchInvoices(page: _currentPage + 1, loadMore: true);
//   }

//   /// Refresh current invoices
//   Future<void> refreshInvoices() async {
//     _isRefreshing = true;
//     notifyListeners();

//     await fetchInvoices(page: 1, refreshCache: true);
//   }

//   /// Search invoices
//   Future<void> searchInvoices(String query) async {
//     await fetchInvoices(page: 1, search: query);
//   }

//   /// Filter by status
//   Future<void> filterByStatus(String status) async {
//     await fetchInvoices(page: 1, status: status.toLowerCase());
//   }

//   /// Clear filters and show all invoices
//   Future<void> clearFilters() async {
//     await fetchInvoices(page: 1);
//   }

//   /// Update invoice status locally
//   void updateInvoiceStatusLocally(String invoiceId, String status) {
//     final index = _invoices.indexWhere((invoice) => invoice.id == invoiceId);
//     if (index != -1) {
//       // Since the fields are final, we need to create a new instance
//       final oldInvoice = _invoices[index];
//       _invoices[index] = InvoiceItem(
//         clientId: oldInvoice.clientId,
//         projects: oldInvoice.projects,
//         issueDate: oldInvoice.issueDate,
//         totalAmount: oldInvoice.totalAmount,
//         status: status,
//         notes: oldInvoice.notes,
//         id: oldInvoice.id,
//         invoiceNumber: oldInvoice.invoiceNumber,
//         discount: oldInvoice.discount,
//         tax: oldInvoice.tax,
//         createdAt: oldInvoice.createdAt,
//         updatedAt: DateTime.now(),
//         v: oldInvoice.v,
//       );
//       notifyListeners();
//     }
//   }

//   /// Delete invoice locally
//   void deleteInvoiceLocally(String invoiceId) {
//     _invoices.removeWhere((invoice) => invoice.id == invoiceId);
//     notifyListeners();
//   }

//   /// Get invoice by ID
//   InvoiceItem? getInvoiceById(String invoiceId) {
//     return _invoices.firstWhere(
//       (invoice) => invoice.id == invoiceId,
//       orElse: () {
//         return InvoiceItem();
//       },
//     );
//   }

//   /// Get invoice statistics from repository
//   Map<String, dynamic> getInvoiceStats() {
//     return _invoiceRepository.getInvoiceStats();
//   }

//   /// Get client-wise summary
//   Map<String, Map<String, dynamic>> getClientWiseSummary() {
//     return _invoiceRepository.getClientWiseSummary();
//   }

//   /// Clear all data
//   void clearData() {
//     _invoices = [];
//     _isLoading = false;
//     _errorMessage = null;
//     _currentPage = 1;
//     _hasMore = true;
//     notifyListeners();
//   }

//   // TODO: Implement actual API methods when they're available
//   Future<bool> createInvoice(Map<String, dynamic> invoiceData) async {
//     await Future.delayed(const Duration(seconds: 1));
//     notifyListeners();
//     return true;
//   }

//   Future<bool> updateInvoiceStatusApi(String invoiceId, String status) async {
//     await Future.delayed(const Duration(seconds: 1));
//     updateInvoiceStatusLocally(invoiceId, status);
//     return true;
//   }

//   Future<bool> deleteInvoiceApi(String invoiceId) async {
//     await Future.delayed(const Duration(seconds: 1));
//     deleteInvoiceLocally(invoiceId);
//     return true;
//   }

//   Future<void> downloadInvoicePDF(String invoiceId) async {
//     await Future.delayed(const Duration(seconds: 1));
//   }
// }

import 'package:flutter/material.dart';
import 'package:project_management/feature/invoices/data/repository/invoice_list_repo.dart';
import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';

class InvoiceVm extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  // State variables
  List<InvoiceItem> _invoices = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isRefreshing = false;

  // Getters
  List<InvoiceItem> get invoices => _invoices;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // Statistics getters
  int get totalInvoices => _invoices.length;

  int get paidCount =>
      _invoices.where((i) => i.status?.toLowerCase() == 'paid').length;

  int get unpaidCount =>
      _invoices.where((i) => i.status?.toLowerCase() == 'unpaid').length;

  double get totalRevenue => _invoices
      .where((i) => i.status?.toLowerCase() == 'paid')
      .fold(0.0, (sum, i) => sum + (i.totalAmount ?? 0).toDouble());

  double get pendingRevenue => _invoices
      .where((i) => i.status?.toLowerCase() == 'unpaid')
      .fold(0.0, (sum, i) => sum + (i.totalAmount ?? 0).toDouble());

  /// Fetch invoices with pagination
  Future<void> fetchInvoices({
    int page = 1,
    String search = '',
    String status = '',
    String? clientId,
    DateTime? startDate,
    DateTime? endDate,
    bool loadMore = false,
    bool refreshCache = false,
  }) async {
    if (_isLoading && !loadMore) return;

    try {
      if (!loadMore) {
        _isLoading = true;
        _errorMessage = null;
      }

      notifyListeners();

      final response = await _invoiceRepository.getInvoices(
        page: page,
        pageSize: 20,
        search: search,
        orderBy: 'desc',
        status: status.isNotEmpty ? status : null,
        clientId: clientId,
        startDate: startDate,
        endDate: endDate,
        refreshCache: refreshCache,
      );

      if (response.success ?? false) {
        if (loadMore) {
          // Append new invoices for infinite scroll
          _invoices.addAll(response.data?.items ?? []);
        } else {
          // Replace invoices for new search/filter
          _invoices = response.data?.items ?? [];
        }

        // Update pagination info
        final paginationInfo = _invoiceRepository.getPaginationInfo();
        _currentPage = paginationInfo['currentPage'] ?? 1;
        _hasMore = paginationInfo['hasMore'] ?? false;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch invoices. Please try again.';
      // Fallback to cached data if available
      final cachedInvoices = _invoiceRepository.getCachedInvoices();
      if (cachedInvoices != null) {
        _invoices = cachedInvoices;
      }
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load more invoices (pagination)
  Future<void> loadMoreInvoices() async {
    if (_isLoading || !_hasMore) return;

    await fetchInvoices(page: _currentPage + 1, loadMore: true);
  }

  /// Refresh current invoices
  Future<void> refreshInvoices() async {
    _isRefreshing = true;
    notifyListeners();

    await fetchInvoices(page: 1, refreshCache: true);
  }

  /// Search invoices
  Future<void> searchInvoices(String query) async {
    await fetchInvoices(page: 1, search: query);
  }

  /// Filter by status
  Future<void> filterByStatus(String status) async {
    await fetchInvoices(page: 1, status: status.toLowerCase());
  }

  /// Clear filters and show all invoices
  Future<void> clearFilters() async {
    await fetchInvoices(page: 1);
  }

  /// Update invoice status locally
  void updateInvoiceStatusLocally(String invoiceId, String status) {
    final index = _invoices.indexWhere((invoice) => invoice.id == invoiceId);
    if (index != -1) {
      // Since the fields are final, we need to create a new instance
      final oldInvoice = _invoices[index];

      // Create a new invoice item with updated status
      _invoices[index] = InvoiceItem(
        clientId: oldInvoice.clientId,
        projects: oldInvoice.projects,
        issueDate: oldInvoice.issueDate,
        totalAmount: oldInvoice.totalAmount,
        status: status,
        notes: oldInvoice.notes,
        id: oldInvoice.id,
        invoiceNumber: oldInvoice.invoiceNumber,
        discount: oldInvoice.discount,
        tax: oldInvoice.tax,
        createdAt: oldInvoice.createdAt,
        updatedAt: DateTime.now(),
        v: oldInvoice.v,
      );
      notifyListeners();
    }
  }

  /// Delete invoice locally
  void deleteInvoiceLocally(String invoiceId) {
    _invoices.removeWhere((invoice) => invoice.id == invoiceId);
    notifyListeners();
  }

  /// Get invoice by ID
  InvoiceItem? getInvoiceById(String invoiceId) {
    try {
      return _invoices.firstWhere((invoice) => invoice.id == invoiceId);
    } catch (e) {
      return null;
    }
  }

  /// Get invoice statistics from repository
  Map<String, dynamic> getInvoiceStats() {
    return _invoiceRepository.getInvoiceStats();
  }

  /// Get client-wise summary
  Map<String, Map<String, dynamic>> getClientWiseSummary() {
    return _invoiceRepository.getClientWiseSummary();
  }

  /// Clear all data
  void clearData() {
    _invoices = [];
    _isLoading = false;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }

  // TODO: Implement actual API methods when they're available
  Future<bool> createInvoice(Map<String, dynamic> invoiceData) async {
    await Future.delayed(const Duration(seconds: 1));
    // Add the new invoice locally for now
    // This should be replaced with actual API call
    _invoices.insert(
      0,
      InvoiceItem(
        clientId: ClientId(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          userName: invoiceData['clientName'] ?? 'Unknown Client',
          email: '',
          userType: 'client',
          isActive: true,
        ),
        projects: [],
        issueDate: DateTime.now(),
        totalAmount: invoiceData['amount'] ?? 0,
        status: 'unpaid',
        notes: invoiceData['notes'] ?? '',
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        invoiceNumber: 'TEMP-${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return true;
  }

  Future<void> downloadInvoicePDF(String invoiceId) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Implement actual PDF download
  }

  // Helper method to check if an invoice exists
  bool hasInvoice(String invoiceId) {
    return _invoices.any((invoice) => invoice.id == invoiceId);
  }

  // Get filtered invoices based on status
  List<InvoiceItem> getFilteredInvoices(String status) {
    if (status == 'All') return _invoices;
    return _invoices
        .where(
          (invoice) => invoice.status?.toLowerCase() == status.toLowerCase(),
        )
        .toList();
  }
}
