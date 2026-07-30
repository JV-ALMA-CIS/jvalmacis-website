import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';

/// Shared interior-page hero.
///
/// Every non-home page currently rebuilds the same dark gradient band with
/// slightly different padding and type sizes. This replaces all of them so the
/// set finally reads as one site.
///
/// Differences from the old band:
///   • single-hue near-black instead of the flat two-stop slate
///   • a soft radial brand glow for depth
///   • the large display type scale
///   • an optional [accent] rule so business-unit pages feel distinct
///     without leaving the system
///   • min-height rather than fixed height, so long titles can never overflow
class PageHero extends StatelessWidget {
  const PageHero({
    super.key,
    required this.title,
    this.subtitle,
    this.accent,
    this.maxWidth = 1000,
  });

  final String title;
  final String? subtitle;

  /// Business-unit accent for the top rule. Null = no rule.
  final Color? accent;

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (accent != null) Container(height: 3, color: accent),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: isMobile ? 260 : 340),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: Palette.heroSurface),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: Palette.heroGlow),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : Space.lg,
                  vertical: isMobile ? Space.xxl : Space.xxxl,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppType.theme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontSize: AppType.fluid(context, min: 28, max: 46),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: Space.md),
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: Space.proseMax),
                            child: Text(
                              subtitle!,
                              textAlign: TextAlign.center,
                              style: AppType.theme.bodyLarge
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}