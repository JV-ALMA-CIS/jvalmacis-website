import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../admin/modules/business_units/business_unit_model.dart';
import '../admin/modules/business_units/business_units_provider.dart';
import '../admin/modules/homepage/homepage_model.dart';
import '../admin/modules/homepage/homepage_provider.dart';
import '../admin/shared/color_key_registry.dart';
import '../admin/shared/icon_key_registry.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/cms_image.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/logo_marquee.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section.dart';

/// Home page.
///
/// Hero, business units, client logos and the CTA band are CMS-driven —
/// see [homepageProvider] and [businessUnitsProvider] — with the original
/// hardcoded copy kept as the fallback (`defaultHomepageContent` /
/// `defaultBusinessUnits`) shown while Firestore is loading or unreachable,
/// so this page never regresses to a blank state.
///
/// SCROLL FIX
/// The previous version rebuilt the entire page tree on every scroll tick
/// (`setState` inside the ScrollController listener). Combined with the
/// marquee's repeating AnimationController this starved the scroll gesture
/// and made the page feel stuck. Parallax now runs through a ValueNotifier
/// that rebuilds the hero image only.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scroll = ScrollController();

  /// Drives hero parallax without rebuilding the rest of the page.
  final ValueNotifier<double> _heroOffset = ValueNotifier<double>(0);

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

    final content = ref.watch(homepageProvider).valueOrNull ?? defaultHomepageContent;
    // An unseeded (but reachable) Firestore collection resolves to an empty
    // list, not null — falling back on nullness alone would leave the
    // section with zero cards instead of the intended default content.
    final liveUnits = ref.watch(businessUnitsProvider).valueOrNull;
    final featuredUnits = List<BusinessUnit>.of(
      (liveUnits == null || liveUnits.isEmpty) ? defaultBusinessUnits : liveUnits,
    )
      ..removeWhere((u) => !u.published || !u.featured)
      ..sort((a, b) => a.order.compareTo(b.order));
    final clientLogos = List<ClientLogo>.of(content.clientLogos)
      ..sort((a, b) => a.order.compareTo(b.order));

    return AppScaffold(
      body: SingleChildScrollView(
        controller: _scroll,
        // Guarantees the view is always draggable even when content is short.
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _hero(context, isMobile, content),
            _businessUnitsSection(context, isMobile, featuredUnits),
            _clientsSection(context, isMobile, clientLogos),
            _ctaBand(context, isMobile, content),
            const Footer(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- hero ---
  Widget _hero(BuildContext context, bool isMobile, HomepageContent content) {
    final height = isMobile ? 520.0 : 640.0;
    final reduced = Motion.reduced(context);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Parallax is isolated: only this subtree rebuilds on scroll.
          // A one-shot Ken Burns zoom (1.08 → 1.0) plays on load, independent
          // of the scroll-driven parallax scale below — the hero shouldn't
          // sit static until the visitor starts scrolling.
          RepaintBoundary(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: reduced ? 1.0 : 1.08, end: 1.0),
              duration: Motion.slow * 2,
              curve: Motion.enter,
              builder: (context, introScale, child) {
                return ValueListenableBuilder<double>(
                  valueListenable: _heroOffset,
                  builder: (context, offset, child) {
                    if (reduced) return child!;
                    return Transform.translate(
                      offset: Offset(0, offset * 0.25),
                      child: Transform.scale(
                        scale: introScale + (offset / 6000),
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              },
              child: CmsImage(
                source: content.heroBackgroundImageUrl,
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
                      content.heroTitle,
                      style: AppType.theme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: AppType.fluid(context, min: 32, max: 58),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.xl),
                  _HeroEntrance(
                    delayMs: 140,
                    child: PrimaryButton(
                      text: content.heroCtaText,
                      onPressed: () => _navigate(content.heroCtaRoute),
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
  Widget _businessUnitsSection(BuildContext context, bool isMobile, List<BusinessUnit> units) {
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
                      : units.length.clamp(1, 4);
              const gap = Space.lg;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: List.generate(units.length, (i) {
                  return SizedBox(
                    width: cardWidth,
                    // Computed widths end the childAspectRatio breakpoint
                    // hacks and the Clip.hardEdge that was masking overflow.
                    child: RevealOnScroll(
                      delayMs: 70 * i,
                      child: _unitCard(context, units[i]),
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

  Widget _unitCard(BuildContext context, BusinessUnit unit) {
    final color = ColorKeyRegistry.resolve(unit.accentColorKey);
    return AppCard(
      accent: color,
      onTap: () => _navigate(unit.route),
      semanticLabel: '${unit.title}. ${unit.tagline}',
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: IconKeyRegistry.resolve(unit.iconKey), color: color),
          const SizedBox(height: Space.lg),
          Text(unit.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Space.xs),
          Text(
            unit.tagline,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Space.lg),
          Row(
            children: [
              Text(
                'Learn more',
                style: AppType.theme.labelLarge?.copyWith(color: color),
              ),
              const SizedBox(width: Space.xxs),
              Icon(LucideIcons.arrowRight, size: 15, color: color),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- clients ---
  Widget _clientsSection(BuildContext context, bool isMobile, List<ClientLogo> logos) {
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
              assetPaths: logos.map((l) => l.imageUrl).toList(),
              logoHeight: isMobile ? 36 : 48,
              gap: isMobile ? 48 : 80,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ CTA band ---
  Widget _ctaBand(BuildContext context, bool isMobile, HomepageContent content) {
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
                        content.ctaBandTitle,
                        textAlign: TextAlign.center,
                        style: (isMobile
                                ? AppType.theme.headlineLarge
                                : AppType.theme.displaySmall)
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: Space.md),
                      Text(
                        content.ctaBandSubtitle,
                        textAlign: TextAlign.center,
                        style: AppType.theme.bodyLarge
                            ?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: Space.xl),
                      PrimaryButton(
                        text: content.ctaBandButtonText,
                        onPressed: () => _navigate(content.ctaBandButtonRoute),
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
    Future.delayed(Duration(milliseconds: 120 + widget.delayMs), () {
      if (mounted) setState(() => _in = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) return widget.child;
    final duration = Motion.slow + const Duration(milliseconds: 250);
    return AnimatedOpacity(
      opacity: _in ? 1 : 0,
      duration: duration,
      curve: Motion.enter,
      child: AnimatedSlide(
        offset: _in ? Offset.zero : const Offset(0, 0.4),
        duration: duration,
        curve: Motion.enter,
        child: AnimatedScale(
          scale: _in ? 1.0 : 0.94,
          duration: duration,
          curve: Motion.enter,
          child: widget.child,
        ),
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