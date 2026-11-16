import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../admin/modules/business_units/business_unit_model.dart';
import '../admin/modules/business_units/business_units_provider.dart';
import '../admin/shared/color_key_registry.dart';
import '../admin/shared/icon_key_registry.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_card.dart';
import '../widgets/cms_image.dart';
import '../widgets/hoverable.dart';

/// A product page related to a business unit.
class _PlatformLink {
  const _PlatformLink(this.label, this.route);
  final String label;
  final String route;
}

/// Product pages related to each unit, keyed by the unit's existing route.
/// The business-unit model has no field for related links, so this is
/// presentation-only; a unit missing from the map simply shows none.
const _platformLinks = <String, List<_PlatformLink>>{
  '/construction-detail': [_PlatformLink('NyumbaSmart CMMS', '/cmms')],
  '/agribusiness': [
    _PlatformLink('Kilimo Mkononi', '/kilimo-mkononi'),
    _PlatformLink('CoffeeCore', '/coffee-core'),
  ],
  '/it-division': [
    _PlatformLink('NyumbaSmart CMMS', '/cmms'),
    _PlatformLink('AlmaWorks', '/alma-works'),
    _PlatformLink('Kilimo Mkononi', '/kilimo-mkononi'),
    _PlatformLink('CoffeeCore', '/coffee-core'),
  ],
};

class BusinessUnitsPage extends ConsumerWidget {
  const BusinessUnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    // An unseeded (but reachable) Firestore collection resolves to an empty
    // list, not null — falling back on nullness alone would leave the page
    // with zero units instead of the intended default content.
    final liveUnits = ref.watch(businessUnitsProvider).valueOrNull;
    final units = List<BusinessUnit>.of(
      (liveUnits == null || liveUnits.isEmpty) ? defaultBusinessUnits : liveUnits,
    )
      ..removeWhere((u) => !u.published)
      ..sort((a, b) => a.order.compareTo(b.order));

    Widget column(Widget child, EdgeInsets padding) => Container(
          width: double.infinity,
          color: Palette.n0,
          padding: padding.add(EdgeInsets.symmetric(horizontal: isMobile ? 20 : Space.lg)),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: child,
            ),
          ),
        );

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 01 — Introduction: neutral ground, hierarchy from type alone.
            column(
              // Full column width so the intro shares the rows' left edge.
              const SizedBox(width: double.infinity, child: _Intro()),
              EdgeInsets.only(
                top: isMobile ? Space.xxl : Space.section - Space.lg,
                bottom: isMobile ? Space.lg : Space.xl,
              ),
            ),

            // 02 — One portfolio row per published unit, in CMS order.
            column(
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < units.length; i++)
                    _UnitRow(
                      unit: units[i],
                      number: i + 1,
                      imageFirst: i.isEven,
                      first: i == 0,
                    ),
                ],
              ),
              EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Business Units',
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 34, max: 48),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Four specialised areas of activity, brought together under one group.',
            style: AppType.theme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

/// One business unit: image beside text on desktop (sides alternating),
/// image above text on narrow screens. Rows are separated by hairlines.
class _UnitRow extends StatelessWidget {
  const _UnitRow({
    required this.unit,
    required this.number,
    required this.imageFirst,
    required this.first,
  });

  final BusinessUnit unit;
  final int number;
  final bool imageFirst;
  final bool first;

  void _go(BuildContext context, String route) => Navigator.pushNamed(context, route);

  @override
  Widget build(BuildContext context) {
    final accent = ColorKeyRegistry.resolve(unit.accentColorKey);
    final platforms = _platformLinks[unit.route] ?? const <_PlatformLink>[];

    final image = Hoverable(
      onTap: () => _go(context, unit.route),
      scale: 1.0,
      lift: 0,
      semanticLabel: '${unit.title}. ${unit.ctaText}',
      builder: (_) => AspectRatio(
        aspectRatio: 3 / 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.md),
          child: ColoredBox(
            color: Palette.n100,
            child: ExcludeSemantics(
              child: CmsImage(
                source: unit.imageUrl,
                fit: BoxFit.cover,
                // Wide images (e.g. software screenshots) keep their left
                // edge, where titles and navigation sit; taller images are
                // still cropped around their vertical centre.
                alignment: Alignment.centerLeft,
                // No image, or one that fails to load: the unit's own icon
                // on a neutral panel rather than an empty box.
                errorBuilder: (_, __, ___) => Center(
                  child: IconChip(
                    icon: IconKeyRegistry.resolve(unit.iconKey),
                    color: accent,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Eyebrow(number.toString().padLeft(2, '0'), color: accent),
        const SizedBox(height: Space.md),
        Text(
          unit.title,
          style: AppType.theme.displaySmall?.copyWith(
            fontSize: AppType.fluid(context, min: 26, max: 34),
          ),
        ),
        const SizedBox(height: Space.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(unit.description, style: AppType.theme.bodyLarge),
        ),
        const SizedBox(height: Space.lg),
        _ArrowLink(
          label: unit.ctaText,
          onTap: () => _go(context, unit.route),
          strong: true,
        ),
        if (platforms.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          Text('RELATED PLATFORMS', style: AppType.eyebrow(Palette.n500)),
          const SizedBox(height: Space.xs),
          Wrap(
            spacing: Space.lg,
            runSpacing: Space.xs,
            children: [
              for (final p in platforms)
                _ArrowLink(label: p.label, onTap: () => _go(context, p.route)),
            ],
          ),
        ],
      ],
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: first ? Palette.ink : Palette.n200),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 860) {
            final children = [
              Expanded(flex: 6, child: image),
              const SizedBox(width: Space.xxl),
              Expanded(flex: 5, child: text),
            ];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xxxl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: imageFirst ? children : children.reversed.toList(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [image, const SizedBox(height: Space.lg), text],
            ),
          );
        },
      ),
    );
  }
}

/// Text link with a trailing arrow that stays beside the text when it wraps.
class _ArrowLink extends StatelessWidget {
  const _ArrowLink({required this.label, required this.onTap, this.strong = false});

  final String label;
  final VoidCallback onTap;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final base = (strong ? AppType.theme.titleMedium : AppType.theme.labelLarge)!;
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: label,
      builder: (hovered) => Text.rich(
        TextSpan(
          text: '$label ',
          style: base.copyWith(
            color: Palette.primary,
            height: 1.4,
            decoration: hovered ? TextDecoration.underline : null,
            decorationColor: Palette.primary,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                LucideIcons.arrowRight,
                size: strong ? 18 : 15,
                color: Palette.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
