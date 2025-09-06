import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Comprehensive Material 3 theme system with improved dark mode
class AppTheme {
  static const Color _seedColor = Color(0xFF1976D2); // Modern Professional Blue

  // Enhanced dark mode seed color for better contrast
  static const Color _darkSeedColor = Color(
    0xFF90CAF9,
  ); // Lighter blue for dark mode

  // Generate color schemes with custom adjustments
  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: _darkSeedColor,
        brightness: Brightness.dark,
      ).copyWith(
        // Enhanced dark mode surface colors for better layering
        surface: const Color(0xFF121212), // True dark surface
        surfaceContainerLowest: const Color(0xFF0F0F0F),
        surfaceContainerLow: const Color(0xFF1A1A1A),
        surfaceContainer: const Color(0xFF1E1E1E),
        surfaceContainerHigh: const Color(0xFF232323),
        surfaceContainerHighest: const Color(0xFF2A2A2A),

        // Better outline colors for dark mode
        outline: const Color(0xFF525252),
        outlineVariant: const Color(0xFF404040),

        // Enhanced on-surface colors for better text contrast
        onSurface: const Color(0xFFE1E1E1),
        onSurfaceVariant: const Color(0xFFBDBDBD),
      );

  /// Light theme configuration
  static ThemeData get light =>
      _buildTheme(_lightColorScheme, Brightness.light);

  /// Dark theme configuration
  static ThemeData get dark => _buildTheme(_darkColorScheme, Brightness.dark);

  /// System theme mode based on platform brightness
  static ThemeMode systemMode(Brightness? platformBrightness) {
    return platformBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,

      // Typography
      textTheme: _buildTextTheme(colorScheme),

      // App Bar - Enhanced for dark mode
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: isDark ? 2 : 1,
        backgroundColor: isDark ? colorScheme.surface : colorScheme.surface,
        surfaceTintColor: isDark ? colorScheme.surfaceTint : null,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: _buildTextTheme(colorScheme).titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.light,
              ),
      ),

      // Navigation - Improved dark mode styling
      navigationBarTheme: NavigationBarThemeData(
        elevation: isDark ? 0 : 3,
        backgroundColor: isDark
            ? colorScheme.surfaceContainer
            : colorScheme.surface,
        surfaceTintColor: isDark ? colorScheme.surfaceTint : null,
        indicatorColor: colorScheme.secondaryContainer,
        shadowColor: isDark ? Colors.black26 : null,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: isDark ? 0 : 3,
        backgroundColor: isDark
            ? colorScheme.surfaceContainer
            : colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),

      // Buttons - Enhanced contrast for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: isDark ? 2 : 1,
          shadowColor: isDark ? Colors.black45 : null,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(64, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(64, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(64, 44),
          side: BorderSide(color: colorScheme.outline, width: isDark ? 1.5 : 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(64, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // FAB - Enhanced for dark mode
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: isDark ? 4 : 3,
        focusElevation: isDark ? 6 : 4,
        hoverElevation: isDark ? 6 : 4,
        highlightElevation: isDark ? 8 : 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),

      // Cards - Better dark mode appearance
      cardTheme: CardThemeData(
        elevation: isDark ? 2 : 1,
        margin: const EdgeInsets.all(0),
        color: isDark ? colorScheme.surfaceContainerLow : null,
        surfaceTintColor: isDark ? colorScheme.surfaceTint : null,
        shadowColor: isDark ? Colors.black26 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Chips - Improved dark mode styling
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        backgroundColor: isDark ? colorScheme.surfaceContainerHigh : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xs),
        ),
        side: BorderSide(
          color: isDark
              ? colorScheme.outline.withValues(alpha: 0.7)
              : colorScheme.outline,
          width: isDark ? 0.8 : 1,
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),

      // Dialogs and Sheets - Enhanced dark mode
      dialogTheme: DialogThemeData(
        elevation: isDark ? 8 : 6,
        backgroundColor: isDark ? colorScheme.surfaceContainerHigh : null,
        surfaceTintColor: isDark ? colorScheme.surfaceTint : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        titleTextStyle: _buildTextTheme(colorScheme).headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: _buildTextTheme(
          colorScheme,
        ).bodyMedium?.copyWith(color: colorScheme.onSurface),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        elevation: isDark ? 12 : 8,
        modalElevation: isDark ? 12 : 8,
        backgroundColor: isDark ? colorScheme.surfaceContainerLow : null,
        surfaceTintColor: isDark ? colorScheme.surfaceTint : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Snackbar - Better dark mode contrast
      snackBarTheme: SnackBarThemeData(
        elevation: isDark ? 8 : 6,
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? colorScheme.inverseSurface : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onInverseSurface,
        ),
      ),

      // Form inputs - Significantly improved for dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
            : colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(
            color: isDark
                ? colorScheme.outline.withValues(alpha: 0.7)
                : colorScheme.outline,
            width: isDark ? 1.2 : 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(
            color: isDark
                ? colorScheme.outline.withValues(alpha: 0.7)
                : colorScheme.outline,
            width: isDark ? 1.2 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant.withValues(
            alpha: isDark ? 0.7 : 0.6,
          ),
        ),
      ),

      // List tiles - Enhanced dark mode
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 8,
        tileColor: isDark ? colorScheme.surfaceContainerLowest : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        titleTextStyle: _buildTextTheme(colorScheme).bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: _buildTextTheme(
          colorScheme,
        ).bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),

      // Switches and checkboxes - Improved dark mode
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surfaceContainerHighest;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(
          color: isDark
              ? colorScheme.outline.withValues(alpha: 0.8)
              : colorScheme.outline,
          width: 2,
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark
              ? colorScheme.outline.withValues(alpha: 0.8)
              : colorScheme.outline;
        }),
      ),

      // Dividers - Better dark mode visibility
      dividerTheme: DividerThemeData(
        color: isDark
            ? colorScheme.outlineVariant.withValues(alpha: 0.8)
            : colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Tooltips - Enhanced for dark mode
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.inverseSurface.withValues(alpha: 0.95)
              : colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadii.xs),
          boxShadow: isDark
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // Tab bar - Improved dark mode
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onSurface.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          return null;
        }),
      ),

      // Enhanced focus and interaction colors for dark mode
      focusColor: colorScheme.tertiary.withValues(alpha: isDark ? 0.16 : 0.12),
      hoverColor: colorScheme.onSurface.withValues(alpha: isDark ? 0.12 : 0.08),
      splashColor: colorScheme.onSurface.withValues(
        alpha: isDark ? 0.16 : 0.12,
      ),
      highlightColor: colorScheme.onSurface.withValues(
        alpha: isDark ? 0.16 : 0.12,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Scaffold background - Ensure proper dark mode background
      scaffoldBackgroundColor: isDark ? colorScheme.surface : null,
      canvasColor: isDark ? colorScheme.surface : null,
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: 57,
        height: 1.12,
        letterSpacing: -0.25,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        height: 1.16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        height: 1.22,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.25,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.29,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.33,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.27,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.50,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.50,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.25,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        height: 1.45,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
    );
  }
}

