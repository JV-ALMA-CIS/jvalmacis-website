import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';
import '../it/cmms_page.dart';

class ConstructionDetail extends StatelessWidget {
  const ConstructionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                        debugPrint('ConstructionDetail: Navigating back to /business-units');
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
                              'Construction & Facility Management',
                              style: (isMobile
                                      ? Theme.of(context).textTheme.headlineLarge
                                      : Theme.of(context).textTheme.displaySmall)
                                  ?.copyWith(color: Palette.n0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.md),
                            Text(
                              'Comprehensive solutions across construction and facility management sectors, powered by cutting-edge technology and decades of expertise.',
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
            _buildConstructionSection(context, screenWidth, isMobile),
            _buildFacilitySection(context, screenWidth, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildConstructionSection(BuildContext context, double screenWidth, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      topRule: Palette.construction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconChip(icon: LucideIcons.building2, color: Palette.construction),
              const SizedBox(width: Space.sm),
              Text(
                'Construction Services',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: Space.lg),
          _buildConstructionContent(context, screenWidth, isMobile),
        ],
      ),
    );
  }

  Widget _buildConstructionContent(BuildContext context, double screenWidth, bool isMobile) {
    const List<Map<String, String>> features = [
      {
        'title': 'Construction Projects',
        'description': 'Specialized upgrades for embassies and infrastructure with a focus on security and precision.',
      },
      {
        'title': 'Facility Management',
        'description': 'Comprehensive services enhanced by proprietary CMMS software for operational efficiency.',
      },
      {
        'title': 'CMMS Integration',
        'description': 'Advanced maintenance management with real-time asset tracking and preventive scheduling.',
      },
    ];

    final List<Map<String, dynamic>> projects = [
      {
        'title': 'United States Embassy - American Center Renov, Nairobi.',
        'client': 'Embassy of United States in Kenya',
        'period': 'Sep 2021 – May 2022',
        'description': 'Comprehensive renovation and interior redesign of the ground floor of the Embassy of the United States in Kenya, transforming it into a modern, multifunctional space. The scope included reconfiguration of key areas such as the Maker Lab, Education USA Workroom, Main Program Space, and Staff Offices.',
        'testimonial': '"Our team delivered an innovative and adaptable space that reflects American values while embracing local culture—a seamless fusion of design and function." — Piergiorgio Di Carmine JV ALMA C.I.S.',
        'imagePaths': [
          'assets/images/construction/american_center_1.jpg',
          'assets/images/construction/american_center_2.jpg',
          'assets/images/construction/american_center_3.jpg',
        ],
      },
      {
        'title': 'United States Embassy - Rosslyn Ridge Renov, Nairobi.',
        'client': 'Embassy of United States, Nairobi',
        'period': 'Sep 2018 – Ongoing',
        'description': 'Multi-phase renovation across more than 50 residential single units including structural upgrades and modern exterior finishes for long-term resilience and performance.',
        'testimonial': '"JV ALMA C.I.S. performed reliably and professionally, meeting all regulatory standards and delivering a high-quality result we would trust again." — Wencke Jacobsen, Contract Specialist, RPSO Frankfurt (PHASE 2)',
        'imagePaths': [
          'assets/images/construction/rosslyn_ridge_1.jpg',
          'assets/images/construction/rosslyn_ridge_2.jpg',
          'assets/images/construction/rosslyn_ridge_3.jpg',
        ],
      },
      {
        'title': 'United States - Medical Research Unit Renov, Kisumu.',
        'client': 'NAVFAC',
        'period': 'Sep 2018 – Mar 2021',
        'description': 'Comprehensive renovation of a medical research facility including removal of the existing roof structure and upgrade of electrical and mechanical systems under challenging pandemic conditions.',
        'testimonial': '"The contractor exceeded expectations during an extremely challenging period, delivering consistent quality and strong coordination." — Brian Tiu, NAVFAC EURAFCENT',
        'imagePaths': [
          'assets/images/construction/medical_research_1.jpg',
        ],
      },
      {
        'title': 'Italian Ambassador\'s Residence Renov, Nairobi.',
        'client': 'Italian Embassy Nairobi',
        'period': 'May 2024 - Ongoing',
        'description': 'Comprehensive renovation of the Italian Ambassador\'s Residence in Karura Close, with a strong focus on modernizing and optimizing building systems for energy efficiency.',
        'testimonial': '"JV ALMA C.I.S provided a detailed and professional assessment, they are setting a clear path for renovation tailored to the building\'s age and structural needs." — Paolo Rotilli',
        'imagePaths': [
          'assets/images/construction/italian_embassy.jpg',
        ],
      },
      {
        'title': 'Portuguese Embassy Renov, Nairobi.',
        'client': 'Embassy of Portugal',
        'period': 'Mar 2025 – Aug 2025',
        'description': 'Adaptive renovation to transform an existing structure into a modern consular section for the Portuguese Embassy. The project involves full conversion of former spaces into biometric enrollment, visa production, and reception offices.',
        'testimonial': '"Thank you for all the thorough documentation and the great partnership throughout. Your support and professionalism have been truly appreciated, and it’s been a pleasure working with you." — Miguel Antonio Luis ',
        'imagePaths': [
          'assets/images/construction/portugese_embassy_1.jpg',
          'assets/images/construction/portugese_embassy_2.jpg',
        ],
      },
      {
        'title': 'Swedish Ambassador\'s Residence Renov, Nairobi.',
        'client': 'Embassy of Sweden',
        'period': 'May 2025 – October 2025',
        'description': 'Overhaul of the electrical systems at the Swedish Ambassador’s residence, including upgrades to key electrical infrastructure to enhance system performance, improve energy efficiency, and ensure the reliability of the residence’s electrical operations.',
        'testimonial': '',
        'imagePaths': [
          'assets/images/construction/swedish_embassy.jpg',
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our construction services deliver large-scale infrastructure and specialized diplomatic missions across Kenya, ensuring precision, sustainability, and compliance with international standards.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Space.lg),
        Text(
          'Key Features',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Space.sm),
        Column(
          children: features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return RevealOnScroll(
              delayMs: 60 * index,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: Space.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      LucideIcons.check,
                      size: 14,
                      color: Palette.success,
                    ),
                    const SizedBox(width: Space.xs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['title']!,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: Space.xxs),
                          Text(
                            feature['description']!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: Space.sm),
        Text(
          'Projects',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Space.sm),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: RevealOnScroll(
              delayMs: 60 * index,
              child: _ProjectCard(
                project: projects[index],
                isMobile: isMobile,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitySection(BuildContext context, double screenWidth, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconChip(icon: LucideIcons.database, color: Palette.construction),
              const SizedBox(width: Space.sm),
              Text(
                'Facility Management Services',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: Space.lg),
          _buildFacilityContent(context, screenWidth, isMobile),
        ],
      ),
    );
  }

  Widget _buildFacilityContent(BuildContext context, double screenWidth, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Facility management (FM) involves the coordination of space, infrastructure, and services to ensure that buildings and facilities operate efficiently and safely. It encompasses maintenance, operations, and strategic planning to support the core functions of an organization.\n\nOur approach integrates our proprietary NyumbaSmart - Computerized Maintenance Management System (CMMS), developed by our IT Division, to streamline these processes.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Space.sm),
        AppCard(
          onTap: () {
            debugPrint('FacilityManagementPage: Navigating to CMMSPage');
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CmmsPage()));
          },
          semanticLabel: 'NyumbaSmart - Computerized Maintenance Management System',
          child: Row(
            children: [
              const IconChip(icon: LucideIcons.database, color: Palette.construction),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NyumbaSmart - Computerized Maintenance Management System (CMMS)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Space.xxs),
                    Text(
                      'Automate work orders, track assets, and schedule maintenance\nEnhance efficiency with our CMMS solution.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: Palette.n500,
                size: isMobile ? 16 : 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final bool isMobile;

  const _ProjectCard({
    required this.project,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      interactive: false,
      padding: EdgeInsets.zero,
      accent: Palette.construction,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            project['title'],
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Palette.primary,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
          childrenPadding: const EdgeInsets.all(Space.sm),
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_shouldCenterImage(project))
                    Center(
                      child: ClipRRect(
                        borderRadius: Radii.card,
                        child: Image.asset(
                          (project['imagePaths'] as List<String>)[0],
                          height: isMobile ? 200 : 300,
                          width: isMobile ? 320 : 480,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: isMobile ? 200 : 300,
                            width: isMobile ? 320 : 480,
                            color: Palette.n200,
                            child: const Center(
                              child: Icon(LucideIcons.imageOff, color: Palette.n500),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: isMobile ? 200 : 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: (project['imagePaths'] as List<String>).map((imagePath) {
                            return Padding(
                              padding: const EdgeInsets.only(right: Space.xs),
                              child: ClipRRect(
                                borderRadius: Radii.card,
                                child: Image.asset(
                                  imagePath,
                                  height: isMobile ? 200 : 300,
                                  width: isMobile ? 320 : 480,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: isMobile ? 200 : 300,
                                    width: isMobile ? 320 : 480,
                                    color: Palette.n200,
                                    child: const Center(
                                      child: Icon(LucideIcons.imageOff, color: Palette.n500),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  const SizedBox(height: Space.sm),
                  Text(
                    'Client: ${project['client']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    'Period: ${project['period']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    project['description'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (project['testimonial'] != '') ...[
                    const SizedBox(height: Space.sm),
                    Text(
                      'Testimonial',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Space.xxs),
                    Text(
                      project['testimonial'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldCenterImage(Map<String, dynamic> project) {
    return (project['imagePaths'] as List<String>).length == 1;
  }
}
