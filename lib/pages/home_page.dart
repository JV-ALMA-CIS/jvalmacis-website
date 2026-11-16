import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../admin/modules/business_units/business_unit_model.dart';
import '../admin/modules/business_units/business_units_provider.dart';
import '../admin/modules/homepage/homepage_model.dart';
import '../admin/modules/homepage/homepage_provider.dart';
import '../admin/shared/color_key_registry.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/cms_image.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/hoverable.dart';
import '../widgets/logo_marquee.dart';

/// Product pages linked from a unit on the homepage, keyed by the unit's
/// existing route (the business-unit model has no related-links field).
const _platformLinks = <String, List<(String, String)>>{
  '/agribusiness': [('Kilimo Mkononi', '/kilimo-mkononi'), ('CoffeeCore', '/coffee-core')],
};

/// Home page: editorial hero, the four areas of expertise, a slim
/// "experience you can explore" section, and a closing call to action.
///
/// The hero headline and button, and the closing heading, copy and button,
/// come from the homepage CMS document ([homepageProvider]); the units come
/// from [businessUnitsProvider]. Both fall back to their defaults while
/// Firestore is loading, empty or unreachable.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(homepageProvider).valueOrNull ?? defaultHomepageContent;

    // An unseeded (but reachable) Firestore collection resolves to an empty
    // list, not null — falling back on nullness alone would leave the
    // section with zero units instead of the intended default content.
    final liveUnits = ref.watch(businessUnitsProvider).valueOrNull;
    final units = List<BusinessUnit>.of(
      (liveUnits == null || liveUnits.isEmpty) ? defaultBusinessUnits : liveUnits,
    )
      ..removeWhere((u) => !u.published || !u.featured)
      ..sort((a, b) => a.order.compareTo(b.order));

    final clientLogos = List<ClientLogo>.of(content.clientLogos)
      ..sort((a, b) => a.order.compareTo(b.order));

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Hero(content: content),
            _Band(
              top: Space.xxxl + Space.md,
              bottom: Space.xxxl + Space.md,
              child: _Expertise(units: units),
            ),
            if (clientLogos.isNotEmpty)
              _Band(
                bottom: Space.xxxl + Space.md,
                child: _Clients(logos: clientLogos),
              ),
            const _Band(
              background: Palette.n50,
              top: Space.xxl + Space.md,
              bottom: Space.xxl + Space.md,
              child: _Experience(),
            ),
            _Band(
              top: Space.xxxl + Space.md,
              bottom: Space.xxxl + Space.md,
              child: _Closing(content: content),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

/// Full-width background with content constrained to the shared site width.
/// Vertical padding is reduced on phones.
class _Band extends StatelessWidget {
  const _Band({
    required this.child,
    this.background = Palette.n0,
    this.top = 0,
    this.bottom = 0,
  });

  final Widget child;
  final Color background;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final scale = isMobile ? 0.6 : 1.0;
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.only(
        left: siteGutter(context),
        right: siteGutter(context),
        top: top * scale,
        bottom: bottom * scale,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: siteContentMax),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

/// Hero over the CMS background image (company_background, by default),
/// with a directional scrim so the white text stays readable. The image
/// fills the band at any height; the band's height follows its content.
class _Hero extends StatelessWidget {
  const _Hero({required this.content});

  final HomepageContent content;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(
            content.heroTitle,
            style: AppType.theme.displayLarge?.copyWith(
              color: Palette.n0,
              fontSize: AppType.fluid(context, min: 38, max: 64),
            ),
          ),
        ),
        const SizedBox(height: Space.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'A multi-sector group delivering construction, '
            'agribusiness solutions, and oil and gas inspection.',
            style: AppType.theme.bodyLarge?.copyWith(
              color: Palette.n0.withValues(alpha: 0.88),
              fontSize: AppType.fluid(context, min: 17, max: 20),
            ),
          ),
        ),
        const SizedBox(height: Space.xl),
        PrimaryButton(
          text: content.heroCtaText,
          icon: LucideIcons.arrowRight,
          large: true,
          onDark: true,
          onPressed: () => Navigator.pushNamed(context, content.heroCtaRoute),
        ),
      ],
    );

    return Stack(
      children: [
        Positioned.fill(
          child: ExcludeSemantics(
            child: CmsImage(
              source: content.heroBackgroundImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Palette.ink),
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(decoration: BoxDecoration(gradient: Palette.photoScrim)),
        ),
        // Even, light veil so the text holds contrast over bright sky.
        const Positioned.fill(child: ColoredBox(color: Color(0x330B1220))),
        _Band(
          background: Colors.transparent,
          top: isMobile ? Space.section : Space.section + Space.xxl,
          bottom: isMobile ? Space.section : Space.section + Space.xl,
          child: text,
        ),
      ],
    );
  }
}

/// The client logos from the homepage CMS document, in configured order.
class _Clients extends StatelessWidget {
  const _Clients({required this.logos});

  final List<ClientLogo> logos;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1, thickness: 1, color: Palette.n200),
        const SizedBox(height: Space.xl),
        Text(
          'Our valued clients',
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 24, max: 32),
          ),
        ),
        const SizedBox(height: Space.xl),
        LogoMarquee(
          assetPaths: [for (final logo in logos) logo.imageUrl],
          logoHeight: isMobile ? 36 : 48,
          gap: isMobile ? 48 : 80,
        ),
      ],
    );
  }
}

class _Expertise extends StatelessWidget {
  const _Expertise({required this.units});

