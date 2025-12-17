import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthViewModel extends ChangeNotifier {
  final emailController = TextEditingController(text: "test@gmail.com");
  final passwordController = TextEditingController(text: "123456");

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get rememberMe => _rememberMe;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    HapticFeedback.mediumImpact();

    // Simulate a login API delay
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // Dummy authentication logic
    if (emailController.text == "test@gmail.com" &&
        passwordController.text == "123456") {
      HapticFeedback.heavyImpact();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
