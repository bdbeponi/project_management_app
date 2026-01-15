import 'dart:developer';

import 'package:project_management/db/service/login/login_local_service.dart';
import 'package:project_management/feature/profile/model/get_user_profile_response_model.dart';
import 'package:project_management/shared/networks/dio/base_api.dart';
import 'package:project_management/shared/networks/dio/dio.dart';
import 'package:project_management/shared/networks/endpoints.dart';

final class GetProfileApi extends BaseApi {
  GetProfileApi._internal();
  static final GetProfileApi _singleton = GetProfileApi._internal();
  static GetProfileApi get instance => _singleton;

  /// Get invoice list with pagination, search, sorting, and filters
  Future<ApiResponse<GetUserProfileResponseModel>> getInvoiceList() async {
    final userID = LoginLocalService().userId;

    return getRequest<GetUserProfileResponseModel>(
      endpoint: Endpoints.getUserProfile(userID),
      // queryParameters: queryParams,
      fromJson: (json) {
        try {
          return GetUserProfileResponseModel.fromJson(json);
        } catch (e) {
          log('Error parsing invoice list response: $e');
          // Return an empty response with error message
          return GetUserProfileResponseModel(
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
}
