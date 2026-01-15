// import 'dart:developer';

// import 'package:project_management/feature/invoices/data/service/invoice_api.dart';
// import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';

// class InvoiceRepository {
//   final InvoiceApi _invoiceApi;

//   // Pagination state
//   int _currentPage = 1;
//   int _totalPages = 1;
//   int _totalItems = 0;
//   int _pageSize = 10;
//   String _currentSearch = '';
//   String _currentOrderBy = 'desc';
//   String? _currentStatus;
//   String? _currentClientId;
//   DateTime? _currentStartDate;
//   DateTime? _currentEndDate;

//   // Cache for current page
//   List<InvoiceItem>? _cachedItems;

//   InvoiceRepository({InvoiceApi? invoiceApi})
//     : _invoiceApi = invoiceApi ?? InvoiceApi.instance;

//   /// Fetch invoice list with pagination
//   Future<InvoiceListResponseModel> getInvoices({
//     int page = 1,
//     int pageSize = 10,
//     String search = '',
//     String orderBy = 'desc',
//     String? status,
//     String? clientId,
//     DateTime? startDate,
//     DateTime? endDate,
//     bool forceRefresh = false,
//   }) async {
//     try {
//       // Update current parameters
//       _currentPage = page;
//       _pageSize = pageSize;
//       _currentSearch = search;
//       _currentOrderBy = orderBy;
//       _currentStatus = status;
//       _currentClientId = clientId;
//       _currentStartDate = startDate;
//       _currentEndDate = endDate;

//       // Check cache first (if not forcing refresh)
//       if (!forceRefresh && _cachedItems != null && page == _currentPage) {
//         log('Returning cached data for page $page');
//         return InvoiceListResponseModel(
//           statusCode: 200,
//           success: true,
//           message: 'Loaded from cache',
//           data: InvoiceData(
//             items: _cachedItems!,
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
//       log('Fetching invoices from API - Page: $page, Search: "$search"');
//       final response = await _invoiceApi.getInvoiceList(
//         page: page,
//         pageSize: pageSize,
//         search: search,
//         orderBy: orderBy,
//         status: status,
//         clientId: clientId,
//         startDate: startDate,
//         endDate: endDate,
//       );

//       // Check response
//       if (!response.success) {
//         throw InvoiceFailure(response.message ?? 'Failed to fetch invoices');
//       }

//       final invoiceData = response.data;
//       if (invoiceData == null) {
//         throw InvoiceFailure('No data received from server');
//       }

//       // Update pagination info
//       if (invoiceData.data?.meta != null) {
//         _totalPages = invoiceData.data!.meta!.lastPage ?? 1;
//         _totalItems = invoiceData.data!.meta!.total ?? 0;
//       } else {
//         // Default values if meta is null
//         _totalPages = 1;
//         _totalItems = invoiceData.data?.items?.length ?? 0;
//       }

//       // Cache the results
//       if (invoiceData.data?.items != null) {
//         _cachedItems = invoiceData.data!.items!;
//       } else {
//         _cachedItems = [];
//       }

//       return invoiceData;
//     } catch (e) {
//       // Try to return cached data if available
//       if (_cachedItems != null) {
//         log('API failed, returning cached data: $e');
//         return InvoiceListResponseModel(
//           statusCode: 200,
//           success: true,
//           message: 'Loaded from cache (offline)',
//           data: InvoiceData(
//             items: _cachedItems!,
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

//       // Handle error
//       return _handleError(e);
//     }
//   }

//   /// Load next page
//   Future<InvoiceListResponseModel> loadNextPage() async {
//     final nextPage = _currentPage + 1;

//     if (nextPage > _totalPages) {
//       return InvoiceListResponseModel(
//         statusCode: 400,
//         success: false,
//         message: 'No more pages available',
//         data: null,
//       );
//     }

//     return getInvoices(
//       page: nextPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       status: _currentStatus,
//       clientId: _currentClientId,
//       startDate: _currentStartDate,
//       endDate: _currentEndDate,
//     );
//   }

//   /// Load previous page
//   Future<InvoiceListResponseModel> loadPreviousPage() async {
//     final prevPage = _currentPage - 1;

//     if (prevPage < 1) {
//       return InvoiceListResponseModel(
//         statusCode: 400,
//         success: false,
//         message: 'Already on first page',
//         data: null,
//       );
//     }

//     return getInvoices(
//       page: prevPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       status: _currentStatus,
//       clientId: _currentClientId,
//       startDate: _currentStartDate,
//       endDate: _currentEndDate,
//     );
//   }

