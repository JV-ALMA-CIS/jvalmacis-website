// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jv_alma_cis/widgets/header.dart';
import 'package:jv_alma_cis/widgets/footer.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/section.dart';
import '../widgets/reveal_on_scroll.dart';

class CareersPage extends StatefulWidget {
  const CareersPage({super.key});

  @override
  State<CareersPage> createState() => _CareersPageState();
}

class _CareersPageState extends State<CareersPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Palette.heroSurface),
              padding: Space.sectionPad(isMobile),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Space.contentMax),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Careers at JV ALMA C.I.S',
                        style: (isMobile
                                ? Theme.of(context).textTheme.headlineLarge
                                : Theme.of(context).textTheme.displaySmall)
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Space.md),
                      Text(
                        'Join our team to shape the future of East Africa',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Space.sm),
                      Text(
                        'Be part of innovation and impact',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Intro Section
            SectionWrapper(
              background: Palette.n0,
              maxWidth: 900,
              child: Column(
                children: [
                  Text(
                    'Careers at JV ALMA C.I.S',
                    style: isMobile
                        ? Theme.of(context).textTheme.headlineLarge
                        : Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.md),
                  Text(
                    'Join us at JV ALMA C.I.S and become part of a leading team in Construction, Agribusiness, Oil & Gas Services and Technology Solutions.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.lg),
                  Text(
                    'Expertise, creativity, and commitment to excellence are the core values that drive everything we do.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Core Values
            SectionWrapper(
              background: Palette.n50,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Our Core Values',
                    subtitle: 'The foundation of our culture',
                  ),
                  const SizedBox(height: Space.xl),
                  GridView.count(
                    crossAxisCount: isMobile
                        ? 1
                        : isTablet
                            ? 2
                            : 3,
                    shrinkWrap: true,
                    crossAxisSpacing: Space.lg,
                    mainAxisSpacing: Space.lg,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isMobile ? 1.3 : 1.0,
                    children: const [
                      RevealOnScroll(
                        delayMs: 0,
                        child: _ValueCard(
                          icon: LucideIcons.target,
                          title: 'Excellence',
                          description:
                              'We strive for the highest standards in everything we do.',
                          iconColor: Palette.primary,
                        ),
                      ),
                      RevealOnScroll(
                        delayMs: 60,
                        child: _ValueCard(
                          icon: LucideIcons.lightbulb,
                          title: 'Innovation',
                          description:
                              'We embrace creativity to solve complex challenges.',
                          iconColor: Palette.it,
                        ),
                      ),
                      RevealOnScroll(
                        delayMs: 120,
                        child: _ValueCard(
                          icon: LucideIcons.users,
                          title: 'Teamwork',
                          description:
                              'We collaborate to achieve shared success.',
                          iconColor: Palette.agribusiness,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Open Positions Section
            const SectionWrapper(
              background: Palette.n0,
              maxWidth: 900,
              child: Column(
                children: [
                  SectionHeader(title: 'Open Positions'),
                  SizedBox(height: Space.xl),

                  // No open positions message
                  _NoOpenPositions(),
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

// New widget for empty state
class _NoOpenPositions extends StatelessWidget {
  const _NoOpenPositions();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      interactive: false,
      padding: const EdgeInsets.all(Space.xxl),
      child: Column(
        children: [
          const Icon(
            LucideIcons.briefcase,
            size: 64,
            color: Palette.n300,
          ),
          const SizedBox(height: Space.lg),
          Text(
            'No Open Positions at the Moment',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.md),
          Text(
            'We are always growing! Check back regularly or follow us on LinkedIn and Instagram for new opportunities.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.xl),
          Text(
            'You can still send your CV to hr@jvalmacis.co.ke\nWe\'ll keep it on file for future openings.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Palette.n500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Keep your existing _ValueCard widget unchanged
class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      interactive: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: icon, color: iconColor, size: 32),
          const SizedBox(height: Space.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
