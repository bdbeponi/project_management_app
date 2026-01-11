// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AuthViewModel extends ChangeNotifier {
//   final emailController = TextEditingController(text: "test@gmail.com");
//   final passwordController = TextEditingController(text: "123456");

//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _rememberMe = true;

//   bool get isLoading => _isLoading;
//   bool get obscurePassword => _obscurePassword;
//   bool get rememberMe => _rememberMe;

//   void togglePasswordVisibility() {
//     _obscurePassword = !_obscurePassword;
//     HapticFeedback.lightImpact();
//     notifyListeners();
//   }

//   void toggleRememberMe(bool? value) {
//     _rememberMe = value ?? false;
//     HapticFeedback.selectionClick();
//     notifyListeners();
//   }

//   Future<bool> login() async {
//     _isLoading = true;
//     notifyListeners();

//     HapticFeedback.mediumImpact();

//     // Simulate a login API delay
//     await Future.delayed(const Duration(seconds: 2));

//     _isLoading = false;
//     notifyListeners();

//     // Dummy authentication logic
//     if (emailController.text == "test@gmail.com" &&
//         passwordController.text == "123456") {
//       HapticFeedback.heavyImpact();
//       return true;
//     }
//     return false;
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/base/base_vm.dart';
import 'package:project_management/feature/auth/data/repository/auth_repo.dart';
import 'package:project_management/feature/auth/model/login_response_model.dart';

class AuthViewModel extends BaseViewModel {
  // ------------------------- DEPENDENCIES -------------------------
  final AuthRepository _authRepository;

  // Inject repository (or create default)
  AuthViewModel({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  // ------------------------- FORM CONTROLLERS -------------------------
  final emailController = TextEditingController(text: "imran130721@gmail.com");
  final passwordController = TextEditingController(text: "Imran@123#");

  // ------------------------- UI STATE -------------------------
  bool _obscurePassword = true;
  bool _rememberMe = true;

  // Response data storage
  LoginResponseModel? _loginResponse;

  // ------------------------- GETTERS -------------------------
  bool get obscurePassword => _obscurePassword;
  bool get rememberMe => _rememberMe;
  LoginResponseModel? get loginResponse => _loginResponse;

  // ------------------------- ACTIONS -------------------------
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    HapticFeedback.lightImpact();
    safeNotifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    HapticFeedback.selectionClick();
    safeNotifyListeners();
  }

  // ------------------------- FORM VALIDATION -------------------------
  bool validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!validateEmail(email)) {
      setError('Please enter a valid email address');
      return false;
    }

    if (!validatePassword(password)) {
      setError('Password must be at least 6 characters');
      return false;
    }

    clearError();
    return true;
  }

  // ------------------------- LOGIN WITH API -------------------------
  Future<LoginResponseModel?> loginWithApi() async {
    if (!validateForm()) return null;

    try {
      // Use the repository to handle the API call
      _loginResponse = await executeApiCall<LoginResponseModel>(
        apiCall: () => _authRepository.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
        loadingMessage: 'Logging in...',
        errorMessage: 'Login failed. Please check your credentials.',
        showLoading: true,
        showError: true,
      );

      // Haptic feedback on success
      if (_loginResponse != null) {
        HapticFeedback.heavyImpact();
      }

      return _loginResponse;
    } catch (e) {
      // Error is already handled by executeApiCall
      return null;
    }
  }

  // ------------------------- LOGOUT -------------------------
  Future<void> logout() async {
    try {
      await executeApiCall<void>(
        apiCall: () => _authRepository.logout(),
        loadingMessage: 'Logging out...',
        errorMessage: 'Logout failed',
        showLoading: false, // You might not want loading for logout
        showError: false, // You might not want error for logout
      );

      // Clear local state
      _loginResponse = null;
      clearForm();
    } catch (e) {
      // Error already handled by executeApiCall
      // Still clear local state even if logout fails
      _loginResponse = null;
      clearForm();
    }
  }

  // ------------------------- CHECK AUTH STATUS -------------------------
  bool isLoggedIn() {
    // Check if we have a login response
    return _loginResponse != null;
  }

  // ------------------------- CLEAR FORM -------------------------
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _obscurePassword = true;
    _rememberMe = true;
    _loginResponse = null;
    clearError();
  }

  // ------------------------- AUTO-FILL TEST CREDENTIALS -------------------------
  void autoFillTestCredentials() {
    emailController.text = "admin@gmail.com";
    passwordController.text = "12345678";
    safeNotifyListeners();
  }

  // ------------------------- DISPOSE -------------------------
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