  final List<BusinessUnit> units;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, thickness: 1, color: Palette.ink),
        const SizedBox(height: Space.xl),
        Text(
          'Our areas of expertise',
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 24, max: 32),
          ),
        ),
        const SizedBox(height: Space.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final cells = [
              for (var i = 0; i < units.length; i++) _UnitCell(unit: units[i], number: i + 1),
            ];
            if (constraints.maxWidth < 720) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: cells);
            }
            // Two columns; each pair shares a row so their rules line up.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < cells.length; i += 2)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cells[i]),
                      const SizedBox(width: Space.xxl),
                      Expanded(child: i + 1 < cells.length ? cells[i + 1] : const SizedBox()),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// One unit: number, linked name, tagline and scope, on a hairline. Related
/// product pages, where the site has them, follow as small links.
class _UnitCell extends StatelessWidget {
  const _UnitCell({required this.unit, required this.number});

  final BusinessUnit unit;
  final int number;

  @override
  Widget build(BuildContext context) {
    final accent = ColorKeyRegistry.resolve(unit.accentColorKey);
    final platforms = _platformLinks[unit.route] ?? const [];

    return Container(
      padding: const EdgeInsets.only(top: Space.lg, bottom: Space.xl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.n200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hoverable(
            onTap: () => Navigator.pushNamed(context, unit.route),
            scale: 1.0,
            lift: 0,
            semanticLabel: '${unit.title}. ${unit.tagline}',
            builder: (hovered) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(number.toString().padLeft(2, '0'), style: AppType.eyebrow(accent)),
                const SizedBox(height: Space.sm),
                Text.rich(
                  TextSpan(
                    text: '${unit.title} ',
                    style: AppType.theme.headlineSmall?.copyWith(
                      fontSize: AppType.fluid(context, min: 20, max: 22),
                      color: hovered ? Palette.primary : Palette.ink,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          LucideIcons.arrowRight,
                          size: 18,
                          color: hovered ? Palette.primary : Palette.n400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unit.tagline.isNotEmpty) ...[
                  const SizedBox(height: Space.xxs),
                  Text(unit.tagline,
                      style: AppType.theme.labelLarge?.copyWith(color: Palette.n500, height: 1.4)),
                ],
                const SizedBox(height: Space.sm),
                Text(unit.description, style: AppType.theme.bodyMedium),
              ],
            ),
          ),
          if (platforms.isNotEmpty) ...[
            const SizedBox(height: Space.sm),
            Wrap(
              spacing: Space.md,
              runSpacing: Space.xxs,
              children: [
                for (final (label, route) in platforms)
                  _SmallLink(label: label, onTap: () => Navigator.pushNamed(context, route)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SmallLink extends StatelessWidget {
  const _SmallLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: label,
      builder: (hovered) => Text(
        label,
        style: AppType.theme.labelLarge?.copyWith(
          color: Palette.primary,
          height: 1.4,
          decoration: hovered ? TextDecoration.underline : null,
          decorationColor: Palette.primary,
        ),
      ),
    );
  }
}

/// Slim, secondary section pointing to evidence already published on the
/// site: the certificates library and the confirmed oil & gas partners.
class _Experience extends StatelessWidget {
  const _Experience();

  static const _items = [
    (
      title: 'Certificates & Compliance',
      text: 'Company registrations, contractor certificates, software copyright registrations '
          'and our data-protection registration.',
      route: '/certificates',
    ),
    (
      title: 'Oil & Gas partnerships',
      text: 'Oil & Gas Services works in partnership with Brisma Africa and TIC Group.',
      route: '/oil-gas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final entries = [
      for (final item in _items)
        Hoverable(
          onTap: () => Navigator.pushNamed(context, item.route),
          scale: 1.0,
          lift: 0,
          semanticLabel: '${item.title}. ${item.text}',
          builder: (hovered) => Container(
            padding: const EdgeInsets.only(top: Space.md),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Palette.n300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '${item.title} ',
                    style: AppType.theme.titleMedium?.copyWith(
                      color: hovered ? Palette.primary : Palette.ink,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          LucideIcons.arrowRight,
                          size: 15,
                          color: hovered ? Palette.primary : Palette.n400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Space.xxs),
                Text(item.text, style: AppType.theme.bodySmall),
              ],
            ),
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final heading = Text('Experience you can explore', style: AppType.theme.titleLarge);
        if (constraints.maxWidth >= 860) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: heading),
              const SizedBox(width: Space.xxl),
              Expanded(flex: 4, child: entries[0]),
              const SizedBox(width: Space.lg),
              Expanded(flex: 4, child: entries[1]),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            heading,
            const SizedBox(height: Space.md),
            entries[0],
            const SizedBox(height: Space.md),
            entries[1],
          ],
        );
      },
    );
  }
}

class _Closing extends StatelessWidget {
  const _Closing({required this.content});

  final HomepageContent content;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          content.ctaBandTitle,
          style: AppType.theme.displaySmall?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 36),
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(content.ctaBandSubtitle, style: AppType.theme.bodyLarge),
      ],
    );
    final button = PrimaryButton(
      text: content.ctaBandButtonText,
      icon: LucideIcons.arrowRight,
      large: true,
      onPressed: () => Navigator.pushNamed(context, content.ctaBandButtonRoute),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 860) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: text),
              const SizedBox(width: Space.xl),
              button,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [text, const SizedBox(height: Space.lg), button],
        );
      },
    );
  }
}
