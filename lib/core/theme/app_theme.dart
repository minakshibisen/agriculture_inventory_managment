import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Blue Colors - Professional Business Theme
  static const Color primaryBlue = Color(0xFF1976D2); // Blue 700
  static const Color secondaryBlue = Color(0xFF42A5F5); // Blue 400
  static const Color lightBlue = Color(0xFF90CAF9); // Blue 200
  static const Color darkBlue = Color(0xFF0D47A1); // Blue 900

  // Accent Colors
  static const Color accentCyan = Color(0xFF00ACC1); // Cyan 600
  static const Color accentLightBlue = Color(0xFF0288D1); // Light Blue 700
  static const Color accentDeepPurple = Color(0xFF5E35B1); // Deep Purple 600

  // Status Colors
  static const Color successGreen = Color(0xFF43A047); // Green 600
  static const Color warningOrange = Color(0xFFFFA726); // Orange 400
  static const Color errorRed = Color(0xFFEF5350); // Red 400
  static const Color dangerRed = Color(0xFFD32F2F); // Red 700

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Responsive Spacing
  static double getSpacing(BuildContext context, {
    double mobile = 16.0,
    double tablet = 24.0,
    double desktop = 32.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) return desktop;
    if (width >= 600) return tablet;
    return mobile;
  }

  // Responsive Font Sizes
  static double getHeadlineSize(BuildContext context, {
    double mobile = 20.0,
    double tablet = 24.0,
    double desktop = 28.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) return desktop;
    if (width >= 600) return tablet;
    return mobile;
  }

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryBlue,
        tertiary: accentCyan,
        error: errorRed,
        background: backgroundColor,
        surface: surfaceColor,
        surfaceVariant: const Color(0xFFF1F5F9),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        outline: dividerColor,
        outlineVariant: const Color(0xFFCBD5E1),
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: backgroundColor,

      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          // Display styles
          displayLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: -0.25,
          ),

          // Headline styles
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),

          // Title styles
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),

          // Body styles
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textPrimary,
            height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: textSecondary,
            height: 1.5,
          ),

          // Label styles
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textTertiary,
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: textPrimary,
          size: 24,
        ),
      ),


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: primaryBlue, width: 1.5),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),

        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),

        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textTertiary,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: lightBlue.withOpacity(0.2),
        selectedColor: primaryBlue,
        deleteIconColor: textSecondary,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: primaryBlue,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 3,
        height: 70,
        indicatorColor: primaryBlue.withOpacity(0.15),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primaryBlue, size: 24);
          }
          return const IconThemeData(color: textSecondary, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: errorRed,
        textColor: Colors.white,
        textStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Status Colors Helper
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'low':
      case 'critical':
        return dangerRed;
      case 'expiring':
      case 'warning':
        return warningOrange;
      case 'expired':
        return errorRed;
      case 'available':
      case 'active':
      case 'in stock':
        return successGreen;
      case 'pending':
        return accentCyan;
      default:
        return textSecondary;
    }
  }

  // Status Background Colors
  static Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'low':
      case 'critical':
        return dangerRed.withOpacity(0.1);
      case 'expiring':
      case 'warning':
        return warningOrange.withOpacity(0.1);
      case 'expired':
        return errorRed.withOpacity(0.1);
      case 'available':
      case 'active':
      case 'in stock':
        return successGreen.withOpacity(0.1);
      case 'pending':
        return accentCyan.withOpacity(0.1);
      default:
        return textSecondary.withOpacity(0.1);
    }
  }

  // Gradient Helpers
  static LinearGradient getPrimaryGradient() {
    return const LinearGradient(
      colors: [primaryBlue, secondaryBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getSuccessGradient() {
    return LinearGradient(
      colors: [successGreen, successGreen.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getWarningGradient() {
    return LinearGradient(
      colors: [warningOrange, const Color(0xFFFFB74D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getErrorGradient() {
    return LinearGradient(
      colors: [dangerRed, errorRed],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Shadow Helpers
  static List<BoxShadow> getCardShadow({double elevation = 1}) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.05 * elevation),
        blurRadius: 8 * elevation,
        offset: Offset(0, 2 * elevation),
      ),
    ];
  }

  static List<BoxShadow> getSoftShadow() {
    return [
      BoxShadow(
        color: primaryBlue.withOpacity(0.1),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }
}