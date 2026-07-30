import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/header.dart';
import '../../widgets/footer.dart';
import '../../widgets/responsive_utils.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';

class AlmaWorksPage extends StatelessWidget {
  const AlmaWorksPage({super.key});

  static const List<Map<String, dynamic>> _userRoles = [
    {
      'role': 'JV Admin',
      'icon': LucideIcons.shieldCheck,
      'color': Palette.it,
      'responsibilities': [
        'Approves client and employee registrations',
        'Manages system-wide permissions and access',
        'Oversees all construction projects',
        'Controls document access and visibility',
      ],
    },
    {
      'role': 'Project Managers',
      'icon': LucideIcons.userCheck,
      'color': Palette.construction,
      'responsibilities': [
        'Manage project timelines and milestones',
        'Assign tasks to contractors and teams',
        'Monitor project progress and budgets',
        'Generate progress reports and documentation',
      ],
    },
    {
      'role': 'Contractors',
      'icon': LucideIcons.hardHat,
      'color': Palette.oilGas,
      'responsibilities': [
        'Access assigned work orders and tasks',
        'Update work progress and completion status',
        'Upload site photos and documentation',
        'Submit billing and cost information',
      ],
    },
    {
      'role': 'Clients',
      'icon': LucideIcons.building2,
      'color': Palette.success,
      'responsibilities': [
        'View project progress and updates',
        'Access approved drawings and documents',
        'Communicate with project managers',
        'Track project milestones and deliverables',
      ],
    },
  ];

  static const List<Map<String, String>> _securityFeatures = [
    {
      'title': 'Approval-Based Access',
      'description': 'All users require JV Admin approval before accessing the platform, ensuring secure access control.',
    },
    {
      'title': 'Role-Based Permissions',
      'description': 'Hierarchical access control ensures users only see data relevant to their role and projects.',
    },
    {
      'title': 'Audit Trail',
      'description': 'Complete tracking of who viewed, edited, or downloaded documents with timestamps for accountability.',
    },
    {
      'title': 'Project-Based Access',
      'description': 'Users only access projects they are authorized for, ensuring complete data separation.',
    },
  ];

  static const List<Map<String, dynamic>> _coreFeatures = [
    {
      'icon': LucideIcons.users,
      'title': 'Role-Based Access Control',
      'description': 'Hierarchical user management with customizable permissions for administrators, project managers, contractors, and clients.',
      'color': Palette.construction,
    },
    {
      'icon': LucideIcons.userCheck,
      'title': 'Client & Employee Management',
      'description': 'Comprehensive database for managing construction clients, employees, and team assignments across multiple projects.',
      'color': Palette.it,
    },
    {
      'icon': LucideIcons.fileText,
      'title': 'Contract Administration',
      'description': 'Centralized contract management system tracking agreements, milestones, deliverables, and contractual obligations.',
      'color': Palette.success,
    },
    {
      'icon': LucideIcons.phone,
      'title': 'Supplier & Client Contacts',
      'description': 'Organized contact database for suppliers, subcontractors, and clients with communication history and interaction logs.',
      'color': Palette.oilGas,
    },
    {
      'icon': LucideIcons.fileImage,
      'title': 'Drawing & Document Storage',
      'description': 'Secure storage and version control for architectural drawings, blueprints, permits, and project documentation.',
      'color': Palette.danger,
    },
    {
      'icon': LucideIcons.dollarSign,
      'title': 'Financial Management',
      'description': 'Comprehensive financial tracking for clients and contractors including invoicing, payments, budgets, and cost analysis.',
      'color': Palette.agribusiness,
    },
  ];

  static const List<Map<String, dynamic>> _advancedFeatures = [
    {
      'icon': LucideIcons.messageSquare,
      'title': 'Client-Contractor Communication',
      'description': 'Built-in messaging system facilitating seamless communication between clients and contractors with threaded conversations.',
      'color': Palette.primary,
    },
    {
      'icon': LucideIcons.shieldCheck,
      'title': 'Quality & Safety Management',
      'description': 'Tools for quality inspections, safety checklists, incident reporting, and compliance tracking to maintain construction standards.',
      'color': Palette.oilGas,
    },
    {
      'icon': LucideIcons.fileBarChart,
      'title': 'Progress Reports',
      'description': 'Automated generation of weekly and monthly progress reports with customizable templates and data visualization.',
      'color': Palette.it,
    },
    {
      'icon': LucideIcons.camera,
      'title': 'Photo Gallery & Documentation',
      'description': 'Organized photo gallery for documenting construction progress, before/after comparisons, and site inspections with geo-tagging.',
      'color': Palette.danger,
    },
  ];

