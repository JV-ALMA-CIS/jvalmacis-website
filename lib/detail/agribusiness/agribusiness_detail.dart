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

class AgribusinessDetail extends StatelessWidget {
  const AgribusinessDetail({super.key});

  static final List<Map<String, dynamic>> _projects = [
    {
      'funded by': 'Italian Agency for Cooperation Development (AICS)',
      'title': 'Sigor Wei Wei Integrated Irrigation Scheme – West Pokot, Kenya',
      'client': 'Kerio Valley Development Authority (KVDA)',
      'period': 'June 2017 – July 2020',
      'description': 'Major civil works for a large-scale irrigation scheme in a remote region, including installation of pipelines to irrigate over 325 hectares. The project also involved bush clearing and refurbishment of 290 ha of existing irrigation systems, and construction of warehouses and support facilities.',
      'testimonial': '"JV ALMA C.I.S. delivered extensive infrastructure in a complex rural setting, significantly boosting the region\'s agricultural productivity." — Eng. Daniel Kimutai, KVDA',
      'imagePaths': [
        {'path': 'assets/images/agribusiness/sigor_1.jpg', 'caption': 'Former President Uhuru Kenyatta During the launch of the project'},
        {'path': 'assets/images/agribusiness/sigor_2.jpg', 'caption': ''},
      ],
    },
    {
      'title': 'Solar-Powered Irrigation Scheme – Kapluk, Baringo, Kenya',
      'client': 'Italian Agency for Cooperation Development (AICS)',
      'period': 'June 2021 – May 2023',
      'description': 'Design-build execution of a solar-powered irrigation system. The scope included survey and design of the distribution network and related pump system, 10,000-liter tanks, hydrants, and all associated valves. The project engaged the local community extensively, providing employment opportunities while ensuring technical supervision and quality control.',
      'testimonial': '"As a farmer and resident of Kapluk, I saw firsthand how JV ALMA C.I.S worked with our community—not just to build an irrigation system, but to build our confidence and capacity. Thanks to their commitment, we now have water, jobs, and a future." — Simion Yator, Kiptolelyo Self Help Group Chairman.',
      'imagePaths': [
        {'path': 'assets/images/agribusiness/kapluk_1.jpg', 'caption': ''},
        {'path': 'assets/images/agribusiness/kapluk_2.jpg', 'caption': ''},
      ],
    },
    {
      'title': 'Makueni Irrigation Scheme',
      'client': 'Greenland Farm',
      'period': '',
      'description': 'Solar-powered irrigation system and agri-enterprise pilot in Makueni County. Beyond construction, JV ALMA C.I.S introduced organic farming methods and trained farmers on sustainable practices. The project catalyzed local agri-enterprise and reduced chemical inputs for improved livelihoods.',
      'testimonial': '"As Greenland Farm, we witnessed how JV ALMA C.I.S combined innovation with hands-on support—delivering not just infrastructure, but real impact. With their guidance, we\'ve adopted sustainable practices, improved our yields, and built stronger ties with the market." — Greenland Farm Management',
      'imagePaths': [
        {'path': 'assets/images/agribusiness/makueni_1.jpg', 'caption': ''},
        {'path': 'assets/images/agribusiness/makueni_2.jpg', 'caption': ''},
      ],
    },
    {
      'title': 'ENI - Provision of Technical Services & Operations Support',
      'client': 'ENI',
      'period': '',
      'description': 'JV ALMA C.I.S provided comprehensive technical services and operations support for ENI\'s projects, ensuring seamless execution through expert coordination, technical oversight, and operational efficiency. Our team delivered specialized support that enhanced project performance and maintained the highest standards of quality and safety.',
      'testimonial': '',
      'imagePaths': [
        {'path': 'assets/images/agribusiness/eni_1.jpg', 'caption': ''},
        {'path': 'assets/images/agribusiness/eni_2.jpg', 'caption': ''},
        {'path': 'assets/images/agribusiness/eni_3.jpg', 'caption': ''},
      ],
    },
  ];

