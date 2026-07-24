import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import 'app_card.dart';
import 'reveal_on_scroll.dart';

/// Standard section shell: background, fixed vertical rhythm, centred
/// max-width column. Every section on every page uses this — that's what
/// creates the cross-page consistency the site currently lacks.
class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.child,
    this.background = Palette.n0,
    this.maxWidth = Space.contentMax,
    this.reveal = true,
    this.topRule,
  });

  final Widget child;
  final Color background;
  final double maxWidth;
  final bool reveal;

  /// Optional 3px accent rule across the top — used to differentiate
  /// business-unit detail pages while staying in-system.
  final Color? topRule;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    Widget content = Container(
      width: double.infinity,
      color: background,
      padding: Space.sectionPad(isMobile),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );

    if (reveal) content = RevealOnScroll(child: content);

    if (topRule != null) {
      return Column(
        children: [
          Container(height: 3, width: double.infinity, color: topRule),
          content,
        ],
      );
    }
    return content;
  }
}

/// Eyebrow + title + subtitle, set identically everywhere.
///
/// Pass the page's existing strings straight through — this component changes
/// only how they are set, never what they say.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.align = TextAlign.center,
    this.accent = Palette.primary,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;
  final TextAlign align;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final centred = align == TextAlign.center;

    return Column(
      crossAxisAlignment:
          centred ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Eyebrow(eyebrow!, color: accent),
          const SizedBox(height: Space.md),
        ],
        Text(
          title,
          textAlign: align,
          style: isMobile ? text.headlineLarge : text.displaySmall,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: Space.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.proseMax),
            child: Text(
              subtitle!,
              textAlign: align,
              style: text.bodyLarge,
            ),
          ),
        ],
      ],
    );
  }
}