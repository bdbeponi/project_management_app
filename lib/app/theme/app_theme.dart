import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // primaryColor: AppColors.primaryLight,
    // scaffoldBackgroundColor: AppColors.backgroundLight,
    // cardColor: AppColors.cardLight,
    // errorColor: AppColors.error,
    // textTheme: AppTextStyles.light,
    // colorScheme: const ColorScheme.light(
    //   primary: AppColors.primaryLight,
    //   background: AppColors.backgroundLight,
    //   error: AppColors.error,
    // ),
    // extensions: const [
    //   CustomThemeExtension.light,
    // ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // primaryColor: AppColors.primaryDark,
    // scaffoldBackgroundColor: AppColors.backgroundDark,
    // cardColor: AppColors.cardDark,
    // errorColor: AppColors.error,
    // textTheme: AppTextStyles.dark,
    // colorScheme: const ColorScheme.dark(
    //   primary: AppColors.primaryDark,
    //   background: AppColors.backgroundDark,
    //   error: AppColors.error,
    // ),
    // extensions: const [
    //   CustomThemeExtension.dark,
    // ],
  );
}
