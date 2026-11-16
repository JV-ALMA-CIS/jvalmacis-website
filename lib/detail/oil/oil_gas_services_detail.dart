import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/cms_image.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import '../../widgets/legal_document.dart';
import '../portfolio/portfolio_project.dart';
import '../portfolio/project_widgets.dart';
import 'oil_gas_content.dart';
import '../unit_intro.dart';

/// Oil & Gas Services: introduction, the services, the partnership with
/// Brisma Africa and TIC East Africa, and the TIC Group behind it.
class OilAndGasServicesDetail extends StatelessWidget {
  const OilAndGasServicesDetail({super.key});

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
              child: const UnitIntro(title: 'Oil & Gas Services', description: oilGasIntro),
            ),
            _Column(
              padding: EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
              child: const _Services(),
            ),
            _Column(
              color: Palette.n50,
              padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
              child: const _Partnership(),
            ),
            _Column(
              padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
              child: const _TicGroup(),
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
  const _Column({required this.child, this.padding = EdgeInsets.zero, this.color});

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color ?? Palette.n0,
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

/// A heading announced as such to screen readers.
Widget _heading(String text, TextStyle? style) =>
    Semantics(header: true, child: Text(text, style: style));

/// Eyebrow, title and optional introduction for a section.
class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.eyebrow, required this.title, this.intro});

  final String eyebrow;
  final String title;
  final String? intro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.sm),
        _heading(
          title,
          AppType.theme.headlineLarge?.copyWith(fontSize: AppType.fluid(context, min: 26, max: 34)),
        ),
        if (intro case final text?) ...[
          const SizedBox(height: Space.md),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.proseMax),
            child: Text(text, style: AppType.theme.bodyLarge),
          ),
        ],
      ],
    );
  }
}

/// A photograph that opens enlarged; logos and diagrams are shown whole.
class _Photo extends StatelessWidget {
  const _Photo({required this.image, required this.aspectRatio, this.gallery});

  final ProjectImage image;
  final double aspectRatio;

  /// The images the viewer can step through; just this one by default.
  final List<ProjectImage>? gallery;

  @override
  Widget build(BuildContext context) {
    final images = gallery ?? [image];
    return Hoverable(
      onTap: () => showProjectImageViewer(
        context,
        images: images,
        initial: images.indexOf(image),
        title: 'Oil & Gas Services',
      ),
      scale: 1.0,
      lift: 0,
      semanticLabel: 'Enlarge image: ${image.caption ?? ''}',
      builder: (hovered) => ClipRRect(
        borderRadius: BorderRadius.circular(Radii.md),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ProjectPhoto(image, zoom: hovered ? 1.03 : 1.0),
        ),
      ),
    );
  }
}

/// One numbered row per service: photograph beside the description on wide
/// screens (sides alternating), above it on narrow ones.
class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(eyebrow: 'SERVICES', title: 'Inspection and Regulatory Compliance'),
        const SizedBox(height: Space.lg),
        for (final (i, service) in oilGasServices.indexed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: Space.xl),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
            child: _ServiceRow(service: service, number: i + 1, wide: wide, imageFirst: i.isEven),
          ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.number,
    required this.wide,
    required this.imageFirst,
  });

  final OilGasService service;
  final int number;
  final bool wide;
  final bool imageFirst;

  @override
  Widget build(BuildContext context) {
    final photo = _Photo(image: service.image, aspectRatio: 4 / 3);
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number.toString().padLeft(2, '0'),
          style: AppType.theme.labelMedium?.copyWith(
            color: Palette.n500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: Space.xs),
        _heading(service.title, AppType.theme.headlineMedium),
        for (final paragraph in service.paragraphs) ...[
          const SizedBox(height: Space.md),
          Text(paragraph, style: AppType.theme.bodyMedium),
        ],
      ],
    );
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [photo, const SizedBox(height: Space.lg), text],
      );
    }
    final children = imageFirst
        ? [
            Expanded(flex: 5, child: photo),
            const SizedBox(width: Space.xxl),
            Expanded(flex: 4, child: text)
          ]
        : [
            Expanded(flex: 4, child: text),
            const SizedBox(width: Space.xxl),
            Expanded(flex: 5, child: photo)
          ];
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }
}

/// The partnership, with TIC East Africa's contact details.
class _Partnership extends StatelessWidget {
  const _Partnership();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(
          eyebrow: 'PARTNERSHIP',
          title: 'Working with Brisma Africa and TIC Group',
        ),
        for (final paragraph in oilGasPartnership) ...[
          const SizedBox(height: Space.md),
          Text(paragraph, style: AppType.theme.bodyLarge),
        ],
        const SizedBox(height: Space.xl),
        const _CompanyCard(company: ticGroup, logo: ticGroupLogo),
      ],
    );
    const photo = _Photo(image: oilGasPartnershipImage, aspectRatio: 4 / 3);
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [text, const SizedBox(height: Space.xl), photo],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: text),
        const SizedBox(width: Space.xxl),
        const Expanded(flex: 4, child: photo),
      ],
    );
  }
}

/// A company's name, origin and published contact details.
class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.company, this.logo});

  final TicCompany company;
  final String? logo;

  @override
  Widget build(BuildContext context) {
    final detail = AppType.theme.bodySmall?.copyWith(color: Palette.n600);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: Space.md),
      decoration:
          const BoxDecoration(border: Border(top: BorderSide(color: Palette.ink, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (logo case final path?) ...[
            Semantics(
              image: true,
              label: '${company.name} logo',
              child: SizedBox(
                height: 48,
                child: CmsImage(
                  source: path,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(height: Space.sm),
          ],
          Text(company.name, style: AppType.theme.titleLarge),
          Text(company.origin, style: AppType.theme.bodyMedium?.copyWith(color: Palette.n500)),
          const SizedBox(height: Space.xs),
          if (company.address case final address?) Text(address, style: detail),
          if (company.phone case final phone?) Text(phone, style: detail),
          if (company.email case final email?)
            LinkedText(email, style: detail ?? const TextStyle()),
        ],
      ),
    );
  }
}

/// The TIC Group: its certifications and references (labelled as the group's own).
class _TicGroup extends StatelessWidget {
  const _TicGroup();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(
          eyebrow: 'TIC GROUP',
          title: 'Certifications and References',
          intro:
              'The TIC Group is a global network of independent companies providing inspection, testing, certification and verification services. TIC Group companies are accredited by national and international bodies to provide these services in accordance with the highest standards.',
        ),
        const SizedBox(height: Space.xxl),
        Text('TIC GROUP CERTIFICATIONS AND REFERENCES', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.md),
        LayoutBuilder(
          builder: (context, box) {
            final two = box.maxWidth >= 600;
            const gap = Space.lg;
            final cell = two ? (box.maxWidth - gap) / 2 : box.maxWidth;
            return Wrap(
              spacing: gap,
              runSpacing: Space.lg,
              children: [
                for (final image in ticGroupCredentials)
                  SizedBox(
                    width: cell,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Photo(image: image, aspectRatio: 4 / 3, gallery: ticGroupCredentials),
                        const SizedBox(height: Space.xs),
                        Text(image.caption!, style: AppType.theme.bodySmall),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
