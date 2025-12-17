import 'package:flutter/material.dart';

class InvoiceVm extends ChangeNotifier {
  // TODO: Replace with actual API data
  List<Map<String, dynamic>> get invoices => [
        {
          'invoiceNumber': 'INV-2025-7807',
          'issueDate': 'Nov-15-25',
          'dueDate': 'Dec-15-25',
          'clientName': 'sk jasib',
          'status': 'Unpaid',
          'amount': 2500.00,
          'items': [
            {
              'description': 'Website Development',
              'quantity': 1,
              'price': 2000.00,
              'total': 2000.00,
            },
            {
              'description': 'Domain & Hosting',
              'quantity': 1,
              'price': 500.00,
              'total': 500.00,
            },
          ],
        },
        {
          'invoiceNumber': 'INV-2025-7806',
          'issueDate': 'Nov-10-25',
          'dueDate': 'Dec-10-25',
          'clientName': 'Prayas Group',
          'status': 'Unpaid',
          'amount': 5000.00,
          'items': [
            {
              'description': 'Corporate Website',
              'quantity': 1,
              'price': 4000.00,
              'total': 4000.00,
            },
            {
              'description': 'CMS Integration',
              'quantity': 1,
              'price': 1000.00,
              'total': 1000.00,
            },
          ],
        },
        {
          'invoiceNumber': 'INV-2025-7805',
          'issueDate': 'Nov-01-25',
          'dueDate': null,
          'clientName': 'TechCorp',
          'status': 'Paid',
          'amount': 8500.00,
          'items': [
            {
              'description': 'Mobile App Development',
              'quantity': 1,
              'price': 7000.00,
              'total': 7000.00,
            },
            {
              'description': 'UI/UX Design',
              'quantity': 1,
              'price': 1500.00,
              'total': 1500.00,
            },
          ],
        },
        {
          'invoiceNumber': 'INV-2025-7804',
          'issueDate': 'Oct-25-25',
          'dueDate': null,
          'clientName': 'ShopMart',
          'status': 'Paid',
          'amount': 12000.00,
          'items': [
            {
              'description': 'E-commerce Platform',
              'quantity': 1,
              'price': 10000.00,
              'total': 10000.00,
            },
            {
              'description': 'Payment Gateway Integration',
              'quantity': 1,
              'price': 2000.00,
              'total': 2000.00,
            },
          ],
        },
        {
          'invoiceNumber': 'INV-2025-7803',
          'issueDate': 'Oct-15-25',
          'dueDate': 'Oct-20-25',
          'clientName': 'StartupXYZ',
          'status': 'Overdue',
          'amount': 1500.00,
          'items': [
            {
              'description': 'Brand Identity Design',
              'quantity': 1,
              'price': 1000.00,
              'total': 1000.00,
            },
            {
              'description': 'Brand Guidelines Document',
              'quantity': 1,
              'price': 500.00,
              'total': 500.00,
            },
          ],
        },
      ];

  int get totalInvoices => invoices.length;
  
  int get paidCount => invoices.where((i) => i['status'] == 'Paid').length;
  
  int get unpaidCount => invoices.where((i) => i['status'] == 'Unpaid').length;
  
  int get overdueCount => invoices.where((i) => i['status'] == 'Overdue').length;
  
  double get totalRevenue => invoices
      .where((i) => i['status'] == 'Paid')
      .fold(0.0, (sum, i) => sum + i['amount']);
  
  double get pendingRevenue => invoices
      .where((i) => i['status'] == 'Unpaid' || i['status'] == 'Overdue')
      .fold(0.0, (sum, i) => sum + i['amount']);

  // TODO: Implement API methods
  Future<void> fetchInvoices() async {
    // Fetch from API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  Future<bool> createInvoice(Map<String, dynamic> invoiceData) async {
    // Create invoice via API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    return true;
  }

  Future<bool> updateInvoiceStatus(String invoiceNumber, String status) async {
    // Update invoice status via API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    return true;
  }

  Future<bool> deleteInvoice(String invoiceNumber) async {
    // Delete invoice via API
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
    return true;
  }

  Future<void> downloadInvoicePDF(String invoiceNumber) async {
    // Generate and download PDF
    await Future.delayed(const Duration(seconds: 1));
  }
}