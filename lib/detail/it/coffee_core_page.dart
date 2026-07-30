import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/header.dart';
import '../../widgets/footer.dart';
import '../../widgets/responsive_utils.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';

class CoffeeCorePage extends StatelessWidget {
  const CoffeeCorePage({super.key});

  static const List<Map<String, dynamic>> _adminRoles = [
    {
      'role': 'JV Admin',
      'icon': LucideIcons.shieldCheck,
      'color': Color(0xFF7C3AED),
      'responsibilities': [
        'Approves cooperative administrator applications',
        'Oversees platform operations and integrity',
        'Manages system-wide configurations',
        'Monitors cooperative registrations',
      ],
    },
    {
      'role': 'Cooperative Admin',
      'icon': LucideIcons.building2,
      'color': Color(0xFF2563EB),
      'responsibilities': [
        'Registers cooperative name for farmer selection',
        'Assigns Market Manager and Loan Manager roles',
        'Manages cooperative member database',
        'Oversees cooperative operations on the platform',
      ],
    },
    {
      'role': 'Market Manager',
      'icon': LucideIcons.trendingUp,
      'color': Color(0xFF059669),
      'responsibilities': [
        'Sets coffee varieties available to cooperative members',
        'Updates market prices for different coffee grades',
        'Provides tailored market insights to members',
        'Manages buyer connections for the cooperative',
      ],
    },
    {
      'role': 'Loan Manager',
      'icon': LucideIcons.wallet,
      'color': Color(0xFFEA580C),
      'responsibilities': [
        'Reviews and approves member loan applications',
        'Tracks loan repayment schedules',
        'Manages cooperative credit facilities',
        'Provides direct loan access to verified farmers',
      ],
    },
  ];

  static const List<Map<String, String>> _farmerBenefits = [
    {
      'title': 'Tailored Market Access',
      'description': 'Receive market prices and information specific to your cooperative membership, filtering out irrelevant data from other cooperatives.'
    },
    {
      'title': 'Direct Loan Access',
      'description': 'Get loans directly from your cooperative and affiliates without dealing with unknown creditors or middlemen.'
    },
    {
      'title': 'Streamlined Operations',
      'description': 'No more run-arounds - cooperatives manage members and loans efficiently through the platform.'
    },
    {
      'title': 'Protected Transactions',
      'description': 'Avoid being duped by unauthorized creditors - all loans are managed through verified cooperative channels.'
    },
  ];

  static const List<Map<String, String>> _features = [
    {
      'title': 'Cultivation Guidance',
      'description': 'Expert tips for coffee planting and growth optimization.'
    },
    {
      'title': 'Cooperative-Specific Pricing',
      'description': 'Real-time market prices tailored to your cooperative membership.'
    },
    {
      'title': 'Weather Monitoring',
      'description': 'Tailored forecasts to protect coffee crops.'
    },
    {
      'title': 'Field Data Input',
      'description': 'Soil management for sustainable coffee farming.'
    },
    {
      'title': 'Pest and Disease Management',
      'description': 'Solutions for coffee-specific pests like berry borers.'
    },
    {
      'title': 'Farm and Loan Management',
      'description': 'Track your cooperative loans and repayment schedules.'
    },
  ];

