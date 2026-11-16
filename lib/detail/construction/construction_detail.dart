import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import '../../widgets/logo_marquee.dart';
import 'construction_projects.dart';
import '../portfolio/project_carousel.dart';
import '../portfolio/project_widgets.dart';
import '../unit_intro.dart';

/// Construction & Facility Management: introduction, a carousel of every
/// construction project, then facility management and NyumbaSmart.
class ConstructionDetail extends StatelessWidget {
  const ConstructionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Column(
              padding: EdgeInsets.only(
                top: isMobile ? Space.xl : Space.xxl,
                bottom: isMobile ? Space.xxl : Space.xxxl,
              ),
              child: const UnitIntro(
                title: 'Construction & Facility Management',
                description:
                    'Specialised construction, renovation and facility management services, delivered '
                    'with attention to quality, functionality and detail.',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
              child: ProjectCarousel(
                title: constructionPortfolio.projectsTitle,
                projects: constructionProjects,
                onOpen: (project) =>
                    Navigator.pushNamed(context, project.route, arguments: fromPortfolio),
              ),
            ),
            const _Partners(),
            const _FacilityManagement(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

/// Centres [child] in the shared content column.
class _Column extends StatelessWidget {
  const _Column({required this.child, this.padding = EdgeInsets.zero, this.color});

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
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

/// Firms worked with on construction projects, as a slowly scrolling strip
/// of their logos (still, for visitors who reduce motion).
class _Partners extends StatelessWidget {
  const _Partners();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return _Column(
      padding: EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
      child: Container(
        padding: EdgeInsets.only(top: isMobile ? Space.xl : Space.xxl),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PARTNERS', style: AppType.eyebrow(Palette.n500)),
            const SizedBox(height: Space.sm),
            Text(
              'Construction Partners',
              style: AppType.theme.headlineLarge?.copyWith(
                fontSize: AppType.fluid(context, min: 26, max: 34),
              ),
            ),
            const SizedBox(height: Space.md),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Space.proseMax),
              child: Text(
                'Specialist firms we have worked with on our construction projects.',
                style: AppType.theme.bodyLarge,
              ),
            ),
            SizedBox(height: isMobile ? Space.lg : Space.xl),
            // Read out as one list: the logos themselves carry no text.
            Semantics(
              container: true,
              label: 'Construction partners: ${[
                for (final p in constructionPartners) p.name
              ].join(', ')}',
              child: ExcludeSemantics(
                child: LogoMarquee(
                  assetPaths: [
                    for (final p in constructionPartners)
                      if (p.logo case final logo?) logo,
                  ],
                  logoHeight: isMobile ? 40 : 52,
                  gap: isMobile ? 48 : 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Facility management, with NyumbaSmart as the platform behind it.
class _FacilityManagement extends StatelessWidget {
  const _FacilityManagement();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final wide = width >= 960;

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SERVICES', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.sm),
        Text(
          'Facility Management',
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 34),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(
          'Facility management involves coordinating building operations, maintenance, '
          'infrastructure and supporting services to help facilities operate efficiently and '
          'reliably.',
          style: AppType.theme.bodyLarge,
        ),
        const SizedBox(height: Space.md),
        Text(
          'Our approach integrates NyumbaSmart, the Computerized Maintenance Management System '
          '(CMMS) developed by our IT Division, to streamline these processes.',
          style: AppType.theme.bodyMedium,
        ),
      ],
    );

    return _Column(
      color: Palette.n50,
      padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: intro),
                const SizedBox(width: Space.xxl),
                const Expanded(flex: 6, child: _NyumbaSmartPanel()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, const SizedBox(height: Space.xl), const _NyumbaSmartPanel()],
            ),
    );
  }
}

class _NyumbaSmartPanel extends StatelessWidget {
  const _NyumbaSmartPanel();

  static const _uses = [
    'Maintenance management',
    'Work orders',
    'Asset tracking',
    'Maintenance scheduling'
  ];

  @override
  Widget build(BuildContext context) {
    void open() => Navigator.pushNamed(context, '/cmms');

    return Hoverable(
      onTap: open,
      scale: 1.0,
      lift: -2,
      semanticLabel: 'NyumbaSmart – Computerized Maintenance Management System (CMMS)',
      builder: (hovered) => AnimatedContainer(
        duration: Motion.fast,
        decoration: BoxDecoration(
          color: Palette.n0,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: hovered ? Palette.n300 : Palette.n200),
          boxShadow: hovered ? Elevation.card : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // A real NyumbaSmart screen: the maintenance task board.
            AspectRatio(
              aspectRatio: 1915 / 891,
              child: ProjectPhoto(
                const ProjectImage('assets/apk/nyumbasmart.jpg'),
                zoom: hovered ? 1.02 : 1.0,
              ),
            ),
            Container(height: 1, color: Palette.n200),
            Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PLATFORM', style: AppType.eyebrow(Palette.construction)),
                  const SizedBox(height: Space.sm),
                  Text('NyumbaSmart', style: AppType.theme.headlineMedium),
                  const SizedBox(height: Space.xxs),
                  Text(
                    'Computerized Maintenance Management System (CMMS)',
                    style: AppType.theme.titleMedium?.copyWith(color: Palette.n600),
                  ),
                  const SizedBox(height: Space.md),
                  Text(
                    'A digital platform designed to support maintenance management, work orders, '
                    'asset tracking and maintenance scheduling.',
                    style: AppType.theme.bodyMedium,
                  ),
                  const SizedBox(height: Space.md),
                  Wrap(
                    spacing: Space.xs,
                    runSpacing: Space.xs,
                    children: [
                      for (final use in _uses)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Palette.n200),
                            borderRadius: BorderRadius.circular(Radii.pill),
                          ),
                          child: Text(use,
                              style: AppType.theme.labelMedium?.copyWith(color: Palette.n600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: Space.lg),
                  ArrowLink(label: 'Explore NyumbaSmart', onTap: open),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
