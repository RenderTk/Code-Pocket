import 'package:flutter/material.dart';

/// Custom theme extension for additional design tokens
@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  const CustomThemeExtension({
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.successContainer,
    required this.warningContainer,
    required this.infoContainer,
  });

  final Color successColor;
  final Color warningColor;
  final Color infoColor;
  final Color successContainer;
  final Color warningContainer;
  final Color infoContainer;

  @override
  CustomThemeExtension copyWith({
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
    Color? successContainer,
    Color? warningContainer,
    Color? infoContainer,
  }) {
    return CustomThemeExtension(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      successContainer: successContainer ?? this.successContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      infoContainer: infoContainer ?? this.infoContainer,
    );
  }

  @override
  CustomThemeExtension lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }

  static const light = CustomThemeExtension(
    successColor: Color(0xFF4CAF50),
    warningColor: Color(0xFFFF9800),
    infoColor: Color(0xFF2196F3),
    successContainer: Color(0xFFE8F5E8),
    warningContainer: Color(0xFFFFF3E0),
    infoContainer: Color(0xFFE3F2FD),
  );

  static const dark = CustomThemeExtension(
    successColor: Color(0xFF81C784),
    warningColor: Color(0xFFFFB74D),
    infoColor: Color(0xFF64B5F6),
    successContainer: Color(0xFF2E7D32),
    warningContainer: Color(0xFFE65100),
    infoContainer: Color(0xFF1565C0),
  );
}
