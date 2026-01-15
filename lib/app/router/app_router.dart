import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_management/app/router/config/navigation_service.dart';
import 'package:project_management/app/router/config/route_names.dart';
import 'package:project_management/app/router/routes/auth_route.dart';
import 'package:project_management/feature/bottom_nav_bar.dart';
import 'package:project_management/feature/clients/presentation/view/client_screen.dart';
import 'package:project_management/feature/dashboard/presentation/view/dashbord_screen.dart';
import 'package:project_management/feature/dummy_screens.dart';
import 'package:project_management/feature/invoices/presentation/view/invoice_screen.dart';
import 'package:project_management/feature/profile/presentation/view/profile_screen.dart';
import 'package:project_management/feature/project/presentation/view/project_details.dart';
import 'package:project_management/feature/project/presentation/view/project_edit_screen.dart';
import 'package:project_management/feature/project/presentation/view/project_screen.dart';
import 'package:project_management/feature/setting/view/setting_screen.dart';
import 'package:project_management/start/loading_screen.dart';

import '../../utils/di.dart';

class AppRouter {
  static late final GoRouter _router;

  static void setupRouter() {
    final navService = locator<NavigationService>();

    _router = GoRouter(
      initialLocation: RouteNames.initialLoading,
      routes: [
        GoRoute(
          path: RouteNames.initialLoading,
          builder: (_, _) => const Loading(),
        ),
        GoRoute(
          path: RouteNames.projectDetails,
          name: RouteNames.projectDetails.name,
          builder: (_, state) {
            final data = state.extra as Map;
            return ProjectDetailsScreen(
              projectId: data["projectId"] ?? "",
              projectName: data["projectName"] ?? "",
            );
          },
        ),
        GoRoute(
          path: RouteNames.editProject,
          name: RouteNames.editProject.name,
          builder: (_, state) {
            // final data = state.extra as Map;
            return EditProjectScreen();
          },
        ),
        GoRoute(
          path: RouteNames.client,
          name: RouteNames.client.name,
          builder: (_, state) {
            // final data = state.extra as Map;
            return ClientScreen();
          },
        ),
        GoRoute(
          path: RouteNames.setting,
          name: RouteNames.setting.name,
          builder: (_, state) {
            // final data = state.extra as Map;
            return SettingsScreen();
          },
        ),

        // // Bottom navigation shell
        _mainNavigationShell(),

        // // Feature-specific routes
        ...AuthRouter.routes,

        // ...ProfileRouter.routes,
      ],

      // Redirect unauthenticated users
      // redirect: (context, state) {
      //   final isLoggedIn = locator<AuthService>().isLoggedIn;
      //   final loggingIn = state.subloc == '/login';
      //   if (!isLoggedIn && !loggingIn) return '/login';
      //   if (isLoggedIn && loggingIn) return '/home';
      //   return null;
      // },
      errorBuilder: (_, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
    );

    navService.setRouter(_router);
  }

  static GoRouter get router => _router;

  static StatefulShellRoute _mainNavigationShell() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          NavigationScreen(shell: navigationShell),
      branches: [
        _buildBranch(RouteNames.dashbord, const DashboardScreen()),
        _buildBranch(RouteNames.earnings, const EarningsScreen()),
        _buildBranch(RouteNames.projects, const ProjectsScreen()),
        _buildBranch(RouteNames.invoices, const InvoicesScreen()),
        _buildBranch(RouteNames.profile, const ProfileScreen()),
      ],
    );
  }

  static StatefulShellBranch _buildBranch(String path, Widget screen) {
    return StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (_, _) => screen)],
    );
  }
}
