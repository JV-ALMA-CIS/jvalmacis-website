import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import 'portfolio_project.dart';
import 'project_widgets.dart';

/// One project of a portfolio: title, its details (client, funder,
/// location, period or status), lead photograph, overview, every photograph
/// (when there is more than one) and the testimonial when there is one.
class PortfolioProjectPage extends StatelessWidget {
  const PortfolioProjectPage({super.key, required this.portfolio, required this.project});

  final Portfolio portfolio;
  final PortfolioProject project;

  /// Back to the portfolio: the carousel underneath when the visitor came
  /// from it (keeping its position), otherwise a fresh unit page.
  static void backToPortfolio(BuildContext context, Portfolio portfolio) {
    final fromCarousel = ModalRoute.of(context)?.settings.arguments == fromPortfolio;
    if (fromCarousel && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, portfolio.route);
    }
  }

  void _view(BuildContext context, int index) => showProjectImageViewer(
        context,
        images: project.images,
        initial: index,
        title: project.title,
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final sectionGap = isMobile ? Space.xxl : Space.xxxl;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Column(
              padding: EdgeInsets.only(top: isMobile ? Space.xl : Space.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Breadcrumb(portfolio: portfolio, project: project),
                  SizedBox(height: isMobile ? Space.xl : Space.xxl),
                  Text(
                    '${portfolio.unit.toUpperCase()} PROJECT',
                    style: AppType.eyebrow(Palette.n500),
                  ),
                  const SizedBox(height: Space.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Text(
                      project.title,
                      style: AppType.theme.displayMedium?.copyWith(
                        fontSize: AppType.fluid(context, min: 30, max: 46),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.lg),
                  ProjectMeta(project: project),
                  SizedBox(height: isMobile ? Space.xl : Space.xxl),
                  _LeadPhoto(
                    image: project.cover,
                    aspectRatio: project.cover.isLogo ? 21 / 9 : (isMobile ? 4 / 3 : 16 / 9),
                    onTap: () => _view(context, project.coverIndex),
                  ),
                  if (project.cover.caption case final caption?) ...[
                    const SizedBox(height: Space.sm),
                    Text(caption, style: AppType.theme.bodySmall),
                  ],
                  SizedBox(height: sectionGap),
                  _Block(title: 'Overview', child: _Overview(project)),
                  if (project.images.length > 1) ...[
                    SizedBox(height: sectionGap),
                    _Block(
                      title: 'Photographs',
                      child: _Gallery(
                        project: project,
                        onTap: (i) => _view(context, i),
                      ),
                    ),
                  ],
                  if (project.testimonial case final testimonial?) ...[
                    SizedBox(height: sectionGap),
                    _Block(title: 'Testimonial', child: _Quote(testimonial)),
                  ],
                  SizedBox(height: sectionGap),
                  _ProjectNav(portfolio: portfolio, project: project),
                  SizedBox(height: isMobile ? Space.xxxl : Space.section),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

/// Centres [child] in the shared content column.
class _Column extends StatelessWidget {
  const _Column({required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Palette.n0,
      padding: padding.add(EdgeInsets.symmetric(horizontal: siteGutter(context))),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: siteContentMax),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.portfolio, required this.project});

  final Portfolio portfolio;
  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final muted = AppType.theme.labelLarge?.copyWith(color: Palette.n500, height: 1.4);
    return Semantics(
      container: true,
      label: 'Breadcrumb',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Space.xs,
        runSpacing: Space.xxs,
        children: [
          ArrowLink(
            label: portfolio.projectsTitle,
            back: true,
            onTap: () => PortfolioProjectPage.backToPortfolio(context, portfolio),
          ),
          if (MediaQuery.sizeOf(context).width >= 600) ...[
            const Icon(LucideIcons.chevronRight, size: 14, color: Palette.n400),
            Text(_shortTitle(project.title), style: muted),
          ],
        ],
      ),
    );
  }

  /// "Portuguese Embassy Renov, Nairobi." → "Portuguese Embassy Renov".
  static String _shortTitle(String title) => title.split(',').first;
}

/// Section with its heading beside the content on wide screens and above
/// it on narrow ones, separated from the previous one by a hairline.
class _Block extends StatelessWidget {
  const _Block({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final heading = Text(title, style: AppType.theme.headlineSmall);
    return Container(
      padding: const EdgeInsets.only(top: Space.lg),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 280, child: heading),
                Expanded(child: child),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: Space.md), child],
            ),
    );
  }
}

