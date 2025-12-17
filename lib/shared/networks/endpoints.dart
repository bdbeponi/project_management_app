// ignore_for_file: constant_identifier_names

const String url = "https://www.baadol.com/api";
// const String imageUrl = "https://backend.bdbeponi.com/";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  ///============================
  /// **** AUthentication ****
  ///============================

  static String login() => "/auth/v1/login";
  static String phoneVerify() => "/auth/v1/register/otp-request";
  static String phoneOtpVerify() => "/auth/v1/register/otp/verify";
  static String signup() => "/auth/v1/register/complete";
  static String forgotPassOtp() => "/v1/reset/password/otp";
  static String forgotPassOtpVerify() => "/v1/reset/password/otp/verify";
  static String forgotPassword() => "/v1/reset/password";

  ///============================
  /// **** Explore List ****
  ///============================

  static String getSubjectList() => "/auth/v1/subjects/list";
  static String getQuickExamInfo() => "/auth/v1/quick-exam/info";
  static String getExamQues() => "/auth/v1/quick-exam/get-questions";
  static String getQuickExamHistory() => "/auth/v1/quick-exam/history";
  static String submitQuickExam() => "/auth/v1/quick-exam/submit";
  static String getImproveList() => "/auth/v1/quick-exam/improvement";
  static String getPracticeWrongQues({
    required int page,
    required int perPage,
    int? subjectId,
  }) {
    final queryParams = {
      "per_page": perPage.toString(),
      "page": page.toString(),
      if (subjectId != null) "subject_id": subjectId.toString(),
    };

    final queryString =
        queryParams.entries.map((e) => "${e.key}=${e.value}").join("&");

    return "/auth/v1/quick-exam/practise-wrong-answers?$queryString";
  }

  static String checkQuickExamEligibility() => "/auth/v1/quick-exam/check-eligibility";

  ///============================
  /// **** Leaderbord ****
  ///============================
  static String getCampaignHistory({required int page, required int perPage}) =>
      "/auth/v1/campaign/expired?page=$page&per_page=$perPage";
  // static String getUserPointHistory(
  //         {required dynamic id, required int page, required int perPage}) =>
  //     "/auth/v1/campaign/user-points/$id?page=$page&per_page=$perPage";
  static String getUserPointHistory(
          {required int id, required int page, required int perPage}) =>
      "/auth/v1/campaign/user-points/$id?page=$page&per_page=$perPage";

  static String getCurrentCampaign() => "/auth/v1/campaign/ongoing";
  static String getCampaignDetails({required int id}) =>
      "/auth/v1/campaign/details/$id";

  ///============================
  /// **** Profile ****
  ///============================

  static String getProfile() => "/auth/v1/profile";
  static String editProfile() => "/auth/v1/profile/update";
  static String updatePassword() => "/auth/v1/password/update";
}
