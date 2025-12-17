// import 'package:flutter/material.dart';
// import 'package:imgori_app/app/constants/app_constants.dart';
// import 'package:imgori_app/utils/di.dart';
// import 'package:project_management/app/constants/app_constants.dart';

// class ThemeProvider extends ChangeNotifier {
//   // static const _key = 'theme_mode';
//   ThemeMode _themeMode = ThemeMode.system;

//   ThemeMode get themeMode => _themeMode;

//   ThemeProvider() {
//     _loadTheme();
//   }

//   void _loadTheme() async {
//     // final prefs = await SharedPreferences.getInstance();
//     final themeStr = appData.read(kKeyAppTheme);
//     _themeMode = ThemeMode.values.firstWhere(
//       (e) => e.toString() == themeStr,
//       orElse: () => ThemeMode.system,
//     );
//     notifyListeners();
//   }

//   Future<void> setTheme(ThemeMode mode) async {
//     _themeMode = mode;
//     // final prefs = await SharedPreferences.getInstance();
//     // await prefs.setString(_key, mode.toString());
//     appData.write(kKeyAppTheme, mode.toString());
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    final themeStr = null; // Replace with your persisted value if needed

    if (themeStr == null || themeStr == ThemeMode.system.toString()) {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeStr,
        orElse: () => ThemeMode.system,
      );
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    // appData.write(kKeyAppTheme, mode.toString());
    notifyListeners();
  }

  /// Helper to toggle between light, dark, and system
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setTheme(ThemeMode.system);
    } else {
      setTheme(ThemeMode.light);
    }
  }

  /// ✅ Simple boolean flag for dark mode
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Use platform brightness for system mode
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
