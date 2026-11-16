import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/hoverable.dart';
import '../portfolio/project_widgets.dart';
import 'it_products.dart';
import 'product_visual.dart';
import '../portfolio/portfolio_project.dart';

/// The AlmaSafety product page.
class AlmaSafetyPage extends StatelessWidget {
  const AlmaSafetyPage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: almaSafetyPage);
}

/// The AlmaHub product page.
class AlmaHubPage extends StatelessWidget {
  const AlmaHubPage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: almaHubPage);
}

/// A product page: introduction, overview, screenshots, who it is for,
/// editions, user roles and functional areas, features, and a contact
/// action (with the app store link when the app is published). Sections
/// without content are left out.
class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.content});

  final ProductPageContent content;

  /// Back to the parent page: the one underneath when the visitor came from
  /// it, so history does not fill with copies; otherwise a fresh one.
  void _back(BuildContext context) {
    final fromParent = ModalRoute.of(context)?.settings.arguments == fromPortfolio;
    if (fromParent && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, content.parent.$2);
    }
  }

  Future<void> _openStore(BuildContext context, String url) async {
    final opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Play. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final product = content.product;
    final gap = isMobile ? Space.xxl : Space.xxxl;
    final store = content.storeLink;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Column(
              padding: EdgeInsets.only(
                top: isMobile ? Space.xl : Space.xxl,
                bottom: isMobile ? Space.xxxl : Space.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArrowLink(
                    label: content.parent.$1,
                    back: true,
                    onTap: () => _back(context),
                  ),
                  SizedBox(height: isMobile ? Space.xl : Space.xxl),
                  Text(content.eyebrow, style: AppType.eyebrow(Palette.n500)),
                  const SizedBox(height: Space.md),
                  Semantics(
                    header: true,
                    child: Text(
                      product.name,
                      style: AppType.theme.displayMedium?.copyWith(
                        fontSize: AppType.fluid(context, min: 34, max: 52),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    product.subtitle,
                    style: AppType.theme.titleLarge?.copyWith(color: Palette.n600),
                  ),
                  if (content.status case final status?) ...[
                    const SizedBox(height: Space.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.ink),
                        borderRadius: BorderRadius.circular(Radii.pill),
                      ),
                      child: Text(status.toUpperCase(), style: AppType.eyebrow(Palette.ink)),
                    ),
                  ],
                  if (content.tagline case final tagline?) ...[
                    const SizedBox(height: Space.xs),
                    Text(tagline, style: AppType.theme.bodyLarge?.copyWith(color: Palette.n500)),
                  ],
                  // The prepared illustrative visual (captioned as such), or the
                  // product's screenshot where the page asks for it.
                  if (product.visual case final visual?
                      when visual.kind == ScreenshotKind.illustration ||
                          content.showVisualInHeader) ...[
                    SizedBox(height: isMobile ? Space.xl : Space.xxl),
                    // Capped so the small prepared images are not blown up.
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: ProductVisual(
                        product: product,
                        aspectRatio: visual.aspectRatio ?? 16 / 10,
                      ),
                    ),
                  ],
                  SizedBox(height: gap),
                  _Block(
                    title: 'Overview',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (i, paragraph) in content.overview.indexed) ...[
                          if (i > 0) const SizedBox(height: Space.md),
                          Text(paragraph, style: AppType.theme.bodyLarge),
                        ],
                      ],
                    ),
                  ),
                  if (content.screenshots.isNotEmpty) ...[
                    SizedBox(height: gap),
                    _Block(
                      title: 'Screenshots',
                      child: _Gallery(product: product, shots: content.screenshots),
                    ),
                  ],
                  if (content.audience.isNotEmpty) ...[
                    SizedBox(height: gap),
                    _Block(title: "Who it's for", child: _Audience(content.audience)),
                  ],
                  if (content.editions.isNotEmpty) ...[
                    SizedBox(height: gap),
                    _Block(title: 'Editions', child: _Editions(content.editions)),
                  ],
                  for (final group in content.groups) ...[
                    SizedBox(height: gap),
                    _Block(title: group.heading, child: _Group(group: group)),
                  ],
                  for (final group in content.featureGroups) ...[
                    SizedBox(height: gap),
                    _Block(title: group.heading, child: _Features(group: group)),
                  ],
                ],
              ),
            ),
            _Column(
              color: Palette.n50,
              padding: EdgeInsets.symmetric(vertical: isMobile ? Space.xxxl : Space.section),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      content.ctaTitle ?? 'Interested in ${product.name}?',
                      style: AppType.theme.headlineLarge?.copyWith(
                        fontSize: AppType.fluid(context, min: 26, max: 34),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.md),
                  Text(
                    content.ctaText ??
                        "Let's discuss how ${product.name} can support your organisation.",
                    style: AppType.theme.bodyLarge,
                  ),
                  const SizedBox(height: Space.lg),
                  Wrap(
                    spacing: Space.md,
                    runSpacing: Space.md,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PrimaryButton(
                        text: 'Contact JV ALMA C.I.S →',
                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                      ),
                      if (store != null)
                        SecondaryButton(
                          text: 'Get it on Google Play',
                          icon: LucideIcons.download,
                          onPressed: () => _openStore(context, store.url),
                        ),
                    ],
                  ),
                  if (store?.note case final note?) ...[
                    const SizedBox(height: Space.sm),
                    Text(note, style: AppType.theme.bodySmall),
                  ],
                  const SizedBox(height: Space.lg),
                  ArrowLink(
                    label: content.parent.$2 == '/it-division'
                        ? 'All IT Division platforms'
                        : content.parent.$1,
                    back: true,
                    onTap: () => _back(context),
                  ),
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

