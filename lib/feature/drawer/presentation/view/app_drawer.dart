import 'package:flutter/material.dart';
import 'package:project_management/app/router/config/route_extention.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
          ),
        ),
        child: Column(
          children: [
            // Header with Logo
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF2a2a2a), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'W',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Woptio',
                    style: TextStyle(
                      color: Colors.white,
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
                    isActive: true,
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.people_rounded,
                    title: 'Clients',
                    onTap: () => nav.toClientScreen(),
                  ),
                  DrawerMenuItem(
                    icon: Icons.folder_rounded,
                    title: 'Projects',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.description_rounded,
                    title: 'Invoices',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.payment_rounded,
                    title: 'Payments',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.group_rounded,
                    title: 'Employees',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // User Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF2a2a2a), width: 1),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF8B5CF6),
                    child: const Text(
                      'JD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'admin@woptio.com',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    color: const Color(0xFF9CA3AF),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              )
            : null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.5),
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
                  color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF9CA3AF),
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

// // Example usage in a Scaffold:
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       drawer: const DashboardDrawer(),
//       body: Container(
//         color: const Color(0xFFF5F5F5),
//         child: const Center(child: Text('Dashboard Content')),
//       ),
//     );
//   }
// }