class _LeadPhoto extends StatelessWidget {
  const _LeadPhoto({required this.image, required this.aspectRatio, required this.onTap});

  final ProjectImage image;
  final double aspectRatio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: 'Enlarge photograph',
      builder: (hovered) => ClipRRect(
        borderRadius: BorderRadius.circular(Radii.md),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProjectPhoto(image, zoom: hovered ? 1.02 : 1.0),
              Positioned(right: Space.md, bottom: Space.md, child: _EnlargeHint(visible: hovered)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnlargeHint extends StatelessWidget {
  const _EnlargeHint({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: Motion.fast,
      child: Container(
        padding: const EdgeInsets.all(Space.xs),
        decoration: BoxDecoration(
          color: Palette.ink.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        child: const Icon(LucideIcons.maximize2, size: 16, color: Palette.n0),
      ),
    );
  }
}

/// Two photographs side by side; three or more in a grid.
class _Gallery extends StatelessWidget {
  const _Gallery({required this.project, required this.onTap});

  final PortfolioProject project;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final images = project.images;
    final width = MediaQuery.sizeOf(context).width;
    final columns = images.length == 2 ? 2 : (width >= 600 ? 3 : 1);
    return LayoutBuilder(
      builder: (context, box) {
        const gap = Space.md;
        final tile = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < images.length; i++)
              SizedBox(
                width: math.max(0, tile),
                child: Hoverable(
                  onTap: () => onTap(i),
                  scale: 1.0,
                  lift: 0,
                  semanticLabel: 'Enlarge photograph ${i + 1} of ${images.length}',
                  builder: (hovered) => _Captioned(
                    caption: images[i].caption,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Radii.sm),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ProjectPhoto(images[i], zoom: hovered ? 1.03 : 1.0),
                            Positioned(
                              right: Space.sm,
                              bottom: Space.sm,
                              child: _EnlargeHint(visible: hovered),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A gallery image with its caption underneath, when it has one.
class _Captioned extends StatelessWidget {
  const _Captioned({required this.caption, required this.child});

  final String? caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = caption;
    if (text == null) return child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        const SizedBox(height: Space.xs),
        Text(text, style: AppType.theme.bodySmall),
      ],
    );
  }
}

/// The description's paragraphs, then any numbered focus areas and a
/// closing paragraph.
class _Overview extends StatelessWidget {
  const _Overview(this.project);

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final body = AppType.theme.bodyLarge;
    final paragraphs = project.description.split(RegExp(r'\n\s*\n'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) const SizedBox(height: Space.md),
          Text(paragraphs[i].trim(), style: body),
        ],
        for (final (i, area) in project.focusAreas.indexed) ...[
          const SizedBox(height: Space.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  '${i + 1}.',
                  style: body?.copyWith(color: Palette.ink, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: body,
                    children: [
                      TextSpan(
                        text: '${area.title}: ',
                        style: const TextStyle(color: Palette.ink, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: area.text),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
        if (project.closing case final closing?) ...[
          const SizedBox(height: Space.md),
          Text(closing, style: body),
        ],
      ],
    );
  }
}

class _Quote extends StatelessWidget {
  const _Quote(this.testimonial);

  final ProjectTestimonial testimonial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: Space.lg),
      decoration:
          const BoxDecoration(border: Border(left: BorderSide(color: Palette.ink, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“${testimonial.quote}”',
            style: AppType.theme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Palette.ink,
            ),
          ),
          const SizedBox(height: Space.md),
          Text('— ${testimonial.attribution}', style: AppType.theme.bodyMedium),
        ],
      ),
    );
  }
}

/// Back to the portfolio, and on to the next project.
class _ProjectNav extends StatelessWidget {
  const _ProjectNav({required this.portfolio, required this.project});

  final Portfolio portfolio;
  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final projects = portfolio.projects;
    final i = projects.indexWhere((p) => p.slug == project.slug);
    final next = projects[(i + 1) % projects.length];
    final args = ModalRoute.of(context)?.settings.arguments;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: Space.lg),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: Space.xl,
        runSpacing: Space.lg,
        children: [
          ArrowLink(
            label: 'All ${portfolio.projectsTitle.toLowerCase()}',
            back: true,
            onTap: () => PortfolioProjectPage.backToPortfolio(context, portfolio),
          ),
          if (next.slug != project.slug)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NEXT PROJECT', style: AppType.eyebrow(Palette.n500)),
                  const SizedBox(height: Space.xs),
                  ArrowLink(
                    label: next.title,
                    // Replace, so "back" still leads to the portfolio.
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, next.route, arguments: args),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
