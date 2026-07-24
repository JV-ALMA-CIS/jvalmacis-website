// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 40 : 64,
                horizontal: isMobile ? 16 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Text(
                        'About JV ALMA C.I.S',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontSize: isMobile ? 28 : 40,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Building Africa\'s future through excellence in construction, agribusiness, oil & gas services, and information technology',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFFBFDBFE),
                              fontSize: isMobile ? 14 : 16,
                            ),
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
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 40,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text(
                'Our Story',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Founded in 2017, JV ALMA C.I.S has rapidly grown into a trusted multi-sector company serving construction, agribusiness, oil & gas services, and information technology across East Africa. In just seven years, we have established ourselves as a leader in delivering high-quality projects and innovative solutions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 13 : 15,
                      color: const Color(0xFF4B5563),
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Our success is built on the foundation of technical expertise, community engagement, and a commitment to sustainable impact. Whether building critical infrastructure, empowering farmers through sustainable agriculture, ensuring regulatory compliance in oil & gas, or delivering innovative digital solutions, we bring the same dedication to excellence in everything we do.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 13 : 15,
                      color: const Color(0xFF4B5563),
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
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

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 40,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text(
                'Our Journey',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Timeline
              ...milestones.asMap().entries.map((entry) {
                final index = entry.key;
                final milestone = entry.value;
                final isLast = index == milestones.length - 1;

                return Row(
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
                            color: const Color(0xFF2563EB),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 60,
                            color: const Color(0xFFE5E7EB),
                          ),
                      ],
                    ),
                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              milestone['year']!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile ? 13 : 15,
                                    color: const Color(0xFF2563EB),
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              milestone['event']!,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              milestone['detail']!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: isMobile ? 12 : 14,
                                    color: const Color(0xFF6B7280),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ===== MISSION & VISION =====
  Widget _buildMissionVisionSection(BuildContext context, bool isMobile) {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 40,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Our Purpose',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPurposeCard(
                      context,
                      'Our Mission',
                      'To deliver exceptional infrastructure, services, and digital solutions that drive sustainable development across East Africa.',
                      LucideIcons.target,
                      const Color(0xFF2563EB),
                      isMobile,
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 24),
                  Expanded(
                    child: _buildPurposeCard(
                      context,
                      'Our Vision',
                      'To be the region\'s most trusted partner for integrated solutions—connecting communities, businesses, and opportunities.',
                      LucideIcons.eye,
                      const Color(0xFF059669),
                      isMobile,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isMobile ? 13 : 14,
                    color: const Color(0xFF4B5563),
                    height: 1.6,
                  ),
            ),
          ],
        ),
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

    return Container(
      color: const Color(0xFFF9FAFB),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 40,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Featured Work',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Representative projects across our divisions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 13 : 14,
                      color: const Color(0xFF6B7280),
                    ),
              ),
              const SizedBox(height: 32),
              if (isMobile)
                Column(
                  children: projects
                      .map((project) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFeaturedProjectCard(context, project, isMobile),
                          ))
                      .toList(),
                )
              else
                Row(
                  children: projects
                      .map((project) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _buildFeaturedProjectCard(context, project, isMobile),
                            ),
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProjectCard(
    BuildContext context,
    Map<String, dynamic> project,
    bool isMobile,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isMobile ? 180 : 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(project['image']),
                fit: BoxFit.cover,
              ),
              color: Colors.grey[200],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['division'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project['title'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 15,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}