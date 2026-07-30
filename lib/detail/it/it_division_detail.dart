import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../../widgets/responsive_utils.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section.dart';
import '../../widgets/reveal_on_scroll.dart';
import '../../design/palette.dart';
import '../../design/tokens.dart';

class ITDivisionDetail extends StatelessWidget {
  const ITDivisionDetail({super.key});

  static const List<Map<String, dynamic>> _products = [
    {
      'icon': LucideIcons.hardHat,
      'title': 'AlmaWorks',
      'subtitle': 'Construction Management Software',
      'description': 'Proprietary construction management platform designed for sensitive construction operations with comprehensive role-based security.',
      'route': '/alma-works',
      'color': Palette.construction,
      'badge': 'Construction Solution',
      
      'features': [
        'Role-based access control',
        'Project & contract management',
        'Financial tracking & billing',
      ],
    },
    {
      'icon': LucideIcons.database,
      'title': 'NyumbaSmart - CMMS',
      'subtitle': 'Facility Management Platform',
      'description': 'Comprehensive facility management software with secure role-based access for multiple facility types and complete audit trails.',
      'route': '/cmms',
      'color': Palette.it,
      'badge': 'Facility Management',
      
      'features': [
        'Multi-facility management',
        'Work order & maintenance tracking',
        'Document tracking & security',
      ],
    },
    {
      'icon': LucideIcons.smartphone,
      'title': 'Kilimo Mkononi',
      'subtitle': 'Agricultural Platform Suite',
      'description': 'Comprehensive agricultural platform with Enterprise and Education editions helping thousands of farmers across Kenya.',
      'route': '/kilimo-mkononi',
      'color': Palette.success,
      'badge': 'Agricultural Solutions',
      
      'features': [
        'Enterprise & Education editions',
        'Weather forecasting & crop management',
        'Pest management & soil health',
      ],
    },
    {
      'icon': LucideIcons.coffee,
      'title': 'Coffee Core',
      'subtitle': 'Coffee Farmers Network',
      'description': 'Dedicated platform connecting coffee farmers with cooperatives for better market access, pricing, and quality control.',
      'route': '/coffee-core',
      'color': Palette.oilGas,
      'badge': 'Coffee Farmers',
      
      'features': [
        'Cooperative integration system',
        'Coffee-specific farming guidance',
        'Market access & yield tracking',
      ],
    },
  ];

  static const List<Map<String, dynamic>> _capabilities = [
    {
      'icon': LucideIcons.cloud,
      'title': 'Cloud-Based',
      'description': 'Secure, scalable infrastructure for global access',
    },
    {
      'icon': LucideIcons.smartphone,
      'title': 'Mobile First',
      'description': 'Native apps for iOS and Android',
    },
    {
      'icon': LucideIcons.lock,
      'title': 'Enterprise Security',
      'description': 'Role-based access, encryption, audit trails',
    },
    {
      'icon': LucideIcons.zap,
      'title': 'Real-Time Sync',
      'description': 'Instant data synchronization across devices',
    },
    {
      'icon': LucideIcons.gauge,
      'title': 'Advanced Analytics',
      'description': 'Comprehensive dashboards and reporting',
    },
    {
      'icon': LucideIcons.users,
      'title': 'Collaboration',
      'description': 'Team tools for seamless coordination',
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
            // Hero Section
            _buildHeroSection(context, isMobile, screenWidth),

            // Division Overview
            _buildOverviewSection(context, isMobile),

            // Products Grid
            _buildProductsSection(context, isMobile),

            // Technical Capabilities
            _buildCapabilitiesSection(context, isMobile),

            // CTA Section
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
                constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 900),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.globe,
                      size: isMobile ? 36 : 48,
                      color: Palette.n0,
                    ),
                    const SizedBox(height: Space.sm),
                    Text(
                      'IT Division',
                      style: (isMobile
                              ? Theme.of(context).textTheme.headlineLarge
                              : Theme.of(context).textTheme.displaySmall)
                          ?.copyWith(color: Palette.n0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Space.sm),
                    Text(
                      'Innovative software solutions powering operations across construction, agriculture, and facility management.',
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

  Widget _buildOverviewSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      topRule: Palette.it,
      background: Palette.n0,
      child: Column(
        children: [
          const SectionHeader(
            title: 'Our IT Division',
            subtitle: 'Our in-house IT division develops cutting-edge software solutions that power our operations across all business units. From facility management systems to agricultural mobile applications, we create technology that drives efficiency and innovation.',
            accent: Palette.it,
          ),
          if (!isMobile) ...[
            const SizedBox(height: Space.xl),
            /*const AppCard(
              interactive: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, '4', 'Core Products'),
                  _buildStatItem(context, '8+', 'Years of Dev'),
                  _buildStatItem(context, '10K+', 'Active Users'),
                  _buildStatItem(context, '100%', 'Uptime Focus'),
                ],
              ),
            ),*/
          ],
        ],
      ),
    );
  }

