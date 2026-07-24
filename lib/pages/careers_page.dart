// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:jv_alma_cis/widgets/header.dart';
import 'package:jv_alma_cis/widgets/custom_card.dart';
import 'package:jv_alma_cis/widgets/footer.dart';

class CareersPage extends StatefulWidget {
  const CareersPage({super.key});

  @override
  State<CareersPage> createState() => _CareersPageState();
}

class _CareersPageState extends State<CareersPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
            ClipRRect(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: isMobile ? screenHeight * 0.7 : screenHeight * 0.6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? screenHeight * 0.06 : screenHeight * 0.08,
                  horizontal: screenWidth * 0.04,
                ),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: isMobile ? screenWidth * 0.95 : 1200),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Careers at JV ALMA C.I.S',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: isMobile ? 24 : 32,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Join our team to shape the future of East Africa',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: const Color(0xFFBFDBFE),
                                fontSize: isMobile ? 14 : 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          'Be part of innovation and impact',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: const Color(0xFFBFDBFE),
                                fontSize: isMobile ? 12 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Intro Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? screenHeight * 0.03 : screenHeight * 0.06,
                horizontal: screenWidth * 0.04,
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: isMobile ? screenWidth * 0.95 : 1200),
                child: Column(
                  children: [
                    Text(
                      'Careers at JV ALMA C.I.S',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                            color: const Color(0xFF111827),
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Join us at JV ALMA C.I.S and become part of a leading team in Construction, Agribusiness, Oil & Gas Services and Technology Solutions.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF4B5563),
                            fontSize: isMobile ? 14 : 16,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Expertise, creativity, and commitment to excellence are the core values that drive everything we do.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF111827),
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Core Values
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.06,
                horizontal: screenWidth * 0.04,
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: isMobile ? screenWidth * 0.95 : 1200),
                child: CustomCard(
                  content: Padding(
                    padding: EdgeInsets.all(
                        isMobile ? screenWidth * 0.06 : screenWidth * 0.04),
                    child: Column(
                      children: [
                        Text(
                          'Our Core Values',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: const Color(0xFF1F2937),
                                fontSize: isMobile ? 20 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'The foundation of our culture',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF4B5563),
                                fontSize: isMobile ? 14 : 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        GridView.count(
                          crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                          shrinkWrap: true,
                          crossAxisSpacing: screenWidth * 0.04,
                          mainAxisSpacing: screenHeight * 0.03,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _ValueCard(
                              icon: LucideIcons.target,
                              title: 'Excellence',
                              description:
                                  'We strive for the highest standards in everything we do.',
                              iconColor: const Color(0xFF2563EB),
                              fontSize: isMobile ? 14 : 16,
                              isMobile: isMobile,
                            ),
                            _ValueCard(
                              icon: LucideIcons.lightbulb,
                              title: 'Innovation',
                              description:
                                  'We embrace creativity to solve complex challenges.',
                              iconColor: const Color(0xFF9333EA),
                              fontSize: isMobile ? 14 : 16,
                              isMobile: isMobile,
                            ),
                            _ValueCard(
                              icon: LucideIcons.users,
                              title: 'Teamwork',
                              description:
                                  'We collaborate to achieve shared success.',
                              iconColor: const Color(0xFF16A34A),
                              fontSize: isMobile ? 14 : 16,
                              isMobile: isMobile,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Open Positions Section
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.06,
                horizontal: screenWidth * 0.04,
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: isMobile ? screenWidth * 0.95 : 1200),
                child: Column(
                  children: [
                    Text(
                      'Open Positions',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: const Color(0xFF111827),
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // No open positions message
                    _NoOpenPositions(isMobile: isMobile),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

// New widget for empty state
class _NoOpenPositions extends StatelessWidget {
  final bool isMobile;

  const _NoOpenPositions({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Padding(
        padding: EdgeInsets.all(isMobile ? 32 : 48),
        child: Column(
          children: [
            Icon(
              LucideIcons.briefcase,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'No Open Positions at the Moment',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'We are always growing! Check back regularly or follow us on LinkedIn and Instagram for new opportunities.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'You can still send your CV to hr@jvalmacis.co.ke\nWe\'ll keep it on file for future openings.',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: isMobile ? 14 : 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    required this.fontSize,
    required this.isMobile,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final double fontSize;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomCard(
      hoverEffect: false,
      content: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    fontSize: fontSize,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4B5563),
                    fontSize: fontSize - 2,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}