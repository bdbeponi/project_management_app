import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/feature/dashboard/presentation/view_model/dashbord_vm.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/bar_chart_card.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/earnings_card.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/performance_chart.dart';
import 'package:project_management/feature/dashboard/presentation/widgets/stat_card.dart';
import 'package:project_management/feature/profile/presentation/view/profile_screen.dart';
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
    return Consumer<DashbordViewModel>(
      builder: (context, DashbordViewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _getSelectedScreen(DashbordViewModel.selectedBottomNavIndex),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     HapticFeedback.mediumImpact();
          //     // TODO: Implement add new project/item
          //     ScaffoldMessenger.of(
          //       context,
          //     ).showSnackBar(const SnackBar(content: Text('Add new item')));
          //   },
          //   backgroundColor: Theme.of(context).colorScheme.primary,
          //   child: const Icon(Icons.add, size: 28),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // bottomNavigationBar: _buildBottomNav(context, DashbordViewModel),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);

    return AppBar(
      title: Text(
        'Skillers Zone',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      actions: [
        // Search
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            HapticFeedback.lightImpact();
            // TODO: Implement search
          },
        ),
        // Notifications
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
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
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.2),
              child: Text(
                // authProvider.currentUser?['name']
                //         ?.substring(0, 1)
                //         .toUpperCase() ??
                'S',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return const _DashboardHome();
      case 1:
        return const ProfileScreen();
      case 2:
        return const _NotificationsPlaceholder();
      default:
        return const _DashboardHome();
    }
  }

  Widget _buildBottomNav(BuildContext context, DashbordViewModel provider) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              isSelected: provider.selectedBottomNavIndex == 0,
              onTap: () {
                HapticFeedback.selectionClick();
                provider.setBottomNavIndex(0);
              },
            ),
            _NavBarItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              isSelected: provider.selectedBottomNavIndex == 1,
              onTap: () {
                HapticFeedback.selectionClick();
                provider.setBottomNavIndex(1);
              },
            ),
            const SizedBox(width: 40), // Space for FAB
            _NavBarItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              isSelected: provider.selectedBottomNavIndex == 2,
              onTap: () {
                HapticFeedback.selectionClick();
                provider.setBottomNavIndex(2);
              },
            ),
            _NavBarItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              isSelected: provider.selectedBottomNavIndex == 3,
              onTap: () {
                HapticFeedback.selectionClick();
                provider.setBottomNavIndex(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Colors.grey;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
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

class _NotificationsPlaceholder extends StatelessWidget {
  const _NotificationsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