  static const List<Map<String, dynamic>> _benefits = [
    {
      'icon': LucideIcons.zap,
      'title': 'Increased Efficiency',
      'description': 'Streamline workflows and reduce administrative overhead',
    },
    {
      'icon': LucideIcons.eye,
      'title': 'Enhanced Visibility',
      'description': 'Real-time insights into project status and performance',
    },
    {
      'icon': LucideIcons.shield,
      'title': 'Improved Compliance',
      'description': 'Maintain safety and quality standards with built-in checks',
    },
    {
      'icon': LucideIcons.trendingUp,
      'title': 'Better Outcomes',
      'description': 'Deliver projects on time and within budget consistently',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ResponsiveUtils.mobileBreakpoint;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, isMobile, screenWidth),
            _buildRolesSection(context, isMobile),
            _buildSecuritySection(context, isMobile),
            _buildCoreFeaturesSection(context, isMobile),
            _buildAdvancedFeaturesSection(context, isMobile),
            _buildBenefitsSection(context, isMobile),
            _buildCtaSection(context, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile, double screenWidth) {
    return Container(
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
                debugPrint('AlmaWorksPage: Navigating back');
                Navigator.pop(context);
              },
              tooltip: 'Back',
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 900),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.hardHat,
                      size: isMobile ? 36 : 48,
                      color: Palette.n0,
                    ),
                    const SizedBox(height: Space.sm),
                    Text(
                      'AlmaWorks',
                      style: (isMobile
                              ? Theme.of(context).textTheme.headlineLarge
                              : Theme.of(context).textTheme.displaySmall)
                          ?.copyWith(color: Palette.n0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Space.xs),
                    Text(
                      'Construction Management Software',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Space.sm),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        'Proprietary construction management platform designed for sensitive construction operations with comprehensive role-based security.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
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
    );
  }

  Widget _buildRolesSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      topRule: Palette.it,
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'User Roles & Permissions',
            subtitle: 'AlmaWorks features hierarchical access control for construction project management:',
          ),
          const SizedBox(height: Space.xl),
          _buildRoleCards(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildRoleCards(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        children: _userRoles.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: Space.md),
          child: RevealOnScroll(
            delayMs: 60 * entry.key,
            child: _buildRoleCard(context, entry.value, isMobile),
          ),
        )).toList(),
      );
    } else {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: RevealOnScroll(delayMs: 0, child: _buildRoleCard(context, _userRoles[0], isMobile))),
              const SizedBox(width: Space.md),
              Expanded(child: RevealOnScroll(delayMs: 60, child: _buildRoleCard(context, _userRoles[1], isMobile))),
            ],
          ),
          const SizedBox(height: Space.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: RevealOnScroll(delayMs: 120, child: _buildRoleCard(context, _userRoles[2], isMobile))),
              const SizedBox(width: Space.md),
              Expanded(child: RevealOnScroll(delayMs: 180, child: _buildRoleCard(context, _userRoles[3], isMobile))),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildRoleCard(BuildContext context, Map<String, dynamic> role, bool isMobile) {
    final color = role['color'] as Color;
    return AppCard(
      accent: color,
      interactive: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconChip(icon: role['icon'] as IconData, color: color, size: isMobile ? 18 : 20),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  role['role'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          ...(role['responsibilities'] as List<String>).map((resp) => Padding(
                padding: const EdgeInsets.only(bottom: Space.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.checkCircle2, size: 14, color: color),
                    const SizedBox(width: Space.xs),
                    Expanded(
                      child: Text(
                        resp,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'Security & Access Control',
          ),
          const SizedBox(height: Space.xl),
          _buildSecurityCards(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildSecurityCards(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        children: _securityFeatures.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: Space.md),
          child: RevealOnScroll(
            delayMs: 60 * entry.key,
            child: _buildSecurityCard(context, entry.value, isMobile),
          ),
        )).toList(),
      );
    } else {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: RevealOnScroll(delayMs: 0, child: _buildSecurityCard(context, _securityFeatures[0], isMobile))),
              const SizedBox(width: Space.md),
              Expanded(child: RevealOnScroll(delayMs: 60, child: _buildSecurityCard(context, _securityFeatures[1], isMobile))),
            ],
          ),
          const SizedBox(height: Space.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: RevealOnScroll(delayMs: 120, child: _buildSecurityCard(context, _securityFeatures[2], isMobile))),
              const SizedBox(width: Space.md),
              Expanded(child: RevealOnScroll(delayMs: 180, child: _buildSecurityCard(context, _securityFeatures[3], isMobile))),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildSecurityCard(BuildContext context, Map<String, String> feature, bool isMobile) {
    return AppCard(
      interactive: false,
      accent: Palette.danger,
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.shield, size: 18, color: Palette.danger),
              const SizedBox(width: Space.xs),
              Expanded(
                child: Text(
                  feature['title']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Palette.danger),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(
            feature['description']!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCoreFeaturesSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'Core Features',
            subtitle: 'Essential tools for modern construction management',
          ),
          const SizedBox(height: Space.xl),
          _buildFeatureCards(context, _coreFeatures, isMobile),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeaturesSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'Advanced Capabilities',
            subtitle: 'Enhanced functionality for comprehensive project oversight',
          ),
          const SizedBox(height: Space.xl),
          _buildFeatureCards(context, _advancedFeatures, isMobile),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, List<Map<String, dynamic>> features, bool isMobile) {
    if (isMobile) {
      return Column(
        children: features.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: Space.md),
          child: RevealOnScroll(
            delayMs: 60 * entry.key,
            child: _buildFeatureCard(context, entry.value, isMobile),
          ),
        )).toList(),
      );
    } else {
      final rows = <Widget>[];
      for (int i = 0; i < features.length; i += 2) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RevealOnScroll(
                  delayMs: 60 * i,
                  child: _buildFeatureCard(context, features[i], isMobile),
                ),
              ),
              const SizedBox(width: Space.md),
              if (i + 1 < features.length)
                Expanded(
                  child: RevealOnScroll(
                    delayMs: 60 * (i + 1),
                    child: _buildFeatureCard(context, features[i + 1], isMobile),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        );
        if (i + 2 < features.length) {
          rows.add(const SizedBox(height: Space.md));
        }
      }
      return Column(children: rows);
    }
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature, bool isMobile) {
    final color = feature['color'] as Color;
    return AppCard(
      accent: color,
      interactive: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconChip(icon: feature['icon'] as IconData, color: color, size: isMobile ? 18 : 20),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text(
                  feature['title'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(
            feature['description'] as String,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        children: [
          const SectionHeader(
            accent: Palette.it,
            title: 'Why Choose AlmaWorks?',
          ),
          const SizedBox(height: Space.xl),
          if (isMobile)
            Column(
              children: _benefits.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: RevealOnScroll(
                  delayMs: 60 * entry.key,
                  child: _buildBenefitCard(context, entry.value, isMobile),
                ),
              )).toList(),
            )
          else
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: RevealOnScroll(delayMs: 0, child: _buildBenefitCard(context, _benefits[0], isMobile))),
                    const SizedBox(width: Space.md),
                    Expanded(child: RevealOnScroll(delayMs: 60, child: _buildBenefitCard(context, _benefits[1], isMobile))),
                  ],
                ),
                const SizedBox(height: Space.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: RevealOnScroll(delayMs: 120, child: _buildBenefitCard(context, _benefits[2], isMobile))),
                    const SizedBox(width: Space.md),
                    Expanded(child: RevealOnScroll(delayMs: 180, child: _buildBenefitCard(context, _benefits[3], isMobile))),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, Map<String, dynamic> benefit, bool isMobile) {
    return AppCard(
      interactive: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: benefit['icon'] as IconData, color: Palette.it, size: isMobile ? 24 : 28),
          const SizedBox(height: Space.sm),
          Text(
            benefit['title'] as String,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Space.xxs),
          Text(
            benefit['description'] as String,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: Palette.ink,
          borderRadius: Radii.card,
        ),
        child: Column(
          children: [
            Icon(LucideIcons.building2, size: isMobile ? 40 : 52, color: Palette.n0),
            const SizedBox(height: Space.sm),
            Text(
              'Built by Construction Professionals',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Palette.n0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.xs),
            Text(
              'AlmaWorks is currently used internally by JV ALMA C.I.S for managing our construction projects. Interested in learning more?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.lg),
            PrimaryButton(
              text: 'Contact Us',
              icon: LucideIcons.mail,
              onDark: true,
              large: true,
              onPressed: () {
                debugPrint('Navigating to contact page for AlmaWorks inquiry');
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
        ),
      ),
    );
  }
}
