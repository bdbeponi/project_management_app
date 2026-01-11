class RouteNames {
  static const String initialLoading = "/";

  //======================
  // Auth Routes
  //======================

  static const String login = "/login";

  //======================
  // Home Routes
  //======================

  static const String dashbord = "/dashbord";
  static const String earnings = "/earnings";

  static const String invoices = "/invoices";

  static const String notification = "/notification";

  //======================
  // Profile Routes
  //======================
  static const String profile = "/profile";
  static const String userProfile = "/user_profile";
  static const String editProfile = "/edit_profile";
  static const String updatePass = "/update_password";

  //======================
  // Projects Routes
  //======================
  static const String projects = "/projects";
  static const String projectDetails = "/project_details";
  static const String editProject = "/edit_project";

  //======================
  // Client Routes
  //======================

  static const String client = "/client";
}

extension AppRoutesName on String {
  /// Returns the route name by removing the leading "/" if present
  String get name => startsWith("/") ? substring(1) : this;
}
