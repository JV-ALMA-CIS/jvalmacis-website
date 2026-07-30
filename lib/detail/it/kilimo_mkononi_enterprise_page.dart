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

class KilimoMkononiEnterprisePage extends StatelessWidget {
  const KilimoMkononiEnterprisePage({super.key});

  static const List<Map<String, String>> _features = [
    {
      'title': 'Tailored Crop Tips',
      'description': 'Practical planting, spacing, soil, and pest guidance specific to selected crops.'
    },
    {
      'title': 'Market Price Advantage',
      'description': 'Access to region-specific price predictions to support direct, profitable sales.'
    },
    {
      'title': 'Weather Planning',
      'description': '5-day forecasts to inform planting, irrigation, and harvest schedules.'
    },
    {
      'title': 'Soil Health Mastery',
      'description': 'Fertility and pH recommendations based on entered soil test data.'
    },
    {
      'title': 'Crop Protection',
      'description': 'Stage-based identification and guidance on managing pests and diseases using chemical or natural options.'
    },
    {
      'title': 'Farm Finance Tracking',
      'description': 'Record-keeping tools for expenses, income, and loan tracking to improve financial planning.'
    },
    {
      'title': 'Innovative Guides',
      'description': 'Certified agricultural techniques to improve yields and introduce sustainable practices.'
    },
  ];

  Future<void> _openPlayStore(BuildContext context) async {
    try {
      debugPrint('KilimoMkononiEnterprisePage: Opening Google Play Store');

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

      const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.jvalmacis.kilimomkononi&pli=1';

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
              backgroundColor: Colors.green,
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
      debugPrint('KilimoMkononiEnterprisePage: Play Store redirect error: $e');

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
    final isTablet = screenWidth >= ResponsiveUtils.mobileBreakpoint &&
        screenWidth <= ResponsiveUtils.tabletBreakpoint;
    debugPrint('KilimoMkononiEnterprisePage: Building with screenWidth=$screenWidth');

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        debugPrint('KilimoMkononiEnterprisePage: Navigating back');
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
                              'Kilimo Mkononi Enterprise',
                              style: (isMobile
                                      ? Theme.of(context).textTheme.headlineLarge
                                      : Theme.of(context).textTheme.displaySmall)
                                  ?.copyWith(color: Palette.n0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Space.xs),
                            Text(
                              'Professional Farming Solutions for Farmers & Enterprises',
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
            Container(height: 3, width: double.infinity, color: Palette.it),
            SectionWrapper(
              background: Palette.n0,
              reveal: false,
              child: isMobile
                  ? _buildMobileLayout(context, screenWidth)
                  : _buildDesktopTabletLayout(context, screenWidth, isTablet),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Palette.n100,
            borderRadius: Radii.card,
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  LucideIcons.wheat,
                  size: 40,
                  color: Palette.n400,
                ),
              ),
              Positioned(
                top: Space.xxs,
                left: Space.xxs,
                child: Chip(
                  label: const Text('Enterprise Edition'),
                  backgroundColor: Palette.agribusiness.withValues(alpha: 0.10),
                  labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Palette.agribusiness,
                        fontSize: 10,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.sm),
        _buildContent(context, screenWidth, true),
      ],
    );
  }

  Widget _buildDesktopTabletLayout(BuildContext context, double screenWidth, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            width: isTablet ? screenWidth * 0.3 : screenWidth * 0.3,
            height: isTablet ? 100 : 120,
            decoration: BoxDecoration(
              color: Palette.n100,
              borderRadius: Radii.card,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    LucideIcons.wheat,
                    size: isTablet ? 40 : 48,
                    color: Palette.n400,
                  ),
                ),
                Positioned(
                  top: Space.xxs,
                  left: Space.xxs,
                  child: Chip(
                    label: const Text('Enterprise Edition'),
                    backgroundColor: Palette.agribusiness.withValues(alpha: 0.10),
                    labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Palette.agribusiness,
                          fontSize: isTablet ? 8 : 10,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(isTablet ? Space.xs : Space.md),
            child: _buildContent(context, screenWidth, false),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, double screenWidth, bool isMobile) {
    final isTablet = screenWidth >= ResponsiveUtils.mobileBreakpoint &&
        screenWidth <= ResponsiveUtils.tabletBreakpoint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kilimo Mkononi Enterprise',
          style: (isMobile
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.headlineSmall)
              ?.copyWith(color: Palette.ink),
        ),
        const SizedBox(height: Space.xs),
        Text(
          'Developed through hands-on work with farming communities and real-world feedback, Kilimo Mkononi Enterprise provides farmers with accessible, actionable tools directly on their mobile phones. Designed for professional farmers and agricultural enterprises growing Beans, Maize, Carrots, Tomatoes, Onions, Courgettes, and Green Peppers to Grow, Protect, and Prosper.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Palette.n600,
              ),
        ),
        const SizedBox(height: Space.sm),
        const SectionHeader(
          title: 'Key Features',
          align: TextAlign.start,
          accent: Palette.it,
        ),
        const SizedBox(height: Space.xs),
        Wrap(
          spacing: isMobile ? Space.xs : Space.sm,
          runSpacing: Space.sm,
          children: _features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return RevealOnScroll(
              delayMs: 60 * index,
              child: SizedBox(
                width: isMobile ? screenWidth * 0.9 : screenWidth * (isTablet ? 0.45 : 0.25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Palette.it,
                    ),
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
            );
          }).toList(),
        ),
        const SizedBox(height: Space.sm),
        const SectionHeader(
          title: 'Impact',
          align: TextAlign.start,
          accent: Palette.it,
        ),
        const SizedBox(height: Space.xs),
        Text(
          'Kilimo Mkononi Enterprise enables smarter, more resilient farming by combining on-the-ground experience with cutting-edge digital tools. It enhances income, strengthens communities, and contributes to a more sustainable agricultural future.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Palette.n600,
              ),
        ),
        const SizedBox(height: Space.md),
        AppCard(
          accent: Palette.it,
          interactive: false,
          child: Column(
            children: [
              const IconChip(icon: LucideIcons.smartphone, color: Palette.it, size: 32),
              const SizedBox(height: Space.sm),
              Text(
                'Get Kilimo Mkononi Enterprise',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.xs),
              Text(
                'Download Kilimo Mkononi Enterprise from Google Play Store and start farming smarter today!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Palette.n600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.md),
              PrimaryButton(
                text: 'Get from Play Store',
                icon: LucideIcons.download,
                onPressed: () => _openPlayStore(context),
                expand: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