/// Spacing tokens following 4dp grid system
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

/// Border radius tokens
class AppRadii {
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
}

/// Animation duration tokens
class AppDurations {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
}

/// Animation curves
class AppCurves {
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve overshoot = Curves.elasticOut;
}

/// Enhanced semantic colors with better dark mode support
class SemanticColors {
  const SemanticColors();

  // Success colors
  Color get success => const Color(0xFF4CAF50);
  Color get onSuccess => const Color(0xFFFFFFFF);
  Color get successContainer => const Color(0xFFE8F5E8);
  Color get onSuccessContainer => const Color(0xFF1B5E20);

  // Dark mode success colors
  Color get successDark => const Color(0xFF81C784);
  Color get onSuccessDark => const Color(0xFF000000);
  Color get successContainerDark => const Color(0xFF2E7D32);
  Color get onSuccessContainerDark => const Color(0xFFE8F5E8);

  // Warning colors
  Color get warning => const Color(0xFFFF9800);
  Color get onWarning => const Color(0xFFFFFFFF);
  Color get warningContainer => const Color(0xFFFFF3E0);
  Color get onWarningContainer => const Color(0xFFE65100);

  // Dark mode warning colors
  Color get warningDark => const Color(0xFFFFB74D);
  Color get onWarningDark => const Color(0xFF000000);
  Color get warningContainerDark => const Color(0xFFFF6F00);
  Color get onWarningContainerDark => const Color(0xFFFFF3E0);

  // Info colors
  Color get info => const Color(0xFF2196F3);
  Color get onInfo => const Color(0xFFFFFFFF);
  Color get infoContainer => const Color(0xFFE3F2FD);
  Color get onInfoContainer => const Color(0xFF0D47A1);

  // Dark mode info colors
  Color get infoDark => const Color(0xFF64B5F6);
  Color get onInfoDark => const Color(0xFF000000);
  Color get infoContainerDark => const Color(0xFF1565C0);
  Color get onInfoContainerDark => const Color(0xFFE3F2FD);
}

/// Extension methods for easy access to theme tokens
extension ThemeExtensions on BuildContext {
  /// Access spacing tokens
  AppSpacing get spacings => AppSpacing();

  /// Access radius tokens
  AppRadii get radii => AppRadii();

  /// Access duration tokens
  AppDurations get durations => AppDurations();

  /// Access animation curves
  AppCurves get curves => AppCurves();

  /// Access semantic colors with dark mode support
  SemanticColors get semanticColors => const SemanticColors();

  /// Check if high contrast is enabled
  bool get isHighContrast => MediaQuery.highContrastOf(this);

  /// Get text scale factor
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);

  /// Check if dark mode is active
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