  Future<void> _openPlayStore(BuildContext context) async {
    try {
      debugPrint('CoffeeCorePage: Opening Google Play Store');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Redirecting to Play Store...'),
              ],
            ),
          );
        },
      );

      const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.jvalmacis.coffeecore';

      if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
        await launchUrl(
          Uri.parse(playStoreUrl),
          mode: LaunchMode.externalApplication,
        );

        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening Google Play Store...'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.brown,
            ),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Play Store. Please try again.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('CoffeeCorePage: Play Store redirect error: $e');

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error redirecting to Play Store. Please visit the Play Store manually.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ResponsiveUtils.mobileBreakpoint;
    debugPrint('CoffeeCorePage: Building with screenWidth=$screenWidth');

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
                        debugPrint('CoffeeCorePage: Navigating back');
                        Navigator.pop(context);
                      },
                      tooltip: 'Back',
                    ),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 896),
                        child: Column(
                          children: [
                            Text(
                              'Coffee Core',
                              style: (isMobile
                                      ? Theme.of(context).textTheme.headlineLarge
                                      : Theme.of(context).textTheme.displaySmall)
                                  ?.copyWith(color: Palette.n0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.xs),
                            Text(
                              'Sow, Safeguard, Soar',
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
            _buildContent(context, screenWidth, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double screenWidth, bool isMobile) {
    final isTablet = screenWidth >= ResponsiveUtils.mobileBreakpoint &&
        screenWidth <= ResponsiveUtils.tabletBreakpoint;

    return Column(
      children: [
        // Intro Section
        const SectionWrapper(
          topRule: Palette.it,
          background: Palette.n0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                eyebrow: 'IT Division',
                title: 'Coffee Core',
                subtitle:
                    'Coffee Core, developed by JV ALMA C.I.S, empowers coffee farmers with specialized tools for cultivation, market access, and farm management through a cooperative-based system.',
                align: TextAlign.start,
                accent: Palette.it,
              ),
            ],
          ),
        ),

        // Admin Roles Section
        SectionWrapper(
          background: Palette.n50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Administrative System',
                subtitle:
                    'Coffee Core features a comprehensive role-based management system:',
                align: TextAlign.start,
                accent: Palette.it,
              ),
              const SizedBox(height: Space.lg),
              if (isMobile)
                Column(
                  children: _adminRoles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final role = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: RevealOnScroll(
                        delayMs: 60 * index,
                        child: _buildAdminRoleCard(
                          context,
                          role: role['role'] as String,
                          icon: role['icon'] as IconData,
                          color: role['color'] as Color,
                          responsibilities: role['responsibilities'] as List<String>,
                          isMobile: isMobile,
                          isTablet: isTablet,
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 0,
                            child: _buildAdminRoleCard(
                              context,
                              role: _adminRoles[0]['role'] as String,
                              icon: _adminRoles[0]['icon'] as IconData,
                              color: _adminRoles[0]['color'] as Color,
                              responsibilities: _adminRoles[0]['responsibilities'] as List<String>,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 60,
                            child: _buildAdminRoleCard(
                              context,
                              role: _adminRoles[1]['role'] as String,
                              icon: _adminRoles[1]['icon'] as IconData,
                              color: _adminRoles[1]['color'] as Color,
                              responsibilities: _adminRoles[1]['responsibilities'] as List<String>,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 120,
                            child: _buildAdminRoleCard(
                              context,
                              role: _adminRoles[2]['role'] as String,
                              icon: _adminRoles[2]['icon'] as IconData,
                              color: _adminRoles[2]['color'] as Color,
                              responsibilities: _adminRoles[2]['responsibilities'] as List<String>,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 180,
                            child: _buildAdminRoleCard(
                              context,
                              role: _adminRoles[3]['role'] as String,
                              icon: _adminRoles[3]['icon'] as IconData,
                              color: _adminRoles[3]['color'] as Color,
                              responsibilities: _adminRoles[3]['responsibilities'] as List<String>,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Farmer Benefits Section
        SectionWrapper(
          background: Palette.n0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Benefits for Farmers',
                align: TextAlign.start,
                accent: Palette.it,
              ),
              const SizedBox(height: Space.lg),
              if (isMobile)
                Column(
                  children: _farmerBenefits.asMap().entries.map((entry) {
                    final index = entry.key;
                    final benefit = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: RevealOnScroll(
                        delayMs: 60 * index,
                        child: _buildBenefitCard(context, benefit, isMobile),
                      ),
                    );
                  }).toList(),
                )
              else
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 0,
                            child: _buildBenefitCard(context, _farmerBenefits[0], isMobile),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 60,
                            child: _buildBenefitCard(context, _farmerBenefits[1], isMobile),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 120,
                            child: _buildBenefitCard(context, _farmerBenefits[2], isMobile),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Expanded(
                          child: RevealOnScroll(
                            delayMs: 180,
                            child: _buildBenefitCard(context, _farmerBenefits[3], isMobile),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Key Features + Download Section
        SectionWrapper(
          background: Palette.n50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Key Features',
                align: TextAlign.start,
                accent: Palette.it,
              ),
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: _features.asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  final tileWidth = isMobile
                      ? screenWidth - (Space.md * 2)
                      : (Space.contentMax / (isTablet ? 2 : 3)) - Space.lg;
                  return RevealOnScroll(
                    delayMs: 60 * index,
                    child: SizedBox(
                      width: tileWidth,
                      child: AppCard(
                        accent: Palette.agribusiness,
                        interactive: false,
                        padding: const EdgeInsets.all(Space.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(LucideIcons.check, size: 14, color: Palette.agribusiness),
                            const SizedBox(width: Space.xs),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feature['title']!,
                                    style: Theme.of(context).textTheme.labelLarge,
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
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: Space.lg),

              // Download Section - Prominent
              RevealOnScroll(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Space.lg),
                  decoration: BoxDecoration(
                    gradient: Palette.heroSurface,
                    borderRadius: Radii.card,
                    boxShadow: Elevation.card,
                    border: Border.all(color: Palette.it.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const IconChip(icon: LucideIcons.coffee, color: Palette.it, size: 40),
                      const SizedBox(height: Space.sm),
                      Text(
                        'Get Coffee Core',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Palette.n0,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Space.xs),
                      Text(
                        'Download from Google Play Store and revolutionize your coffee farming!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Space.md),
                      SizedBox(
                        width: isMobile ? double.infinity : 300,
                        child: PrimaryButton(
                          text: 'Get from Play Store',
                          icon: LucideIcons.download,
                          large: true,
                          expand: true,
                          onDark: true,
                          onPressed: () => _openPlayStore(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminRoleCard(
    BuildContext context, {
    required String role,
    required IconData icon,
    required Color color,
    required List<String> responsibilities,
    required bool isMobile,
    required bool isTablet,
  }) {
    return AppCard(
      accent: color,
      interactive: false,
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconChip(icon: icon, color: color, size: isMobile ? 18 : 20),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  role,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          ...responsibilities.map((responsibility) => Padding(
                padding: const EdgeInsets.only(bottom: Space.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.checkCircle2, size: 14, color: color),
                    const SizedBox(width: Space.xs),
                    Expanded(
                      child: Text(
                        responsibility,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, Map<String, String> benefit, bool isMobile) {
    return AppCard(
      accent: Palette.success,
      interactive: false,
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.checkCircle, size: 18, color: Palette.success),
              const SizedBox(width: Space.xs),
              Expanded(
                child: Text(
                  benefit['title']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Palette.success,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(
            benefit['description']!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
