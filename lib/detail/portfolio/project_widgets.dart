import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/cms_image.dart';
import '../../widgets/hoverable.dart';
import 'portfolio_project.dart';

/// A project image filling its box: photographs are cropped to fit, logos
/// are shown whole on a light surface. A missing file shows a quiet
/// placeholder instead of an error.
class ProjectPhoto extends StatelessWidget {
  const ProjectPhoto(this.image, {super.key, this.zoom = 1.0, this.contain = false});

  final ProjectImage image;

  /// Scale for hover feedback; the image is clipped by its parent.
  final double zoom;

  /// Show the whole photograph (for the image viewer).
  final bool contain;

  @override
  Widget build(BuildContext context) {
    final whole = contain || image.isLogo;
    Widget picture = CmsImage(
      source: image.path,
      fit: whole ? BoxFit.contain : BoxFit.cover,
      errorBuilder: (_, __, ___) => const _MissingImage(),
    );
    if (image.isLogo && !contain) {
      picture = ColoredBox(
        color: Palette.n50,
        child: Padding(padding: const EdgeInsets.all(Space.xl), child: picture),
      );
    }
    return AnimatedScale(
      scale: zoom,
      duration: Motion.base,
      curve: Motion.hover,
      child: SizedBox.expand(child: picture),
    );
  }
}

class _MissingImage extends StatelessWidget {
  const _MissingImage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.n100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.imageOff, color: Palette.n400, size: 28),
            const SizedBox(height: Space.xs),
            Text('Image unavailable', style: AppType.theme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Client, funder, location and period (or status) as small labelled pairs;
/// whichever the project has.
class ProjectMeta extends StatelessWidget {
  const ProjectMeta({super.key, required this.project, this.vertical = false});

  final PortfolioProject project;

  /// Stack the pairs instead of placing them side by side.
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    Widget pair(String label, String value, {String? logo}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: AppType.eyebrow(Palette.n500)),
            const SizedBox(height: Space.xs),
            if (logo != null) ...[ClientLogoImage(logo), const SizedBox(height: Space.xs)],
            Text(value, style: AppType.theme.bodyMedium?.copyWith(color: Palette.ink)),
          ],
        );

    final pairs = [
      if (project.client case final client?)
        pair(project.clientLabel, client, logo: project.clientLogo),
      if (project.funder case final funder?) pair('Funded by', funder),
      if (project.location case final location?) pair('Location', location),
      if (project.period case final period?)
        pair('Period', period)
      else if (project.status case final status?)
        pair('Status', status),
    ];
    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < pairs.length; i++) ...[
            if (i > 0) const SizedBox(height: Space.md),
            pairs[i],
          ],
        ],
      );
    }
    return Wrap(spacing: Space.xxl, runSpacing: Space.md, children: pairs);
  }
}

/// A client's logo at a small, even height. The client's name is always
/// shown next to it, so the logo itself is not read out.
class ClientLogoImage extends StatelessWidget {
  const ClientLogoImage(this.path, {super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 28,
        child: CmsImage(
          source: path,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Text link with an arrow that stays beside the text when it wraps.
class ArrowLink extends StatelessWidget {
  const ArrowLink({super.key, required this.label, required this.onTap, this.back = false});

  final String label;
  final VoidCallback onTap;

  /// Leading left arrow instead of a trailing right arrow.
  final bool back;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: label,
      builder: (hovered) {
        final style = AppType.theme.labelLarge?.copyWith(
          color: Palette.primary,
          height: 1.4,
          decoration: hovered ? TextDecoration.underline : null,
          decorationColor: Palette.primary,
        );
        final arrow = WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            back ? LucideIcons.arrowLeft : LucideIcons.arrowRight,
            size: 15,
            color: Palette.primary,
          ),
        );
        return Text.rich(
          TextSpan(
            style: style,
            children:
                back ? [arrow, TextSpan(text: ' $label')] : [TextSpan(text: '$label '), arrow],
          ),
        );
      },
    );
  }
}

/// Circular outlined control for carousels and the image viewer.
class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.onDark = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final fg = onDark ? Palette.n0 : Palette.ink;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: Colors.transparent,
          shape: CircleBorder(
            side: BorderSide(color: onDark ? const Color(0x66FFFFFF) : Palette.n300),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, size: 20, color: enabled ? fg : fg.withValues(alpha: 0.3)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens [images] full screen at [initial], with previous/next controls,
/// arrow keys and Escape to close.
Future<void> showProjectImageViewer(
  BuildContext context, {
  required List<ProjectImage> images,
  required int initial,
  required String title,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xF20B1220),
    barrierLabel: 'Close image viewer',
    builder: (_) => _ImageViewer(images: images, initial: initial, title: title),
  );
}

class _ImageViewer extends StatefulWidget {
  const _ImageViewer({required this.images, required this.initial, required this.title});

  final List<ProjectImage> images;
  final int initial;
  final String title;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late int _index = widget.initial;

  void _go(int delta) {
    final next = _index + delta;
    if (next < 0 || next >= widget.images.length) return;
    setState(() => _index = next);
  }

  @override
  Widget build(BuildContext context) {
    final many = widget.images.length > 1;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _go(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _go(1),
      },
      child: Focus(
        autofocus: true,
        child: Material(
          type: MaterialType.transparency,
          child: Semantics(
            label: '${widget.title}, image ${_index + 1} of ${widget.images.length}',
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? Space.md : Space.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            many ? '${_index + 1} / ${widget.images.length}' : '',
                            style: AppType.theme.labelLarge?.copyWith(
                              color: Palette.n0,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        RoundButton(
                          icon: LucideIcons.x,
                          label: 'Close image viewer',
                          onDark: true,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.md),
                    Expanded(
                      child: Row(
                        children: [
                          if (many && !isMobile) ...[
                            RoundButton(
                              icon: LucideIcons.chevronLeft,
                              label: 'Previous image',
                              onDark: true,
                              onPressed: _index > 0 ? () => _go(-1) : null,
                            ),
                            const SizedBox(width: Space.lg),
                          ],
                          Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: many
                                  ? (d) {
                                      final v = d.primaryVelocity ?? 0;
                                      if (v < -200) _go(1);
                                      if (v > 200) _go(-1);
                                    }
                                  : null,
                              child: ProjectPhoto(widget.images[_index], contain: true),
                            ),
                          ),
                          if (many && !isMobile) ...[
                            const SizedBox(width: Space.lg),
                            RoundButton(
                              icon: LucideIcons.chevronRight,
                              label: 'Next image',
                              onDark: true,
                              onPressed: _index < widget.images.length - 1 ? () => _go(1) : null,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.images[_index].caption case final caption?) ...[
                      const SizedBox(height: Space.md),
                      Text(
                        caption,
                        textAlign: TextAlign.center,
                        style: AppType.theme.bodyMedium?.copyWith(color: Palette.n0),
                      ),
                    ],
                    if (many && isMobile) ...[
                      const SizedBox(height: Space.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundButton(
                            icon: LucideIcons.chevronLeft,
                            label: 'Previous image',
                            onDark: true,
                            onPressed: _index > 0 ? () => _go(-1) : null,
                          ),
                          const SizedBox(width: Space.lg),
                          RoundButton(
                            icon: LucideIcons.chevronRight,
                            label: 'Next image',
                            onDark: true,
                            onPressed: _index < widget.images.length - 1 ? () => _go(1) : null,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