/// Outlined labels naming who the product is for.
class _Audience extends StatelessWidget {
  const _Audience(this.audience);

  final List<String> audience;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.xs,
      runSpacing: Space.xs,
      children: [
        for (final who in audience)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.n300),
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: Text(who, style: AppType.theme.bodyMedium?.copyWith(color: Palette.ink)),
          ),
      ],
    );
  }
}

/// Screenshots in light panels; tap one to see it enlarged. Desktop screens
/// get wider tiles than phone screens.
class _Gallery extends StatelessWidget {
  const _Gallery({required this.product, required this.shots});

  final SoftwareProduct product;
  final List<ProductScreenshot> shots;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final images = [for (final s in shots) ProjectImage(s.path, caption: s.description)];
    return LayoutBuilder(
      builder: (context, box) {
        const gap = Space.md;
        final desktopWidth = narrow ? box.maxWidth : (box.maxWidth - gap) / 2;
        final phoneWidth = narrow ? (box.maxWidth - gap) / 2 : (box.maxWidth - 2 * gap) / 3;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (i, shot) in shots.indexed)
              SizedBox(
                width: shot.kind == ScreenshotKind.desktop ? desktopWidth : phoneWidth,
                child: Hoverable(
                  onTap: () => showProjectImageViewer(
                    context,
                    images: images,
                    initial: i,
                    title: product.name,
                  ),
                  scale: 1.0,
                  lift: 0,
                  semanticLabel:
                      'Enlarge screenshot ${i + 1} of ${shots.length}: ${shot.description}',
                  builder: (hovered) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: Motion.fast,
                        decoration: BoxDecoration(
                          color: Palette.n50,
                          borderRadius: BorderRadius.circular(Radii.md),
                          border: Border.all(color: hovered ? Palette.n300 : Palette.n100),
                        ),
                        child: AspectRatio(
                          aspectRatio: shot.kind == ScreenshotKind.desktop ? 16 / 10 : 3 / 4,
                          child: ScreenshotFrame(shot),
                        ),
                      ),
                      const SizedBox(height: Space.xs),
                      Text(shot.description, style: AppType.theme.bodySmall),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Editions side by side on wide screens, each with its status, features
/// and a link to its own page.
class _Editions extends StatelessWidget {
  const _Editions(this.editions);

  final List<ProductEdition> editions;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    final cards = [for (final e in editions) _EditionCard(edition: e, alignLink: wide)];
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: Space.xl),
            cards[i],
          ],
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: Space.lg),
            Expanded(child: cards[i]),
          ],
        ],
      ),
    );
  }
}

class _EditionCard extends StatelessWidget {
  const _EditionCard({required this.edition, required this.alignLink});

  final ProductEdition edition;

