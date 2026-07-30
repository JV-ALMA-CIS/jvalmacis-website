import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Curated icon-name <-> IconData lookup.
///
/// Firestore can't store an `IconData`, so CMS content stores a String key
/// instead. This is the single place both the admin icon picker and the
/// public renderer resolve that key back to a Lucide icon, so the two never
/// drift.
abstract final class IconKeyRegistry {
  static const Map<String, IconData> _icons = {
    'building': LucideIcons.building,
    'building2': LucideIcons.building2,
    'sprout': LucideIcons.sprout,
    'droplets': LucideIcons.droplets,
    'globe': LucideIcons.globe,
    'award': LucideIcons.award,
    'lightbulb': LucideIcons.lightbulb,
    'leaf': LucideIcons.leaf,
    'users': LucideIcons.users,
    'target': LucideIcons.target,
    'eye': LucideIcons.eye,
    'mail': LucideIcons.mail,
    'shield': LucideIcons.shield,
    'phone': LucideIcons.phone,
    'newspaper': LucideIcons.newspaper,
    'home': LucideIcons.home,
    'info': LucideIcons.info,
    'star': LucideIcons.star,
    'briefcase': LucideIcons.briefcase,
    'mapPin': LucideIcons.mapPin,
  };

  static const String fallbackKey = 'building';

  static IconData resolve(String? key) => _icons[key] ?? _icons[fallbackKey]!;

  static List<String> get keys => _icons.keys.toList(growable: false);
}
