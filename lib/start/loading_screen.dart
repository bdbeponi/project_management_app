import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_management/app/router/config/route_extention.dart';
import 'package:project_management/db/service/login/login_local_service.dart';
import 'package:project_management/shared/networks/dio/dio.dart';

import 'welcome_screen.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    log("App initialization started");

    // Simulate initialization work (e.g., reading local storage, DI setup)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    log("App initialization finished, navigating...");

    // Navigate based on login status
    if (LoginLocalService().isLoggedIn) {
      DioSingleton.instance.updateAuth(LoginLocalService().accessToken!);
      // nav.toHome(); // Replace with your home screen navigation
      // nav.toNavigation();
    } else {
      nav.toLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Building WelcomeScreen...");
    // Keep showing WelcomeScreen until navigation occurs
    return const WelcomeScreen();
  }
}
