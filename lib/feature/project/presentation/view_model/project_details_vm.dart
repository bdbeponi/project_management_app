import 'package:project_management/app/provider/base/base_vm.dart';
import 'package:project_management/feature/project/data/repository/get_project_details_repo.dart';
import 'package:project_management/feature/project/model/get_project_details_response_model.dart';

class ProjectDetailsViewModel extends BaseViewModel {
  final ProjectDetailsRepository _repository;
  final String projectId;

  // ------------------------- STATE -------------------------
  Data? _projectDetails;
  bool _isRefreshing = false;
  bool _showPassword = false;
  final List<String> _selectedDocuments = [];

  // ------------------------- GETTERS -------------------------
  Data? get projectDetails => _projectDetails;
  bool get isRefreshing => _isRefreshing;
  bool get showPassword => _showPassword;
  List<String> get selectedDocuments => _selectedDocuments;

  // Derived getters for easier access
  String get projectName => _projectDetails?.name ?? 'N/A';
  String get projectType => _projectDetails?.projectType ?? 'N/A';
  String get paymentStatus => _projectDetails?.cPaymentStatus ?? 'N/A';
  String get employeePaymentStatus => _projectDetails?.ePaymentStatus ?? 'N/A';
  String get cost => _projectDetails?.cost ?? '0';
  String get price => _projectDetails?.price ?? '0';
  bool get isActive => _projectDetails?.isActive ?? false;
  String? get startDate =>
      _projectDetails?.startDate?.toLocal().toString().split(' ')[0];
  String? get endDate => _projectDetails?.endDate;
  String? get billingDate =>
      _projectDetails?.billingDate?.toLocal().toString().split(' ')[0];
  String? get note => _projectDetails?.note;
  List<Social>? get socialAccounts => _projectDetails?.social;
  List<WorkSheet>? get workSheets => _projectDetails?.workSheet;
  bool get hasSocialAccounts => (_projectDetails?.social?.isNotEmpty ?? false);
  bool get hasWorkSheets => (_projectDetails?.workSheet?.isNotEmpty ?? false);
  bool get hasDocuments =>
      (_projectDetails?.agreement != null &&
          (_projectDetails?.agreement as String?)?.isNotEmpty == true) ||
      (_projectDetails?.srs != null &&
          (_projectDetails?.srs as String?)?.isNotEmpty == true);
  String? get agreementUrl => _projectDetails?.agreement as String?;
  String? get srsUrl => _projectDetails?.srs as String?;

  ProjectDetailsViewModel({
    required this.projectId,
    ProjectDetailsRepository? repository,
  }) : _repository = repository ?? ProjectDetailsRepository();

  // ------------------------- INITIALIZATION -------------------------

  /// Initialize and load project details
  Future<void> initialize() async {
    try {
      // Check if we have cached data first for immediate UI
      final cachedData = _repository.getCachedProjectDetails(projectId);
      if (cachedData != null) {
        _projectDetails = cachedData;
        safeNotifyListeners();
      }

      // Then fetch fresh data
      await loadProjectDetails();
    } catch (e) {
      // If we have cached data, still show it even if API fails
      if (_projectDetails == null) {
        setError('Failed to load project details: ${e.toString()}');
      }
    }
  }

  // ------------------------- DATA LOADING -------------------------

  /// Load project details
  Future<void> loadProjectDetails({bool forceRefresh = false}) async {
    return executeApiCall(
      apiCall: () async {
        final response = await _repository.getProjectDetails(
          projectId: projectId,
          forceRefresh: forceRefresh,
        );

        if ((response.success == true) && response.data != null) {
          _projectDetails = response.data!;
          setSuccess();
        } else {
          throw Exception(response.message ?? 'Failed to load project details');
        }
      },
      errorMessage: 'Failed to load project details',
    );
  }

  /// Refresh project details
  Future<void> refreshProjectDetails() async {
    try {
      _isRefreshing = true;
      safeNotifyListeners();

      await loadProjectDetails(forceRefresh: true);
    } finally {
      _isRefreshing = false;
      safeNotifyListeners();
    }
  }

