import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';
import 'dart:developer' as developer;

class OilAndGasServicesDetail extends StatelessWidget {
  const OilAndGasServicesDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 600;

        return AppScaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
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
                            developer.log('OilAndGasServicesDetail: Navigating back to /business-units', name: 'OilAndGasServicesDetail');
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/business-units',
                              (route) => false,
                            );
                          },
                          tooltip: 'Back to Business Units',
                        ),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 896),
                            child: Column(
                              children: [
                                Text(
                                  'Oil & Gas Services',
                                  style: (isMobile
                                          ? Theme.of(context).textTheme.headlineLarge
                                          : Theme.of(context).textTheme.displaySmall)
                                      ?.copyWith(color: Palette.n0),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: Space.md),
                                Text(
                                  'Comprehensive solution across the oil & gas services sector, powered by partnerships and decades of expertise.',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white70,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildAboutAndSubsidiariesSection(context, isMobile, screenWidth),
                _buildServicesSection(context, isMobile),
                _buildCertificationsAndClientsSection(context, isMobile),
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutAndSubsidiariesSection(BuildContext context, bool isMobile, double screenWidth) {
    return SectionWrapper(
      background: Palette.n0,
      topRule: Palette.oilGas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'JV ALMA C.I.S',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.ink,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: ' based on the experience in construction of oil and gas pipelines ventured as shareholders together with ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.n600,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: 'BRISMA AFRICA',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.ink,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: ' and ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.n600,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: 'TIC GROUP',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.ink,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: ' to create ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.n600,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: 'TIC East Africa',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.ink,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                ),
                TextSpan(
                  text: '. TIC EA is a company specializing in inspection services, built on the extensive experience of the TIC Group a global organization with a presence in multiple countries and a workforce of over 500 employees, 70% of whom are specialized technicians.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Palette.n600,
                        height: 1.6,
                      ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 300 : 400),
              child: Semantics(
                label: 'TIC East Africa overview image',
                child: Image.asset(
                  'assets/images/tic/tic_1.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.xl),
          Text(
            'Subsidiaries',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.md),
          // Featured Subsidiary and Other Subsidiaries
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Subsidiary',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Space.sm),
                    _buildFeaturedSubsidiary(context, isMobile, screenWidth),
                    const SizedBox(height: Space.lg),
                    Text(
                      'Other Subsidiaries',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Space.sm),
                    Semantics(
                      label: 'Other subsidiaries list',
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildOtherSubsidiariesList(context, isMobile),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Subsidiary',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: Space.sm),
                          _buildFeaturedSubsidiary(context, isMobile, screenWidth),
                        ],
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Other Subsidiaries',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: Space.sm),
                          Semantics(
                            label: 'Other subsidiaries list',
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildOtherSubsidiariesList(context, isMobile),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: Space.lg),
          // Map of All Subsidiaries
          Text(
            'Our Global Presence',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: Space.sm),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 500),
              child: Semantics(
                label: 'Map of all TIC subsidiaries',
                child: Image.asset(
                  'assets/images/tic/tic_2.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          Text(
            'a. Inspection and integrity management',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          Text(
            "• TIC EA guarantees the information and resources needed to ensure the safety of customers' activities and products. • TIC EA is a leader in facility integrity and risk management for the oil and gas industry.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Palette.n600,
                  height: 1.6,
                ),
            textAlign: TextAlign.left,
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 300 : 400),
              child: Semantics(
                label: 'Inspection and integrity management',
                child: Image.asset(
                  'assets/images/tic/tic_3.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          Text(
            'b. Non-Destructive Examination',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          Text(
            '• TIC EA specializes in non-destructive testing of materials and metal structures. Customers trust us for. Characterize the state of integrity of their equipment, without damaging it, either during production, use or maintenance.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Palette.n600,
                  height: 1.6,
                ),
            textAlign: TextAlign.left,
          ),
          Text(
            '• Our inspectors are certified, empowered and qualified to international standards. Thanks to a wide range of conventional and advanced control methods, we offer a high value-added service that helps to control risks and reduce lead times and costs.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Palette.n600,
                  height: 1.6,
                ),
            textAlign: TextAlign.left,
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 300 : 400),
              child: Semantics(
                label: 'Non-Destructive Examination',
                child: Image.asset(
                  'assets/images/tic/tic_4.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          Text(
            'c. Regulatory Compliance Services',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          Text(
            '• Regulatory auditing and inspection at TIC EA is a service-focused process that goes beyond routine compliance checks. Its purpose is to identify and address a range of risks that can directly impact operational safety, integrity, and continuity.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Palette.n600,
                  height: 1.6,
                ),
            textAlign: TextAlign.left,
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 300 : 400),
              child: Semantics(
                label: 'Regulatory Compliance Services',
                child: Image.asset(
                  'assets/images/tic/tic_5.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsAndClientsSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Certifications',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 300 : 400),
              child: Semantics(
                label: 'Certifications',
                child: Image.asset(
                  'assets/images/tic/tic_6.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.xl),
          Text(
            'Clients',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: Space.sm),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 500 : 700),
              child: Semantics(
                label: 'Clients',
                child: Image.asset(
                  'assets/images/tic/tic_7.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSubsidiary(BuildContext context, bool isMobile, double screenWidth) {
    return RevealOnScroll(
      child: AppCard(
        interactive: false,
        accent: Palette.oilGas,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Semantics(
                  label: 'TIC East Africa',
                  child: Image.asset(
                    'assets/images/subsidiaries/TIC-ea.jpg',
                    fit: BoxFit.contain,
                    height: isMobile ? 150 : 200,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 16, color: Palette.n600),
                  const SizedBox(width: Space.xs),
                  Expanded(
                    child: Text(
                      'TIC East Africa - Kenya/2022',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.sm),
              Text(
                'Address: 5th-floor Brisma Towers, Off Magadi 74429-00200 Nairobi, Kenya',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: Space.xxs),
              Text(
                'Phone: +254 72 28 46 458',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: Space.xxs),
              Text(
                'Email: tic@tic-inspectiongroup.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOtherSubsidiariesList(BuildContext context, bool isMobile) {
    final otherSubsidiaries = [
      {
        'title': 'Technique Inspection & Contrôle - Tunisia/1993',
        'phone': '+216 71 180 140',
        'email': 'tic@tic-inspectiongroup.com',
      },
      {
        'title': 'TIC Gabon - Gabon/2014',
        'phone': '+241 01 53 08 52',
        'email': 'contact@tic-ga.com',
      },
      {
        'title': 'TIC JSC - Libya/2003',
        'phone': '+218 21 44 40 504',
        'email': 'tic@tic-inspectiongroup.com',
      },
      {
        'title': 'ICT Algeria - Algeria/2023',
        'phone': '+213 (0) 23 469 808',
        'email': null,
      },
      {
        'title': 'TIC Gc - Tunisia/2010',
        'phone': '+216 71 180 029',
        'email': 'ticgc@tic-inspectiongroup.com',
      },
      {
        'title': 'CETIM International Engineering Services - 2008',
        'phone': null,
        'email': null,
      },
      {
        'title': 'Advanced inspection services - KSA/2010',
        'phone': '+966 (3) 340 1100 (Extn 112)',
        'email': 'info@ais-ksa.com',
      },
    ];

    return otherSubsidiaries.asMap().entries.map((entry) {
      final index = entry.key;
      final subsidiary = entry.value;
      return RevealOnScroll(
        delayMs: 60 * index,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.mapPin, size: 14, color: Palette.n600),
              const SizedBox(width: Space.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subsidiary['title'] as String,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Space.xxs),
                    if (subsidiary['phone'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: Space.md, bottom: 2.0),
                        child: Text(
                          '• Phone: ${subsidiary['phone']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                        ),
                      ),
                    if (subsidiary['email'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: Space.md, bottom: 2.0),
                        child: Text(
                          '• Email: ${subsidiary['email']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
