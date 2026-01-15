import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/app/router/config/route_extention.dart';
import 'package:project_management/app/router/config/route_names.dart';
import 'package:project_management/db/service/login/login_local_service.dart';
import 'package:project_management/gen/assets.gen.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:project_management/shared/networks/endpoints.dart';
import 'package:project_management/utils/ui_helpers.dart';
import 'package:provider/provider.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = LoginLocalService();
    // Get the current route location
    final currentRoute = GoRouterState.of(context).uri.path;

    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Drawer(
          child: Container(
            color: themeProv.isDarkMode
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            child: Column(
              children: [
                UIHelper.verticalSpaceSmall,
                // Header with Logo
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: themeProv.isDarkMode
                            ? AppColors.dividerDark
                            : AppColors.dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        // decoration: BoxDecoration(
                        //   color: AppColors.primaryColor,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.asset(Assets.images.skzClientInApp.path),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SKZ Client',
                        style: TextStyle(
                          color: themeProv.isDarkMode
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    children: [
                      DrawerMenuItem(
                        icon: Icons.dashboard_rounded,
                        title: 'Dashboard',
                        isActive: currentRoute == RouteNames.dashbord,
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {
                          context.go(RouteNames.dashbord);
                          Navigator.of(context).pop();
                        },
                      ),
                      // DrawerMenuItem(
                      //   icon: Icons.people_rounded,
                      //   title: 'Clients',
                      //   isActive: currentRoute == RouteNames.client,
                      //   isDarkMode: themeProv.isDarkMode,
                      //   onTap: () {
                      //     nav.toClientScreen();
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                      DrawerMenuItem(
                        icon: Icons.folder_rounded,
                        title: 'Projects',
                        isActive: currentRoute == RouteNames.projects,
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {
                          context.go(RouteNames.projects);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerMenuItem(
                        icon: Icons.description_rounded,
                        title: 'Invoices',
                        isActive: currentRoute == RouteNames.invoices,
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {
                          context.go(RouteNames.invoices);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerMenuItem(
                        icon: Icons.bar_chart_rounded,
                        title: 'Reports',
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {},
                      ),
                      DrawerMenuItem(
                        icon: Icons.payment_rounded,
                        title: 'Payments',
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {},
                      ),
                      DrawerMenuItem(
                        icon: Icons.group_rounded,
                        title: 'Employees',
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {},
                      ),
                      DrawerMenuItem(
                        icon: Icons.settings_rounded,
                        title: 'Settings',
                        isDarkMode: themeProv.isDarkMode,
                        onTap: () {
                          nav.toSettingScreen();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),

                // User Profile Section
                auth.isLoggedIn
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: themeProv.isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            auth.image == null
                                ? Container(
                                    height: 40.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor.withValues(
                                        alpha: themeProv.isDarkMode ? 0.3 : 0.2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        auth.userName != null
                                            ? auth.userName!
                                                  .substring(0, 2)
                                                  .toUpperCase()
                                            : '',
                                        style: TextStyle(
                                          color: themeProv.isDarkMode
                                              ? AppColors.primaryColor
                                              : AppColors.primaryDark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      imageUrl + (auth.image!),
                                      height: 40.h,
                                      width: 40.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    auth.userName ?? 'John Doe',
                                    style: TextStyle(
                                      color: themeProv.isDarkMode
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    auth.email ?? 'admin@woptio.com',
                                    style: TextStyle(
                                      color: themeProv.isDarkMode
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout_rounded),
                              color: themeProv.isDarkMode
                                  ? AppColors.iconError
                                  : AppColors.iconSecondary,
                              onPressed: () async {
                                await LoginLocalService().clearLoginData();

                                nav.toLogin();
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isDarkMode;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.isActive = false,
    this.isDarkMode = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? Colors.white
                      : (isDarkMode
                            ? AppColors.iconSecondaryDark
                            : AppColors.iconSecondary),
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : (isDarkMode
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
