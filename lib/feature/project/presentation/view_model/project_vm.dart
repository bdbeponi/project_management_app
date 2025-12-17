import 'package:flutter/material.dart';

class ProjectVm extends ChangeNotifier {
  // TODO: Replace with actual API data
  List<Map<String, dynamic>> get projects => [
    {
      'code': '47243',
      'name': 'website',
      'type': 'project based',
      'startDate': '2025-11-06',
      'endDate': '2025-11-11',
      'status': 'Running',
      'payment': 'Unpaid',
      'client': 'sk jasib',
      'description': 'Complete website development project',
    },
    {
      'code': '63406',
      'name': 'prayas group website',
      'type': 'project based',
      'startDate': '2025-11-02',
      'endDate': '2025-11-22',
      'status': 'Running',
      'payment': 'Unpaid',
      'client': 'Prayas Group',
      'description': 'Corporate website with CMS integration',
    },
    {
      'code': '58921',
      'name': 'Mobile App Development',
      'type': 'project based',
      'startDate': '2025-10-15',
      'endDate': '2025-12-30',
      'status': 'Running',
      'payment': 'Paid',
      'client': 'TechCorp',
      'description': 'iOS and Android mobile application',
    },
    {
      'code': '52314',
      'name': 'E-commerce Platform',
      'type': 'hourly based',
      'startDate': '2025-09-01',
      'endDate': '2025-10-31',
      'status': 'Completed',
      'payment': 'Paid',
      'client': 'ShopMart',
      'description': 'Full-stack e-commerce solution',
    },
    {
      'code': '49872',
      'name': 'Brand Identity Design',
      'type': 'project based',
      'startDate': '2025-08-20',
      'endDate': '2025-09-15',
      'status': 'On Hold',
      'payment': 'Unpaid',
      'client': 'StartupXYZ',
      'description': 'Logo and brand guidelines',
    },
  ];

  int get totalProjects => projects.length;

  int get runningProjects =>
      projects.where((p) => p['status'] == 'Running').length;

  int get completedProjects =>
      projects.where((p) => p['status'] == 'Completed').length;

  // TODO: Implement API methods
  Future<void> fetchProjects() async {
    // Fetch from API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  Future<bool> createProject(Map<String, dynamic> projectData) async {
    // Create project via API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    return true;
  }

  Future<bool> updateProject(String code, Map<String, dynamic> updates) async {
    // Update project via API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    return true;
  }

  Future<bool> deleteProject(String code) async {
    // Delete project via API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    return true;
  }
}
