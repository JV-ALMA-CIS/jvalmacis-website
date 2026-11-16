// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';
import '../admin/modules/site_settings/site_settings_model.dart';
import '../admin/modules/site_settings/site_settings_provider.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/brand_icons.dart';
import '../widgets/hoverable.dart';

/// A confirmed publication date. [day] is null when only the month is known.
class _NewsDate {
  const _NewsDate(this.year, this.month, [this.day]);

  final int year;
  final int month;
  final int? day;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get label =>
      day == null ? '${_months[month - 1]} $year' : '${_months[month - 1]} $day, $year';

  /// A month-only date sorts after any specific day in the same month.
  int get sortKey => year * 10000 + month * 100 + (day ?? 0);
}

/// One news entry.
///
/// News is not CMS-managed: this list is the page's only data source and has
/// no publication status or detail route. Items with a [url] link out to the
/// publisher; the rest open their [image] (a scanned clipping) in a dialog.
/// [date] is set only where the publication date is confirmed. [featured]
/// is the explicit editorial choice for the featured story.
class _NewsItem {
  const _NewsItem({
    required this.image,
    required this.title,
    required this.summary,
    required this.category,
    this.date,
    this.url,
    this.source,
    this.featured = false,
  });

  final String image;
  final String title;
  final String summary;
  final String category;
  final _NewsDate? date;
  final String? url;
  final String? source;
  final bool featured;

  bool get isExternal => url != null && url!.isNotEmpty;

  String get action => isExternal ? 'Read on ${source ?? 'publisher site'}' : 'View article';
}

const _newsItems = <_NewsItem>[
  // The Wei Wei and "giardiniera" clippings show printed dates
  // (6 March 2020 and 23 November 2023) that the company has not confirmed,
  // so they are deliberately left undated.
  _NewsItem(
    image: 'assets/news/news_2.jpg',
    title: 'Pastoralists in West Pokot reap big from seed maize farming',
    summary: 'Transforming lives through agricultural innovation in West Pokot region',
    category: 'Agriculture',
  ),
  _NewsItem(
    image: 'assets/news/wei_wei_project.jpg',
    title: 'Wei Wei irrigation scheme to be handed over to pastoralists',
    summary: 'Empowering communities with sustainable irrigation infrastructure',
    category: 'Development',
  ),
  _NewsItem(
    image: 'assets/news/italy_project.jpg',
    title: 'Italian "giardiniera" helps Kenyan farmers',
    summary: 'International collaboration bringing expertise to local agriculture',
    category: 'Collaboration',
  ),
  _NewsItem(
    image: 'assets/news/news_3.jpg',
    title: 'Pastoralists in Baringo Kapluk benefit from seed maize farming',
    summary: 'Continued success stories from our agricultural development programs',
    category: 'Agriculture',
  ),
  _NewsItem(
    image: 'assets/news/gourmet_article.jpg',
    title: 'From Abruzzo to Kenya: The Digital Revolution Transforming African Agriculture',
    summary:
        'Technology, training and sustainable agriculture: the story of an Italian company building a development model in East Africa where innovation and social impact grow together.',
    category: 'Press',
    date: _NewsDate(2026, 3, 6),
    url:
        'https://www.gourmetandtravelmagazine.com/2026/03/06/dallabruzzo-al-kenya-la-rivoluzione-digitale-che-sta-cambiando-lagricoltura-africana/',
    source: 'Gourmet & Travel Magazine',
  ),
  _NewsItem(
    image: 'assets/news/ilpescara_article.jpg',
    title:
        'With JV Almacis, Pescara Native Di Carmine is Leading Agriculture 2.0 in Kenya, Combining Business and Social Development',
    summary:
        'How a Pescara entrepreneur built a digital agribusiness model in Kenya, blending technology, sustainability, and social impact across East Africa.',
    category: 'Press',
    date: _NewsDate(2026, 3),
    url:
        'https://www.ilpescara.it/attualita/piergiorgio-di-carmine-jv-almacis-kenya-agricoltura-digitale.html',
    source: 'Il Pescara',
    // Featured: a genuine field photograph from the story itself.
    featured: true,
  ),
];

