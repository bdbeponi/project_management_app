import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// A lightweight helper class for showing consistent custom toasts
/// across your app using the `toastification` package.
///
/// Example:
/// ```dart
/// CustomToast.showSuccess(context, 'Profile updated successfully!');
/// CustomToast.showError(context, 'Failed to upload image');
/// ```
class CustomToast {
  CustomToast._(); // Private constructor to prevent instantiation

  static const _defaultDuration = Duration(seconds: 3);
  static const _defaultAnimationDuration = Duration(milliseconds: 250);

  /// Common base method for showing any toast
  static void _show({
    required BuildContext context,
    required ToastificationType type,
    required String title,
    String? description,
    Color? primaryColor,
    Color? backgroundColor,
    IconData? icon,
    Duration? duration,
  }) {
    Toastification().show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? _defaultDuration,
      animationDuration: _defaultAnimationDuration,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(color: Colors.white),
            )
          : null,
      icon: Icon(icon, color: Colors.white),
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return Center(
              child: Icon(
            Icons.close,
            color: Colors.white,
          ));
        },
      ),
      showIcon: true,
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
      pauseOnHover: true,
      callbacks: ToastificationCallbacks(
        onTap: (item) => log('Toast tapped: ${item.id}'),
        onDismissed: (item) => log('Toast dismissed: ${item.id}'),
      ),
    );
  }

  /// ✅ Success toast
  static void showSuccess(BuildContext context, String message,
      {String? description}) {
    _show(
      context: context,
      type: ToastificationType.success,
      title: message,
      description: description,
      icon: Icons.check_circle_rounded,
      primaryColor: Colors.green.shade600,
      backgroundColor: Colors.green.shade700,
    );
  }

  /// ⚠️ Warning toast
  static void showWarning(BuildContext context, String message,
      {String? description}) {
    _show(
      context: context,
      type: ToastificationType.warning,
      title: message,
      description: description,
      icon: Icons.warning_amber_rounded,
      primaryColor: Colors.orange.shade700,
      backgroundColor: Colors.orange.shade800,
    );
  }

  /// ❌ Error toast
  static void showError(BuildContext context, String message,
      {String? description}) {
    _show(
      context: context,
      type: ToastificationType.error,
      title: message,
      description: description,
      icon: Icons.error_outline_rounded,
      primaryColor: Colors.red.shade700,
      backgroundColor: Colors.red.shade800,
    );
  }

  /// ℹ️ Info toast
  static void showInfo(BuildContext context, String message,
      {String? description}) {
    _show(
      context: context,
      type: ToastificationType.info,
      title: message,
      description: description,
      icon: Icons.info_outline_rounded,
      primaryColor: Colors.blue.shade700,
      backgroundColor: Colors.blue.shade800,
    );
  }
}
