import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

/// Type scale for JV ALMA C.I.S.
///
/// Two moves carry the whole redesign:
///   1. Display sizes get much larger (up to 60) with negative tracking.
///   2. Body sizes come up from 13/14 to 16/18 with 1.6 line-height.
///
/// The result is high contrast between headline and body — the single
/// clearest visual difference between an in-house build and Stripe/Linear.
abstract final class AppType {
  static TextStyle _i(
    double size,
    FontWeight weight, {
    double height = 1.4,
    double tracking = 0,
    Color color = Palette.ink,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: tracking,
        color: color,
      );

  static TextTheme get theme => TextTheme(
        // Display — hero and major statements. Tight, confident, negative tracking.
        displayLarge: _i(60, FontWeight.w700, height: 1.04, tracking: -1.6),
        displayMedium: _i(48, FontWeight.w700, height: 1.08, tracking: -1.1),
        displaySmall: _i(36, FontWeight.w700, height: 1.12, tracking: -0.7),

        // Headline — section titles and card titles.
        headlineLarge: _i(30, FontWeight.w600, height: 1.2, tracking: -0.4),
        headlineMedium: _i(24, FontWeight.w600, height: 1.25, tracking: -0.25),
        headlineSmall: _i(20, FontWeight.w600, height: 1.3, tracking: -0.1),

        // Title — sub-headings, list leads.
        titleLarge: _i(18, FontWeight.w600, height: 1.4),
        titleMedium: _i(16, FontWeight.w600, height: 1.4),
        titleSmall: _i(14, FontWeight.w600, height: 1.4),

        // Body — was 13/14. Now readable at enterprise distance.
        bodyLarge: _i(18, FontWeight.w400, height: 1.6, color: Palette.n600),
        bodyMedium: _i(16, FontWeight.w400, height: 1.6, color: Palette.n600),
        bodySmall: _i(14, FontWeight.w400, height: 1.5, color: Palette.n500),

        // Label — buttons, eyebrows, chips.
        labelLarge: _i(14, FontWeight.w600, height: 1.0, tracking: 0.2),
        labelMedium: _i(13, FontWeight.w600, height: 1.0, tracking: 0.3),
        labelSmall: _i(12, FontWeight.w600, height: 1.0, tracking: 0.8),
      );

  /// Eyebrow label — uppercase, tracked out. Used above section titles.
  static TextStyle eyebrow(Color color) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 1.4,
        color: color,
      );

  /// Fluid interpolation for display type so the hero scales smoothly
  /// instead of snapping between breakpoints.
  ///
  ///   fontSize: AppType.fluid(context, min: 34, max: 60)
  static double fluid(BuildContext context, {required double min, required double max}) {
    final w = MediaQuery.sizeOf(context).width.clamp(360.0, 1440.0);
    final t = (w - 360.0) / (1440.0 - 360.0);
    return min + (max - min) * t;
  }
}