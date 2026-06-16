import 'package:flutter/material.dart';
import '../app/theme.dart' as theme;

/// Compatibility shim: expose `AppColors` names expected by older files
/// while delegating to the canonical definitions in `app/theme.dart`.
class AppColors {
  AppColors._();

  static const Color primary = theme.AppColors.primary;
  static const Color primaryDark = theme.AppColors.primaryDark;
  static const Color primaryLight = theme.AppColors.primaryLight;
  static const Color primarySurface = theme.AppColors.primarySurface;

  // Many files expect `secondary` — map to `accent`.
  static const Color secondary = theme.AppColors.accent;
  static const Color accent = theme.AppColors.accent;

  static const Color black = theme.AppColors.black;
  static const Color darkGray = theme.AppColors.darkGray;
  static const Color mediumGray = theme.AppColors.mediumGray;
  static const Color lightGray = theme.AppColors.lightGray;
  static const Color background = theme.AppColors.background;
  static const Color lightBg = theme.AppColors.background;
  static const Color white = theme.AppColors.white;
  static const Color cardBg = theme.AppColors.cardBg;

  static const Color textDark = theme.AppColors.black;

  static const Color success = theme.AppColors.success;
  static const Color error = theme.AppColors.error;
  static const Color warning = theme.AppColors.warning;
  static const Color info = theme.AppColors.info;

  static const LinearGradient primaryGradient = theme.AppColors.primaryGradient;
}

// Re-export text styles for convenience (non-const)
class AppTextStyles {
  AppTextStyles._();
  static TextStyle get displaySmall => theme.AppTextStyles.displaySmall;
  static TextStyle get bodyLarge => theme.AppTextStyles.bodyLarge;
}
