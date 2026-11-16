import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/cms_image.dart';
import 'it_products.dart';

/// A product's visual: an illustration uncropped and captioned as
/// illustrative, a screenshot whole in a neutral panel, or, without either,
/// a panel carrying the product's name so every product keeps its place.
class ProductVisual extends StatelessWidget {
  const ProductVisual({
    super.key,
    required this.product,
    this.aspectRatio = 4 / 3,
    this.zoom = 1.0,
  });

  final SoftwareProduct product;

  /// Box for screenshots and the name panel; illustrations keep their own.
  final double aspectRatio;

  /// Scale for hover feedback.
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final visual = product.visual;
    final namePanel = _NamePanel(product: product);

    if (visual != null && visual.kind == ScreenshotKind.illustration) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Box(
            aspectRatio: visual.aspectRatio ?? aspectRatio,
            zoom: zoom,
            child: Semantics(
              image: true,
              label: visual.description,
              child: CmsImage(
                source: visual.path,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => namePanel,
              ),
            ),
          ),
          const SizedBox(height: Space.xs),
          Text(illustrativeCaption, style: AppType.theme.bodySmall?.copyWith(fontSize: 12)),
        ],
      );
    }

    return _Box(
      aspectRatio: aspectRatio,
      zoom: zoom,
      child: visual == null ? namePanel : ScreenshotFrame(visual, fallback: namePanel),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.aspectRatio, required this.zoom, required this.child});

  final double aspectRatio;
  final double zoom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.md),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ColoredBox(
          color: Palette.n50,
          child: AnimatedScale(
            scale: zoom,
            duration: Motion.reduced(context) ? Duration.zero : Motion.base,
            curve: Motion.hover,
            child: SizedBox.expand(child: child),
          ),
        ),
      ),
    );
  }
}

/// A screenshot shown whole inside a light frame: desktop screens with a
/// small corner radius, phone screens upright with a larger one. Fill a
/// sized box with it.
class ScreenshotFrame extends StatelessWidget {
  const ScreenshotFrame(this.shot, {super.key, this.fallback});

  final ProductScreenshot shot;

  /// Shown if the file cannot be loaded.
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final phone = shot.kind == ScreenshotKind.phone;
    return Semantics(
      image: true,
      label: shot.description,
      child: Padding(
        padding: EdgeInsets.all(phone ? Space.lg : Space.md),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(phone ? Radii.lg : Radii.sm),
              border: Border.all(color: Palette.n200),
              boxShadow: Elevation.card,
            ),
            clipBehavior: Clip.antiAlias,
            child: CmsImage(
              source: shot.path,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => fallback ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NamePanel extends StatelessWidget {
  const _NamePanel({required this.product});

  final SoftwareProduct product;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ColoredBox(
        color: Palette.n50,
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 32, height: 2, color: Palette.ink),
              const SizedBox(height: Space.md),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(product.name, style: AppType.theme.displaySmall),
              ),
              const SizedBox(height: Space.xs),
              Text(product.subtitle.toUpperCase(), style: AppType.eyebrow(Palette.n500)),
            ],
          ),
        ),
      ),
    );
  }
}
