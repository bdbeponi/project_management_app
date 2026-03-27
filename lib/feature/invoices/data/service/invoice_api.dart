import 'dart:developer';

import 'package:project_management/db/service/login/login_local_service.dart';
import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';
import 'package:project_management/shared/networks/dio/base_api.dart';
import 'package:project_management/shared/networks/dio/dio.dart';
import 'package:project_management/shared/networks/endpoints.dart';

final class InvoiceApi extends BaseApi {
  InvoiceApi._internal();
  static final InvoiceApi _singleton = InvoiceApi._internal();
  static InvoiceApi get instance => _singleton;

  /// Get invoice list with pagination, search, sorting, and filters
  Future<ApiResponse<InvoiceListResponseModel>> getInvoiceList({
    required int page,
    required int pageSize,
    String search = '',
    String orderBy = 'desc',
    String? status,
    // String clientId =,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Build query parameters
    final Map<String, dynamic> queryParams = {
      'page': page,
      'page_size': pageSize,
      'search': search,
      'order_by': orderBy,
    };

    // Add optional parameters if they're not null or empty
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    if (true) {
      queryParams['clientId'] = LoginLocalService().userId;
    }

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }

    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    log("Fetching invoice list with params: $queryParams");

    return getRequest<InvoiceListResponseModel>(
      endpoint: Endpoints.getInvoiceList(),
      queryParameters: queryParams,
      fromJson: (json) {
        try {
          return InvoiceListResponseModel.fromJson(json);
        } catch (e) {
          log('Error parsing invoice list response: $e');
          // Return an empty response with error message
          return InvoiceListResponseModel(
            statusCode: 500,
            success: false,
            message: 'Failed to parse response: $e',
            data: null,
          );
        }
      },
      errorMessage: 'Failed to fetch invoice list.',
    );
  }

  /// Get single invoice details by ID
  // Future<ApiResponse<InvoiceListResponseModel>> getInvoiceDetails({
  //   required String invoiceId,
  // }) async {
  //   try {
  //     log("Fetching invoice details for ID: $invoiceId");

  //     return getRequest<InvoiceListResponseModel>(
  //       endpoint: Endpoints.getInvoiceDetails(id: invoiceId),
  //       fromJson: (json) {
  //         try {
  //           // The response might be a single invoice object or wrapped differently
  //           // Adjust based on your actual API response structure
  //           if (json['data'] != null && json['data'] is Map<String, dynamic>) {
  //             // If the API returns a single invoice in 'data' field
  //             return InvoiceListResponseModel.fromJson(json);
  //           } else {
  //             // If the API returns the invoice directly
  //             return InvoiceListResponseModel(
  //               statusCode: 200,
  //               success: true,
  //               message: 'Invoice fetched successfully',
  //               data: InvoiceData(
  //                 items: [InvoiceItem.fromJson(json)],
  //                 meta: Meta(
  //                   currentPage: 1,
  //                   from: 1,
  //                   lastPage: 1,
  //                   perPage: 1,
  //                   to: 1,
  //                   total: 1,
  //                 ),
  //               ),
  //             );
  //           }
  //         } catch (e) {
  //           log('Error parsing invoice details response: $e');
  //           // Return an empty response with error message
  //           return InvoiceListResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to fetch invoice details.',
  //     );
  //   } catch (e) {
  //     log('Error in getInvoiceDetails API call: $e');
  //     rethrow;
  //   }
  // }

  // /// Create a new invoice
  // Future<ApiResponse<InvoiceListResponseModel>> createInvoice({
  //   required String clientId,
  //   required List<Map<String, dynamic>> projects,
  //   required DateTime issueDate,
  //   String? notes,
  //   int? discount,
  //   int? tax,
  //   String? status,
  // }) async {
  //   try {
  //     final Map<String, dynamic> invoiceData = {
  //       'clientId': clientId,
  //       'projects': projects,
  //       'issueDate': issueDate.toIso8601String(),
  //       'notes': notes ?? '',
  //       'discount': discount ?? 0,
  //       'tax': tax ?? 0,
  //       'status': status ?? 'unpaid',
  //     };

  //     log("Creating invoice with data: $invoiceData");

