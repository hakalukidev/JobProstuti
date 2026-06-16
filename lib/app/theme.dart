import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors (green like bcsprostuti.com)
  static const Color primary = Color(0xFF1B8E3D);
  static const Color primaryDark = Color(0xFF146B2E);
  static const Color primaryLight = Color(0xFF4CAF70);
  static const Color primarySurface = Color(0xFFE8F5ED);

  // Accent
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFFF0EB);

  // Neutrals
  static const Color black = Color(0xFF1A1A2E);
  static const Color darkGray = Color(0xFF2D2D2D);
  static const Color mediumGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFE5E7EB);
  static const Color background = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B8E3D), Color(0xFF146B2E)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D5C27), Color(0xFF1B8E3D), Color(0xFF4CAF70)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B8E3D), Color(0xFF22C55E)],
  );
}

class AppTextStyles {
  static const String banglaFont = 'Hind Siliguri';
  static const String englishFont = 'Roboto';

  // Hero / Display
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.3,
  );

  static TextStyle get displaySmall => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.4,
  );

  // Headings
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.4,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.4,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.5,
  );

  // Body
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGray,
    height: 1.6,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGray,
    height: 1.6,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mediumGray,
    height: 1.5,
  );

  // Labels
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.4,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    height: 1.4,
  );

  // Stats
  static TextStyle get statNumber => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    height: 1.2,
  );

  static TextStyle get statLabel => const TextStyle(
    fontFamily: banglaFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGray,
    height: 1.4,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.black,
      ),
      fontFamily: AppTextStyles.banglaFont,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: false,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.banglaFont,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightGray, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTextStyles.labelLarge,
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTextStyles.banglaFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: AppTextStyles.banglaFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.mediumGray,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.mediumGray,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGray,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primarySurface,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mediumGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.banglaFont,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.banglaFont,
          fontSize: 11,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.mediumGray,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.banglaFont,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppTextStyles.banglaFont,
          fontSize: 14,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.black,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.mediumGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return AppColors.primaryLight;
          return AppColors.lightGray;
        }),
      ),
    );
  }
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}

class AppShadows {
  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get subtle => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
