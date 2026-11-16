import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import 'hoverable.dart';

/// The one card surface used everywhere: business units, values, metrics,
/// certificates, news, contact info, project tiles.
///
/// Replaces the mix of raw `Container` + flat shadow, stock `Card()`, and
/// `CustomCard` currently spread across the pages.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.lg),
    this.accent,
    this.interactive = true,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  /// Business-unit accent. Only tints the border on hover — never fills.
  final Color? accent;

  /// Set false for purely static surfaces (no hover lift).
  final bool interactive;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget surface(bool hovered) => AnimatedContainer(
          duration: Motion.fast,
          curve: Motion.hover,
          padding: padding,
          decoration: BoxDecoration(
            color: Palette.n0,
            borderRadius: Radii.card,
            border: Border.all(
              color: hovered ? (accent ?? Palette.primary).withValues(alpha: 0.45) : Palette.n200,
            ),
            boxShadow: hovered ? Elevation.cardHover : Elevation.card,
          ),
          child: child,
        );

    if (!interactive && onTap == null) return surface(false);

    return Hoverable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      builder: surface,
    );
  }
}

/// Tinted rounded icon chip. Used on unit cards, value cards, contact tiles.
/// This is where business-unit colour is allowed to appear.
class IconChip extends StatelessWidget {
  const IconChip({
    super.key,
    required this.icon,
    required this.color,
    this.size = 26,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: Radii.chip,
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}

/// Uppercase tracked-out label sitting above a section title.
/// A structural device, not decoration — it names the section's role.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = Palette.primary});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 20, height: 2, color: color),
        const SizedBox(width: Space.xs),
        // Flexible: long eyebrows wrap on narrow screens instead of overflowing.
        Flexible(
          child: Text(text.toUpperCase(), style: AppType.eyebrow(color).copyWith(height: 1.5)),
        ),
      ],
    );
  }
}
