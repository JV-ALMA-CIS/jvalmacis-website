// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/section.dart';
import '../widgets/reveal_on_scroll.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Text(
                        'About JV ALMA C.I.S',
                        style: (isMobile
                                ? Theme.of(context).textTheme.headlineLarge
                                : Theme.of(context).textTheme.displaySmall)
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Space.md),
                      Text(
                        'Building Africa\'s future through excellence in construction, agribusiness, oil & gas services, and information technology',
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
            ),

            // Company Overview - Brief Story
            _buildCompanyOverviewSection(context, isMobile),

            // Timeline with CORRECT data
            _buildTimelineSection(context, isMobile),

            // Mission & Vision
            _buildMissionVisionSection(context, isMobile),

            // Featured Projects Across Divisions
            _buildFeaturedProjectsSection(context, isMobile, isTablet),

            const Footer(),
          ],
        ),
      ),
    );
  }

  // ===== COMPANY OVERVIEW (CORRECTED) =====
  Widget _buildCompanyOverviewSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      maxWidth: 900,
      child: Column(
        children: [
          const SectionHeader(title: 'Our Story', align: TextAlign.center, eyebrow: null, subtitle: null),
          const SizedBox(height: Space.lg),
          Text(
            'Founded in 2017, JV ALMA C.I.S has rapidly grown into a trusted multi-sector company serving construction, agribusiness, oil & gas services, and information technology across East Africa. In just seven years, we have established ourselves as a leader in delivering high-quality projects and innovative solutions.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.sm),
          Text(
            'Our success is built on the foundation of technical expertise, community engagement, and a commitment to sustainable impact. Whether building critical infrastructure, empowering farmers through sustainable agriculture, ensuring regulatory compliance in oil & gas, or delivering innovative digital solutions, we bring the same dedication to excellence in everything we do.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ===== TIMELINE (CORRECTED WITH ACTUAL DATA) =====
  Widget _buildTimelineSection(BuildContext context, bool isMobile) {
    final milestones = [
      {
        'year': '2017',
        'event': 'Company Founded',
        'detail': 'JV ALMA C.I.S Kenya was established with a focus on construction services.'
      },
      {
        'year': '2021',
        'event': 'Expansion into Agribusiness',
        'detail': 'Diversified operations to include agricultural solutions and climate resilience programs.'
      },
      {
        'year': '2022',
        'event': 'Oil & Gas Services Launch',
        'detail': 'Entered the energy sector with professional inspection and partnership services.'
      },
      {
        'year': '2024',
        'event': 'IT Division Established',
        'detail':
            'Launched technology solutions including NyumbaSmart CMMS management software, Kilimo Mkononi platform and CoffeeCore platform systems.'
      },
    ];

    return SectionWrapper(
      background: Palette.n0,
      maxWidth: 900,
      child: Column(
        children: [
          const SectionHeader(title: 'Our Journey'),
          const SizedBox(height: Space.xl),
          // Timeline
          ...milestones.asMap().entries.map((entry) {
            final index = entry.key;
            final milestone = entry.value;
            final isLast = index == milestones.length - 1;

            return RevealOnScroll(
              delayMs: 60 * index,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline dot and line
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.primary,
                          border: Border.all(
                            color: Palette.n0,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 60,
                          color: Palette.n200,
                        ),
                    ],
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: Space.lg, bottom: Space.xxxl - 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            milestone['year']!,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Palette.primary,
                                ),
                          ),
                          const SizedBox(height: Space.xxs),
                          Text(
                            milestone['event']!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: Space.xxs),
                          Text(
                            milestone['detail']!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ===== MISSION & VISION =====
  Widget _buildMissionVisionSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        children: [
          const SectionHeader(title: 'Our Purpose'),
          const SizedBox(height: Space.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RevealOnScroll(
                  delayMs: 0,
                  child: _buildPurposeCard(
                    context,
                    'Our Mission',
                    'To deliver exceptional infrastructure, services, and digital solutions that drive sustainable development across East Africa.',
                    LucideIcons.target,
                    Palette.primary,
                    isMobile,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? Space.sm : Space.lg),
              Expanded(
                child: RevealOnScroll(
                  delayMs: 60,
                  child: _buildPurposeCard(
                    context,
                    'Our Vision',
                    'To be the region\'s most trusted partner for integrated solutions—connecting communities, businesses, and opportunities.',
                    LucideIcons.eye,
                    Palette.success,
                    isMobile,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return AppCard(
      interactive: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: icon, color: color),
          const SizedBox(height: Space.lg),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Space.sm),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // ===== FEATURED PROJECTS =====
  Widget _buildFeaturedProjectsSection(BuildContext context, bool isMobile, bool isTablet) {
    final projects = [
      {
        'title': 'US Embassy Renovation',
        'division': 'Construction',
        'image': 'assets/images/construction/american_center_1.jpg',
      },
      {
        'title': 'Sigor Wei Wei Irrigation',
        'division': 'Agribusiness',
        'image': 'assets/images/agribusiness/sigor_1.jpg',
      },
      {
        'title': 'NyumbaSmart CMMS',
        'division': 'IT Solutions',
        'image': 'assets/apk/cmms_overview.jpg',
      },
    ];

    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        children: [
          const SectionHeader(
            title: 'Featured Work',
            subtitle: 'Representative projects across our divisions',
          ),
          const SizedBox(height: Space.xl),
          if (isMobile)
            Column(
              children: projects
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: Space.md),
                        child: RevealOnScroll(
                          delayMs: 60 * entry.key,
                          child: _buildFeaturedProjectCard(context, entry.value, isMobile),
                        ),
                      ))
                  .toList(),
            )
          else
            Row(
              children: projects
                  .asMap()
                  .entries
                  .map((entry) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Space.xs),
                          child: RevealOnScroll(
                            delayMs: 60 * entry.key,
                            child: _buildFeaturedProjectCard(context, entry.value, isMobile),
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProjectCard(
    BuildContext context,
    Map<String, dynamic> project,
    bool isMobile,
  ) {
    return AppCard(
      interactive: false,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.lg)),
            child: Container(
              height: isMobile ? 180 : 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(project['image']),
                  fit: BoxFit.cover,
                ),
                color: Palette.n200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['division'],
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Palette.primary),
                ),
                const SizedBox(height: Space.xxs),
                Text(
                  project['title'],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
