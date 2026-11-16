import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jv_alma_cis/widgets/header.dart';
import 'package:jv_alma_cis/widgets/footer.dart';
import '../admin/modules/business_units/business_unit_model.dart';
import '../admin/modules/business_units/business_units_provider.dart';
import '../admin/modules/site_settings/site_settings_model.dart';
import '../admin/modules/site_settings/site_settings_provider.dart';
import '../admin/shared/color_key_registry.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/brand_icons.dart';
import '../widgets/hoverable.dart';

/// The address the page has always given for CVs. It has not been
/// confirmed as an active, monitored inbox, so the page does not promise
/// that CVs are received or kept on file.
const careersEmail = 'hr@jvalmacis.co.ke';

const _values = [
  (title: 'Excellence', text: 'We hold our work to high standards.'),
  (title: 'Innovation', text: 'We look for creative ways to solve challenges.'),
  (title: 'Teamwork', text: 'We work together towards shared goals.'),
];

/// Careers page: introduction, the business units, values, open positions
/// (none advertised; there is no vacancy data source), future
/// opportunities and social links.
class CareersPage extends ConsumerWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;

    // Same fallback, publication and ordering rules as the Business Units page.
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
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        );

    final gap = EdgeInsets.only(bottom: isMobile ? Space.xxl : Space.xxxl);

    Future<void> openUrl(String url) async {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The link could not be opened.')),
        );
      }
    }

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 01 — Introduction.
            column(
              const _Intro(),
              EdgeInsets.only(
                top: isMobile ? Space.xxl : Space.section - Space.lg,
                bottom: isMobile ? Space.xl : Space.xxl,
              ),
            ),
            // 02 — The business units.
            column(
              _Split(
                heading: 'Working across our business units',
                child: _Units(units: units),
              ),
              gap,
            ),
            // 03 — Values.
            column(const _Split(heading: 'What we value', child: _Values()), gap),
            // 04 — Open positions: none advertised.
            column(const _Split(heading: 'Open positions', child: _NoOpenPositions()), gap),
            // 05 — Future opportunities.
            column(
                const _Split(heading: 'Future opportunities', child: _FutureOpportunities()), gap),
            // 06 — Follow our updates.
            column(
              _FollowUs(
                onLinkedIn: () => openUrl(settings.linkedinUrl),
                onInstagram: () => openUrl(settings.instagramUrl),
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
          'Careers at JV ALMA C.I.S',
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 32, max: 48),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Explore opportunities to contribute across our specialised areas of activity, from '
            'facility services and agribusiness to oil and gas inspection and software development.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        // No closing rule: the first section opens with its own hairline.
      ],
    );
  }
}

/// Section heading in a narrow left column, content on the right; stacked
/// on narrow screens. Matches the About page's editorial sections.
class _Split extends StatelessWidget {
  const _Split({required this.heading, required this.child});

  final String heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      heading,
      style: AppType.theme.headlineLarge?.copyWith(
        fontSize: AppType.fluid(context, min: 22, max: 28),
      ),
    );

    return Container(
      padding: const EdgeInsets.only(top: Space.xl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.n200)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 860) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: title),
                const SizedBox(width: Space.xxl),
                Expanded(flex: 7, child: child),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: Space.lg), child],
          );
        },
      ),
    );
  }
}

class _Units extends StatelessWidget {
  const _Units({required this.units});

  final List<BusinessUnit> units;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'The group works across four business units, each in its own field.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        const SizedBox(height: Space.md),
        for (var i = 0; i < units.length; i++) _UnitLine(unit: units[i], number: i + 1),
        const Divider(height: 1, thickness: 1, color: Palette.n200),
      ],
    );
  }
}

/// One ruled line per unit: number, linked name, its one-sentence scope.
class _UnitLine extends StatelessWidget {
  const _UnitLine({required this.unit, required this.number});

  final BusinessUnit unit;
  final int number;

  @override
  Widget build(BuildContext context) {
    final accent = ColorKeyRegistry.resolve(unit.accentColorKey);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.n200)),
      ),
      child: Hoverable(
        onTap: () => Navigator.pushNamed(context, unit.route),
        scale: 1.0,
        lift: 0,
        semanticLabel: '${unit.title}. ${unit.description}',
        builder: (hovered) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 44,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(number.toString().padLeft(2, '0'), style: AppType.eyebrow(accent)),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: '${unit.title} ',
                        style: AppType.theme.titleLarge?.copyWith(
                          color: hovered ? Palette.primary : Palette.ink,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              LucideIcons.arrowRight,
                              size: 16,
                              color: hovered ? Palette.primary : Palette.n400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Space.xxs),
                    Text(unit.description, style: AppType.theme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The three values side by side on wide screens, stacked on narrow ones.
/// Text only: no icons or cards.
class _Values extends StatelessWidget {
  const _Values();

  @override
  Widget build(BuildContext context) {
    Widget value(({String title, String text}) v) => Container(
          padding: const EdgeInsets.only(top: Space.md),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Palette.ink, width: 2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(v.title, style: AppType.theme.titleLarge),
              const SizedBox(height: Space.xxs),
              Text(v.text, style: AppType.theme.bodyMedium),
            ],
          ),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 560) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _values.length; i++) ...[
                if (i > 0) const SizedBox(width: Space.lg),
                Expanded(child: value(_values[i])),
              ],
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < _values.length; i++) ...[
              if (i > 0) const SizedBox(height: Space.lg),
              value(_values[i]),
            ],
          ],
        );
      },
    );
  }
}

/// The deliberate empty state. There is no vacancy data source in the
/// project; when one exists, this is where listings would render.
class _NoOpenPositions extends StatelessWidget {
  const _NoOpenPositions();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: Palette.n50,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: Palette.n200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No open positions at the moment', style: AppType.theme.titleLarge),
          const SizedBox(height: Space.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              "We don't currently have any advertised vacancies. Please check back for future "
              'opportunities and follow our official channels for updates.',
              style: AppType.theme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _FutureOpportunities extends StatelessWidget {
  const _FutureOpportunities();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'If you would like to be considered for future opportunities, you can send your CV to:',
            style: AppType.theme.bodyLarge,
          ),
        ),
        const SizedBox(height: Space.sm),
        SelectableText(
          careersEmail,
          style: AppType.theme.titleLarge?.copyWith(color: Palette.ink),
        ),
      ],
    );
  }
}

class _FollowUs extends StatelessWidget {
  const _FollowUs({required this.onLinkedIn, required this.onInstagram});

  final VoidCallback onLinkedIn;
  final VoidCallback onInstagram;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Space.xl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.n200)),
      ),
      child: Wrap(
        spacing: Space.lg,
        runSpacing: Space.md,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Follow our updates', style: AppType.theme.titleLarge),
                const SizedBox(height: Space.xxs),
                Text(
                  'Follow JV ALMA C.I.S on our official channels for company news and updates.',
                  style: AppType.theme.bodyMedium,
                ),
              ],
            ),
          ),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              SecondaryButton(text: 'LinkedIn', icon: BrandIcons.linkedin, onPressed: onLinkedIn),
              SecondaryButton(
                  text: 'Instagram', icon: BrandIcons.instagram, onPressed: onInstagram),
            ],
          ),
        ],
      ),
    );
  }
}