  static final Map<String, dynamic> _content = {
    'description': 'JV ALMA C.I.S approaches capacity building as a transformative process designed to equip individuals and communities with the skills, knowledge, and structures needed to drive their own development. In the context of rural agribusiness, this involves:',
    'coreServices': [
      {
        'title': 'Training Programs',
        'description': '• Training young professionals in multidisciplinary skills (engineering, agribusiness, irrigation design) through technical modules delivered in partnership with academic institutions.',
        'imagePaths': [
          {'path': 'assets/images/agribusiness/training_2.jpg', 'caption': ''},
        ],
      },
      {
        'title': 'Formation of Self-Help Groups',
        'description': '• Organizing communities into formal groups, such as self-help groups (e.g., Kiptolelyo SHG), to transition from fragmented subsistence farming to coordinated, economically viable units.',
        'imagePaths': [
          {'path': 'assets/images/agribusiness/group_cert.jpg', 'caption': ''},
        ],
      },
      {
        'title': 'Promoting Sustainability',
        'description': '• Promoting sustainability by emphasizing self-reliance over aid-dependence ("beyond the mentality of grants")—encouraging co-investment, structured loan repayment, and shared ownership of infrastructure.',
        'imagePaths': [
          {'path': 'assets/images/agribusiness/sustainability.jpg', 'caption': ''},
        ],
      },
      {
        'title': 'Soil Health and Controlled Use of Pesticides',
        'description': '• Soil sampling and analysis to support fertility management\n• Recommendations for responsible fertilizer and pesticide use\n• Tailored nutrient application plans based on farm-specific data',
        'imagePaths': [
          {'path': 'assets/images/agribusiness/soil_health_1.jpg', 'caption': ''},
          {'path': 'assets/images/agribusiness/soil_health_2.jpg', 'caption': ''},
        ],
      },
      {
        'title': 'Data Processing',
        'description': '• Collection and analysis of real-time field data\n• Crop and pest tracking for precision farming\n• Integration of mobile technology to support informed decisions',
        'imagePaths': [
          {'path': 'assets/images/agribusiness/data_processing.jpg', 'caption': ''},
          {'path': 'assets/images/agribusiness/data_extraction.jpg', 'caption': ''},
        ],
      },
    ],
  };

