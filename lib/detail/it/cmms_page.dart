import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/header.dart';
import '../../widgets/footer.dart';
import '../../widgets/responsive_utils.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';

class CmmsPage extends StatelessWidget {
  const CmmsPage({super.key});

  static const List<Map<String, dynamic>> _userRoles = [
    {
      'role': 'JV Admin',
      'icon': LucideIcons.shieldCheck,
      'color': Palette.it,
      'responsibilities': [
        'Approves client and JV employee registrations',
        'Grants or denies access based on employee functions',
        'Controls document access permissions',
        'Tracks who viewed what and when for accountability',
      ],
    },
    {
      'role': 'JV Employees',
      'icon': LucideIcons.users,
      'color': Palette.construction,
      'responsibilities': [
        'Create work orders from client requests',
        'Upload, view, edit, or download documentation',
        'Manage preventive maintenance schedules',
        'Access varies based on assigned function',
      ],
    },
    {
      'role': 'Clients',
      'icon': LucideIcons.building2,
      'color': Palette.success,
      'responsibilities': [
        'Submit work requests for facility maintenance',
        'View approved documentation and drawings',
        'Track work order progress',
        'Access limited to authorized facilities only',
      ],
    },
    {
      'role': 'Contractors',
      'icon': LucideIcons.hardHat,
      'color': Palette.oilGas,
      'responsibilities': [
        'Access assigned work orders',
        'Update work progress and completion status',
        'View relevant facility documentation',
        'Limited access based on project scope',
      ],
    },
  ];

  static const List<Map<String, dynamic>> _features = [
    {'icon': LucideIcons.building, 'title': 'Facility Management', 'description': 'Manage multiple facilities with facility selection on login.'},
    {'icon': LucideIcons.fileText, 'title': 'Building Information', 'description': 'Access surveys, documentation, and drawings.'},
    {'icon': LucideIcons.clipboardList, 'title': 'Scope of Work', 'description': 'Upload documents or schedule activities.'},
    {'icon': LucideIcons.calendar, 'title': 'Preventive Maintenance', 'description': 'Schedule and automate routine maintenance.'},
    {'icon': LucideIcons.fileBarChart, 'title': 'Reports & Analytics', 'description': 'Generate detailed performance reports.'},
    {'icon': LucideIcons.messageSquare, 'title': 'Work Requests', 'description': 'Client submission and tracking system.'},
    {'icon': LucideIcons.wrench, 'title': 'Work Orders', 'description': 'Full lifecycle management and tracking.'},
    {'icon': LucideIcons.receipt, 'title': 'Billing Management', 'description': 'Track costs and generate invoices.'},
  ];

  static const List<Map<String, String>> _securityFeatures = [
    {
      'title': 'Approval-Based Access',
      'description': 'JV Admin approval required after login, even for Play Store downloads.',
    },
    {
      'title': 'Role-Based Permissions',
      'description': 'Strict access control based on user roles and functions.',
    },
    {
      'title': 'Document Tracking',
      'description': 'Complete audit trail with timestamps for accountability.',
    },
    {
      'title': 'Facility-Based Access',
      'description': 'Users only see authorized facility data ensuring privacy.',
    },
  ];

  static const List<Map<String, String>> _media = [
    {'type': 'image', 'path': 'assets/apk/cmms_overview.jpg', 'description': 'CMMS Overview.'},
    {'type': 'image', 'path': 'assets/apk/nyumba_dashboard.jpg', 'description': 'CMMS mobile app view.'},
    {'type': 'image', 'path': 'assets/apk/nyumba_mobile_section.jpg', 'description': 'CMMS mobile section view.'},
    {'type': 'image', 'path': 'assets/apk/cmms_desktop_view.jpg', 'description': 'CMMS dashboard interface.'},
    {'type': 'image', 'path': 'assets/apk/cmms_desktop_view1.jpg', 'description': 'CMMS dashboard section.'},
  ];

