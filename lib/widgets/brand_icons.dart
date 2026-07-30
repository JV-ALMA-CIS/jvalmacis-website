import 'package:flutter/widgets.dart';

/// Brand glyphs not present in the Lucide icon set (Lucide dropped
/// trademarked logo icons upstream). Sourced from the Font Awesome Brands
/// font bundled by the `font_awesome_flutter` package, referenced directly
/// as plain [IconData] instead of via `FontAwesomeIcons.*` — that class
/// extends [IconData], which the current Flutter SDK no longer allows
/// outside its defining library.
abstract final class BrandIcons {
  static const IconData linkedin = IconData(
    0xf08c,
    fontFamily: 'FontAwesomeBrands',
    fontPackage: 'font_awesome_flutter',
  );

  static const IconData instagram = IconData(
    0xf16d,
    fontFamily: 'FontAwesomeBrands',
    fontPackage: 'font_awesome_flutter',
  );
}
