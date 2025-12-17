import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color badgeColor;

  const CustomThemeExtension({required this.badgeColor});

  @override
  CustomThemeExtension copyWith({Color? badgeColor}) {
    return CustomThemeExtension(badgeColor: badgeColor ?? this.badgeColor);
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      badgeColor: Color.lerp(badgeColor, other.badgeColor, t)!,
    );
  }

  static const light = CustomThemeExtension(badgeColor: Colors.redAccent);
  static const dark = CustomThemeExtension(badgeColor: Colors.orangeAccent);
}
