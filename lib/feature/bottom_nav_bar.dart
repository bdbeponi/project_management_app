// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class NavigationScreen extends StatefulWidget {
//   final StatefulNavigationShell shell;

//   const NavigationScreen({super.key, required this.shell});

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Initialize any required data here
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         body: SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: widget.shell,
//         ),
//         // bottomNavigationBar: _GoogleNavBar(shell: widget.shell),
//         bottomNavigationBar: BottomNavBar(
//           // currentIndex:  widget.shell.currentIndex,
//           // onTabSelected: (index) =>  widget.shell.goBranch(index),
//         ),
//       ),
//     );
//   }
// }

// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.white,
//       height: 90,
//       elevation: 8,
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 8,
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(
//               context,
//               icon: Icons.grid_view_rounded,
//               label: 'Overview',
//               index: 0,
//               isActive: true,
//             ),
//             _buildNavItem(
//               context,
//               icon: Icons.insert_chart_outlined_rounded,
//               label: 'Reports',
//               index: 1,
//               isActive: false,
//             ),
//             const SizedBox(width: 40),
//             _buildNavItem(
//               context,
//               icon: Icons.inventory_2_outlined,
//               label: 'Stock',
//               index: 2,
//               isActive: false,
//             ),
//             _buildNavItem(
//               context,
//               icon: Icons.settings_outlined,
//               label: 'Settings',
//               index: 3,
//               isActive: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required int index,
//     required bool isActive,
//   }) {
//     // final provider = Provider.of<DashboardProvider>(context, listen: false);

//     return InkWell(
//       onTap: () {
//         if (index < 3) {
//           // Only first 3 tabs are functional
//           // provider.setTabIndex(index);
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isActive ? const Color(0xFF6C5DD3) : Colors.grey[400],
//               size: 24,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
//                 color: isActive ? const Color(0xFF6C5DD3) : Colors.grey[400],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/drawer/presentation/view/app_drawer.dart';
import 'package:project_management/feature/invoices/presentation/view_model/invoice_vm.dart';
import 'package:project_management/feature/project/presentation/view_model/project_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  final StatefulNavigationShell shell;

  const NavigationScreen({super.key, required this.shell});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectVm = Provider.of<ProjectVm>(context, listen: false);
      projectVm.loadInitialProjects();
      context.read<InvoiceVm>().fetchInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: widget.shell,
        bottomNavigationBar: BottomNavBar(
          currentIndex: widget.shell.currentIndex,
          onTabSelected: (index) => widget.shell.goBranch(index),
        ),

        drawer: DashboardDrawer(),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Container(
          decoration: BoxDecoration(
            // border: Border(
            //   top: BorderSide(
            //     color: Theme.of(context).dividerColor.withOpacity(0.15),
            //     width: 1,
            //   ),
            // ),
            boxShadow: [
              BoxShadow(
                color: themeProv.isDarkMode
                    ? AppColors.backgroundColor.withValues(alpha: .15)
                    : AppColors.backgroundDark.withValues(alpha: .3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: BottomAppBar(
            color: themeProv.isDarkMode
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            height: 90,
            elevation: 8,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Overview',
                    index: 0,
                    isActive: currentIndex == 0,
                  ),

                  // _buildNavItem(
                  //   icon: Icons.attach_money_rounded,
                  //   label: 'Earnings',
                  //   index: 1,
                  //   isActive: currentIndex == 1,
                  // ),
                  _buildNavItem(
                    icon: Icons.folder_outlined,
                    label: 'Projects',
                    index: 2,
                    isActive: currentIndex == 2,
                  ),
                  _buildNavItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Invoices',
                    index: 3,
                    isActive: currentIndex == 3,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    index: 4,
                    isActive: currentIndex == 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF6C5DD3) : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? const Color(0xFF6C5DD3) : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
