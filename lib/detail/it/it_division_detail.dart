import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import '../portfolio/project_widgets.dart';
import '../../pages/certificates_page.dart' show CertificateDocument, certificateSections;
import '../../widgets/cms_image.dart';
import '../portfolio/portfolio_project.dart' show ProjectImage, fromPortfolio;
import 'it_products.dart';
import 'product_visual.dart';
import '../unit_intro.dart';

/// IT Division: introduction, the six platforms in three solution areas,
/// the development approach, and a contact call to action.
class ITDivisionDetail extends StatelessWidget {
  const ITDivisionDetail({super.key});

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
                title: 'IT Division',
                description:
                    'We design and develop digital platforms that support operations across '
                    'construction, facility management, agriculture and workforce management — '
                    'connecting people, processes and operational information.',
              ),
            ),
            _Column(
              padding: EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
              child: const _Platforms(),
            ),
            _Column(
              color: Palette.n50,
              padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
              child: const _Approach(),
            ),
            _Column(
              padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
              child: const _ClosingCta(),
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

/// The three solution areas, each laid out for its number of products.
class _Platforms extends StatelessWidget {
  const _Platforms();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(
          'Our Digital Platforms',
          AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 34),
          ),
        ),
        for (final (i, area) in solutionAreas.indexed) ...[
          SizedBox(height: isMobile ? Space.xxl : Space.xxxl),
          _Area(area: area, number: i + 1),
        ],
      ],
    );
  }
}

class _Area extends StatelessWidget {
  const _Area({required this.area, required this.number});

  final SolutionArea area;
  final int number;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final twoColumns = width >= 760;
    final products = area.products;

    Widget pair(List<SoftwareProduct> items) => twoColumns
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: Space.xxl),
                Expanded(child: _StackedProduct(product: items[i])),
              ],
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.xxl),
                _StackedProduct(product: items[i]),
              ],
            ],
          );

    final body = switch (products.length) {
      1 => _WideProduct(product: products.first),
      2 => pair(products),
      _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WideProduct(product: products.first),
            const SizedBox(height: Space.xxl),
            pair(products.sublist(1)),
          ],
        ),
    };

    return Container(
      padding: const EdgeInsets.only(top: Space.lg),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${number.toString().padLeft(2, '0')}  ${area.category.toUpperCase()}',
            style: AppType.eyebrow(Palette.n500),
          ),
          const SizedBox(height: Space.sm),
          _heading(area.heading, AppType.theme.headlineMedium),
          const SizedBox(height: Space.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.proseMax),
            child: Text(area.intro, style: AppType.theme.bodyMedium),
          ),
          SizedBox(height: width < 600 ? Space.xl : Space.xxl),
          body,
        ],
      ),
    );
  }
}

/// A product's visual, clickable through to its page.
class _Visual extends StatelessWidget {
  const _Visual({required this.product, required this.aspectRatio});

  final SoftwareProduct product;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => Navigator.pushNamed(context, product.route, arguments: fromPortfolio),
      scale: 1.0,
      lift: 0,
      semanticLabel: 'Explore ${product.name}',
      builder: (hovered) => ProductVisual(
        product: product,
        aspectRatio: aspectRatio,
        zoom: hovered ? 1.02 : 1.0,
      ),
    );
  }
}

/// Name, category, description, capabilities and the link to the product.
class _ProductText extends StatelessWidget {
  const _ProductText({required this.product});

  final SoftwareProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(product.name, AppType.theme.headlineMedium),
        const SizedBox(height: Space.xxs),
        Text(
          product.subtitle,
          style: AppType.theme.titleMedium?.copyWith(color: Palette.n600),
        ),
        const SizedBox(height: Space.md),
        Text(product.description, style: AppType.theme.bodyMedium),
        const SizedBox(height: Space.md),
        for (final capability in product.capabilities)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9, right: Space.sm),
                  child: Container(width: 5, height: 5, color: Palette.n400),
                ),
                Expanded(child: Text(capability, style: AppType.theme.bodyMedium)),
              ],
            ),
          ),
        if (_copyrightCertificate(product.name) case final certificate?) ...[
          const SizedBox(height: Space.sm),
          _CertificateLink(product: product, certificate: certificate),
        ],
        const SizedBox(height: Space.md),
        ArrowLink(
          label: 'Explore ${product.name}',
          onTap: () => Navigator.pushNamed(context, product.route, arguments: fromPortfolio),
        ),
      ],
    );
  }
}

