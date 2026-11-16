import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import '../portfolio/project_carousel.dart';
import '../portfolio/project_widgets.dart';
import 'agribusiness_content.dart';
import 'institution_list.dart';
import '../unit_intro.dart';

/// Agribusiness: introduction, a carousel of every project, the
/// institutions the division works with, and its digital platforms.
class AgribusinessDetail extends StatelessWidget {
  const AgribusinessDetail({super.key});

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
                title: 'Agribusiness',
                description:
                    'Agricultural infrastructure, technical services and digital solutions supporting '
                    'more informed and sustainable agricultural practices.',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
              child: ProjectCarousel(
                title: agribusinessPortfolio.projectsTitle,
                projects: agribusinessProjects,
                onOpen: (project) =>
                    Navigator.pushNamed(context, project.route, arguments: fromPortfolio),
              ),
            ),
            const _Institutions(),
            const _Technology(),
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

/// Eyebrow, title and a short introduction, shared by the page's sections.
class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.eyebrow, required this.title, required this.intro});

  final String eyebrow;
  final String title;
  final String intro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.sm),
        Text(
          title,
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 34),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(intro, style: AppType.theme.bodyLarge),
        ),
      ],
    );
  }
}

/// Research and academic institutions: their logos, what each agreement
/// covers and who signed it.
class _Institutions extends StatelessWidget {
  const _Institutions();

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
            const _SectionHead(
              eyebrow: 'INSTITUTIONS',
              title: 'Working with Institutions',
              intro: 'Our work is strengthened through collaboration with research institutions '
                  'and academic partners, bringing together technical expertise, research and '
                  'practical agricultural applications.',
            ),
            SizedBox(height: isMobile ? Space.xl : Space.xxl),
            InstitutionList(institutions: agribusinessInstitutions, wide: width >= 720),
          ],
        ),
      ),
    );
  }
}

/// Kilimo Mkononi and CoffeeCore: one row each, a phone screenshot beside
/// the platform's description and a link to its page.
class _Technology extends StatelessWidget {
  const _Technology();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return _Column(
      color: Palette.n50,
      padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHead(
            eyebrow: 'DIGITAL AGRICULTURE',
            title: 'Technology in Agriculture',
            intro: 'JV ALMA C.I.S leverages digital innovation to empower farmers with '
                'mobile-based tools for crop management, market access, and financial planning.',
          ),
          SizedBox(height: isMobile ? Space.xl : Space.xxl),
          for (final (i, platform) in agribusinessPlatforms.indexed)
            _PlatformRow(platform: platform, first: i == 0),
        ],
      ),
    );
  }
}

class _PlatformRow extends StatelessWidget {
  const _PlatformRow({required this.platform, required this.first});

  final DigitalPlatform platform;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 720;
    void open() => Navigator.pushNamed(context, platform.route);

    final path = platform.screenshot;
    final screenshot = path == null
        ? null
        : Hoverable(
            onTap: open,
            scale: 1.0,
            lift: -2,
            semanticLabel: 'Open ${platform.name}',
            builder: (hovered) => AnimatedContainer(
              duration: Motion.fast,
              width: wide ? 200 : 150,
              decoration: BoxDecoration(
                color: Palette.n0,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(color: hovered ? Palette.n300 : Palette.n200),
                boxShadow: hovered ? Elevation.card : null,
              ),
              padding: const EdgeInsets.all(Space.xs),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.md),
                child: AspectRatio(
                  aspectRatio: 576 / 1280,
                  child: ProjectPhoto(ProjectImage(path)),
                ),
              ),
            ),
          );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(platform.name, style: AppType.theme.headlineMedium),
        const SizedBox(height: Space.xxs),
        Text(platform.tagline, style: AppType.theme.titleMedium?.copyWith(color: Palette.n600)),
        const SizedBox(height: Space.md),
        Text(platform.description, style: AppType.theme.bodyMedium),
        for (final (name, description) in platform.editions) ...[
          const SizedBox(height: Space.md),
          Text(name, style: AppType.theme.titleMedium),
          const SizedBox(height: Space.xxs),
          Text(description, style: AppType.theme.bodyMedium),
        ],
        const SizedBox(height: Space.lg),
        ArrowLink(label: 'Explore ${platform.name}', onTap: open),
      ],
    );

    return Container(
      padding: EdgeInsets.only(top: first ? 0 : Space.xl, bottom: Space.xl),
      decoration:
          first ? null : const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
      child: screenshot == null
          ? text
          : wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [screenshot, const SizedBox(width: Space.xxl), Expanded(child: text)],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [screenshot, const SizedBox(height: Space.lg), text],
                ),
    );
  }
}