  //     return postRequest<InvoiceListResponseModel>(
  //       endpoint: Endpoints.createInvoice(),
  //       data: invoiceData,
  //       fromJson: (json) {
  //         try {
  //           return InvoiceListResponseModel.fromJson(json);
  //         } catch (e) {
  //           log('Error parsing create invoice response: $e');
  //           return InvoiceListResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to create invoice.',
  //     );
  //   } catch (e) {
  //     log('Error in createInvoice API call: $e');
  //     rethrow;
  //   }
  // }

  // /// Update invoice details
  // Future<ApiResponse<InvoiceListResponseModel>> updateInvoice({
  //   required String invoiceId,
  //   required Map<String, dynamic> updateData,
  // }) async {
  //   try {
  //     log("Updating invoice $invoiceId with data: $updateData");

  //     return putRequest<InvoiceListResponseModel>(
  //       endpoint: Endpoints.updateInvoice(invoiceId),
  //       data: updateData,
  //       fromJson: (json) {
  //         try {
  //           return InvoiceListResponseModel.fromJson(json);
  //         } catch (e) {
  //           log('Error parsing update invoice response: $e');
  //           return InvoiceListResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to update invoice.',
  //     );
  //   } catch (e) {
  //     log('Error in updateInvoice API call: $e');
  //     rethrow;
  //   }
  // }

  // /// Delete an invoice
  // Future<ApiResponse<InvoiceListResponseModel>> deleteInvoice({
  //   required String invoiceId,
  // }) async {
  //   try {
  //     log("Deleting invoice with ID: $invoiceId");

  //     return deleteRequest<InvoiceListResponseModel>(
  //       endpoint: Endpoints.deleteInvoice(invoiceId),
  //       fromJson: (json) {
  //         try {
  //           return InvoiceListResponseModel.fromJson(json);
  //         } catch (e) {
  //           log('Error parsing delete invoice response: $e');
  //           return InvoiceListResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to delete invoice.',
  //     );
  //   } catch (e) {
  //     log('Error in deleteInvoice API call: $e');
  //     rethrow;
  //   }
  // }

  // /// Update invoice status (mark as paid/unpaid)
  // Future<ApiResponse<InvoiceListResponseModel>> updateInvoiceStatus({
  //   required String invoiceId,
  //   required String status, // 'paid' or 'unpaid'
  // }) async {
  //   try {
  //     log("Updating invoice $invoiceId status to: $status");

  //     return putRequest<InvoiceListResponseModel>(
  //       endpoint: Endpoints.updateInvoiceStatus(invoiceId),
  //       data: {'status': status},
  //       fromJson: (json) {
  //         try {
  //           return InvoiceListResponseModel.fromJson(json);
  //         } catch (e) {
  //           log('Error parsing update invoice status response: $e');
  //           return InvoiceListResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to update invoice status.',
  //     );
  //   } catch (e) {
  //     log('Error in updateInvoiceStatus API call: $e');
  //     rethrow;
  //   }
  // }

  // /// Download invoice as PDF
  // Future<ApiResponse<dynamic>> downloadInvoice({
  //   required String invoiceId,
  // }) async {
  //   try {
  //     log("Downloading invoice PDF for ID: $invoiceId");

  //     return getRequest<dynamic>(
  //       endpoint: Endpoints.downloadInvoice(invoiceId),
  //       fromJson: (json) => json, // Return raw response for file download
  //       errorMessage: 'Failed to download invoice.',
  //     );
  //   } catch (e) {
  //     log('Error in downloadInvoice API call: $e');
  //     rethrow;
  //   }
  // }

  // /// Send invoice via email
  // Future<ApiResponse<InvoiceListResponseModel>> sendInvoiceEmail({
  //   required String invoiceId,
  //   required String email,
  //   String? message,
  // }) async {
  //   try {
  //     final Map<String, dynamic> emailData = {
  //       'email': email,
  //       'message': message ?? '',
  //     };

  //     log("Sending invoice $invoiceId to email: $email");

  //     return postRequest<InvoiceListResponseModel>(
  //       endpoint: Endpoints.sendInvoiceEmail(invoiceId),
  //       data: emailData,
  //       fromJson: (json) {
  //         try {
  //           return InvoiceListResponseModel.fromJson(json);
  //         } catch (e) {
  //           log('Error parsing send invoice email response: $e');
  //           return InvoiceListResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to send invoice email.',
  //     );
  //   } catch (e) {
  //     log('Error in sendInvoiceEmail API call: $e');
  //     rethrow;
  //   }
  // }
}