  /*Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Palette.it),
        ),
        const SizedBox(height: Space.xxs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }*/

  Widget _buildProductsSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n50,
      child: Column(
        children: [
          const SectionHeader(
            title: 'Our Software Solutions',
            accent: Palette.it,
          ),
          const SizedBox(height: Space.xl),
          if (isMobile)
            Column(
              children: _products.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: RevealOnScroll(
                  delayMs: 60 * entry.key,
                  child: _buildProductCard(context, entry.value, isMobile),
                ),
              )).toList(),
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
                        child: _buildProductCard(context, _products[0], isMobile),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 60,
                        child: _buildProductCard(context, _products[1], isMobile),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 120,
                        child: _buildProductCard(context, _products[2], isMobile),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: RevealOnScroll(
                        delayMs: 180,
                        child: _buildProductCard(context, _products[3], isMobile),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, bool isMobile) {
    final color = product['color'] as Color;
    return AppCard(
      accent: color,
      onTap: () {
        Navigator.pushNamed(context, product['route'] as String);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon and Badge
          Row(
            children: [
              IconChip(icon: product['icon'] as IconData, color: color),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xxs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: Radii.chip,
                ),
                child: Text(
                  product['badge'] as String,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),

          // Title
          Text(
            product['title'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: Space.xxs),

          // Subtitle
          Text(
            product['subtitle'] as String,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
          ),
          const SizedBox(height: Space.sm),

          // Description
          Text(
            product['description'] as String,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: Space.sm),

          // Metrics (optional — not every product entry defines these)
          if ((product['metrics'] as Map<String, String>?)?.isNotEmpty ?? false) ...[
            Container(
              padding: const EdgeInsets.all(Space.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: Radii.chip,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: (product['metrics'] as Map<String, String>).entries.map((entry) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.value,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: Space.sm),
          ],

          // Features
          ...(product['features'] as List<String>).map((feature) => Padding(
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
                    feature,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: Space.md),

          // Learn More Link
          Row(
            children: [
              Text(
                'Learn more',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
              ),
              const SizedBox(width: Space.xxs),
              Icon(
                LucideIcons.arrowRight,
                size: 16,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilitiesSection(BuildContext context, bool isMobile) {
    return SectionWrapper(
      background: Palette.n0,
      child: Column(
        children: [
          const SectionHeader(
            title: 'Technical Capabilities',
            accent: Palette.it,
          ),
          const SizedBox(height: Space.xl),
          if (isMobile)
            Column(
              children: _capabilities.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: RevealOnScroll(
                    delayMs: 60 * entry.key,
                    child: _buildCapabilityCard(context, entry.value, isMobile),
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
                    Expanded(child: RevealOnScroll(delayMs: 0, child: _buildCapabilityCard(context, _capabilities[0], isMobile))),
                    const SizedBox(width: Space.md),
                    Expanded(child: RevealOnScroll(delayMs: 60, child: _buildCapabilityCard(context, _capabilities[1], isMobile))),
                    const SizedBox(width: Space.md),
                    Expanded(child: RevealOnScroll(delayMs: 120, child: _buildCapabilityCard(context, _capabilities[2], isMobile))),
                  ],
                ),
                const SizedBox(height: Space.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: RevealOnScroll(delayMs: 180, child: _buildCapabilityCard(context, _capabilities[3], isMobile))),
                    const SizedBox(width: Space.md),
                    Expanded(child: RevealOnScroll(delayMs: 240, child: _buildCapabilityCard(context, _capabilities[4], isMobile))),
                    const SizedBox(width: Space.md),
                    Expanded(child: RevealOnScroll(delayMs: 300, child: _buildCapabilityCard(context, _capabilities[5], isMobile))),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCapabilityCard(BuildContext context, Map<String, dynamic> capability, bool isMobile) {
    return AppCard(
      interactive: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconChip(icon: capability['icon'] as IconData, color: Palette.it),
          const SizedBox(height: Space.sm),
          Text(
            capability['title'] as String,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: Space.xxs),
          Text(
            capability['description'] as String,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready to Transform Your Operations?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Palette.n0),
            ),
            const SizedBox(height: Space.sm),
            Text(
              'Discover how our software solutions can streamline your business processes and unlock new opportunities.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: Space.lg),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                PrimaryButton(
                  text: 'Schedule a Demo',
                  icon: LucideIcons.mail,
                  onDark: true,
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact');
                  },
                ),
                SecondaryButton(
                  text: 'Request Info',
                  icon: LucideIcons.download,
                  onDark: true,
                  onPressed: () {
                    // Navigate to case studies or docs
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
