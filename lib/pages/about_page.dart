import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../admin/modules/business_units/business_unit_model.dart';
import '../admin/modules/business_units/business_units_provider.dart';
import '../admin/modules/site_settings/site_settings_model.dart';
import '../admin/modules/site_settings/site_settings_provider.dart';
import '../admin/shared/color_key_registry.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_card.dart';
import '../widgets/hoverable.dart';

/// Subdivision milestones. Years and meanings are carried over unchanged
/// from the previous About page timeline; only the wording is tidied.
const _milestones = [
  (
    year: '2017',
    event: 'Company founded',
    detail: 'JV ALMA C.I.S was established in Kenya with a focus on construction services.',
  ),
  (
    year: '2021',
    event: 'Expansion into Agribusiness',
    detail:
        'Operations diversified to include agricultural solutions and climate resilience programs.',
  ),
  (
    year: '2022',
    event: 'Oil & Gas Services launched',
    detail: 'Entered the energy sector with inspection services, working in partnership with '
        'Brisma Africa and TIC East Africa.',
  ),
  (
    year: '2024',
    event: 'IT Division established',
    detail: 'Launched the software platforms NyumbaSmart CMMS, Kilimo Mkononi and CoffeeCore.',
  ),
];

/// About page: identity, the group and its four units, the journey, and
/// purpose.
///
/// The unit list and office locations come from the same CMS providers (and
/// fallbacks) as the Business Units page and footer, so they never drift.
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

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

    Widget column(Widget child, EdgeInsets padding, {Color background = Palette.n0}) => Container(
          width: double.infinity,
          color: background,
          padding: padding.add(EdgeInsets.symmetric(horizontal: isMobile ? 20 : Space.lg)),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        );

    final sectionGap = isMobile ? Space.xxl : Space.xxxl + Space.lg;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 01 — Identity.
            column(
              _Identity(settings: settings),
              EdgeInsets.only(
                  top: isMobile ? Space.xxl : Space.section - Space.lg, bottom: sectionGap),
            ),

            // 02 — The story: the group, its four units and how they connect.
            column(
              _Split(
                heading: 'One group. Four areas of expertise.',
                child: _Story(units: units),
              ),
              EdgeInsets.only(bottom: sectionGap),
            ),

            // 03 — Journey: the subdivision milestones.
            column(
              const _Split(heading: 'Our journey', child: _Journey()),
              EdgeInsets.only(bottom: sectionGap),
            ),

            // 04 — Purpose.
            column(
              const _Purpose(),
              EdgeInsets.symmetric(vertical: sectionGap),
              background: Palette.n50,
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }
}

/// Section heading in a narrow left column, content on the right; stacked
/// on narrow screens. Every section starts on a hairline so the page reads
/// as one continuous document.
class _Split extends StatelessWidget {
  const _Split({required this.heading, required this.child});

  final String heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      heading,
      style: AppType.theme.headlineLarge?.copyWith(
        fontSize: AppType.fluid(context, min: 24, max: 30),
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

class _Identity extends StatelessWidget {
  const _Identity({required this.settings});

  final SiteSettings settings;

  @override
  Widget build(BuildContext context) {
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About JV ALMA C.I.S',
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 34, max: 52),
          ),
        ),
        const SizedBox(height: Space.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            'Founded in 2017, JV ALMA C.I.S is a multi-sector group based in Kenya. It brings '
            'together four specialised areas of activity: facility management and renovation, '
            'agricultural services, oil and gas inspection, and software development.',
            style: AppType.theme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: AppType.fluid(context, min: 18, max: 22),
              height: 1.5,
              color: Palette.n700,
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 860) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 7, child: intro),
              const SizedBox(width: Space.xxl),
              Expanded(flex: 4, child: _PlanPanel(settings: settings)),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [intro, const SizedBox(height: Space.xl), _PlanPanel(settings: settings)],
        );
      },
    );
  }
}

/// The identity visual: a quiet drawing-sheet panel (fine grid, corner
/// registration marks) carrying the founding year and the offices from site
/// settings. Architectural in feel without standing in for a project photo.
class _PlanPanel extends StatelessWidget {
  const _PlanPanel({required this.settings});

  final SiteSettings settings;

