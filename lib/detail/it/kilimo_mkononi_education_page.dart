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

class KilimoMkononiEducationPage extends StatelessWidget {
  const KilimoMkononiEducationPage({super.key});

  static const List<Map<String, String>> _coreFeatures = [
    {
      'title': 'Farming Tips & Best Practices',
      'description': 'Comprehensive agricultural guidance tailored for educational purposes and student learning.'
    },
    {
      'title': 'Market Insights',
      'description': 'Real-time market data and pricing trends to teach students about agricultural economics.'
    },
    {
      'title': 'Weather Forecasting',
      'description': '5-day weather forecasts integrated with lessons on climate impact on agriculture.'
    },
    {
      'title': 'Field Data Input',
      'description': 'Hands-on data collection tools for students to document their agricultural projects.'
    },
    {
      'title': 'Pest & Disease Management',
      'description': 'Interactive pest identification and management strategies for student research.'
    },
    {
      'title': 'Farm Management Tools',
      'description': 'Digital tools for students to plan, track, and manage agricultural projects.'
    },
    {
      'title': 'Educational Manuals',
      'description': 'Curriculum-aligned agricultural manuals and reference materials for students.'
    },
  ];

  static const List<Map<String, String>> _educationFeatures = [
    {
      'icon': 'shield',
      'title': 'Three-Tier Approval System',
      'description': 'JV Admin approves headteachers, headteachers approve teachers, and teachers approve students - ensuring a safe, verified learning environment.'
    },
    {
      'icon': 'users',
      'title': 'Role-Based Access',
      'description': 'Distinct roles for headteachers, teachers, and students with appropriate permissions and safeguards for each level.'
    },
    {
      'icon': 'clipboardList',
      'title': 'Interactive Quizzes',
      'description': 'Teachers create custom quizzes to test student knowledge on farming concepts, crop management, and agricultural science.'
    },
    {
      'icon': 'cpu',
      'title': 'Farm Simulations',
      'description': 'Immersive simulation exercises where students can practice farming decisions in a virtual environment without real-world risks.'
    },
    {
      'icon': 'barChart',
      'title': 'Progress Tracking',
      'description': 'Teachers monitor student performance, quiz results, and simulation outcomes to guide learning paths.'
    },
    {
      'icon': 'graduationCap',
      'title': 'Curriculum Integration',
      'description': 'Content aligned with educational standards, making it easy to integrate into existing agricultural education programs.'
    },
  ];