  /// Push the link to the bottom, so side-by-side editions' links line up.
  /// Only possible when the card has a set height.
  final bool alignLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Space.md),
      decoration:
          const BoxDecoration(border: Border(top: BorderSide(color: Palette.ink, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Each edition's own screenshot, or its name until it has one.
          ProductVisual(
            product: SoftwareProduct(
              name: edition.name,
              subtitle: edition.subtitle,
              description: edition.description,
              capabilities: const [],
              route: edition.route,
              visual: edition.visual,
            ),
            aspectRatio: 16 / 10,
          ),
          const SizedBox(height: Space.md),
          // Status in words, not colour alone.
          Text(edition.status.toUpperCase(), style: AppType.eyebrow(Palette.n500)),
          const SizedBox(height: Space.xs),
          Text(edition.name, style: AppType.theme.titleLarge),
          Text(edition.subtitle, style: AppType.theme.bodyMedium?.copyWith(color: Palette.n600)),
          const SizedBox(height: Space.sm),
          Text(edition.description, style: AppType.theme.bodyMedium),
          const SizedBox(height: Space.sm),
          for (final feature in edition.features) _Bullet(feature),
          if (alignLink) const Spacer(),
          const SizedBox(height: Space.md),
          ArrowLink(
            label: 'Explore ${edition.name.replaceFirst('Kilimo Mkononi ', '')}',
            // Marked, so the edition page's back link returns here.
            onTap: () => Navigator.pushNamed(context, edition.route, arguments: fromPortfolio),
          ),
        ],
      ),
    );
  }
}

/// Features as a two-column list of titles with short explanations.
class _Features extends StatelessWidget {
  const _Features({required this.group});

  final FeatureGroup group;

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.sizeOf(context).width >= 600 ? 2 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.intro case final intro?) ...[
          Text(intro, style: AppType.theme.bodyMedium),
          const SizedBox(height: Space.md),
        ],
        LayoutBuilder(
          builder: (context, box) {
            const gap = Space.lg;
            final cell = (box.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: Space.md,
              children: [
                for (final f in group.features)
                  SizedBox(
                    width: cell,
                    child: Container(
                      padding: const EdgeInsets.only(top: Space.sm),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Palette.n200)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title, style: AppType.theme.titleMedium),
                          const SizedBox(height: Space.xxs),
                          Text(f.description, style: AppType.theme.bodyMedium),
                        ],
                      ),
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

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 9, right: Space.sm),
            child: Container(width: 5, height: 5, color: Palette.n400),
          ),
          Expanded(child: Text(text, style: AppType.theme.bodyMedium)),
        ],
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

/// Section with its heading beside the content on wide screens and above
/// it on narrow ones, separated from the previous one by a hairline.
class _Block extends StatelessWidget {
  const _Block({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final heading = Semantics(
      header: true,
      child: Text(title, style: AppType.theme.headlineSmall),
    );
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

/// A group's note, then its areas side by side where they fit.
class _Group extends StatelessWidget {
  const _Group({required this.group});

  final ProductAreaGroup group;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 3 : (width >= 600 ? 2 : 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.note case final note?) ...[
          Text(note, style: AppType.theme.bodyMedium),
          const SizedBox(height: Space.md),
        ],
        LayoutBuilder(
          builder: (context, box) {
            // Four areas sit two by two rather than leaving one alone.
            final count = group.areas.length;
            final n = count == 1 ? 1 : (count == 4 ? columns.clamp(1, 2) : columns.clamp(1, count));
            const gap = Space.lg;
            final cell = (box.maxWidth - gap * (n - 1)) / n;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final area in group.areas) SizedBox(width: cell, child: _AreaCard(area: area)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AreaCard extends StatelessWidget {
  const _AreaCard({required this.area});

  final ProductArea area;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Space.md),
      decoration:
          const BoxDecoration(border: Border(top: BorderSide(color: Palette.ink, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(area.title, style: AppType.theme.titleLarge),
          const SizedBox(height: Space.sm),
          for (final item in area.items)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 9, right: Space.sm),
                    child: Container(width: 5, height: 5, color: Palette.n400),
                  ),
                  Expanded(child: Text(item, style: AppType.theme.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
