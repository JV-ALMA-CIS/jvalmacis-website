import 'package:flutter/material.dart';

import '../../design/palette.dart';

/// Curated color-name <-> [Palette] token lookup.
///
/// Firestore can't store a `Color`, so CMS content stores a String key
/// instead. This keeps the existing design system authoritative — admins
/// pick from the same brand/accent palette used everywhere else, never a
/// raw hex value.
abstract final class ColorKeyRegistry {
  static const Map<String, Color> _colors = {
    'primary': Palette.primary,
    'construction': Palette.construction,
    'agribusiness': Palette.agribusiness,
    'oilGas': Palette.oilGas,
    'it': Palette.it,
    'success': Palette.success,
    'danger': Palette.danger,
    'ink': Palette.ink,
  };

  static const String fallbackKey = 'primary';

  static Color resolve(String? key) => _colors[key] ?? _colors[fallbackKey]!;

  static List<String> get keys => _colors.keys.toList(growable: false);
}