  Future<void> _openPlayStore(BuildContext context) async {
    try {
      debugPrint('CmmsPage: Opening Google Play Store');

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

      const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.jvalmacis.cmms';

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
              backgroundColor: Palette.it,
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
              backgroundColor: Palette.danger,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('CmmsPage: Play Store redirect error: $e');

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error redirecting to Play Store. Please visit the Play Store manually.'),
            duration: Duration(seconds: 3),
            backgroundColor: Palette.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < ResponsiveUtils.mobileBreakpoint;
    debugPrint('CmmsPage: Building with screenWidth=$screenWidth');

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, isMobile, screenWidth),
            _buildRolesSection(context, isMobile),
            _buildSecuritySection(context, isMobile),
            _buildFeaturesSection(context, isMobile, screenWidth),
            _buildMediaSection(context, isMobile, screenWidth),
            _buildDownloadSection(context, isMobile),
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
                debugPrint('CmmsPage: Navigating back');
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
                      'NyumbaSmart - CMMS',
                      style: (isMobile
                              ? Theme.of(context).textTheme.headlineLarge
                              : Theme.of(context).textTheme.displaySmall)
                          ?.copyWith(color: Palette.n0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Space.xs),
                    Text(
                      'Facility Management Platform',
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
            subtitle: 'Comprehensive facility management platform with secure, role-based access to manage multiple facilities efficiently.',
          ),
          const SizedBox(height: Space.xl),
          if (isMobile)
            Column(
              children: _userRoles.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: RevealOnScroll(
                  delayMs: 60 * entry.key,
                  child: _buildRoleCard(context, entry.value, isMobile),
                ),
              )).toList(),
            )
          else
            Column(
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
            ),
        ],
      ),
    );
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
          AppCard(
            interactive: false,
            accent: Palette.primary,
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.building2, color: Palette.primary, size: 20),
                    const SizedBox(width: Space.xs),
                    Text(
                      'Facility Selection on Login',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Palette.primaryHover),
                    ),
                  ],
                ),
                const SizedBox(height: Space.xs),
                Text(
                  'Users select their facility (Houses, Garages, Storerooms, Office Buildings, etc.) and only access authorized data, ensuring complete security.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.xl),
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'Security & Access Control',
          ),
          const SizedBox(height: Space.lg),
          if (isMobile)
            Column(
              children: _securityFeatures.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: RevealOnScroll(
                  delayMs: 60 * entry.key,
                  child: _buildSecurityCard(context, entry.value, isMobile),
                ),
              )).toList(),
            )
          else
            Column(
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
            ),
        ],
      ),
    );
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

  Widget _buildFeaturesSection(BuildContext context, bool isMobile, double screenWidth) {
    final isTablet = screenWidth >= ResponsiveUtils.mobileBreakpoint &&
        screenWidth <= ResponsiveUtils.tabletBreakpoint;

    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'Core Features',
          ),
          const SizedBox(height: Space.lg),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: _features.asMap().entries.map((entry) {
              final feature = entry.value;
              return SizedBox(
                width: isMobile ? screenWidth * 0.9 : (screenWidth / (isTablet ? 2 : 4)) - Space.lg,
                child: RevealOnScroll(
                  delayMs: 40 * entry.key,
                  child: AppCard(
                    interactive: false,
                    accent: Palette.it,
                    padding: const EdgeInsets.all(Space.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(feature['icon'] as IconData, size: 20, color: Palette.it),
                        const SizedBox(height: Space.xs),
                        Text(
                          feature['title']!,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          feature['description']!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context, bool isMobile, double screenWidth) {
    final isTablet = screenWidth >= ResponsiveUtils.mobileBreakpoint &&
        screenWidth <= ResponsiveUtils.tabletBreakpoint;

    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            align: TextAlign.start,
            accent: Palette.it,
            title: 'Platform Views',
          ),
          const SizedBox(height: Space.lg),
          Wrap(
            spacing: Space.md,
            runSpacing: Space.md,
            alignment: WrapAlignment.center,
            children: _media.asMap().entries.map((entry) {
              final media = entry.value;
              return RevealOnScroll(
                delayMs: 60 * entry.key,
                child: SizedBox(
                  width: isMobile ? screenWidth * 0.9 : screenWidth * (isTablet ? 0.45 : 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (media['type'] == 'image')
                        Semantics(
                          image: true,
                          label: media['description'],
                          child: ClipRRect(
                            borderRadius: Radii.card,
                            child: SizedBox(
                              height: isMobile ? 200 : 300,
                              child: Image.asset(
                                media['path']!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Palette.n200,
                                  child: const Center(
                                    child: Icon(LucideIcons.imageOff, color: Palette.n500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: Space.xs),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Space.xs),
                        child: Text(
                          media['description']!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
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

  Widget _buildDownloadSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: Palette.ink,
          borderRadius: Radii.card,
        ),
        child: Column(
          children: [
            const Icon(LucideIcons.database, size: 48, color: Palette.n0),
            const SizedBox(height: Space.sm),
            Text(
              'Get NyumbaSmart - CMMS',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Palette.n0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.xs),
            Text(
              'Download from Google Play Store. JV Admin approval required after login.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.lg),
            PrimaryButton(
              text: 'Get from Play Store',
              icon: LucideIcons.download,
              onDark: true,
              large: true,
              onPressed: () => _openPlayStore(context),
            ),
          ],
        ),
      ),
    );
  }
}
