import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The one hover primitive used across the entire site.
///
/// Every interactive surface — cards, logos, buttons, info tiles, project
/// images — gets the same hover language: a small lift plus whatever the
/// builder does with the [hovered] flag. Consistency is what reads as
/// "designed" rather than "assembled".
///
/// ```dart
/// Hoverable(
///   onTap: () => Navigator.pushNamed(context, route),
///   builder: (hovered) => AnimatedContainer(
///     duration: Motion.fast,
///     decoration: BoxDecoration(
///       boxShadow: hovered ? Elevation.cardHover : Elevation.card,
///     ),
///     child: ...,
///   ),
/// )
/// ```
class Hoverable extends StatefulWidget {
  const Hoverable({
    super.key,
    required this.builder,
    this.onTap,
    this.scale = 1.02,
    this.lift = -2.0,
    this.semanticLabel,
  });

  /// Rebuilds with the current hover state.
  final Widget Function(bool hovered) builder;

  final VoidCallback? onTap;

  /// Scale applied on hover. Keep it subtle — 1.02 reads as premium, 1.08 reads as a toy.
  final double scale;

  /// Vertical translation on hover, in logical pixels (negative = up).
  final double lift;

  final String? semanticLabel;

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovered = false;
  bool _focused = false;

  bool get _active => _hovered || _focused;

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);

    Widget child = AnimatedSlide(
      offset: (_active && !reduced) ? Offset(0, widget.lift / 100) : Offset.zero,
      duration: Motion.fast,
      curve: Motion.hover,
      child: AnimatedScale(
        scale: (_active && !reduced) ? widget.scale : 1.0,
        duration: Motion.fast,
        curve: Motion.hover,
        child: widget.builder(_active),
      ),
    );

    if (widget.onTap != null) {
      child = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: FocusableActionDetector(
          onShowFocusHighlight: (v) => setState(() => _focused = v),
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap!.call();
                return null;
              },
            ),
          },
          child: child,
        ),
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      button: widget.onTap != null,
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: child,
      ),
    );
  }
}