  static const List<Map<String, dynamic>> _userRoles = [
    {
      'role': 'JV Admin',
      'icon': LucideIcons.shieldCheck,
      'color': Palette.it,
      'responsibilities': [
        'Approve and manage headteachers',
        'Oversee platform integrity',
        'Monitor school registrations',
        'Ensure compliance with safety standards',
      ],
    },
    {
      'role': 'Headteacher',
      'icon': LucideIcons.school,
      'color': Palette.construction,
      'responsibilities': [
        'Register and verify school teachers',
        'Manage school-level settings',
        'Monitor teacher and student activities',
        'Generate school-wide reports',
      ],
    },
    {
      'role': 'Teacher',
      'icon': LucideIcons.userCheck,
      'color': Palette.success,
      'responsibilities': [
        'Approve and manage students',
        'Create quizzes and simulations',
        'Track student progress',
        'Provide feedback and guidance',
      ],
    },
    {
      'role': 'Student',
      'icon': LucideIcons.bookOpen,
      'color': Palette.oilGas,
      'responsibilities': [
        'Complete assigned quizzes',
        'Participate in farm simulations',
        'Access educational materials',
        'Track personal learning progress',
      ],
    },
  ];

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shield':
        return LucideIcons.shieldCheck;
      case 'users':
        return LucideIcons.users;
      case 'clipboardList':
        return LucideIcons.clipboardList;
      case 'cpu':
        return LucideIcons.cpu;
      case 'barChart':
        return LucideIcons.barChart3;
      case 'graduationCap':
        return LucideIcons.graduationCap;
      default:
        return LucideIcons.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ResponsiveUtils.mobileBreakpoint;
    final isTablet = screenWidth >= ResponsiveUtils.mobileBreakpoint &&
        screenWidth <= ResponsiveUtils.tabletBreakpoint;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
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
                        debugPrint('KilimoMkononiEducationPage: Navigating back');
                        Navigator.pop(context);
                      },
                      tooltip: 'Back',
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 896),
                        child: Column(
                          children: [
                            Text(
                              'Kilimo Mkononi Education',
                              style: (isMobile
                                      ? Theme.of(context).textTheme.headlineLarge
                                      : Theme.of(context).textTheme.displaySmall)
                                  ?.copyWith(color: Palette.n0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.xs),
                            Text(
                              'Safe, Interactive Agricultural Learning for Schools',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
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

            // Introduction
            _buildIntroSection(context, isMobile),

            // Safety First Banner
            _buildSafetyBanner(context, isMobile),

            // User Roles Section
            _buildUserRolesSection(context, isMobile, isTablet, screenWidth),

            // Core Features
            _buildFeaturesSection(
              context,
              isMobile,
              isTablet,
              screenWidth,
              'Core Agricultural Features',
              _coreFeatures,
              Palette.success,
            ),

            // Education-Specific Features
            _buildEducationFeaturesSection(context, isMobile, isTablet, screenWidth),

            // Coming Soon CTA
            _buildComingSoonCTA(context, isMobile),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      topRule: Palette.it,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Empowering the Next Generation of Farmers',
            align: TextAlign.start,
            accent: Palette.it,
          ),
          const SizedBox(height: Space.sm),
          Text(
            'Kilimo Mkononi Education brings agricultural learning to life through interactive tools, hands-on simulations, and a secure platform designed specifically for schools. With built-in student protection measures and engaging educational content, we\'re making agricultural education accessible, safe, and exciting for students across Kenya.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyBanner(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: AppCard(
        interactive: false,
        accent: Palette.success,
        child: Row(
          children: [
            const IconChip(icon: LucideIcons.shieldCheck, color: Palette.success, size: 32),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Safety First',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Palette.success),
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    'Our three-tier approval system ensures every user is verified by trusted educational authorities, protecting students from fraudulent accounts and inappropriate interactions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRolesSection(BuildContext context, bool isMobile, bool isTablet, double screenWidth) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'How It Works: Verified Roles & Responsibilities',
            subtitle: 'Our platform uses a hierarchical approval system to ensure accountability and safety at every level.',
            align: TextAlign.start,
            accent: Palette.it,
          ),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.md,
            runSpacing: Space.md,
            children: _userRoles.asMap().entries.map((entry) {
              final index = entry.key;
              final role = entry.value;
              return SizedBox(
                width: isMobile
                    ? double.infinity
                    : isTablet
                        ? (screenWidth - 48) / 2
                        : (screenWidth - 64) / 4,
                child: RevealOnScroll(
                  delayMs: 60 * index,
                  child: _buildRoleCard(
                    context,
                    isMobile,
                    role['role'] as String,
                    role['icon'] as IconData,
                    role['color'] as Color,
                    role['responsibilities'] as List<String>,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    bool isMobile,
    String role,
    IconData icon,
    Color color,
    List<String> responsibilities,
  ) {
    return AppCard(
      accent: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconChip(icon: icon, color: color, size: 24),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  role,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          ...responsibilities.map((responsibility) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.checkCircle2,
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: Space.xs),
                  Expanded(
                    child: Text(
                      responsibility,
                      style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildFeaturesSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    double screenWidth,
    String title,
    List<Map<String, String>> features,
    Color accentColor,
  ) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, align: TextAlign.start, accent: Palette.it),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: isMobile ? Space.xs : Space.sm,
            runSpacing: Space.sm,
            children: features.asMap().entries.map((entry) {
              final index = entry.key;
              final feature = entry.value;
              return SizedBox(
                width: isMobile ? screenWidth * 0.9 : screenWidth * (isTablet ? 0.45 : 0.3),
                child: RevealOnScroll(
                  delayMs: 60 * index,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.checkCircle2,
                        size: 16,
                        color: accentColor,
                      ),
                      const SizedBox(width: Space.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature['title']!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: Space.xxs),
                            Text(
                              feature['description']!,
                              style: Theme.of(context).textTheme.bodySmall,
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
        ],
      ),
    );
  }

  Widget _buildEducationFeaturesSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    double screenWidth,
  ) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Educational Enhancements',
            subtitle: 'Purpose-built features that transform agricultural education into an engaging, interactive experience.',
            align: TextAlign.start,
            accent: Palette.it,
          ),
          const SizedBox(height: Space.md),
          Wrap(
            spacing: Space.md,
            runSpacing: Space.md,
            children: _educationFeatures.asMap().entries.map((entry) {
              final index = entry.key;
              final feature = entry.value;
              return SizedBox(
                width: isMobile
                    ? double.infinity
                    : isTablet
                        ? (screenWidth - 48) / 2
                        : (screenWidth - 64) / 3,
                child: RevealOnScroll(
                  delayMs: 60 * index,
                  child: _buildEducationFeatureCard(
                    context,
                    isMobile,
                    feature['title'] as String,
                    _getIconData(feature['icon'] as String),
                    feature['description'] as String,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationFeatureCard(
    BuildContext context,
    bool isMobile,
    String title,
    IconData icon,
    String description,
  ) {
    return AppCard(
      accent: Palette.it,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: icon, color: Palette.it, size: 32),
          const SizedBox(height: Space.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Space.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonCTA(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? Space.lg : Space.xl),
        decoration: BoxDecoration(
          gradient: Palette.heroSurface,
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
        child: Column(
          children: [
            Icon(
              LucideIcons.rocket,
              size: isMobile ? 48 : 64,
              color: Palette.n0,
            ),
            const SizedBox(height: Space.md),
            Text(
              'Coming Soon to Schools',
              style: (isMobile
                      ? Theme.of(context).textTheme.headlineMedium
                      : Theme.of(context).textTheme.headlineLarge)
                  ?.copyWith(color: Palette.n0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.sm),
            Text(
              'Kilimo Mkononi Education is currently in development. We\'re working with schools to create the perfect agricultural learning platform.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.lg),
            Text(
              'Interested in bringing this to your school?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Palette.n0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.sm),
            PrimaryButton(
              text: 'Contact Us',
              icon: LucideIcons.mail,
              onDark: true,
              onPressed: () {
                // Navigate to contact page
                debugPrint('Navigating to contact page for Kilimo Mkononi Education');
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
        ),
      ),
    );
  }
}