  // ------------------------- UI ACTIONS -------------------------

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    safeNotifyListeners();
  }

  /// Toggle document selection
  void toggleDocumentSelection(String documentUrl) {
    if (_selectedDocuments.contains(documentUrl)) {
      _selectedDocuments.remove(documentUrl);
    } else {
      _selectedDocuments.add(documentUrl);
    }
    safeNotifyListeners();
  }

  /// Clear selected documents
  void clearSelectedDocuments() {
    _selectedDocuments.clear();
    safeNotifyListeners();
  }

  /// Copy text to clipboard
  Future<void> copyToClipboard(String text, {String? successMessage}) async {
    // Implementation depends on your clipboard service
    // You can use Clipboard.setData(ClipboardData(text: text));

    // For now, just trigger a success notification
    safeNotifyListeners();
  }

  /// Open external link
  Future<void> openExternalLink(String url) async {
    // Implementation depends on your URL launcher
    // You can use url_launcher package
  }

  /// Download document
  Future<void> downloadDocument(String url, String fileName) async {
    // Implementation depends on your download service
  }

  // ------------------------- DOCUMENT MANAGEMENT -------------------------

  /// Check if document is selected
  bool isDocumentSelected(String url) {
    return _selectedDocuments.contains(url);
  }

  /// Get selected document count
  int get selectedDocumentCount => _selectedDocuments.length;

  // ------------------------- SOCIAL ACCOUNT MANAGEMENT -------------------------

  /// Get social account by index
  Social? getSocialAccount(int index) {
    if (socialAccounts == null || index >= socialAccounts!.length) {
      return null;
    }
    return socialAccounts![index];
  }

  /// Get social account count
  int get socialAccountCount => socialAccounts?.length ?? 0;

  /// Format social account name
  String formatSocialName(String name) {
    return name.toLowerCase().replaceAll(' ', '_');
  }

  // ------------------------- WORKSHEET MANAGEMENT -------------------------

  /// Get worksheet by index
  WorkSheet? getWorksheet(int index) {
    if (workSheets == null || index >= workSheets!.length) {
      return null;
    }
    return workSheets![index];
  }

  /// Get worksheet count
  int get worksheetCount => workSheets?.length ?? 0;

  // ------------------------- VALIDATION -------------------------

  /// Validate if project data is complete
  bool validateProjectData() {
    return _projectDetails != null &&
        (_projectDetails?.name?.isNotEmpty ?? false) &&
        (_projectDetails?.projectType?.isNotEmpty ?? false);
  }

  /// Check if project is overdue
  bool get isOverdue {
    if (_projectDetails?.endDate == null) return false;

    try {
      final endDate = DateTime.tryParse(_projectDetails!.endDate!);
      if (endDate == null) return false;

      final now = DateTime.now();
      return now.isAfter(endDate);
    } catch (e) {
      return false;
    }
  }

  /// Check if billing is due
  bool get isBillingDue {
    if (_projectDetails?.billingDate == null) return false;

    try {
      final billingDate = _projectDetails!.billingDate;
      if (billingDate == null) return false;

      final now = DateTime.now();
      return now.isAfter(billingDate);
    } catch (e) {
      return false;
    }
  }

  // ------------------------- FORMATTING -------------------------

  /// Format currency
  String formatCurrency(String amount) {
    if (amount.isEmpty) return '0 ৳';

    try {
      final number = double.tryParse(amount.replaceAll(',', ''));
      if (number == null) return '$amount ৳';

      return '${number.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ৳';
    } catch (e) {
      return '$amount ৳';
    }
  }

  /// Format date
  String formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Format date string
  String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '--';

    try {
      final date = DateTime.tryParse(dateString);
      if (date == null) return dateString;
      return formatDate(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Get status color
  int getStatusColor() {
    final status = _projectDetails?.cPaymentStatus?.toLowerCase();

    switch (status) {
      case 'paid':
        return 0xFF4CAF50; // Green
      case 'unpaid':
        return 0xFFF44336; // Red
      case 'pending':
        return 0xFFFF9800; // Orange
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Get status text
  String getStatusText() {
    final status = _projectDetails?.cPaymentStatus ?? 'unknown';
    return status[0].toUpperCase() + status.substring(1);
  }

  // ------------------------- CACHE MANAGEMENT -------------------------

  /// Check if data is cached
  bool isDataCached() {
    return _repository.isCached(projectId);
  }

  /// Clear cache for this project
  void clearCache() {
    _repository.clearProjectFromCache(projectId);
    safeNotifyListeners();
  }

  // ------------------------- ERROR HANDLING -------------------------

  /// Handle specific errors
  String getErrorMessage(dynamic error) {
    if (error is String) return error;

    final errorStr = error.toString();

    if (errorStr.contains('No Internet')) {
      return 'Please check your internet connection';
    } else if (errorStr.contains('404')) {
      return 'Project not found';
    } else if (errorStr.contains('401') || errorStr.contains('403')) {
      return 'Session expired. Please login again';
    } else if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again';
    } else {
      return 'An error occurred: $errorStr';
    }
  }

  // ------------------------- DISPOSE -------------------------
  @override
  void dispose() {
    // Clear any pending operations
    super.dispose();
  }
}