//   /// Refresh current page
//   Future<InvoiceListResponseModel> refreshCurrentPage() async {
//     return getInvoices(
//       page: _currentPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       status: _currentStatus,
//       clientId: _currentClientId,
//       startDate: _currentStartDate,
//       endDate: _currentEndDate,
//       forceRefresh: true,
//     );
//   }

//   /// Search invoices (resets to page 1)
//   Future<InvoiceListResponseModel> searchInvoices({
//     required String query,
//     String? status,
//     String? clientId,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     // Clear cache when starting new search
//     _cachedItems = null;

//     return getInvoices(
//       page: 1,
//       pageSize: _pageSize,
//       search: query,
//       orderBy: _currentOrderBy,
//       status: status,
//       clientId: clientId,
//       startDate: startDate,
//       endDate: endDate,
//     );
//   }

//   /// Filter invoices by status
//   Future<InvoiceListResponseModel> filterByStatus({
//     required String status,
//   }) async {
//     // Clear cache when applying new filter
//     _cachedItems = null;

//     return getInvoices(
//       page: 1,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       status: status,
//       clientId: _currentClientId,
//       startDate: _currentStartDate,
//       endDate: _currentEndDate,
//     );
//   }

//   /// Filter invoices by client
//   Future<InvoiceListResponseModel> filterByClient({
//     required String clientId,
//   }) async {
//     // Clear cache when applying new filter
//     _cachedItems = null;

//     return getInvoices(
//       page: 1,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       status: _currentStatus,
//       clientId: clientId,
//       startDate: _currentStartDate,
//       endDate: _currentEndDate,
//     );
//   }

//   /// Filter invoices by date range
//   Future<InvoiceListResponseModel> filterByDateRange({
//     required DateTime startDate,
//     required DateTime endDate,
//   }) async {
//     // Clear cache when applying new filter
//     _cachedItems = null;

//     return getInvoices(
//       page: 1,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: _currentOrderBy,
//       status: _currentStatus,
//       clientId: _currentClientId,
//       startDate: startDate,
//       endDate: endDate,
//     );
//   }

//   /// Sort invoices
//   Future<InvoiceListResponseModel> sortInvoices({
//     required String orderBy,
//   }) async {
//     // Clear cache when changing sort
//     _cachedItems = null;

//     return getInvoices(
//       page: _currentPage,
//       pageSize: _pageSize,
//       search: _currentSearch,
//       orderBy: orderBy,
//       status: _currentStatus,
//       clientId: _currentClientId,
//       startDate: _currentStartDate,
//       endDate: _currentEndDate,
//     );
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
//       'status': _currentStatus,
//       'clientId': _currentClientId,
//       'startDate': _currentStartDate,
//       'endDate': _currentEndDate,
//     };
//   }

//   /// Get cached invoices
//   List<InvoiceItem>? getCachedInvoices() {
//     return _cachedItems;
//   }

//   /// Clear cache
//   void clearCache() {
//     _cachedItems = null;
//     _currentPage = 1;
//     _totalPages = 1;
//     _totalItems = 0;
//   }

//   /// Get invoice statistics from cached invoices
//   Map<String, dynamic> getInvoiceStats() {
//     if (_cachedItems == null || _cachedItems!.isEmpty) {
//       return {
//         'total': 0,
//         'paid': 0,
//         'unpaid': 0,
//         'totalAmount': 0.0,
//         'totalPaidAmount': 0.0,
//         'totalUnpaidAmount': 0.0,
//         'averageAmount': 0.0,
//       };
//     }

//     int paidCount = 0;
//     int unpaidCount = 0;
//     double totalPaidAmount = 0.0;
//     double totalUnpaidAmount = 0.0;
//     double totalAmount = 0.0;

//     for (final invoice in _cachedItems!) {
//       totalAmount += (invoice.totalAmount ?? 0).toDouble();

//       if (invoice.status?.toLowerCase() == 'paid') {
//         paidCount++;
//         totalPaidAmount += (invoice.totalAmount ?? 0).toDouble();
//       } else if (invoice.status?.toLowerCase() == 'unpaid') {
//         unpaidCount++;
//         totalUnpaidAmount += (invoice.totalAmount ?? 0).toDouble();
//       }
//     }

//     return {
//       'total': _cachedItems!.length,
//       'paid': paidCount,
//       'unpaid': unpaidCount,
//       'totalAmount': totalAmount,
//       'totalPaidAmount': totalPaidAmount,
//       'totalUnpaidAmount': totalUnpaidAmount,
//       'averageAmount': totalAmount / _cachedItems!.length,
//     };
//   }

