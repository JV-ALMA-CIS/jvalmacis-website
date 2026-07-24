import 'package:flutter/material.dart';

import 'palette.dart';
import 'tokens.dart';
import 'typography.dart';

/// The single ThemeData for the site.
///
/// Drop-in replacement for the inline `theme:` block currently in main.dart.
/// Import this and use `theme: buildAppTheme()`.
ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: Palette.primary,
      surface: Palette.n0,
      onSurface: Palette.ink,
    ),
    scaffoldBackgroundColor: Palette.n0,
  );

  return base.copyWith(
    textTheme: AppType.theme,

    // Cards are drawn by AppCard; keep Material's own card flat so the two
    // systems never fight.
    cardTheme: CardThemeData(
      color: Palette.n0,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: Radii.card),
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: Palette.n200,
      thickness: 1,
      space: 1,
    ),

    // Filled fields with an animated 2px focus ring.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.n50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      labelStyle: AppType.theme.bodyMedium,
      hintStyle: AppType.theme.bodyMedium?.copyWith(color: Palette.n400),
      floatingLabelStyle: AppType.theme.labelLarge?.copyWith(color: Palette.primary),
      enabledBorder: OutlineInputBorder(
        borderRadius: Radii.button,
        borderSide: const BorderSide(color: Palette.n200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: Radii.button,
        borderSide: const BorderSide(color: Palette.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: Radii.button,
        borderSide: const BorderSide(color: Palette.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: Radii.button,
        borderSide: const BorderSide(color: Palette.danger, width: 2),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Palette.ink,
      contentTextStyle: AppType.theme.bodyMedium?.copyWith(color: Palette.n0),
      shape: RoundedRectangleBorder(borderRadius: Radii.button),
    ),

    // Visible keyboard focus everywhere.
    focusColor: Palette.primary.withValues(alpha: 0.12),

    splashFactory: InkSparkle.splashFactory,
  );
}