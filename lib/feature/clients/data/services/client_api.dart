import 'dart:developer';

import 'package:project_management/feature/clients/model/client_list_response_model.dart';
import 'package:project_management/shared/networks/dio/base_api.dart';
import 'package:project_management/shared/networks/dio/dio.dart';
import 'package:project_management/shared/networks/endpoints.dart';

final class ClientApi extends BaseApi {
  ClientApi._internal();
  static final ClientApi _singleton = ClientApi._internal();
  static ClientApi get instance => _singleton;

  /// Get client list with pagination, search, sorting, and filters
  Future<ApiResponse<ClientListResponseModel>> getClientList({
    required int page,
    required int perPage,
    String search = '',
    String orderBy = 'desc',
    String? role,
    String? status,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'perPage': perPage,
      'search': search,
      'order_by': orderBy,
      'user_type': 'client',
    };

    if (role != null && role.isNotEmpty) {
      queryParams['role'] = role;
    }

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    log('Fetching client list: $queryParams');

    return getRequest<ClientListResponseModel>(
      endpoint: Endpoints.getClientList(),
      queryParameters: queryParams,
      fromJson: ClientListResponseModel.fromJson,
      errorMessage: 'Failed to fetch client list.',
    );
  }
}
