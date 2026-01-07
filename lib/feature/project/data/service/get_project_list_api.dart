import 'dart:developer';

import 'package:project_management/feature/project/model/get_project_list_response_model.dart';
import 'package:project_management/shared/networks/dio/base_api.dart';
import 'package:project_management/shared/networks/dio/dio.dart';
import 'package:project_management/shared/networks/endpoints.dart';

final class GetProjectListApi extends BaseApi {
  GetProjectListApi._internal();
  static final GetProjectListApi _singleton = GetProjectListApi._internal();
  static GetProjectListApi get instance => _singleton;

  /// Get project list with pagination, search, sorting, and filters
  Future<ApiResponse<GetProjectListResponseModel>> getProjectList({
    required int page,
    required int pageSize,
    String search = '',
    String orderBy = 'desc',
    String? role,
    String? status,
  }) async {
    // Build query parameters
    final Map<String, dynamic> queryParams = {
      'page': page,
      'page_size': pageSize,
      'search': search,
      'order_by': orderBy,
    };

    // Add optional parameters if they're not null or empty
    if (role != null && role.isNotEmpty) {
      queryParams['role'] = role;
    }

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    log("Fetching project list with params: $queryParams");

    return getRequest<GetProjectListResponseModel>(
      endpoint: Endpoints.getProjectList(),
      queryParameters: queryParams,
      fromJson: GetProjectListResponseModel.fromJson,
      errorMessage: 'Failed to fetch project list.',
    );
  }
}