//   /// Get client-wise invoice summary
//   Map<String, Map<String, dynamic>> getClientWiseSummary() {
//     if (_cachedItems == null || _cachedItems!.isEmpty) {
//       return {};
//     }

//     final clientSummary = <String, Map<String, dynamic>>{};

//     for (final invoice in _cachedItems!) {
//       final clientId = invoice.clientId?.id;
//       final clientName = invoice.clientId?.userName ?? 'Unknown Client';

//       if (clientId != null) {
//         if (!clientSummary.containsKey(clientId)) {
//           clientSummary[clientId] = {
//             'name': clientName,
//             'totalInvoices': 0,
//             'paidInvoices': 0,
//             'unpaidInvoices': 0,
//             'totalAmount': 0.0,
//             'paidAmount': 0.0,
//             'unpaidAmount': 0.0,
//           };
//         }

//         final summary = clientSummary[clientId]!;
//         summary['totalInvoices'] = (summary['totalInvoices'] as int) + 1;
//         summary['totalAmount'] =
//             (summary['totalAmount'] as double) +
//             (invoice.totalAmount ?? 0).toDouble();

//         if (invoice.status?.toLowerCase() == 'paid') {
//           summary['paidInvoices'] = (summary['paidInvoices'] as int) + 1;
//           summary['paidAmount'] =
//               (summary['paidAmount'] as double) +
//               (invoice.totalAmount ?? 0).toDouble();
//         } else if (invoice.status?.toLowerCase() == 'unpaid') {
//           summary['unpaidInvoices'] = (summary['unpaidInvoices'] as int) + 1;
//           summary['unpaidAmount'] =
//               (summary['unpaidAmount'] as double) +
//               (invoice.totalAmount ?? 0).toDouble();
//         }
//       }
//     }

//     return clientSummary;
//   }

//   // Private helper method
//   InvoiceListResponseModel _handleError(dynamic e) {
//     String errorMessage;

//     if (e is InvoiceFailure) {
//       errorMessage = e.message;
//     } else {
//       final errorString = e.toString();

//       if (errorString.contains('timeout') ||
//           errorString.contains('SocketException')) {
//         errorMessage = 'Connection timeout. Check your internet.';
//       } else if (errorString.contains('401') || errorString.contains('403')) {
//         errorMessage = 'Session expired. Please login again.';
//       } else if (errorString.contains('404')) {
//         errorMessage = 'Invoices not found.';
//       } else if (errorString.contains('500')) {
//         errorMessage = 'Server error. Try again later.';
//       } else {
//         errorMessage = 'An error occurred. Please try again.';
//       }
//     }

//     return InvoiceListResponseModel(
//       statusCode: 500,
//       success: false,
//       message: errorMessage,
//       data: null,
//     );
//   }
// }

// class InvoiceFailure implements Exception {
//   final String message;
//   InvoiceFailure(this.message);

//   @override
//   String toString() => message;
// }

import 'dart:developer';

import 'package:project_management/feature/invoices/data/service/invoice_api.dart';
import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';

class InvoiceRepository {
  final InvoiceApi _invoiceApi;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _pageSize = 10;
  String _currentSearch = '';
  String _currentOrderBy = 'desc';
  String? _currentStatus;
  String? _currentClientId;
  DateTime? _currentStartDate;
  DateTime? _currentEndDate;

  // Cache for current page
  List<InvoiceItem>? _cachedItems;

  InvoiceRepository({InvoiceApi? invoiceApi})
    : _invoiceApi = invoiceApi ?? InvoiceApi.instance;