  @override
  Widget build(BuildContext context) {
    final offices = List<OfficeLocation>.of(settings.officeLocations)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Container(
      decoration: BoxDecoration(
        color: Palette.n50,
        border: Border.all(color: Palette.n200),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: CustomPaint(
        painter: _DrawingSheetPainter(),
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ESTABLISHED', style: AppType.eyebrow(Palette.n500)),
              const SizedBox(height: Space.xs),
              Text(
                '2017',
                style: AppType.theme.displayLarge?.copyWith(
                  fontSize: AppType.fluid(context, min: 48, max: 64),
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: Space.lg),
              const Divider(height: 1, thickness: 1, color: Palette.n300),
              const SizedBox(height: Space.lg),
              Text('OFFICES', style: AppType.eyebrow(Palette.n500)),
              const SizedBox(height: Space.sm),
              for (var i = 0; i < offices.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.sm),
                Text(offices[i].label, style: AppType.theme.titleSmall),
                const SizedBox(height: Space.xxs),
                Text(offices[i].address, style: AppType.theme.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawingSheetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) return;
    final grid = Paint()
      ..color = Palette.n200.withValues(alpha: 0.7)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Registration marks in the corners, as on a drawing sheet.
    final mark = Paint()
      ..color = Palette.n400
      ..strokeWidth = 1;
    const inset = 10.0, arm = 10.0;
    for (final (cx, sx) in [(inset, 1.0), (size.width - inset, -1.0)]) {
      for (final (cy, sy) in [(inset, 1.0), (size.height - inset, -1.0)]) {
        canvas.drawLine(Offset(cx, cy), Offset(cx + arm * sx, cy), mark);
        canvas.drawLine(Offset(cx, cy), Offset(cx, cy + arm * sy), mark);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Story extends StatelessWidget {
  const _Story({required this.units});

  final List<BusinessUnit> units;

  @override
  Widget build(BuildContext context) {
    final body = AppType.theme.bodyLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Each business unit works in its own field. Together they share a foundation of '
            'technical expertise, community engagement and a commitment to sustainable impact.',
            style: body,
          ),
        ),
        const SizedBox(height: Space.lg),
        for (var i = 0; i < units.length; i++) _UnitLine(unit: units[i], number: i + 1),
        const Divider(height: 1, thickness: 1, color: Palette.n200),
        const SizedBox(height: Space.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The units support one another. NyumbaSmart, the maintenance management platform '
                'developed by the IT Division, supports the facility management services delivered '
                'by Construction. In agriculture, Kilimo Mkononi was developed through hands-on work '
                'with farming communities, and CoffeeCore gives coffee farmers and cooperatives '
                'tools for cultivation, market access and farm management.',
                style: body,
              ),
              const SizedBox(height: Space.md),
              Text(
                'Oil & Gas Services provides inspection and related operational services in '
                'partnership with Brisma Africa and TIC East Africa.',
                style: body,
              ),
            ],
          ),
        ),
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

/// The milestones as a ruled list: year, then what happened. A thin
/// vertical rule links the years so they read as one sequence.
class _Journey extends StatelessWidget {
  const _Journey();

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'The group has grown one area of expertise at a time, adding a new business unit as '
            'its work and partnerships developed.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        const SizedBox(height: Space.lg),
        for (var i = 0; i < _milestones.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: narrow ? 72 : 96,
                  child: Container(
                    padding: const EdgeInsets.only(top: Space.md),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Palette.ink, width: 2)),
                    ),
                    child: Text(
                      _milestones[i].year,
                      style: AppType.theme.headlineMedium?.copyWith(
                        fontSize: narrow ? 20 : 24,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Space.lg),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: Space.md, bottom: Space.lg),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Palette.n200)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_milestones[i].event, style: AppType.theme.titleLarge),
                        const SizedBox(height: Space.xxs),
                        Text(_milestones[i].detail, style: AppType.theme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Purpose extends StatelessWidget {
  const _Purpose();

  @override
  Widget build(BuildContext context) {
    // Edited from the previous statements to match the approved scope of
    // the four units; intent unchanged.
    const mission =
        'To deliver reliable facility management, agricultural, inspection and digital services '
        'that support sustainable development across East Africa.';
    const vision =
        'To become a trusted partner for integrated solutions, connecting communities, businesses '
        'and opportunities across the region.';

    Widget statement(String label, String text) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(label, color: Palette.primary),
            const SizedBox(height: Space.md),
            Text(
              text,
              style: AppType.theme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: AppType.fluid(context, min: 19, max: 23),
                height: 1.45,
              ),
            ),
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our purpose',
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 24, max: 30),
          ),
        ),
        const SizedBox(height: Space.xl),
        LayoutBuilder(
          builder: (context, constraints) {
            final missionBlock = statement('Mission', mission);
            final visionBlock = statement('Vision', vision);
            if (constraints.maxWidth >= 720) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: missionBlock),
                    const VerticalDivider(width: Space.xxl * 2, thickness: 1, color: Palette.n200),
                    Expanded(child: visionBlock),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                missionBlock,
                const SizedBox(height: Space.xl),
                const Divider(height: 1, thickness: 1, color: Palette.n200),
                const SizedBox(height: Space.xl),
                visionBlock,
              ],
            );
          },
        ),
      ],
    );
  }
}