/// Newest confirmed date first; undated items follow in their original
/// order, never ahead of a dated one.
List<_NewsItem> _orderedNews(List<_NewsItem> items) {
  final indexed = items.indexed.toList()
    ..sort((a, b) {
      final da = a.$2.date;
      final db = b.$2.date;
      if (da != null && db != null) {
        final byDate = db.sortKey.compareTo(da.sortKey);
        if (byDate != 0) return byDate;
      } else if (da != null) {
        return -1;
      } else if (db != null) {
        return 1;
      }
      return a.$1.compareTo(b.$1);
    });
  return [for (final (_, item) in indexed) item];
}

/// Shared column for every section on this page: white ground, site gutter,
/// one editorial width so the header, featured story and list share edges.
class _PageColumn extends StatelessWidget {
  const _PageColumn({required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  static const maxWidth = 1080.0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Container(
      width: double.infinity,
      color: Palette.n0,
      padding: padding.add(EdgeInsets.symmetric(horizontal: isMobile ? 20 : Space.lg)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> {
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
                          semanticLabel: title,
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
                  tooltip: 'Close',
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

  void _open(_NewsItem item) {
    if (item.isExternal) {
      _launchUrl(item.url!);
    } else {
      _showImageDialog(item.image, item.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;

    final ordered = _orderedNews(_newsItems);
    final featured = ordered.where((n) => n.featured && n.image.isNotEmpty).firstOrNull;
    final listing = [
      for (final n in ordered)
        if (!identical(n, featured)) n
    ];

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 01 — Page header: neutral ground, hierarchy from type alone.
            _PageColumn(
              padding: EdgeInsets.only(
                top: isMobile ? Space.xxl : Space.section - Space.lg,
                bottom: isMobile ? Space.xl : Space.xxl,
              ),
              child: const _PageHeader(),
            ),

            // 02 — Featured story, only when one is explicitly marked.
            if (featured != null)
              _PageColumn(
                padding: EdgeInsets.only(bottom: isMobile ? Space.xxl : Space.xxxl),
                child: _FeaturedStory(item: featured, onOpen: () => _open(featured)),
              ),

            // 03 — Article listing.
            _PageColumn(
              padding: EdgeInsets.only(bottom: isMobile ? Space.xxl : Space.xxxl),
              child: _ArticleList(
                items: listing,
                heading: featured != null ? 'More news' : 'Latest news',
                onOpen: _open,
              ),
            ),

            // Social accounts, from the same site settings as the footer.
            _PageColumn(
              padding: EdgeInsets.only(bottom: isMobile ? Space.xxl : Space.xxxl),
              child: _FollowUs(
                onLinkedIn: () => _launchUrl(settings.linkedinUrl),
                onInstagram: () => _launchUrl(settings.instagramUrl),
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'News & Updates',
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 34, max: 48),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Company announcements, developments and updates from across the group.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).width < 600 ? Space.xl : Space.xxl),
        const Divider(height: 1, thickness: 1, color: Palette.ink),
      ],
    );
  }
}

/// Category in brand blue, then the confirmed date if there is one.
class _Meta extends StatelessWidget {
  const _Meta({required this.item});

  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.bodySmall;
    return Wrap(
      spacing: Space.xs,
      runSpacing: Space.xxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(item.category.toUpperCase(), style: AppType.eyebrow(Palette.primary)),
        if (item.date != null) ...[
          Text('·', style: small),
          Text(item.date!.label, style: small),
        ],
      ],
    );
  }
}

class _NewsImage extends StatelessWidget {
  const _NewsImage({
    required this.item,
    required this.aspectRatio,
    required this.decodeWidth,
    this.radius = Radii.sm,
  });

  final _NewsItem item;
  final double aspectRatio;
  final double decodeWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: Palette.n100,
          child: Image.asset(
            item.image,
            fit: BoxFit.cover,
            // Many images are scanned clippings; anchoring to the top keeps
            // the printed headline in frame.
            alignment: Alignment.topCenter,
            // Decode at display size rather than full resolution.
            cacheWidth: (decodeWidth * MediaQuery.devicePixelRatioOf(context)).round(),
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(LucideIcons.imageOff, color: Palette.n400, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wide image beside the story on desktop, image over text on narrow
/// screens. Larger headline and summary than the list, no card chrome.
class _FeaturedStory extends StatelessWidget {
  const _FeaturedStory({required this.item, required this.onOpen});

  final _NewsItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final image = Hoverable(
      onTap: onOpen,
      scale: 1.0,
      lift: 0,
      semanticLabel: '${item.title}. ${item.action}',
      builder: (_) =>
          _NewsImage(item: item, aspectRatio: 3 / 2, decodeWidth: 720, radius: Radii.md),
    );

    final credit = item.isExternal
        ? Padding(
            padding: const EdgeInsets.only(top: Space.xs),
            child: Text(
              'Image: ${item.source}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        : const SizedBox.shrink();

    final story = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('FEATURED', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.md),
        _Meta(item: item),
        const SizedBox(height: Space.sm),
        Text(
          item.title,
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 24, max: 30),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(item.summary, style: AppType.theme.bodyLarge),
        const SizedBox(height: Space.lg),
        SecondaryButton(
          text: item.action,
          icon: item.isExternal ? LucideIcons.externalLink : LucideIcons.arrowRight,
          onPressed: onOpen,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 820) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [image, credit],
                ),
              ),
              const SizedBox(width: Space.xxl),
              Expanded(flex: 5, child: story),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [image, credit, const SizedBox(height: Space.lg), story],
        );
      },
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({required this.items, required this.heading, required this.onOpen});

  final List<_NewsItem> items;
  final String heading;
  final void Function(_NewsItem) onOpen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No news has been published yet.', style: text.titleLarge),
            const SizedBox(height: Space.xs),
            Text('Please check back soon.', style: text.bodyMedium),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(heading, style: text.headlineSmall),
        const SizedBox(height: Space.md),
        const Divider(height: 1, thickness: 1, color: Palette.n200),
        for (final item in items) ...[
          _ArticleRow(item: item, onOpen: () => onOpen(item)),
          const Divider(height: 1, thickness: 1, color: Palette.n200),
        ],
      ],
    );
  }
}

