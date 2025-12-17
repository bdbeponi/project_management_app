import 'package:flutter/material.dart';

class DashbordViewModel extends ChangeNotifier {
  int _selectedBottomNavIndex = 0;

  int get selectedBottomNavIndex => _selectedBottomNavIndex;

  void setBottomNavIndex(int index) {
    _selectedBottomNavIndex = index;
    notifyListeners();
  }

  // TODO: Replace with actual API calls
  Map<String, dynamic> get dashboardStats => {
        'totalProjects': 38,
        'recentProjects': 5,
        'totalClients': 25,
        'recentClients': 3,
        'newProjects': 862,
        'yearlyProjects': 120,
        'totalUsers': 2856,
      };

  Map<String, dynamic> get earningsData => {
        'totalEarning': 24895.0,
        'growthPercentage': 10.0,
        'comparisonAmount': 84325.0,
        'projects': [
          {
            'name': 'Zipcar',
            'tech': 'Vue.js, React & HTML',
            'amount': 24895.65,
            'progress': 0.75,
            'icon': '📱',
          },
          {
            'name': 'Bitbank',
            'tech': 'Sketch, Figma & XD',
            'amount': 8650.20,
            'progress': 0.50,
            'icon': '💳',
          },
          {
            'name': 'Aviato',
            'tech': 'HTML & Angular',
            'amount': 1245.80,
            'progress': 0.20,
            'icon': '✈️',
          },
        ],
      };

  // Performance radar chart data
  List<Map<String, dynamic>> get performanceData => [
        {'month': 'Jan', 'income': 45000, 'netWorth': 42000},
        {'month': 'Feb', 'income': 38000, 'netWorth': 35000},
        {'month': 'Mar', 'income': 52000, 'netWorth': 48000},
        {'month': 'Apr', 'income': 48000, 'netWorth': 44000},
        {'month': 'May', 'income': 42000, 'netWorth': 38000},
        {'month': 'Jun', 'income': 55000, 'netWorth': 51000},
      ];

  // Project overview bar chart data
  List<Map<String, dynamic>> get projectOverviewData => [
        {'label': 'Mon', 'value': 35000},
        {'label': 'Tue', 'value': 45000},
        {'label': 'Wed', 'value': 28000},
        {'label': 'Thu', 'value': 52000},
        {'label': 'Fri', 'value': 75000},
        {'label': 'Sat', 'value': 48000},
        {'label': 'Sun', 'value': 62000},
      ];

  // User activity mini chart
  List<int> get userActivityData => [10, 15, 12, 18, 16, 22, 25, 20, 28, 24, 30, 26];

  // Recent projects table data
  List<Map<String, dynamic>> get recentProjects => [
        {
          'code': '47243',
          'name': 'website',
          'type': 'project based',
          'startDate': '2025-11-06',
          'endDate': '2025-11-11',
          'status': 'Running',
          'payment': 'Unpaid',
        },
        {
          'code': '63406',
          'name': 'prayas group website',
          'type': 'project based',
          'startDate': '2025-11-02',
          'endDate': '2025-11-22',
          'status': 'Running',
          'payment': 'Unpaid',
        },
      ];

  // Recent invoices
  List<Map<String, dynamic>> get recentInvoices => [
        {
          'invoiceNumber': 'INV-2025-7807',
          'issueDate': 'Nov-15-25',
          'clientName': 'sk jasib',
          'status': 'Unpaid',
        },
      ];
}