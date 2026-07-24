import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/logo_marquee.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section.dart';

/// Home page — visual redesign only.
///
/// TEXT POLICY FOR THIS FILE
/// Only strings that exist in the original home_page.dart appear here.
/// The invented eyebrow labels from the previous pass ('JV ALMA C.I.S',
/// 'What we do', 'Partners') have been removed, and the invented secondary
/// hero button has been removed. Strings rendered by this file:
///
///   'For Construction, Agribusiness, Oil & Gas Services, and IT Solutions'
///   'Our Business Units'
///   'Comprehensive solutions across multiple sectors'
///   'Construction' / 'Civil Works & Systems'
///   'Agribusiness' / 'Infrastructure, Training and Digitization'
///   'Oil & Gas Services' / 'Inspection and Regulatory Compliance'
///   'IT Division' / 'Digital Solutions'
///   'Learn more'
///   'Our Valued Clients'
///   'Trusted by leading organizations across industries'
///   'Ready to Collaborate?'
///   "Let's build a sustainable future together."
///   'Contact Us'
///
/// SCROLL FIX
/// The previous version rebuilt the entire page tree on every scroll tick
/// (`setState` inside the ScrollController listener). Combined with the
/// marquee's repeating AnimationController this starved the scroll gesture
/// and made the page feel stuck. Parallax now runs through a ValueNotifier
/// that rebuilds the hero image only.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();

  /// Drives hero parallax without rebuilding the rest of the page.
  final ValueNotifier<double> _heroOffset = ValueNotifier<double>(0);

  static const _clientLogos = <String>[
    'assets/images/clients/kvda.jpg',
    'assets/images/clients/sweden.jpg',
    'assets/images/clients/italy.jpg',
    'assets/images/clients/usa.jpg',
    'assets/images/clients/navfac.jpg',
    'assets/images/clients/portugal.jpg',
    'assets/images/clients/iadc.jpg',
    'assets/images/clients/total.jpg',
    'assets/images/clients/eni.jpg',
  ];

  static const _businessUnits = <_Unit>[
    _Unit('Construction', 'Civil Works & Systems', LucideIcons.building,
        '/construction-detail', Palette.construction),
    _Unit('Agribusiness', 'Infrastructure, Training and Digitization',
        LucideIcons.sprout, '/agribusiness', Palette.agribusiness),
    _Unit('Oil & Gas Services', 'Inspection and Regulatory Compliance',
        LucideIcons.droplets, '/oil-gas', Palette.oilGas),
    _Unit('IT Division', 'Digital Solutions', LucideIcons.globe, '/it-division',
        Palette.it),
  ];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final offset = _scroll.offset;
    // Only the hero cares, and only while it is on screen.
    if (offset <= 700) _heroOffset.value = offset;
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _heroOffset.dispose();
    super.dispose();
  }

  void _navigate(String route) => Navigator.of(context).pushNamed(route);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return AppScaffold(
      body: SingleChildScrollView(
        controller: _scroll,
        // Guarantees the view is always draggable even when content is short.
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hero(context, isMobile),
            _businessUnitsSection(context, isMobile),
            _clientsSection(context, isMobile),
            _ctaBand(context, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- hero ---
  Widget _hero(BuildContext context, bool isMobile) {
    final height = isMobile ? 520.0 : 640.0;
    final reduced = Motion.reduced(context);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Parallax is isolated: only this subtree rebuilds on scroll.
          RepaintBoundary(
            child: ValueListenableBuilder<double>(
              valueListenable: _heroOffset,
              builder: (context, offset, child) {
                if (reduced) return child!;
                return Transform.translate(
                  offset: Offset(0, offset * 0.25),
                  child: Transform.scale(
                    scale: 1.0 + (offset / 6000),
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/company_background.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: Palette.ink),
              ),
            ),
          ),

          // Directional scrim replaces the flat 0x99000000 wash — the photo
          // stays legible while the text sits on real contrast.
          const DecoratedBox(
            decoration: BoxDecoration(gradient: Palette.photoScrim),
          ),

          // Fine grid texture. Quiet, but it removes the "stock header" feel.
          const Positioned.fill(
            child: RepaintBoundary(child: _GridTexture()),
          ),

          // Left-aligned editorial column, not centred.
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : Space.xxl,
              ),
              constraints: const BoxConstraints(maxWidth: 880),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroEntrance(
                    delayMs: 0,
                    child: Text(
                      // Original string, unchanged.
                      'For Construction, Agribusiness, Oil & Gas Services, and IT Solutions',
                      style: AppType.theme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: AppType.fluid(context, min: 32, max: 58),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.xl),
                  _HeroEntrance(
                    delayMs: 140,
                    // 'Contact Us' is an existing string from this page's CTA
                    // band, reused. Delete this block if you want the hero to
                    // stay exactly as it was.
                    child: PrimaryButton(
                      text: 'Contact Us',
                      onPressed: () => _navigate('/contact'),
                      icon: LucideIcons.arrowRight,
                      large: true,
                      onDark: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------- business units ---
  Widget _businessUnitsSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      reveal: false,
      child: Column(
        children: [
          const RevealOnScroll(
            child: SectionHeader(
              title: 'Our Business Units',
              subtitle: 'Comprehensive solutions across multiple sectors',
            ),
          ),
          const SizedBox(height: Space.xxl),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 640
                  ? 1
                  : constraints.maxWidth < 1000
                      ? 2
                      : 4;
              const gap = Space.lg;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: List.generate(_businessUnits.length, (i) {
                  return SizedBox(
                    width: cardWidth,
                    // Computed widths end the childAspectRatio breakpoint
                    // hacks and the Clip.hardEdge that was masking overflow.
                    child: RevealOnScroll(
                      delayMs: 70 * i,
                      child: _unitCard(context, _businessUnits[i]),
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

  Widget _unitCard(BuildContext context, _Unit unit) {
    return AppCard(
      accent: unit.color,
      onTap: () => _navigate(unit.route),
      semanticLabel: '${unit.title}. ${unit.description}',
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: unit.icon, color: unit.color),
          const SizedBox(height: Space.lg),
          Text(unit.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Space.xs),
          Text(
            unit.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Space.lg),
          Row(
            children: [
              Text(
                'Learn more',
                style: AppType.theme.labelLarge?.copyWith(color: unit.color),
              ),
              const SizedBox(width: Space.xxs),
              Icon(LucideIcons.arrowRight, size: 15, color: unit.color),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- clients ---
  Widget _clientsSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      reveal: false,
      child: Column(
        children: [
          const RevealOnScroll(
            child: SectionHeader(
              title: 'Our Valued Clients',
              subtitle: 'Trusted by leading organizations across industries',
            ),
          ),
          const SizedBox(height: Space.xxl),
          RevealOnScroll(
            delayMs: 80,
            child: LogoMarquee(
              assetPaths: _clientLogos,
              logoHeight: isMobile ? 36 : 48,
              gap: isMobile ? 48 : 80,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ CTA band ---
  Widget _ctaBand(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: Palette.heroSurface),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: Palette.heroGlow),
            ),
          ),
          Padding(
            padding: Space.sectionPad(isMobile),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: RevealOnScroll(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ready to Collaborate?',
                        textAlign: TextAlign.center,
                        style: (isMobile
                                ? AppType.theme.headlineLarge
                                : AppType.theme.displaySmall)
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: Space.md),
                      Text(
                        "Let's build a sustainable future together.",
                        textAlign: TextAlign.center,
                        style: AppType.theme.bodyLarge
                            ?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: Space.xl),
                      PrimaryButton(
                        text: 'Contact Us',
                        onPressed: () => _navigate('/contact'),
                        icon: LucideIcons.arrowRight,
                        large: true,
                        onDark: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Unit {
  const _Unit(this.title, this.description, this.icon, this.route, this.color);
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;
}

/// One-shot entrance for hero elements (plays on load, not on scroll).
class _HeroEntrance extends StatefulWidget {
  const _HeroEntrance({required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<_HeroEntrance> createState() => _HeroEntranceState();
}

class _HeroEntranceState extends State<_HeroEntrance> {
  bool _in = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 80 + widget.delayMs), () {
      if (mounted) setState(() => _in = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) return widget.child;
    return AnimatedOpacity(
      opacity: _in ? 1 : 0,
      duration: Motion.slow,
      curve: Motion.enter,
      child: AnimatedSlide(
        offset: _in ? Offset.zero : const Offset(0, 0.18),
        duration: Motion.slow,
        curve: Motion.enter,
        child: widget.child,
      ),
    );
  }
}

/// Very faint grid overlay for hero texture.
class _GridTexture extends StatelessWidget {
  const _GridTexture();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GridPainter(), size: Size.infinite);
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) return;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;
    const step = 64.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}