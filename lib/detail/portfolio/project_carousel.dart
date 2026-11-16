import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import 'portfolio_project.dart';
import 'project_widgets.dart';

/// Every project of a portfolio as a row of cards.
///
/// Three cards fit the content column on desktop, two on tablets, one on
/// phones. Wider screens also show part of the next card past the column's
/// right edge, so it is clear there is more. Visitors move one card at a
/// time with the arrows, the arrow keys, a swipe or a drag; nothing moves on
/// its own.
class ProjectCarousel extends StatefulWidget {
  const ProjectCarousel({
    super.key,
    required this.projects,
    required this.onOpen,
    this.title = 'Projects',
    this.eyebrow = 'PORTFOLIO',
  });

  final List<PortfolioProject> projects;
  final String title;
  final String eyebrow;
  final ValueChanged<PortfolioProject> onOpen;

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> with SingleTickerProviderStateMixin {
  /// Scroll position in cards; 2.0 means the third project is first in view.
  late final AnimationController _position = AnimationController.unbounded(vsync: this);

  /// Keyboard focus for the arrow keys; taken on any press in the carousel.
  final _focus = FocusNode(debugLabel: 'ProjectCarousel');

  /// The first project in view.
  int _index = 0;

  /// Cards that fit the column, and the distance between card starts; both
  /// set by the latest layout.
  int _visible = 1;
  double _step = 1;

  /// Width kept free at the column's end for a slice of the next card.
  double _reserve = 0;

  /// The furthest the row can move: the last card at the column's end.
  int get _last => math.max(0, widget.projects.length - _visible);

  @override
  void dispose() {
    _position.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Where the row rests with [index] first in view. At the end it shifts
  /// by the reserved width so the last card meets the column's right edge.
  double _restFor(int index) =>
      index == _last && _last > 0 ? index - _reserve / _step : index.toDouble();

  void _go(int index) {
    final target = index.clamp(0, _last);
    setState(() => _index = target);
    if (Motion.reduced(context)) {
      _position.value = _restFor(target);
    } else {
      _position.animateTo(_restFor(target), duration: Motion.base, curve: Motion.enter);
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    _position.stop();
    var next = _position.value - details.delta.dx / _step;
    // Resist past either end.
    if (next < 0 || next > _last) next = _position.value - details.delta.dx / _step / 3;
    _position.value = next.clamp(-0.25, _last + 0.25);
  }

  /// A flick, or a drag of more than a sixth of a card, moves one project
  /// in that direction; anything less settles back.
  void _dragEnd(DragEndDetails details) {
    final v = details.primaryVelocity ?? 0;
    final moved = _position.value - _restFor(_index);
    if (v < -300 || moved > 1 / 6) {
      _go(_index + 1);
    } else if (v > 300 || moved < -1 / 6) {
      _go(_index - 1);
    } else {
      _go(_index);
    }
  }

  void _tapCard(int i) {
    if (i < _index) {
      _go(i);
    } else if (i >= _index + _visible) {
      _go(i - _visible + 1);
    } else {
      widget.onOpen(widget.projects[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = siteGutter(context);
    final content = math.min(siteContentMax, width - 2 * gutter);
    final count = widget.projects.length;
    _visible = math.min(count, content >= 900 ? 3 : (content >= 560 ? 2 : 1));
    final peek = _visible > 1;

    // With a preview the row runs from the column's left edge to the
    // window's right edge; without one it spans the window and cards sit
    // inside the gutters. Where the window's margin is too narrow to show
    // a useful slice of the next card, the cards narrow to make room.
    final margin = (width - content) / 2;
    final trackLeft = peek ? margin : 0.0;
    final leading = peek ? 0.0 : gutter;
    final gap = peek ? Space.lg : 2 * gutter;
    _reserve = peek ? math.max(0.0, 96 - (margin - gap)) : 0.0;
    final cardWidth = (content - gap * (_visible - 1) - _reserve) / _visible;
    _step = cardWidth + gap;

    // A resize can leave the row past its new end.
    if (_index > _last) WidgetsBinding.instance.addPostFrameCallback((_) => _go(_last));

    final lastInView = math.min(_index + _visible, count);
    final counter = Text(
      _visible > 1
          ? '${_pad(_index + 1)}–${_pad(lastInView)} / ${_pad(count)}'
          : '${_pad(_index + 1)} / ${_pad(count)}',
      style: AppType.theme.titleMedium?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      semanticsLabel: _visible > 1
          ? 'Projects ${_index + 1} to $lastInView of $count'
          : 'Project ${_index + 1} of $count',
    );
    final arrows = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoundButton(
          icon: LucideIcons.arrowLeft,
          label: 'Previous project',
          onPressed: _index > 0 ? () => _go(_index - 1) : null,
        ),
        const SizedBox(width: Space.sm),
        RoundButton(
          icon: LucideIcons.arrowRight,
          label: 'Next project',
          onPressed: _index < _last ? () => _go(_index + 1) : null,
        ),
      ],
    );

    Widget inColumn(Widget child) => Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: child,
        );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _go(_index - 1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _go(_index + 1),
      },
      child: Focus(
        focusNode: _focus,
        child: Listener(
          onPointerDown: (_) {
            if (!_focus.hasFocus) _focus.requestFocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inColumn(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.eyebrow, style: AppType.eyebrow(Palette.n500)),
                          const SizedBox(height: Space.sm),
                          Text(
                            widget.title,
                            style: AppType.theme.headlineLarge?.copyWith(
                              fontSize: AppType.fluid(context, min: 26, max: 34),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (peek) Row(children: [counter, const SizedBox(width: Space.lg), arrows]),
                  ],
                ),
              ),
              SizedBox(height: peek ? Space.xl : Space.lg),

              // The row of cards: as tall as its tallest card, as wide as the
              // window allows, sliding under a clip.
              Padding(
                padding: EdgeInsets.only(left: trackLeft),
                child: Semantics(
                  label: widget.title,
                  child: GestureDetector(
                    // Count the touch slop as part of the drag, so the cards
                    // follow the finger from where it went down.
                    dragStartBehavior: DragStartBehavior.down,
                    onHorizontalDragUpdate: _dragUpdate,
                    onHorizontalDragEnd: _dragEnd,
                    onHorizontalDragCancel: () => _go(_index),
                    child: UnconstrainedBox(
                      constrainedAxis: Axis.vertical,
                      alignment: Alignment.topLeft,
                      clipBehavior: Clip.hardEdge,
                      child: AnimatedBuilder(
                        animation: _position,
                        builder: (context, row) => Transform.translate(
                          offset: Offset(leading - _position.value * _step, 0),
                          child: row,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < count; i++)
                              Padding(
                                padding: EdgeInsets.only(right: i < count - 1 ? gap : 0),
                                child: SizedBox(
                                  width: cardWidth,
                                  child: _ProjectCard(
                                    project: widget.projects[i],
                                    index: i,
                                    position: _position,
                                    visible: _visible,
                                    inView: i >= _index && i < _index + _visible,
                                    onTap: () => _tapCard(i),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: peek ? Space.xl : Space.lg),
              inColumn(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Progress(start: _index / count, end: lastInView / count),
                    if (!peek) ...[
                      const SizedBox(height: Space.md),
                      Row(children: [counter, const Spacer(), arrows]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}

/// One project: photograph, number, title, client, location and period or
/// status. Cards outside
/// the view fade as they slide away.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.index,
    required this.position,
    required this.visible,
    required this.inView,
    required this.onTap,
  });

  final PortfolioProject project;
  final int index;
  final Animation<double> position;
  final int visible;
  final bool inView;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final card = Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: inView ? 'Open project: ${project.title}' : 'Show project: ${project.title}',
      builder: (hovered) {
        final active = hovered && inView;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.md),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ProjectPhoto(project.cover, zoom: active ? 1.04 : 1.0),
              ),
            ),
            const SizedBox(height: Space.md),
            Text(
              (index + 1).toString().padLeft(2, '0'),
              style: AppType.theme.labelMedium?.copyWith(
                color: Palette.n500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: Space.xs),
            Text(
              project.title,
              style: AppType.theme.titleLarge?.copyWith(
                decoration: active ? TextDecoration.underline : null,
                decorationColor: Palette.ink,
              ),
            ),
            const SizedBox(height: Space.sm),
            if (project.clientLogo case final logo?) ...[
              ClientLogoImage(logo),
              const SizedBox(height: Space.xs),
            ],
            if (project.client case final client?)
              Text(client, style: AppType.theme.bodySmall?.copyWith(color: Palette.n600)),
            if (project.location case final location?)
              Text(location, style: AppType.theme.bodySmall),
            if (project.timing case final timing?) Text(timing, style: AppType.theme.bodySmall),
          ],
        );
      },
    );

    // Fade by distance from the cards in view.
    return AnimatedBuilder(
      animation: position,
      builder: (context, child) {
        final p = position.value;
        final away = index < p ? p - index : index - (p + visible - 1);
        return Opacity(opacity: 1 - 0.5 * away.clamp(0.0, 1.0), child: child);
      },
      child: card,
    );
  }
}

/// Thin line marking which part of the portfolio is in view.
class _Progress extends StatelessWidget {
  const _Progress({required this.start, required this.end});

  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    final duration = Motion.reduced(context) ? Duration.zero : Motion.base;
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, box) => SizedBox(
          height: 2,
          child: Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: Palette.n200)),
              AnimatedPositioned(
                duration: duration,
                curve: Motion.enter,
                left: box.maxWidth * start,
                width: box.maxWidth * (end - start),
                top: 0,
                bottom: 0,
                child: const ColoredBox(color: Palette.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
