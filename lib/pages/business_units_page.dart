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
import '../widgets/app_card.dart';
import '../widgets/section.dart';
import '../widgets/reveal_on_scroll.dart';

class BusinessUnitsPage extends ConsumerWidget {
  const BusinessUnitsPage({super.key});

  static const List<Map<String, dynamic>> _whyChooseUs = [
    {
      'icon': LucideIcons.award,
      'title': 'Proven Excellence',
      'description': 'Decades of experience delivering top-quality projects across industries.',
    },
    {
      'icon': LucideIcons.lightbulb,
      'title': 'Innovation-Driven',
      'description': 'Leveraging cutting-edge technology to solve complex challenges.',
    },
    {
      'icon': LucideIcons.leaf,
      'title': 'Sustainable Solutions',
      'description': 'Committed to environmentally responsible and sustainable practices.',
    },
    {
      'icon': LucideIcons.users,
      'title': 'Client-Centric Approach',
      'description': 'Building strong partnerships with a focus on client needs.',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // An unseeded (but reachable) Firestore collection resolves to an empty
    // list, not null — falling back on nullness alone would leave the page
    // with zero cards instead of the intended default content.
    final liveUnits = ref.watch(businessUnitsProvider).valueOrNull;
    final units = List<BusinessUnit>.of(
      (liveUnits == null || liveUnits.isEmpty) ? defaultBusinessUnits : liveUnits,
    )
      ..removeWhere((u) => !u.published)
      ..sort((a, b) => a.order.compareTo(b.order));

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, isMobile),
            _buildBusinessUnitsSection(context, isMobile, units),
            _buildWhyChooseUsSection(context, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: Palette.heroSurface),
      padding: Space.sectionPad(isMobile),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.contentMax),
          child: Column(
            children: [
              Text(
                'Our Business Units',
                style: (isMobile
                        ? Theme.of(context).textTheme.headlineLarge
                        : Theme.of(context).textTheme.displaySmall)
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.md),
              Text(
                'Delivering innovative solutions across construction, agribusiness, oil & gas, and information technology.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessUnitsSection(BuildContext context, bool isMobile, List<BusinessUnit> units) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        children: [
          const SectionHeader(
            title: 'Our Core Divisions',
            subtitle: 'Explore our diverse portfolio of services across multiple industries',
          ),
          const SizedBox(height: Space.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 640
                  ? 1
                  : constraints.maxWidth < 1000
                      ? 2
                      : units.length.clamp(1, 4);
              const gap = Space.md;
              final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: List.generate(units.length, (i) {
                  return SizedBox(
                    width: cardWidth,
                    child: RevealOnScroll(
                      delayMs: 60 * i,
                      child: _buildBusinessUnitCard(context, units[i], isMobile),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessUnitCard(BuildContext context, BusinessUnit unit, bool isMobile) {
    final color = ColorKeyRegistry.resolve(unit.accentColorKey);
    return AppCard(
      accent: color,
      onTap: () {
        Navigator.pushNamed(context, unit.route);
      },
      semanticLabel: unit.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(
            icon: IconKeyRegistry.resolve(unit.iconKey),
            color: color,
            size: isMobile ? 28 : 32,
          ),
          const SizedBox(height: Space.md),
          Text(
            unit.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Space.xs),
          Text(
            unit.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Space.md),
          Row(
            children: [
              Text(
                unit.ctaText,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: color),
              ),
              const SizedBox(width: Space.xxs),
              Icon(
                LucideIcons.arrowRight,
                size: 16,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUsSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        children: [
          const SectionHeader(
            title: 'Why Choose Us',
            subtitle: 'Our commitment to quality and innovation sets us apart',
          ),
          const SizedBox(height: Space.xl),

          // Why Choose Us - True side-by-side layout
          if (isMobile)
            Column(
              children: _whyChooseUs
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: Space.md),
                        child: RevealOnScroll(
                          delayMs: 60 * entry.key,
                          child: _buildWhyChooseUsCard(context, entry.value, isMobile),
                        ),
                      ))
                  .toList(),
            )
          else
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 0,
                        child: _buildWhyChooseUsCard(context, _whyChooseUs[0], isMobile),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 60,
                        child: _buildWhyChooseUsCard(context, _whyChooseUs[1], isMobile),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 120,
                        child: _buildWhyChooseUsCard(context, _whyChooseUs[2], isMobile),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 180,
                        child: _buildWhyChooseUsCard(context, _whyChooseUs[3], isMobile),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUsCard(BuildContext context, Map<String, dynamic> item, bool isMobile) {
    return AppCard(
      interactive: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(
            icon: item['icon'] as IconData,
            color: Palette.primary,
            size: isMobile ? 28 : 32,
          ),
          const SizedBox(height: Space.sm),
          Text(
            item['title'] as String,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Space.xs),
          Text(
            item['description'] as String,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
