import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../design/tokens.dart';

/// Fade + rise as an element scrolls into view. Fires once.
///
/// Wrap every top-level section and every grid child. Staggering grid children
/// by index is what makes a page feel orchestrated rather than static:
///
/// ```dart
/// RevealOnScroll(delayMs: 60 * index, child: UnitCard(...))
/// ```
///
/// Requires `visibility_detector` in pubspec.yaml.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.offsetY = 24,
    this.threshold = 0.08,
  });

  final Widget child;

  /// Stagger delay. Keep total stagger under ~300ms or the page feels slow.
  final int delayMs;

  /// How far the element rises, in logical pixels.
  final double offsetY;

  /// Fraction of the widget that must be visible before revealing.
  final double threshold;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool _shown = false;

  void _onVisibility(VisibilityInfo info) {
    if (_shown || !mounted) return;
    if (info.visibleFraction >= widget.threshold) {
      if (widget.delayMs == 0) {
        setState(() => _shown = true);
      } else {
        Future.delayed(Duration(milliseconds: widget.delayMs), () {
          if (mounted) setState(() => _shown = true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Users who asked for reduced motion get the content immediately.
    if (Motion.reduced(context)) return widget.child;

    return VisibilityDetector(
      key: ValueKey('reveal-${identityHashCode(this)}'),
      onVisibilityChanged: _onVisibility,
      child: AnimatedOpacity(
        opacity: _shown ? 1 : 0,
        duration: Motion.base,
        curve: Motion.enter,
        child: AnimatedSlide(
          offset: _shown ? Offset.zero : Offset(0, widget.offsetY / 100),
          duration: Motion.base,
          curve: Motion.enter,
          child: widget.child,
        ),
      ),
    );
  }
}