/// The product's copyright registration certificate, from the Certificates
/// page's library (documents there are titled with the product's name).
CertificateDocument? _copyrightCertificate(String productName) {
  for (final section in certificateSections) {
    for (final doc in section.documents) {
      if (doc.title == productName && (doc.label ?? '').startsWith('Copyright')) return doc;
    }
  }
  return null;
}

/// A small preview of the product's copyright certificate; opens it enlarged.
class _CertificateLink extends StatelessWidget {
  const _CertificateLink({required this.product, required this.certificate});

  final SoftwareProduct product;
  final CertificateDocument certificate;

  @override
  Widget build(BuildContext context) {
    final caption = '${product.name} copyright registration certificate';
    return Hoverable(
      onTap: () => showProjectImageViewer(
        context,
        images: [ProjectImage(certificate.asset, caption: caption, isLogo: true)],
        initial: 0,
        title: caption,
      ),
      scale: 1.0,
      lift: 0,
      semanticLabel: 'View the $caption',
      builder: (hovered) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 52,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Palette.n0,
              borderRadius: BorderRadius.circular(Radii.sm / 2),
              border: Border.all(color: hovered ? Palette.n400 : Palette.n200),
            ),
            child: ExcludeSemantics(
              child: CmsImage(
                source: certificate.asset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(width: Space.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COPYRIGHT REGISTERED', style: AppType.eyebrow(Palette.n500)),
                const SizedBox(height: Space.xxs),
                Text(
                  'View certificate',
                  style: AppType.theme.labelLarge?.copyWith(
                    color: Palette.primary,
                    height: 1.4,
                    decoration: hovered ? TextDecoration.underline : null,
                    decorationColor: Palette.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A product given the full width: visual beside the text on wide screens,
/// above it on narrow ones.
class _WideProduct extends StatelessWidget {
  const _WideProduct({required this.product});

  final SoftwareProduct product;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    final visual = _Visual(product: product, aspectRatio: 16 / 9);
    final text = _ProductText(product: product);
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [visual, const SizedBox(height: Space.lg), text],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 7, child: visual),
        const SizedBox(width: Space.xxl),
        Expanded(flex: 4, child: text),
      ],
    );
  }
}

/// A product in a column: visual above the text.
class _StackedProduct extends StatelessWidget {
  const _StackedProduct({required this.product});

  final SoftwareProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Matches the prepared illustrations' proportions, so a column pair
        // lines up whether or not each product has one.
        _Visual(product: product, aspectRatio: 571 / 355),
        const SizedBox(height: Space.lg),
        _ProductText(product: product),
      ],
    );
  }
}

/// How the division develops software: four columns on desktop, two on
/// tablets, one sequence on phones.
class _Approach extends StatelessWidget {
  const _Approach();

  static const _steps = [
    ('Understand', 'Identify operational needs and user requirements.'),
    ('Design', 'Translate requirements into practical solutions.'),
    ('Develop', 'Build and deliver functional digital platforms.'),
    ('Improve', 'Refine platforms as operational needs evolve.'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 960 ? 4 : (width >= 600 ? 2 : 1);

    Widget step(int i) {
      final (title, text) = _steps[i];
      return Container(
        padding: const EdgeInsets.only(top: Space.md),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n300))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (i + 1).toString().padLeft(2, '0'),
              style: AppType.theme.headlineLarge?.copyWith(
                color: Palette.n400,
                fontWeight: FontWeight.w400,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: Space.sm),
            Text(title, style: AppType.theme.titleLarge),
            const SizedBox(height: Space.xs),
            Text(text, style: AppType.theme.bodyMedium),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('OUR DEVELOPMENT APPROACH', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.sm),
        _heading(
          'Technology shaped around real operations.',
          AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 34),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Our approach to software development begins with understanding how people work. '
            'We translate operational needs into practical digital tools, developing and '
            'refining platforms that support real-world processes across the sectors we serve.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        SizedBox(height: width < 600 ? Space.xl : Space.xxl),
        LayoutBuilder(
          builder: (context, box) {
            const gap = Space.lg;
            final cell = (box.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: Space.xl,
              children: [
                for (var i = 0; i < _steps.length; i++) SizedBox(width: cell, child: step(i)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ClosingCta extends StatelessWidget {
  const _ClosingCta();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(
          'Have an operational challenge to solve?',
          AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 34),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(
          "Let's discuss how a digital platform can support your organisation.",
          style: AppType.theme.bodyLarge,
        ),
        const SizedBox(height: Space.lg),
        PrimaryButton(
          text: 'Contact JV ALMA C.I.S →',
          onPressed: () => Navigator.pushNamed(context, '/contact'),
        ),
      ],
    );
  }
}
