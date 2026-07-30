// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/header.dart';
import '../../widgets/footer.dart';
import '../../widgets/responsive_utils.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';

class KilimoMkononiLandingPage extends StatelessWidget {
  const KilimoMkononiLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ResponsiveUtils.mobileBreakpoint;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Palette.heroSurface),
              padding: Space.sectionPad(isMobile),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        LucideIcons.arrowLeft,
                        color: Palette.n0,
                        size: isMobile ? 20 : 24,
                      ),
                      onPressed: () {
                        debugPrint('KilimoMkononiLandingPage: Navigating back');
                        Navigator.pop(context);
                      },
                      tooltip: 'Back',
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1000),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.sprout,
                              size: isMobile ? 48 : 64,
                              color: Palette.agribusiness,
                            ),
                            const SizedBox(height: Space.md),
                            Text(
                              'Kilimo Mkononi',
                              style: (isMobile
                                      ? Theme.of(context).textTheme.headlineLarge
                                      : Theme.of(context).textTheme.displaySmall)
                                  ?.copyWith(color: Palette.n0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.sm),
                            Text(
                              'Farming in the Palm of Your Hand',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.md),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: Text(
                                'Choose the platform that fits your needs - whether you\'re a professional farmer looking to optimize your operations or an educator bringing agricultural learning to your students.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.7),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Platform Selection Cards
            SectionWrapper(
              background: Palette.n0,
              topRule: Palette.it,
              child: isMobile
                  ? Column(
                      children: [
                        RevealOnScroll(
                          delayMs: 0,
                          child: _buildPlatformCard(
                            context,
                            isMobile,
                            title: 'Kilimo Mkononi Enterprise',
                            subtitle: 'For Farmers & Agricultural Businesses',
                            description:
                                'Professional farming solutions with market insights, weather forecasting, pest management, and financial tracking tools.',
                            icon: LucideIcons.wheat,
                            iconColor: Palette.agribusiness,
                            highlights: [
                              'Real-time market prices',
                              'Comprehensive pest & disease management',
                              'Farm Management Financial planning tools',
                              'Expert farming guidance',
                              'Comprehensive field data input & analysis',
                            ],
                            route: '/kilimo-mkononi-enterprise',
                            buttonText: 'Explore Enterprise',
                            badge: 'Available Now',
                          ),
                        ),
                        const SizedBox(height: Space.lg),
                        RevealOnScroll(
                          delayMs: 60,
                          child: _buildPlatformCard(
                            context,
                            isMobile,
                            title: 'Kilimo Mkononi Education',
                            subtitle: 'For Schools & Educational Institutions',
                            description:
                                'Interactive agricultural learning platform with quizzes, simulations, and built-in student protection features.',
                            icon: LucideIcons.graduationCap,
                            iconColor: Palette.it,
                            highlights: [
                              'Safe, verified user system',
                              'Interactive quizzes & simulations',
                              'Teacher-created content',
                              'Progress tracking & reporting',
                            ],
                            route: '/kilimo-mkononi-education',
                            buttonText: 'Learn About Education',
                            badge: 'Coming Soon',
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 0,
                            child: _buildPlatformCard(
                              context,
                              isMobile,
                              title: 'Kilimo Mkononi Enterprise',
                              subtitle: 'For Farmers & Agricultural Businesses',
                              description:
                                  'Professional farming solutions with market insights, weather forecasting, pest management, and financial tracking tools.',
                              icon: LucideIcons.wheat,
                              iconColor: Palette.agribusiness,
                              highlights: [
                                'Real-time market prices',
                                'Comprehensive pest & disease management',
                                'Farm Management Financial planning tools',
                                'Expert farming guidance',
                                'Comprehensive field data input & analysis',
                              ],
                              route: '/kilimo-mkononi-enterprise',
                              buttonText: 'Explore Enterprise',
                              badge: 'Available Now',
                            ),
                          ),
                        ),
                        const SizedBox(width: Space.lg),
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 60,
                            child: _buildPlatformCard(
                              context,
                              isMobile,
                              title: 'Kilimo Mkononi Education',
                              subtitle: 'For Schools & Educational Institutions',
                              description:
                                  'Interactive agricultural learning platform with quizzes, simulations, and built-in student protection features.',
                              icon: LucideIcons.graduationCap,
                              iconColor: Palette.it,
                              highlights: [
                                'Safe, verified user system',
                                'Interactive quizzes & simulations',
                                'Teacher-created content',
                                'Progress tracking & reporting',
                              ],
                              route: '/kilimo-mkononi-education',
                              buttonText: 'Learn About Education',
                              badge: 'Coming Soon',
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            // Shared Features Section
            SectionWrapper(
              background: Palette.n50,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Shared Core Features',
                    subtitle:
                        'Both platforms are built on the same powerful foundation of agricultural knowledge and tools.',
                    accent: Palette.it,
                  ),
                  const SizedBox(height: Space.xl),
                  _buildSharedFeaturesGrid(context, isMobile),
                ],
              ),
            ),

            const SizedBox(height: Space.xl),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformCard(
    BuildContext context,
    bool isMobile, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color iconColor,
    required List<String> highlights,
    required String route,
    required String buttonText,
    required String badge,
  }) {
    final bool isComingSoon = badge == 'Coming Soon';

    void onNavigate() {
      debugPrint('KilimoMkononiLandingPage: Navigating to $route');
      Navigator.pushNamed(context, route);
    }

    return AppCard(
      accent: Palette.it,
      onTap: onNavigate,
      semanticLabel: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconChip(icon: icon, color: iconColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xxs),
                decoration: BoxDecoration(
                  color: isComingSoon
                      ? Palette.n400.withValues(alpha: 0.15)
                      : Palette.success.withValues(alpha: 0.12),
                  borderRadius: Radii.chip,
                ),
                child: Text(
                  badge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isComingSoon ? Palette.n500 : Palette.success,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.lg),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Space.xxs),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.n500),
          ),
          const SizedBox(height: Space.md),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Space.lg),
          Text(
            'Key Highlights',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: Space.sm),
          ...highlights.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.checkCircle2,
                    size: 16,
                    color: Palette.agribusiness,
                  ),
                  const SizedBox(width: Space.xs),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: Space.lg),
          PrimaryButton(
            text: buttonText,
            icon: LucideIcons.arrowRight,
            onPressed: onNavigate,
            expand: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSharedFeaturesGrid(BuildContext context, bool isMobile) {
    final features = [
      {
        'icon': LucideIcons.cloudSun,
        'title': 'Weather Forecasting',
        'description': '5-day forecasts for better planning',
        'color': Palette.agribusiness,
      },
      {
        'icon': LucideIcons.trendingUp,
        'title': 'Market Insights',
        'description': 'Real-time agricultural market data',
        'color': Palette.it,
      },
      {
        'icon': LucideIcons.bug,
        'title': 'Pest & Disease Management',
        'description': 'Identification and control strategies',
        'color': Palette.agribusiness,
      },
      {
        'icon': LucideIcons.sprout,
        'title': 'Farming Guidance',
        'description': 'Expert tips for multiple crops',
        'color': Palette.agribusiness,
      },
      {
        'icon': LucideIcons.leafyGreen,
        'title': 'Filed Data input ',
        'description': 'Testing and fertility recommendations',
        'color': Palette.agribusiness,
      },
      {
        'icon': LucideIcons.calculator,
        'title': 'Financial Farm Management Tracking',
        'description': 'Manage cost of production, revenues and loans',
        'color': Palette.it,
      },
      {
        'icon': LucideIcons.bookOpen,
        'title': 'Agricultural Manuals',
        'description': 'Comprehensive farming resources',
        'color': Palette.it,
      },
    ];

    return Wrap(
      spacing: isMobile ? Space.sm : Space.lg,
      runSpacing: isMobile ? Space.sm : Space.lg,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        return RevealOnScroll(
          delayMs: 60 * index,
          child: SizedBox(
            width: isMobile ? (MediaQuery.of(context).size.width - 40) / 2 : 180,
            child: AppCard(
              interactive: false,
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                children: [
                  IconChip(
                    icon: feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: isMobile ? 24 : 28,
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    feature['title'] as String,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    feature['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
