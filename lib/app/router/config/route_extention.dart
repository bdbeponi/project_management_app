import 'package:project_management/app/router/config/navigation_service.dart';
import 'package:project_management/app/router/config/route_names.dart';
import 'package:project_management/utils/di.dart';

final nav = locator<NavigationService>();

extension NavHelpers on NavigationService {
  //======================
  // Common Routes
  //======================

  void goBack() => pop();
  void toLoading() => go(RouteNames.initialLoading);

  //======================
  // Auth Routes
  //======================

  void toLogin() => goNamed(RouteNames.login.name);
  void toNavigation() => go(RouteNames.dashbord);
  void toProjectDetails({
    required String? projectName,
    required String? projectId,
  }) => pushNamedWithExtra(
    RouteNames.projectDetails.name,
    extra: {"projectId": projectId, "projectName": projectName},
  );
    void toEditProject() => pushNamed(RouteNames.editProject.name);
}
