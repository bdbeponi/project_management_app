import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const _DummyScreen(
//       title: 'Dashboard',
//       color: Colors.blueAccent,
//       icon: Icons.dashboard_rounded,
//     );
//   }
// }

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DummyScreen(
      title: 'Earnings',
      color: Colors.greenAccent,
      icon: Icons.attach_money_rounded,
    );
  }
}

// class ProjectsScreen extends StatelessWidget {
//   const ProjectsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const _DummyScreen(
//       title: 'Projects',
//       color: Colors.orangeAccent,
//       icon: Icons.folder_outlined,
//     );
//   }
// }

// class InvoicesScreen extends StatelessWidget {
//   const InvoicesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const _DummyScreen(
//       title: 'Invoices',
//       color: Colors.purpleAccent,
//       icon: Icons.receipt_long_outlined,
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const _DummyScreen(
//       title: 'Profile',
//       color: Colors.pinkAccent,
//       icon: Icons.person_outline_rounded,
//     );
//   }
// }

class _DummyScreen extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _DummyScreen({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.withOpacity(0.1),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        centerTitle: true,
      ),
      body: Center(child: Icon(icon, size: 100, color: color.withOpacity(0.8))),
    );
  }
}
