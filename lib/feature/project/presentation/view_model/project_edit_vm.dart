import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProjectViewModel extends ChangeNotifier {
  // Form controllers
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectPriceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController billingDateController = TextEditingController();

  // Social Media Fields
  final TextEditingController socialNameController = TextEditingController();
  final TextEditingController socialLinkController = TextEditingController();
  final TextEditingController socialUsernameController =
      TextEditingController();
  final TextEditingController socialPasswordController =
      TextEditingController();

  // Work Sheet Fields
  final List<Map<String, TextEditingController>> workSheets = [];

  // Dropdown values
  String selectedStatus = 'Running';
  String selectedProjectType = 'project based';
  String selectedPaymentStatus = 'Unpaid';
  String? selectedAssignee;

  // State
  bool isLoading = false;
  bool isCreateMode = true;

  // File paths (for future implementation)
  String? agreementPaperPath;
  String? srsPath;

  // Initialize with existing project data
  void initialize(Map<String, dynamic>? project) {
    isCreateMode = project == null;

    if (project != null) {
      projectNameController.text = project['name'] ?? '';
      projectPriceController.text = project['price']?.toString() ?? '';
      startDateController.text = project['startDate'] ?? '';
      endDateController.text = project['endDate'] ?? '';
      billingDateController.text = project['billingDate'] ?? '';
      selectedStatus = project['status'] ?? 'Running';
      selectedProjectType = project['type'] ?? 'project based';
      selectedPaymentStatus = project['payment'] ?? 'Unpaid';

      // Social Media
      socialNameController.text = project['socialName'] ?? '';
      socialLinkController.text = project['socialLink'] ?? '';
      socialUsernameController.text = project['socialUsername'] ?? '';
      socialPasswordController.text = project['socialPassword'] ?? '';

      // Work Sheets (you'll need to handle this based on your data structure)
      addWorkSheet(); // Initial worksheet
    } else {
      addWorkSheet(); // Initial worksheet for new project
    }

    notifyListeners();
  }

  // Work Sheet management
  void addWorkSheet() {
    workSheets.add({
      'name': TextEditingController(),
      'link': TextEditingController(),
    });
    notifyListeners();
  }

  void removeWorkSheet(int index) {
    workSheets[index]['name']?.dispose();
    workSheets[index]['link']?.dispose();
    workSheets.removeAt(index);
    notifyListeners();
  }

  // Date selection
  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  // Form validation
  bool validateForm() {
    return projectNameController.text.isNotEmpty &&
        projectPriceController.text.isNotEmpty &&
        selectedAssignee != null;
  }

  // Submit form
  Future<bool> submitForm() async {
    if (!validateForm()) return false;

    isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual API submission
      // Prepare data
      final projectData = {
        'name': projectNameController.text,
        'price': double.tryParse(projectPriceController.text) ?? 0.0,
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'billingDate': billingDateController.text,
        'status': selectedStatus,
        'type': selectedProjectType,
        'payment': selectedPaymentStatus,
        'socialName': socialNameController.text,
        'socialLink': socialLinkController.text,
        'socialUsername': socialUsernameController.text,
        'socialPassword': socialPasswordController.text,
        'assignedBy': selectedAssignee,
        'workSheets': workSheets
            .map(
              (sheet) => {
                'name': sheet['name']?.text ?? '',
                'link': sheet['link']?.text ?? '',
              },
            )
            .toList(),
      };

      // TODO: API call here
      // final response = await api.createOrUpdateProject(projectData);

      return true; // Success
    } catch (e) {
      log('Error submitting project: $e');
      return false; // Failure
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // File upload methods (stubs for future implementation)
  Future<void> uploadAgreementPaper() async {
    // TODO: Implement file picker
  }

  Future<void> uploadSRS() async {
    // TODO: Implement file picker
  }

  // Cleanup
  @override
  void dispose() {
    projectNameController.dispose();
    projectPriceController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    billingDateController.dispose();
    socialNameController.dispose();
    socialLinkController.dispose();
    socialUsernameController.dispose();
    socialPasswordController.dispose();

    for (var sheet in workSheets) {
      sheet['name']?.dispose();
      sheet['link']?.dispose();
    }

    super.dispose();
  }
}
