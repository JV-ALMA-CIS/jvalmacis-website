import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';

/// Continuous, constant-velocity logo marquee.
///
/// Replaces the `CarouselSlider` with `enlargeCenterPage: true` and the
/// hard-coded per-logo enlargement for Sweden/Portugal. Logos now sit at one
/// uniform height, desaturated by default and returning to full colour on
/// hover — the treatment IBM, AWS and Stripe all use for "trusted by" rows.
class LogoMarquee extends StatefulWidget {
  const LogoMarquee({
    super.key,
    required this.assetPaths,
    this.logoHeight = 44,
    this.gap = 72,
    this.pixelsPerSecond = 28,
  });

  final List<String> assetPaths;
  final double logoHeight;
  final double gap;
  final double pixelsPerSecond;

  @override
  State<LogoMarquee> createState() => _LogoMarqueeState();
}

class _LogoMarqueeState extends State<LogoMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _paused = false;

  // Each logo occupies a fixed cell so spacing stays perfectly even.
  double get _cellWidth => 150 + widget.gap;
  double get _runWidth => _cellWidth * widget.assetPaths.length;

  @override
  void initState() {
    super.initState();
    final seconds = _runWidth / widget.pixelsPerSecond;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (seconds * 1000).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reduced motion: fall back to a calm static wrap, no scrolling.
    if (Motion.reduced(context)) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: widget.gap,
        runSpacing: Space.lg,
        children: widget.assetPaths.map(_logo).toList(),
      );
    }

    return MouseRegion(
      onEnter: (_) {
        _controller.stop();
        setState(() => _paused = true);
      },
      onExit: (_) {
        _controller.repeat();
        setState(() => _paused = false);
      },
      child: ShaderMask(
        // Fade the edges so logos enter and leave softly instead of clipping.
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.08, 0.92, 1.0],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: SizedBox(
          height: widget.logoHeight + Space.xl,
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final dx = -_controller.value * _runWidth;
                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    // Two runs back to back give a seamless loop.
                    children: [
                      ...widget.assetPaths.map(_cell),
                      ...widget.assetPaths.map(_cell),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(String path) => SizedBox(
        width: _cellWidth,
        child: Center(child: _logo(path)),
      );

  Widget _logo(String path) => _MarqueeLogo(
        path: path,
        height: widget.logoHeight,
        forceColour: _paused,
      );
}

class _MarqueeLogo extends StatefulWidget {
  const _MarqueeLogo({
    required this.path,
    required this.height,
    required this.forceColour,
  });

  final String path;
  final double height;
  final bool forceColour;

  @override
  State<_MarqueeLogo> createState() => _MarqueeLogoState();
}

class _MarqueeLogoState extends State<_MarqueeLogo> {
  bool _hovered = false;

  // Luminance matrix — standard greyscale conversion.
  static const _greyscale = <double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  @override
  Widget build(BuildContext context) {
    final coloured = _hovered || widget.forceColour;

    final image = Image.asset(
      widget.path,
      height: widget.height,
      fit: BoxFit.contain,
      // Uniform height for every logo — no more per-logo special cases.
      errorBuilder: (_, __, ___) => SizedBox(height: widget.height),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedOpacity(
        opacity: coloured ? 1.0 : 0.65,
        duration: Motion.fast,
        child: coloured
            ? image
            : ColorFiltered(
                colorFilter: const ColorFilter.matrix(_greyscale),
                child: image,
              ),
      ),
    );
  }
}

/// Small helper so the marquee edges read correctly on tinted backgrounds.
const marqueeBackground = Palette.n0;