  /// Fetch invoice list with pagination
  Future<InvoiceListResponseModel> getInvoices({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String orderBy = 'desc',
    String? status,
    String? clientId,
    DateTime? startDate,
    DateTime? endDate,
    bool refreshCache = false,
  }) async {
    try {
      // Update current parameters
      _currentPage = page;
      _pageSize = pageSize;
      _currentSearch = search;
      _currentOrderBy = orderBy;
      _currentStatus = status;
      _currentClientId = clientId;
      _currentStartDate = startDate;
      _currentEndDate = endDate;

      // Check cache first (if not refreshing)
      if (!refreshCache && _cachedItems != null && page == _currentPage) {
        log('Returning cached data for page $page');
        return InvoiceListResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache',
          data: InvoiceData(
            items: _cachedItems!,
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

      // Call API
      log('Fetching invoices from API - Page: $page, Search: "$search"');
      final response = await _invoiceApi.getInvoiceList(
        page: page,
        pageSize: pageSize,
        search: search,
        orderBy: orderBy,
        status: status,
        // clientId: clientId,
        startDate: startDate,
        endDate: endDate,
      );

      // Check response
      if (!response.success) {
        throw InvoiceFailure(response.message ?? 'Failed to fetch invoices');
      }

      final invoiceData = response.data;
      if (invoiceData == null) {
        throw InvoiceFailure('No data received from server');
      }

      // Update pagination info
      if (invoiceData.data?.meta != null) {
        _totalPages = invoiceData.data!.meta!.lastPage ?? 1;
        _totalItems = invoiceData.data!.meta!.total ?? 0;
      } else {
        // Default values if meta is null
        _totalPages = 1;
        _totalItems = invoiceData.data?.items?.length ?? 0;
      }

      // Cache the results
      if (invoiceData.data?.items != null) {
        _cachedItems = invoiceData.data!.items!;
      } else {
        _cachedItems = [];
      }

      return invoiceData;
    } catch (e) {
      // Try to return cached data if available
      if (_cachedItems != null) {
        log('API failed, returning cached data: $e');
        return InvoiceListResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache (offline)',
          data: InvoiceData(
            items: _cachedItems!,
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

      // Handle error
      return _handleError(e);
    }
  }

  /// Load next page
  Future<InvoiceListResponseModel> loadNextPage() async {
    final nextPage = _currentPage + 1;

    if (nextPage > _totalPages) {
      return InvoiceListResponseModel(
        statusCode: 400,
        success: false,
        message: 'No more pages available',
        data: null,
      );
    }

    return getInvoices(
      page: nextPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      status: _currentStatus,
      clientId: _currentClientId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
    );
  }

  /// Load previous page
  Future<InvoiceListResponseModel> loadPreviousPage() async {
    final prevPage = _currentPage - 1;

    if (prevPage < 1) {
      return InvoiceListResponseModel(
        statusCode: 400,
        success: false,
        message: 'Already on first page',
        data: null,
      );
    }

    return getInvoices(
      page: prevPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      status: _currentStatus,
      clientId: _currentClientId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
    );
  }

  /// Refresh current page
  Future<InvoiceListResponseModel> refreshCurrentPage() async {
    return getInvoices(
      page: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      status: _currentStatus,
      clientId: _currentClientId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      refreshCache: true,
    );
  }

  /// Search invoices (resets to page 1)
  Future<InvoiceListResponseModel> searchInvoices({
    required String query,
    String? status,
    String? clientId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Clear cache when starting new search
    _cachedItems = null;

    return getInvoices(
      page: 1,
      pageSize: _pageSize,
      search: query,
      orderBy: _currentOrderBy,
      status: status,
      clientId: clientId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Filter invoices by status
  Future<InvoiceListResponseModel> filterByStatus({
    required String status,
  }) async {
    // Clear cache when applying new filter
    _cachedItems = null;

    return getInvoices(
      page: 1,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      status: status,
      clientId: _currentClientId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
    );
  }

  /// Filter invoices by client
  Future<InvoiceListResponseModel> filterByClient({
    required String clientId,
  }) async {
    // Clear cache when applying new filter
    _cachedItems = null;

    return getInvoices(
      page: 1,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      status: _currentStatus,
      clientId: clientId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
    );
  }

  /// Filter invoices by date range
  Future<InvoiceListResponseModel> filterByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Clear cache when applying new filter
    _cachedItems = null;

    return getInvoices(
      page: 1,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      status: _currentStatus,
      clientId: _currentClientId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Sort invoices
  Future<InvoiceListResponseModel> sortInvoices({
    required String orderBy,
  }) async {
    // Clear cache when changing sort
    _cachedItems = null;

    return getInvoices(
      page: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: orderBy,
      status: _currentStatus,
      clientId: _currentClientId,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
    );
  }

  /// Get current pagination info
  Map<String, dynamic> getPaginationInfo() {
    return {
      'currentPage': _currentPage,
      'totalPages': _totalPages,
      'totalItems': _totalItems,
      'pageSize': _pageSize,
      'hasMore': _currentPage < _totalPages,
    };
  }

  /// Get current search/filter parameters
  Map<String, dynamic> getCurrentFilters() {
    return {
      'search': _currentSearch,
      'orderBy': _currentOrderBy,
      'status': _currentStatus,
      'clientId': _currentClientId,
      'startDate': _currentStartDate,
      'endDate': _currentEndDate,
    };
  }

  /// Get cached invoices
  List<InvoiceItem>? getCachedInvoices() {
    return _cachedItems;
  }

  /// Clear cache
  void clearCache() {
    _cachedItems = null;
    _currentPage = 1;
    _totalPages = 1;
    _totalItems = 0;
  }

  /// Get invoice statistics from cached invoices
  Map<String, dynamic> getInvoiceStats() {
    if (_cachedItems == null || _cachedItems!.isEmpty) {
      return {
        'total': 0,
        'paid': 0,
        'unpaid': 0,
        'totalAmount': 0.0,
        'totalPaidAmount': 0.0,
        'totalUnpaidAmount': 0.0,
        'averageAmount': 0.0,
      };
    }

    int paidCount = 0;
    int unpaidCount = 0;
    double totalPaidAmount = 0.0;
    double totalUnpaidAmount = 0.0;
    double totalAmount = 0.0;

    for (final invoice in _cachedItems!) {
      totalAmount += (invoice.totalAmount ?? 0).toDouble();

      if (invoice.status?.toLowerCase() == 'paid') {
        paidCount++;
        totalPaidAmount += (invoice.totalAmount ?? 0).toDouble();
      } else if (invoice.status?.toLowerCase() == 'unpaid') {
        unpaidCount++;
        totalUnpaidAmount += (invoice.totalAmount ?? 0).toDouble();
      }
    }

    return {
      'total': _cachedItems!.length,
      'paid': paidCount,
      'unpaid': unpaidCount,
      'totalAmount': totalAmount,
      'totalPaidAmount': totalPaidAmount,
      'totalUnpaidAmount': totalUnpaidAmount,
      'averageAmount': totalAmount / _cachedItems!.length,
    };
  }

  /// Get client-wise invoice summary
  Map<String, Map<String, dynamic>> getClientWiseSummary() {
    if (_cachedItems == null || _cachedItems!.isEmpty) {
      return {};
    }

    final clientSummary = <String, Map<String, dynamic>>{};

    for (final invoice in _cachedItems!) {
      final clientId = invoice.clientId?.id;
      final clientName = invoice.clientId?.userName ?? 'Unknown Client';

      if (clientId != null) {
        if (!clientSummary.containsKey(clientId)) {
          clientSummary[clientId] = {
            'name': clientName,
            'totalInvoices': 0,
            'paidInvoices': 0,
            'unpaidInvoices': 0,
            'totalAmount': 0.0,
            'paidAmount': 0.0,
            'unpaidAmount': 0.0,
          };
        }

        final summary = clientSummary[clientId]!;
        summary['totalInvoices'] = (summary['totalInvoices'] as int) + 1;
        summary['totalAmount'] =
            (summary['totalAmount'] as double) +
            (invoice.totalAmount ?? 0).toDouble();

        if (invoice.status?.toLowerCase() == 'paid') {
          summary['paidInvoices'] = (summary['paidInvoices'] as int) + 1;
          summary['paidAmount'] =
              (summary['paidAmount'] as double) +
              (invoice.totalAmount ?? 0).toDouble();
        } else if (invoice.status?.toLowerCase() == 'unpaid') {
          summary['unpaidInvoices'] = (summary['unpaidInvoices'] as int) + 1;
          summary['unpaidAmount'] =
              (summary['unpaidAmount'] as double) +
              (invoice.totalAmount ?? 0).toDouble();
        }
      }
    }

    return clientSummary;
  }

  // Private helper method
  InvoiceListResponseModel _handleError(dynamic e) {
    String errorMessage;

    if (e is InvoiceFailure) {
      errorMessage = e.message;
    } else {
      final errorString = e.toString();

      if (errorString.contains('timeout') ||
          errorString.contains('SocketException')) {
        errorMessage = 'Connection timeout. Check your internet.';
      } else if (errorString.contains('401') || errorString.contains('403')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (errorString.contains('404')) {
        errorMessage = 'Invoices not found.';
      } else if (errorString.contains('500')) {
        errorMessage = 'Server error. Try again later.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
    }

    return InvoiceListResponseModel(
      statusCode: 500,
      success: false,
      message: errorMessage,
      data: null,
    );
  }
}

class InvoiceFailure implements Exception {
  final String message;
  InvoiceFailure(this.message);

  @override
  String toString() => message;
}
