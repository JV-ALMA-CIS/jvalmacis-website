import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import 'hoverable.dart';

/// Solid, high-contrast primary action.
///
/// The site currently leans on outlined buttons, which read as secondary or
/// disabled. Primary actions should be the loudest thing in their section.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.large = false,
    this.loading = false,
    this.onDark = false,
    this.expand = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool large;
  final bool loading;

  /// Inverts to a white button for use on dark bands.
  final bool onDark;

  final bool expand;

  @override
  Widget build(BuildContext context) {
    final bg = onDark ? Palette.n0 : Palette.primary;
    final fg = onDark ? Palette.ink : Palette.n0;
    final hoverBg = onDark ? Palette.n100 : Palette.primaryHover;

    return Hoverable(
      onTap: loading ? null : onPressed,
      scale: 1.0,
      lift: -1.5,
      semanticLabel: text,
      builder: (hovered) => AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.hover,
        width: expand ? double.infinity : null,
        height: large ? 56 : 48,
        padding: EdgeInsets.symmetric(horizontal: large ? Space.xl : Space.lg),
        decoration: BoxDecoration(
          color: hovered ? hoverBg : bg,
          borderRadius: Radii.button,
          boxShadow: hovered ? Elevation.cardHover : Elevation.card,
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              ),
              const SizedBox(width: Space.sm),
            ],
            // Flexible: long labels wrap on narrow screens instead of overflowing.
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppType.theme.labelLarge?.copyWith(
                  color: fg,
                  fontSize: large ? 15 : 14,
                  height: 1.25,
                ),
              ),
            ),
            if (icon != null && !loading) ...[
              const SizedBox(width: Space.xs),
              AnimatedSlide(
                offset: hovered ? const Offset(0.25, 0) : Offset.zero,
                duration: Motion.fast,
                curve: Motion.hover,
                child: Icon(icon, size: 16, color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Quiet secondary action. Outlined on light, hairline on dark.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.large = false,
    this.onDark = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool large;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? Palette.n0 : Palette.ink;
    final border = onDark ? Colors.white24 : Palette.n300;

    return Hoverable(
      onTap: onPressed,
      scale: 1.0,
      lift: -1.5,
      semanticLabel: text,
      builder: (hovered) => AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.hover,
        height: large ? 56 : 48,
        padding: EdgeInsets.symmetric(horizontal: large ? Space.xl : Space.lg),
        decoration: BoxDecoration(
          color: hovered ? (onDark ? Colors.white10 : Palette.n50) : Colors.transparent,
          borderRadius: Radii.button,
          border: Border.all(
            color: hovered ? (onDark ? Colors.white38 : Palette.n400) : border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flexible: long labels wrap on narrow screens instead of overflowing.
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppType.theme.labelLarge?.copyWith(
                  color: fg,
                  fontSize: large ? 15 : 14,
                  height: 1.25,
                ),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: Space.xs),
              AnimatedSlide(
                offset: hovered ? const Offset(0.25, 0) : Offset.zero,
                duration: Motion.fast,
                curve: Motion.hover,
                child: Icon(icon, size: 16, color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
