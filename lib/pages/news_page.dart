// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/app_buttons.dart';
import '../widgets/section.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/brand_icons.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        developer.log('NewsPage: Page loaded successfully', name: 'NewsPage');
      }
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  void _showImageDialog(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Palette.n0,
                  borderRadius: Radii.card,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Space.md),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Radii.lg),
                          bottomRight: Radius.circular(Radii.lg),
                        ),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Palette.n200,
                            child: const Center(
                              child: Icon(LucideIcons.imageOff, color: Palette.n400),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Space.xs,
                right: Space.xs,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(Space.xxs),
                    decoration: BoxDecoration(
                      color: Palette.n0,
                      borderRadius: Radii.chip,
                    ),
                    child: const Icon(LucideIcons.x, color: Palette.ink),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    final newsItems = [
      {
        'image': 'assets/news/news_2.jpg',
        'title': 'Pastoralists in West Pokot reap big from seed maize farming',
        'excerpt': 'Transforming lives through agricultural innovation in West Pokot region',
        'date': 'Project Highlight',
        'category': 'Agriculture',
        'color': Palette.agribusiness,
      },
      {
        'image': 'assets/news/wei_wei_project.jpg',
        'title': 'Wei Wei irrigation scheme to be handed over to pastoralists',
        'excerpt': 'Empowering communities with sustainable irrigation infrastructure',
        'date': 'Infrastructure',
        'category': 'Development',
        'color': Palette.construction,
      },
      {
        'image': 'assets/news/italy_project.jpg',
        'title': 'Italian "giardiniera" helps Kenyan farmers',
        'excerpt': 'International collaboration bringing expertise to local agriculture',
        'date': 'Partnership',
        'category': 'Collaboration',
        'color': Palette.danger,
      },
      {
        'image': 'assets/news/news_3.jpg',
        'title': 'Pastoralists in Baringo Kapluk benefit from seed maize farming',
        'excerpt': 'Continued success stories from our agricultural development programs',
        'date': 'Impact Story',
        'category': 'Agriculture',
        'color': Palette.it,
      },
      {
        'image': 'assets/news/gourmet_article.jpg',
        'title': 'From Abruzzo to Kenya: The Digital Revolution Transforming African Agriculture',
        'excerpt': 'Technology, training and sustainable agriculture: the story of an Italian company building a development model in East Africa where innovation and social impact grow together.',
        'date': 'March 6, 2026',
        'category': 'Press',
        'color': Palette.agribusiness,
        'url': 'https://www.gourmetandtravelmagazine.com/2026/03/06/dallabruzzo-al-kenya-la-rivoluzione-digitale-che-sta-cambiando-lagricoltura-africana/',
        'source': 'Gourmet & Travel Magazine',
      },
      {
        'image': 'assets/news/ilpescara_article.jpg',
        'title': 'With JV Almacis, Pescara Native Di Carmine is Leading Agriculture 2.0 in Kenya, Combining Business and Social Development',
        'excerpt': 'How a Pescara entrepreneur built a digital agribusiness model in Kenya, blending technology, sustainability, and social impact across East Africa.',
        'date': 'March 2026',
        'category': 'Press',
        'color': Palette.construction,
        'url': 'https://www.ilpescara.it/attualita/piergiorgio-di-carmine-jv-almacis-kenya-agricoltura-digitale.html',
        'source': 'Il Pescara',
      },
    ];

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Palette.heroSurface),
              padding: Space.sectionPad(isMobile),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.newspaper,
                        size: isMobile ? 40 : 56,
                        color: Palette.n0,
                      ),
                      const SizedBox(height: Space.md),
                      Text(
                        'News & Updates',
                        style: (isMobile
                                ? Theme.of(context).textTheme.headlineLarge
                                : Theme.of(context).textTheme.displaySmall)
                            ?.copyWith(color: Palette.n0),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Space.sm),
                      Text(
                        'Stay informed about JV ALMA C.I.S\'s latest achievements, project milestones, and industry insights',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // News Grid Section
            SectionWrapper(
              background: Palette.n0,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Latest Stories',
                    subtitle: 'Highlights from our recent projects and initiatives',
                  ),
                  const SizedBox(height: Space.xxl),

                  // News Cards Grid
                  Wrap(
                    spacing: Space.lg,
                    runSpacing: Space.lg,
                    children: newsItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return SizedBox(
                        width: isMobile
                            ? double.infinity
                            : isTablet
                                ? (screenWidth - 64) / 2
                                : (screenWidth - 96) / 2,
                        child: RevealOnScroll(
                          delayMs: 60 * index,
                          child: _buildNewsCard(
                            context,
                            isMobile,
                            item['image'] as String,
                            item['title'] as String,
                            item['excerpt'] as String,
                            item['date'] as String,
                            item['category'] as String,
                            item['color'] as Color,
                            externalUrl: item['url'] as String?,
                            source: item['source'] as String?,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Stay Updated Section
            SectionWrapper(
              background: Palette.n50,
              maxWidth: 800,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Space.md),
                    decoration: BoxDecoration(
                      color: Palette.n0,
                      borderRadius: Radii.chip,
                      boxShadow: Elevation.card,
                    ),
                    child: Icon(
                      LucideIcons.bell,
                      size: isMobile ? 32 : 40,
                      color: Palette.primary,
                    ),
                  ),
                  const SizedBox(height: Space.lg),
                  const SectionHeader(
                    title: 'Stay Connected',
                    subtitle:
                        'Follow us on social media for real-time updates, behind-the-scenes content, and more stories from JV ALMA C.I.S',
                  ),
                  const SizedBox(height: Space.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        context,
                        'LinkedIn',
                        BrandIcons.linkedin,
                        () => _launchUrl('https://www.linkedin.com/company/jvalmacis/'),
                      ),
                      const SizedBox(width: Space.md),
                      _buildSocialButton(
                        context,
                        'Instagram',
                        BrandIcons.instagram,
                        () => _launchUrl('https://www.instagram.com/jvalmacis/'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context,
    bool isMobile,
    String imageUrl,
    String title,
    String excerpt,
    String date,
    String category,
    Color categoryColor, {
    String? externalUrl,
    String? source,
  }) {
    final bool isExternal = externalUrl != null && externalUrl.isNotEmpty;
    return AppCard(
      onTap: () {
        if (isExternal) {
          _launchUrl(externalUrl);
        } else {
          _showImageDialog(imageUrl, title);
        }
      },
      accent: categoryColor,
      padding: EdgeInsets.zero,
      semanticLabel: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.lg)),
                child: Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: isMobile ? 200 : 240,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: isMobile ? 200 : 240,
                    color: Palette.n200,
                    child: const Center(
                      child: Icon(LucideIcons.imageOff, color: Palette.n400, size: 48),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Space.sm,
                left: Space.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xxs),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: Radii.chip,
                  ),
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Palette.n0,
                        ),
                  ),
                ),
              ),
              if (isExternal)
                Positioned(
                  top: Space.sm,
                  right: Space.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.xxs),
                    decoration: BoxDecoration(
                      color: Palette.n0.withValues(alpha: 0.9),
                      borderRadius: Radii.chip,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.externalLink, size: 12, color: categoryColor),
                        const SizedBox(width: Space.xxs),
                        Text(
                          'External',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: categoryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(isMobile ? Space.md : Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.tag,
                      size: 14,
                      color: Palette.n400,
                    ),
                    const SizedBox(width: Space.xxs + 2),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Palette.n400,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.sm),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Space.xs),
                Text(
                  excerpt,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Palette.n600,
                        height: 1.5,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Space.md),
                Row(
                  children: [
                    Text(
                      isExternal ? 'Read Article' : 'View Article',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: categoryColor,
                          ),
                    ),
                    const SizedBox(width: Space.xxs),
                    Icon(
                      isExternal ? LucideIcons.externalLink : LucideIcons.arrowRight,
                      size: 16,
                      color: categoryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return PrimaryButton(
      text: label,
      icon: icon,
      onPressed: onPressed,
    );
  }
}
