import 'package:flutter/material.dart';

/// Fixed 8-pt spacing scale.
///
/// Replaces every `screenHeight * 0.0x` / `screenWidth * 0.0x` in the codebase.
/// Viewport-relative vertical padding is why section rhythm currently differs
/// on every device and collapses on short viewports.
abstract final class Space {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const xxxl = 64.0;
  static const section = 96.0;

  /// Standard section padding. Fixed vertical rhythm, breathing horizontal gutter.
  static EdgeInsets sectionPad(bool isMobile) => EdgeInsets.symmetric(
        vertical: isMobile ? xxxl : section,
        horizontal: isMobile ? 20 : lg,
      );

  /// Content max-widths.
  static const contentMax = 1200.0;
  static const proseMax = 720.0;
}

abstract final class Radii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const pill = 999.0;

  static final card = BorderRadius.circular(lg);
  static final chip = BorderRadius.circular(md);
  static final button = BorderRadius.circular(md);
}

/// Layered, neutral shadows.
///
/// The old single flat shadow (blur 8, offset 0,4) with *coloured* tint is the
/// clearest "default Flutter" tell. Real depth needs two layers: a tight
/// contact shadow plus a wide ambient one.
abstract final class Elevation {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x0D0B1220), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x140B1220), blurRadius: 16, offset: Offset(0, 8)),
  ];

  static const cardHover = <BoxShadow>[
    BoxShadow(color: Color(0x120B1220), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x1F0B1220), blurRadius: 32, offset: Offset(0, 18)),
  ];

  static const overlay = <BoxShadow>[
    BoxShadow(color: Color(0x140B1220), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x290B1220), blurRadius: 48, offset: Offset(0, 24)),
  ];
}

/// Two durations, two curves. Everything on the site uses these.
abstract final class Motion {
  static const fast = Duration(milliseconds: 180);
  static const base = Duration(milliseconds: 420);
  static const slow = Duration(milliseconds: 700);

  /// Entrances and reveals.
  static const enter = Curves.easeOutCubic;

  /// Hover lifts and presses.
  static const hover = Curves.easeOut;

  /// Honour the OS "reduce motion" setting. Gate every decorative
  /// animation behind this.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}