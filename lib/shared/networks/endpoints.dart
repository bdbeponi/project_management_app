// ignore_for_file: constant_identifier_names

// const String url = "https://project.toletpanda.com/api";
const String url = "https://backend.woptio.website/api";
const String imageUrl = "https://backend.woptio.website/";

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

  static String login() => "/v1/login";

  // static String refreshToken() => "/auth/v1/login";

  ///============================
  /// **** Projects ****
  ///============================

  static String getProjectList() => "/v1/get-project-list";
  static String getProjectDetails({required String id}) =>
      "/v1/get-single-project/$id";

  ///============================
  /// **** Invoices ****
  ///============================

  // Invoice endpoints
  static String getInvoiceList() => '/v1/get-invoice-list';

  // static String getInvoiceDetails({required String id}) => '/invoices/$id';

  // static String createInvoice() => '/invoices';

  // static String updateInvoice(String id) => '/invoices/$id';

  // static String deleteInvoice(String id) => '/invoices/$id';

  // static String updateInvoiceStatus(String id) => '/invoices/$id/status';

  // static String downloadInvoice(String id) => '/invoices/$id/download';

  // static String sendInvoiceEmail(String id) => '/invoices/$id/send-email';

  ///============================
  /// **** Clients ****
  ///============================
  static String getClientList() => '/v1/get-user-list';
}