/// Wide: thumbnail, then text. Narrow: text with a small square thumbnail
/// on the right, so the list stays scannable on a phone.
class _ArticleRow extends StatelessWidget {
  const _ArticleRow({required this.item, required this.onOpen});

  final _NewsItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Hoverable(
      onTap: onOpen,
      scale: 1.0,
      lift: 0,
      semanticLabel: '${item.title}. ${item.action}',
      builder: (hovered) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 640;

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Meta(item: item),
              const SizedBox(height: Space.xs),
              AnimatedDefaultTextStyle(
                duration: Motion.fast,
                curve: Motion.hover,
                style: (wide ? text.headlineSmall : text.titleLarge)!.copyWith(
                  color: hovered ? Palette.primary : Palette.ink,
                ),
                child: Text(item.title),
              ),
              const SizedBox(height: Space.xs),
              Text(
                item.summary,
                style: wide ? text.bodyMedium : text.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Space.sm),
              // Icon flows inline so it stays beside the text when it wraps.
              Text.rich(
                TextSpan(
                  text: '${item.action} ',
                  style: text.labelLarge?.copyWith(
                    color: Palette.primary,
                    height: 1.4,
                    decoration: hovered ? TextDecoration.underline : null,
                    decorationColor: Palette.primary,
                  ),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        item.isExternal ? LucideIcons.externalLink : LucideIcons.arrowRight,
                        size: 15,
                        color: Palette.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          return Padding(
            padding: EdgeInsets.symmetric(vertical: wide ? Space.lg : Space.md),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: _NewsImage(item: item, aspectRatio: 4 / 3, decodeWidth: 400),
                      ),
                      const SizedBox(width: Space.xl),
                      Expanded(child: details),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: details),
                      const SizedBox(width: Space.md),
                      SizedBox(
                        width: 88,
                        child: _NewsImage(item: item, aspectRatio: 1, decodeWidth: 176),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _FollowUs extends StatelessWidget {
  const _FollowUs({required this.onLinkedIn, required this.onInstagram});

  final VoidCallback onLinkedIn;
  final VoidCallback onInstagram;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: Palette.n50,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: Palette.n200),
      ),
      child: Wrap(
        spacing: Space.lg,
        runSpacing: Space.md,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Follow JV ALMA C.I.S', style: text.titleLarge),
                const SizedBox(height: Space.xxs),
                Text(
                  'More project news and updates on our social media accounts.',
                  style: text.bodyMedium,
                ),
              ],
            ),
          ),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              SecondaryButton(text: 'LinkedIn', icon: BrandIcons.linkedin, onPressed: onLinkedIn),
              SecondaryButton(
                  text: 'Instagram', icon: BrandIcons.instagram, onPressed: onInstagram),
            ],
          ),
        ],
      ),
    );
  }
}
