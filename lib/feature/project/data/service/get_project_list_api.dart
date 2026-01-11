import 'dart:developer';

import 'package:project_management/feature/project/model/get_project_details_response_model.dart';
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
    required String? userId,
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
    if (userId != null && userId.isNotEmpty) {
      queryParams['userId'] = userId;
    }

    log("Fetching project list with params: $queryParams");

    return getRequest<GetProjectListResponseModel>(
      endpoint: Endpoints.getProjectList(),
      queryParameters: queryParams,
      fromJson: GetProjectListResponseModel.fromJson,
      errorMessage: 'Failed to fetch project list.',
    );
  }

  /// Get single project details by ID
  Future<ApiResponse<GetProjectDetailsResponseModel>> getProjectDetails({
    required String projectId,
  }) async {
    try {
      log("Fetching project details for ID: $projectId");

      return getRequest<GetProjectDetailsResponseModel>(
        endpoint: Endpoints.getProjectDetails(id: projectId),
        fromJson: (json) {
          try {
            return GetProjectDetailsResponseModel.fromJson(json);
          } catch (e) {
            log('Error parsing project details response: $e');
            // Return an empty response with error message
            return GetProjectDetailsResponseModel(
              statusCode: 500,
              success: false,
              message: 'Failed to parse response: $e',
              data: null,
            );
          }
        },
        errorMessage: 'Failed to fetch project details.',
      );
    } catch (e) {
      log('Error in getProjectDetails API call: $e');
      rethrow;
    }
  }

  /// Update project details
  // Future<ApiResponse<GetProjectDetailsResponseModel>> updateProject({
  //   required String projectId,
  //   required Map<String, dynamic> updateData,
  // }) async {
  //   try {
  //     log("Updating project $projectId with data: $updateData");

  //     return putRequest<GetProjectDetailsResponseModel>(
  //       endpoint: Endpoints.updateProject(projectId),
  //       data: updateData,
  //       fromJson: (json) {
  //         try {
  //           return GetProjectDetailsResponseModel.fromJson(json);
  //         } catch (e) {
  //           log('Error parsing update project response: $e');
  //           // Return an empty response with error message
  //           return GetProjectDetailsResponseModel(
  //             statusCode: 500,
  //             success: false,
  //             message: 'Failed to parse response: $e',
  //             data: null,
  //           );
  //         }
  //       },
  //       errorMessage: 'Failed to update project.',
  //     );
  //   } catch (e) {
  //     log('Error in updateProject API call: $e');
  //     rethrow;
  //   }
  // }
}
