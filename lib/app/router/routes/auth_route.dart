import 'package:go_router/go_router.dart';
import 'package:project_management/app/router/config/route_names.dart';
import 'package:project_management/feature/auth/presentation/view/login_screen.dart';

class AuthRouter {
  static List<GoRoute> get routes => [
    GoRoute(
      path: RouteNames.login,
      name: RouteNames.login.name,
      builder: (_, state) {
        return LoginScreen();
      },
    ),
  ];
}