  static final Map<String, dynamic> _partnerships = {
    'title': 'Partnership With Institutions',
    'partnerships': [
      {
        'name': 'KALRO & JV ALMA C.I.S',
        'signatories': [
          '• Piergiorgio Di Carmine – CEO, JV ALMA C.I.S',
          '• Dr. Eliud Kireger – Director General, KALRO',
          '• Patricia Ngutu – Corporation Secretary, KALRO',
        ],
        'impact': "The MoU empowers KALRO to provide technical support, capacity building, irrigation supervision, soil/water analysis, and ESIA services. This partnership grounds JV ALMA C.I.S's field projects in scientific rigor, enhancing sustainability and agricultural productivity.",
        'imagePaths': [
          {'path': 'assets/images/agribusiness/kalro_logo.jpg', 'caption': 'KALRO Logo'},
        ],
      },
      {
        'name': 'Moi University & JV ALMA C.I.S',
        'signatories': [
          '• Piergiorgio Di Carmine – CEO, JV ALMA C.I.S',
          '• Prof. Eng. Simiyu Sitati – Dean School of Engineering, Moi University',
        ],
        'impact': 'Through the agribusiness training program, Moi University trained students, developed business models, and coordinated local engagement. The MoU strengthens academic-practical collaboration and builds youth capacity for rural innovation.',
        'imagePaths': [
          {'path': 'assets/images/agribusiness/moi_logo.jpg', 'caption': 'Moi University Logo'},
        ],
      },
    ],
  };

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
                        developer.log('AgribusinessDetail: Navigating back to /business-units', name: 'AgribusinessDetail');
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
                              'Agribusiness',
                              style: (isMobile
                                      ? Theme.of(context).textTheme.headlineLarge
                                      : Theme.of(context).textTheme.displaySmall)
                                  ?.copyWith(color: Palette.n0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.md),
                            Text(
                              'End-to-end solutions for rural transformation, integrating advanced infrastructure, community development & capacity building, and digital tools to enhance agricultural productivity and sustainability.',
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
            // Overview Section
            _buildOverviewSection(context, isMobile),
            // Infrastructure Section
            _buildInfrastructureSection(context, isMobile),
            // Community Section
            _buildCommunitySection(context, isMobile),
            // Digitization Section
            _buildDigitizationSection(context, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      topRule: Palette.agribusiness,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconChip(icon: LucideIcons.sprout, color: Palette.agribusiness),
              const SizedBox(width: Space.sm),
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            'JV ALMA C.I.S delivers comprehensive solutions for rural transformation, combining large-scale infrastructure development, community development & capacity building, and innovative digital agriculture tools. Our approach enhances productivity, builds resilient livelihoods, and promotes sustainable growth in underserved regions.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfrastructureSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconChip(icon: LucideIcons.bookOpen, color: Palette.agribusiness),
              const SizedBox(width: Space.sm),
              Text(
                'Technical Services',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: Space.lg),
          _buildInfrastructureContent(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildInfrastructureContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "JV ALMA C.I.S Kenya's technical services programs empower rural communities through targeted development and sustainable solutions.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Space.sm),
        Text(
          'projects & Project Management',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Space.sm),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _projects.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: RevealOnScroll(
              delayMs: 60 * index,
              child: AppCard(
                interactive: false,
                padding: EdgeInsets.zero,
                accent: Palette.agribusiness,
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      _projects[index]['title'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Palette.primary),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
                    childrenPadding: const EdgeInsets.all(Space.sm),
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _getImageWidgets(context, _projects[index]['imagePaths'], isLogo: false),
                                ),
                              ),
                            ),
                            const SizedBox(height: Space.sm),
                            Text(
                              'Client: ${_projects[index]['client']}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (_projects[index]['funded by'] != null) ...[
                              const SizedBox(height: Space.xxs),
                              Text(
                                'Funded by: ${_projects[index]['funded by']}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                            if (_projects[index]['period'].isNotEmpty) ...[
                              const SizedBox(height: Space.xxs),
                              Text(
                                'Period: ${_projects[index]['period']}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                            const SizedBox(height: Space.xs),
                            Text(
                              _projects[index]['description'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: Space.sm),
                            Text(
                              'Testimonial',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: Space.xxs),
                            Text(
                              _projects[index]['testimonial'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunitySection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconChip(icon: LucideIcons.users, color: Palette.agribusiness),
              const SizedBox(width: Space.sm),
              Text(
                'Capacity Building',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: Space.lg),
          _buildCommunityContent(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildCommunityContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _content['description'],
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Space.sm),
        AppCard(
          interactive: false,
          padding: EdgeInsets.zero,
          accent: Palette.agribusiness,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                'Core Services',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Palette.primary),
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
              childrenPadding: const EdgeInsets.all(Space.sm),
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...(_content['coreServices'] as List<Map<String, dynamic>>).asMap().entries.map(
                        (entry) => RevealOnScroll(
                          delayMs: 60 * entry.key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value['title'],
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: Space.xxs),
                              Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _getImageWidgets(context, entry.value['imagePaths'], isLogo: false),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Space.xs),
                              Text(
                                entry.value['description'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: Space.sm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.sm),
        AppCard(
          interactive: false,
          padding: EdgeInsets.zero,
          accent: Palette.agribusiness,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                _partnerships['title'],
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Palette.primary),
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
              childrenPadding: const EdgeInsets.all(Space.sm),
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the entire partnership content
                    children: [
                      ...(_partnerships['partnerships'] as List<Map<String, dynamic>>).asMap().entries.map(
                        (entry) => RevealOnScroll(
                          delayMs: 60 * entry.key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Center each partnership
                            children: [
                              Text(
                                entry.value['name'],
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: Space.xxs),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center the logos
                                  children: _getImageWidgets(context, entry.value['imagePaths'], isLogo: true),
                                ),
                              ),
                              const SizedBox(height: Space.xs),
                              Text(
                                entry.value['impact'],
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center, // Center the impact text
                              ),
                              const SizedBox(height: Space.xs),
                              Text(
                                'Signatories:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center, // Center the signatories header
                              ),
                              ...((entry.value['signatories'] as List<String>).map(
                                (signatory) => Text(
                                  signatory,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center, // Center each signatory
                                ),
                              )),
                              const SizedBox(height: Space.sm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDigitizationSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconChip(icon: LucideIcons.globe, color: Palette.agribusiness),
              const SizedBox(width: Space.sm),
              Text(
                'Digitization In Agriculture',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: Space.lg),
          _buildDigitizationContent(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildDigitizationContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'JV ALMA C.I.S leverages digital innovation to empower farmers with mobile-based tools for crop management, market access, and financial planning.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Space.sm),
        Text(
          'Applications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Space.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RevealOnScroll(
              delayMs: 0,
              child: AppCard(
                onTap: () {
                  developer.log('AgribusinessDetail: Navigating to /kilimo-mkononi', name: 'AgribusinessDetail');
                  Navigator.pushNamed(context, '/kilimo-mkononi');
                },
                semanticLabel: 'KilimoMkononi Platform',
                child: Row(
                  children: [
                    const IconChip(icon: LucideIcons.globe, color: Palette.agribusiness),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KilimoMkononi Platform',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: Space.xxs),
                          Text(
                            'Grow, Protect, Prosper\n\nKilimoMkononi delivers comprehensive agricultural solutions through two specialized editions:\n\n• Enterprise Edition: Empowers professional farmers and agricultural businesses with crop-specific advice, real-time market prices, 5-day weather forecasts, soil health management, pest/disease control, and financial tracking for crops like maize, beans, carrots, and tomatoes.\n\n• Education Edition: Interactive learning platform for schools featuring quizzes, farm simulations, and a three-tier safety approval system (JV Admin → Headteachers → Teachers → Students), making agricultural education safe, engaging, and accessible.',
                            style: Theme.of(context).textTheme.bodyMedium,
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
            ),
            const SizedBox(height: Space.sm),
            RevealOnScroll(
              delayMs: 60,
              child: AppCard(
                onTap: () {
                  developer.log('AgribusinessDetail: Navigating to /coffee-core', name: 'AgribusinessDetail');
                  Navigator.pushNamed(context, '/coffee-core');
                },
                semanticLabel: 'CoffeeCore Application',
                child: Row(
                  children: [
                    const IconChip(icon: LucideIcons.globe, color: Palette.agribusiness),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CoffeeCore Application',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: Space.xxs),
                          Text(
                            'Sow – Safeguard – Soar\nDesigned specifically for coffee farmers and cooperatives, CoffeeCore offers farm management tools, real-time market prices, soil and weather data, pest solutions, and financial oversight. It streamlines cooperative coordination while promoting sustainable coffee farming and data-driven decisions from seed to sale.',
                            style: Theme.of(context).textTheme.bodyMedium,
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
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _getImageWidgets(BuildContext context, dynamic imagePaths, {bool isLogo = false}) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (imagePaths == null) return [];
    if (imagePaths is List<dynamic>) {
      return imagePaths.map((imageData) {
        if (imageData is Map<String, dynamic> && imageData['path'] is String) {
          return Padding(
            padding: const EdgeInsets.only(right: Space.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: isLogo ? (isMobile ? 100 : 150) : (isMobile ? 180 : 240), // Reduced height for logos only
                  width: isLogo ? (isMobile ? 150 : 200) : (isMobile ? 300 : 400),   // Reduced width for logos only
                  child: ClipRRect(
                    borderRadius: Radii.card,
                    child: Image.asset(
                      imageData['path'],
                      height: isLogo ? (isMobile ? 100 : 150) : (isMobile ? 180 : 240),
                      width: isLogo ? (isMobile ? 150 : 200) : (isMobile ? 300 : 400),
                      fit: isLogo ? BoxFit.contain : BoxFit.cover, // Contain for logos, cover for others
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: isLogo ? (isMobile ? 100 : 150) : (isMobile ? 180 : 240),
                        width: isLogo ? (isMobile ? 150 : 200) : (isMobile ? 300 : 400),
                        color: Palette.n200,
                        child: const Center(child: Icon(LucideIcons.imageOff, color: Palette.n500)),
                      ),
                    ),
                  ),
                ),
                if (imageData['caption'] != null && imageData['caption'].isNotEmpty) ...[
                  const SizedBox(height: Space.sm),
                  SizedBox(
                    width: isLogo ? (isMobile ? 150 : 200) : (isMobile ? 300 : 400),
                    child: Text(
                      imageData['caption'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList();
    }
    return [];
  }
}
