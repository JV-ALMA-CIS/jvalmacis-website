import 'package:flutter/material.dart';

/// JV ALMA C.I.S colour system.
///
/// One primary brand blue. A disciplined neutral ramp. The four business-unit
/// colours are demoted to *accents only* — icon chips, thin rules, small tags.
/// They must never be used as full-bleed fills, card backgrounds, or shadows.
abstract final class Palette {
  // ---- Brand -------------------------------------------------------------
  /// Near-black. Warmer and deeper than the old slate #0F172A.
  static const ink = Color(0xFF0B1220);

  /// The one brand blue. Buttons, links, focus rings, active states.
  static const primary = Color(0xFF1D4ED8);
  static const primaryHover = Color(0xFF1E40AF);
  static const primarySubtle = Color(0xFFEFF4FF);

  // ---- Neutral ramp ------------------------------------------------------
  static const n0 = Color(0xFFFFFFFF);
  static const n50 = Color(0xFFF7F8FA);
  static const n100 = Color(0xFFEEF1F5);
  static const n200 = Color(0xFFE2E6EC);
  static const n300 = Color(0xFFCBD2DC);
  static const n400 = Color(0xFF9AA4B2);
  static const n500 = Color(0xFF6B7685);
  static const n600 = Color(0xFF3A4557);
  static const n700 = Color(0xFF232D3D);

  // ---- Business-unit accents (chips, rules, tags only) -------------------
  static const construction = Color(0xFF2563EB);
  static const agribusiness = Color(0xFF16A34A);
  static const oilGas = Color(0xFFEA580C);
  static const it = Color(0xFF7C3AED);

  // ---- Semantic ----------------------------------------------------------
  static const success = Color(0xFF059669);
  static const danger = Color(0xFFDC2626);

  // ---- Gradients ---------------------------------------------------------
  /// Single-hue near-black. Replaces the old two-hue blue→green gradient.
  static const heroSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1220), Color(0xFF111A2E)],
  );

  /// Soft brand glow, layered *over* [heroSurface] for depth.
  static const heroGlow = RadialGradient(
    center: Alignment(-0.6, -0.8),
    radius: 1.2,
    colors: [Color(0x331D4ED8), Color(0x000B1220)],
  );

  /// Directional scrim for text sitting on photography.
  static const photoScrim = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xE60B1220), Color(0x660B1220), Color(0x1A0B1220)],
    stops: [0.0, 0.55, 1.0],
  );
}