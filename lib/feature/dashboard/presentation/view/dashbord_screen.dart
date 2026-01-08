import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/dashboard/presentation/view_model/dashbord_vm.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/bar_chart_card.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/earnings_card.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/performance_chart.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/stat_card.dart';
import 'package:project_management/feature/profile/presentation/view/profile_screen.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashbordViewModel(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Scaffold(
          backgroundColor: themeProv.isDarkMode
              ? AppColors.backgroundDark
              : AppColors.backgroundColor,
          appBar: _buildAppBar(context, themeProv),
          // body: _getSelectedScreen(DashbordViewModel.selectedBottomNavIndex),
          body: const _DashboardHome(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeProvider themeProv,
  ) {
    // final authProvider = Provider.of<AuthProvider>(context);

    return AppBar(
      backgroundColor: themeProv.isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundColor,
      title: Text( 
        'Skillers Zone',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: themeProv.isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimary,
        ),
      ),
      actions: [
        // Search
        IconButton(
          icon: Icon(
            Icons.search,
            color: themeProv.isDarkMode
                ? AppColors.iconDark
                : AppColors.iconColor,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            // TODO: Implement search
          },
        ),
        // Notifications
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: themeProv.isDarkMode
                    ? AppColors.iconDark
                    : AppColors.iconColor,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                // TODO: Show notifications
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        // Profile Avatar
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 8),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate to profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryColor.withOpacity(
                themeProv.isDarkMode ? .3 : .2,
              ),
              child: Text(
                // authProvider.currentUser?['name']
                //         ?.substring(0, 1)
                //         .toUpperCase() ??
                'S',
                style: TextStyle(
                  color: themeProv.isDarkMode
                      ? AppColors.primaryColor
                      : AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashbordViewModel>(context);
    final stats = provider.dashboardStats;
    final earnings = provider.earningsData;

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(seconds: 1));
        // TODO: Refresh data from API
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row 1
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Project',
                    value: stats['totalProjects'].toString(),
                    subtitle: 'Recent Project',
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Total Clients',
                    value: stats['totalClients'].toString(),
                    subtitle: 'Recent Clients',
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF6C63FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats Row 2
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'New Project',
                    value: stats['newProjects'].toString(),
                    subtitle: 'Yearly Project',
                    icon: Icons.folder_outlined,
                    iconColor: const Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Users',
                    value: stats['totalUsers'].toString(),
                    subtitle: '',
                    icon: Icons.person_add_outlined,
                    iconColor: const Color(0xFF6C63FF),
                    showChart: true,
                    chartData: provider.userActivityData,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Project Overview Bar Chart
            BarChartCard(
              title: 'Project Overview Graph',
              data: provider.projectOverviewData,
            ),
            const SizedBox(height: 20),

            // Earnings Card
            EarningsCard(earnings: earnings),
            const SizedBox(height: 20),

            // Performance Radar Chart
            PerformanceChart(data: provider.performanceData),
            const SizedBox(height: 80), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }
}
