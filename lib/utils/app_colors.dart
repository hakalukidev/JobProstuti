import 'package:flutter/material.dart';

class AppColors {
  // =================== Professional Dark Green Theme ===================

  // Primary Color - Deep Forest Green
  static const Color primary = Color(0xFF064E3B);      // Emerald 900
  static const Color primaryDark = Color(0xFF022C22);   // Emerald 950 (Hero/Navbar)
  static const Color primaryLight = Color(0xFF059669);  // Emerald 600

  // Secondary Color - Vibrant Green/Mint
  static const Color secondary = Color(0xFF10B981);     // Emerald 500
  static const Color secondaryLight = Color(0xFF34D399); // Emerald 400

  // Accent Color - Gold/Amber (Matches the star in screenshot)
  static const Color accent = Color(0xFFFBBF24);        // Amber 400
  static const Color accentLight = Color(0xFFFDE68A);   // Amber 200

  // Background Colors
  static const Color background = Color(0xFFF0FDF4);     // Green 50
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color backgroundDark = Color(0xFFDCFCE7);  // Green 100

  // Text Colors
  static const Color textPrimary = Color(0xFF064E3B);    // Deep Green
  static const Color textSecondary = Color(0xFF374151);  // Gray 700
  static const Color textMuted = Color(0xFF6B7280);      // Gray 500
  static const Color textWhite = Color(0xFFFFFFFF);      // White

  // Border & Divider
  static const Color border = Color(0xFFE5E7EB);         // Gray 200
  static const Color divider = Color(0xFFF3F4F6);        // Gray 100

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Navbar Colors
  static const Color navbarBackground = Color(0xFF022C22);
  static const Color navbarText = Color(0xFFFFFFFF);
  static const Color navbarTextActive = Color(0xFF10B981);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF10B981);
  static const Color buttonSecondary = Color(0xFF064E3B);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0F000000);

  // Footer Colors
  static const Color footerBackground = Color(0xFF022C22);
  static const Color footerText = Color(0xFF94A3B8);

  // ========== Backward Compatibility / Aliases ==========
  static const Color navy = Color(0xFF022C22); 
  static const Color navyDark = Color(0xFF011611);
  static const Color blue = Color(0xFF059669);
  static const Color blueLight = Color(0xFF34D399);
  static const Color white = Colors.white;
  static const Color lightBg = Color(0xFFF0FDF4);
  static const Color textDark = Color(0xFF064E3B);
  static const Color gold = Color(0xFFFBBF24);
}
