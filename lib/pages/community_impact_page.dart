import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../detail/agribusiness/agribusiness_content.dart';
import '../detail/portfolio/project_widgets.dart';
import '../widgets/app_buttons.dart';
import '../widgets/cms_image.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/hoverable.dart';
import 'community_impact_content.dart';

/// Community & Impact: the community, social, educational and development
/// work of JV ALMA C.I.S as an editorial portfolio. In order: introduction,
/// approach, an index of impact areas, the featured initiatives (the Kapluk
/// case study first), the institutions involved and an invitation to work
/// together. Content lives in community_impact_content.dart.
class CommunityImpactPage extends StatefulWidget {
  const CommunityImpactPage({super.key, this.stories = featuredStories});

  /// The initiatives to feature; unpublished ones are left out.
  final List<ImpactStory> stories;

  @override
  State<CommunityImpactPage> createState() => _CommunityImpactPageState();
}

/// Anchor of the Working Together section.
const _workingTogetherId = 'working-together';

class _CommunityImpactPageState extends State<CommunityImpactPage> {
  final _anchors = <String, GlobalKey>{};

  GlobalKey _anchor(String id) => _anchors.putIfAbsent(id, () => GlobalKey(debugLabel: id));

  void _jumpTo(String id) {
    final target = _anchors[id]?.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target, duration: Motion.slow, curve: Motion.enter);
  }

  void _open(StoryLink link) {
    if (link.storyId case final id?) {
      _jumpTo(id);
    } else if (link.route case final route?) {
      Navigator.pushNamed(context, route);
    } else if (link.url case final url?) {
      _launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = publishedStories(widget.stories);
    final lead = stories.where((s) => s.id == kaplukStory.id).firstOrNull;
    final others = [
      for (final s in stories)
        if (s.id != kaplukStory.id) s
    ];
    final nav = _PageNav(open: _open, jumpTo: _jumpTo, anchor: _anchor);

    return AppScaffold(
      body: SingleChildScrollView(
        child: _Nav(
          nav: nav,
          child: Column(
            children: [
              const _Intro(),
              const _Approach(),
              _Areas(areas: visibleAreas(widget.stories), stories: stories),
              _Featured(lead: lead, others: others),
              _Column(
                key: _anchor(_workingTogetherId),
                color: Palette.n50,
                padding: _sectionPadding(context),
                child: const _WorkingTogether(),
              ),
              const _Closing(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launch(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (e) {
    developer.log('Could not open $url: $e', name: 'CommunityImpactPage');
  }
}

/// What the page's sections need to link within and beyond the page.
class _PageNav {
  const _PageNav({required this.open, required this.jumpTo, required this.anchor});

  final void Function(StoryLink link) open;
  final void Function(String id) jumpTo;
  final GlobalKey Function(String id) anchor;
}

class _Nav extends InheritedWidget {
  const _Nav({required this.nav, required super.child});

  final _PageNav nav;

  static _PageNav of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Nav>()!.nav;

  @override
  bool updateShouldNotify(_Nav oldWidget) => false;
}

// Layout helpers --------------------------------------------------------------

bool _isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= 900;
bool _isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 600;

EdgeInsets _sectionPadding(BuildContext context) =>
    EdgeInsets.symmetric(vertical: _isMobile(context) ? Space.xxxl : Space.section);

/// Centres [child] in the shared content column.
class _Column extends StatelessWidget {
  const _Column({super.key, required this.child, this.padding = EdgeInsets.zero, this.color});

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color ?? Palette.n0,
      padding: padding.add(EdgeInsets.symmetric(horizontal: siteGutter(context))),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: siteContentMax),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

/// A numbered section label, e.g. "03 · IMPACT AREAS".
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.number, this.label);

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text('$number · ${label.toUpperCase()}', style: AppType.eyebrow(Palette.n500));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: AppType.theme.headlineLarge?.copyWith(
          fontSize: AppType.fluid(context, min: 26, max: 34),
        ),
      ),
    );
  }
}

/// Section label and title, with an optional lead paragraph.
class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.number, required this.label, required this.title, this.lead});

  final String number;
  final String label;
  final String title;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(number, label),
        const SizedBox(height: Space.sm),
        _SectionTitle(title),
        if (lead case final lead?) ...[
          const SizedBox(height: Space.md),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.proseMax),
            child: Text(lead, style: AppType.theme.bodyLarge),
          ),
        ],
      ],
    );
  }
}

/// Paragraphs of body text.
class _Paragraphs extends StatelessWidget {
  const _Paragraphs(this.paragraphs, {this.large = false});

  final List<String> paragraphs;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) const SizedBox(height: Space.md),
          Text(
            paragraphs[i],
            style: large ? AppType.theme.bodyLarge : AppType.theme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

/// A link: within the page, to another page, or out to a publication.
class _Link extends StatelessWidget {
  const _Link(this.link);

  final StoryLink link;

  @override
  Widget build(BuildContext context) {
    final nav = _Nav.of(context);
    if (link.url != null) {
      return _ExternalLink(label: link.label, onTap: () => nav.open(link));
    }
    return ArrowLink(label: link.label, onTap: () => nav.open(link));
  }
}

/// A link that leaves the site, marked with an outward arrow.
class _ExternalLink extends StatelessWidget {
  const _ExternalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: '$label (opens in a new tab)',
      builder: (hovered) => Text.rich(
        TextSpan(
          style: AppType.theme.labelLarge?.copyWith(
            color: Palette.primary,
            height: 1.4,
            decoration: hovered ? TextDecoration.underline : null,
            decorationColor: Palette.primary,
          ),
          children: [
            TextSpan(text: '$label '),
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(LucideIcons.arrowUpRight, size: 15, color: Palette.primary),
            ),
          ],
        ),
      ),
    );
  }
}

/// A column of links with even spacing.
class _Links extends StatelessWidget {
  const _Links(this.links);

  final List<StoryLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < links.length; i++) ...[
          if (i > 0) const SizedBox(height: Space.xs),
          _Link(links[i]),
        ],
      ],
    );
  }
}

String _areaTitle(ImpactArea area) => impactAreas.firstWhere((a) => a.area == area).title;

// 01 Introduction ---------------------------------------------------------------

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    return _Column(
      padding: EdgeInsets.only(
        top: mobile ? Space.xxl : Space.section - Space.lg,
        bottom: mobile ? Space.xxl : Space.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('01', 'Community & Impact'),
          const SizedBox(height: Space.md),
          Semantics(
            header: true,
            child: Text(
              introTitle,
              style: AppType.theme.displayMedium?.copyWith(
                fontSize: AppType.fluid(context, min: 34, max: 52),
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Text(
              introHeadline,
              style: AppType.theme.headlineMedium?.copyWith(
                fontSize: AppType.fluid(context, min: 21, max: 28),
                fontWeight: FontWeight.w500,
                height: 1.3,
                color: Palette.ink,
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Space.proseMax),
            child: Text(introText, style: AppType.theme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

// 02 Approach -------------------------------------------------------------------

class _Approach extends StatelessWidget {
  const _Approach();

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    const head = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('02', 'Our approach'),
        SizedBox(height: Space.sm),
        _SectionTitle(approachTitle),
      ],
    );
    const body = _Paragraphs(approachParagraphs, large: true);

    return _Column(
      padding: EdgeInsets.only(bottom: mobile ? Space.xxxl : Space.section),
      child: Container(
        padding: EdgeInsets.only(top: mobile ? Space.xl : Space.xxl),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
        child: _isWide(context)
            ? const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: head),
                  SizedBox(width: Space.xxl),
                  Expanded(flex: 5, child: body),
                ],
              )
            : const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [head, SizedBox(height: Space.lg), body],
              ),
      ),
    );
  }
}

// 03 Impact areas ---------------------------------------------------------------

class _Areas extends StatelessWidget {
  const _Areas({required this.areas, required this.stories});

  final List<ImpactAreaInfo> areas;
  final List<ImpactStory> stories;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900 ? 3 : (width >= 600 ? 2 : 1);

    return _Column(
      color: Palette.n50,
      padding: _sectionPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHead(number: '03', label: 'Impact areas', title: 'Where We Contribute'),
          SizedBox(height: _isMobile(context) ? Space.xl : Space.xxl),
          LayoutBuilder(
            builder: (context, box) {
              const gap = Space.xl;
              final cell = (box.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: Space.xl,
                children: [
                  for (final area in areas)
                    SizedBox(width: cell, child: _AreaEntry(area: area, stories: stories)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// One impact area: its name, a line on it, and the stories it covers.
class _AreaEntry extends StatelessWidget {
  const _AreaEntry({required this.area, required this.stories});

  final ImpactAreaInfo area;
  final List<ImpactStory> stories;

  @override
  Widget build(BuildContext context) {
    final links = area.area == ImpactArea.collaboration
        ? const [StoryLink.story(workingTogetherTitle, _workingTogetherId)]
        : [
            for (final s in stories)
              if (s.areas.contains(area.area)) StoryLink.story(s.title, s.id),
          ];

    return Container(
      padding: const EdgeInsets.only(top: Space.md),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(area.title, style: AppType.theme.titleLarge),
          const SizedBox(height: Space.xs),
          Text(area.summary, style: AppType.theme.bodyMedium),
          const SizedBox(height: Space.sm),
          _Links(links),
        ],
      ),
    );
  }
}

// 04 Featured initiatives -------------------------------------------------------

class _Featured extends StatelessWidget {
  const _Featured({required this.lead, required this.others});

  final ImpactStory? lead;
  final List<ImpactStory> others;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    final nav = _Nav.of(context);

    return Column(
      children: [
        _Column(
          padding: EdgeInsets.only(top: mobile ? Space.xxxl : Space.section),
          child: const _SectionHead(
            number: '04',
            label: 'Featured initiatives',
            title: 'Initiatives in Focus',
            lead: 'Initiatives drawn from project records and photographs. The Kapluk programme '
                'leads; several of the stories that follow were part of it.',
          ),
        ),
        if (lead case final lead?)
          _Column(
            key: nav.anchor(lead.id),
            padding: EdgeInsets.only(top: mobile ? Space.xl : Space.xxl),
            child: _KaplukCaseStudy(story: lead, related: [
              for (final s in others)
                if (s.partOfKapluk) s
            ]),
          ),
        for (final (i, story) in others.indexed)
          _Column(
            key: nav.anchor(story.id),
            padding: EdgeInsets.only(
              top: mobile ? Space.xxl : Space.xxxl,
              bottom: i == others.length - 1 ? (mobile ? Space.xxxl : Space.section) : 0,
            ),
            child: _StoryFeature(story: story, imageFirst: i.isEven),
          ),
      ],
    );
  }
}

/// A small label above a story: its area and, for stories within the Kapluk
/// programme, a link back to the case study.
class _StoryLabel extends StatelessWidget {
  const _StoryLabel({required this.story, this.caseStudy = false});

  final ImpactStory story;
  final bool caseStudy;

  @override
  Widget build(BuildContext context) {
    final nav = _Nav.of(context);
    final area = _areaTitle(story.areas.first).toUpperCase();
    return Wrap(
      spacing: Space.md,
      runSpacing: Space.xxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(caseStudy ? 'CASE STUDY · $area' : area, style: AppType.eyebrow(Palette.n500)),
        if (story.partOfKapluk)
          Hoverable(
            onTap: () => nav.jumpTo(kaplukStory.id),
            scale: 1.0,
            lift: 0,
            semanticLabel: 'Part of the Kapluk programme: go to the case study',
            builder: (hovered) => Container(
              padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.pill),
                border: Border.all(color: hovered ? Palette.primary : Palette.n300),
              ),
              child: Text(
                'Part of the Kapluk programme',
                style: AppType.theme.labelSmall?.copyWith(
                  color: hovered ? Palette.primary : Palette.n600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A story's details as label/value pairs.
class _Facts extends StatelessWidget {
  const _Facts(this.facts, {this.columns = 1});

  final List<StoryFact> facts;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        const gap = Space.lg;
        final cell = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: Space.md,
          children: [
            for (final (label, value) in facts)
              SizedBox(
                width: cell,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label.toUpperCase(), style: AppType.eyebrow(Palette.n500)),
                    const SizedBox(height: Space.xxs),
                    Text(value, style: AppType.theme.bodyMedium?.copyWith(color: Palette.ink)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Figures from the AICS report, attributed as reported by the company.
class _ReportedOutcomes extends StatelessWidget {
  const _ReportedOutcomes(this.outcomes, {this.showReportLink = true});

  final List<String> outcomes;
  final bool showReportLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: Palette.n50,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: Palette.n200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            outcomes.length == 1 ? 'REPORTED OUTCOME' : 'REPORTED OUTCOMES',
            style: AppType.eyebrow(Palette.n500),
          ),
          const SizedBox(height: Space.sm),
          for (final outcome in outcomes)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Text(outcome, style: AppType.theme.titleMedium?.copyWith(height: 1.45)),
            ),
          const SizedBox(height: Space.xxs),
          Text(reportedOutcomesSource,
              style: AppType.theme.bodySmall?.copyWith(color: Palette.n600)),
          if (showReportLink) ...[
            const SizedBox(height: Space.sm),
            const _Link(aicsReportLink),
          ],
        ],
      ),
    );
  }
}

/// Press coverage, linking to the original publications.
class _Press extends StatelessWidget {
  const _Press(this.press);

  final List<PressLink> press;

  @override
  Widget build(BuildContext context) {
    final nav = _Nav.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('IN THE PRESS', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.xs),
        for (final article in press) ...[
          Text(
            '${article.publication} · ${article.date}',
            style: AppType.theme.bodySmall?.copyWith(color: Palette.n600),
          ),
          const SizedBox(height: Space.xxs),
          _ExternalLink(
            label: article.title,
            onTap: () => nav.open(StoryLink.external(article.title, article.url)),
          ),
        ],
      ],
    );
  }
}

/// Photographs of a story: one or two side by side; three or more as a
/// lead photograph over up to three thumbnails, the last counting any it
/// cannot show. Each opens the full set.
class _Photos extends StatelessWidget {
  const _Photos({required this.images, required this.title, this.leadRatio = 16 / 10});

  final List<ProjectImage> images;
  final String title;
  final double leadRatio;

  @override
  Widget build(BuildContext context) {
    Widget tile(int i, double aspectRatio, {int more = 0}) => Hoverable(
          onTap: () => showProjectImageViewer(context, images: images, initial: i, title: title),
          scale: 1.0,
          lift: 0,
          semanticLabel: more > 0
              ? 'View all ${images.length} photographs: $title'
              : 'Enlarge photograph ${i + 1} of ${images.length}: $title'
                  '${images[i].caption != null ? ' (${images[i].caption})' : ''}',
          builder: (hovered) => ClipRRect(
            borderRadius: BorderRadius.circular(Radii.md),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProjectPhoto(images[i], zoom: hovered ? 1.03 : 1.0),
                  if (more > 0)
                    ColoredBox(
                      color: Palette.ink.withValues(alpha: 0.55),
                      child: Center(
                        child: Text(
                          '+$more',
                          style: AppType.theme.headlineMedium?.copyWith(color: Palette.n0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

    if (images.length < 3) {
      return Row(
        children: [
          for (var i = 0; i < images.length; i++) ...[
            if (i > 0) const SizedBox(width: Space.sm),
            Expanded(child: tile(i, images.length > 1 ? 3 / 4 : leadRatio)),
          ],
        ],
      );
    }
    const maxThumbs = 3;
    final thumbs = (images.length - 1).clamp(0, maxThumbs);
    final hidden = images.length - 1 - thumbs;
    return Column(
      children: [
        tile(0, leadRatio),
        const SizedBox(height: Space.sm),
        Row(
          children: [
            for (var t = 0; t < maxThumbs; t++) ...[
              if (t > 0) const SizedBox(width: Space.sm),
              Expanded(
                child: t < thumbs
                    ? tile(t + 1, 4 / 3, more: t == thumbs - 1 ? hidden : 0)
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// The Kapluk case study -----------------------------------------------------------

class _KaplukCaseStudy extends StatelessWidget {
  const _KaplukCaseStudy({required this.story, required this.related});

  final ImpactStory story;

  /// Stories elsewhere on the page that were part of the programme.
  final List<ImpactStory> related;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;
    final mobile = width < 600;
    final project = agribusinessProjects.firstWhere((p) => p.slug == kaplukProjectSlug);
    final nav = _Nav.of(context);

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StoryLabel(story: story, caseStudy: true),
        const SizedBox(height: Space.sm),
        Semantics(
          header: true,
          child: Text(
            story.title,
            style: AppType.theme.headlineLarge?.copyWith(
              fontSize: AppType.fluid(context, min: 26, max: 36),
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        _Paragraphs(story.paragraphs, large: true),
      ],
    );

    return Container(
      padding: EdgeInsets.only(top: mobile ? Space.xl : Space.xxl),
      decoration:
          const BoxDecoration(border: Border(top: BorderSide(color: Palette.ink, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: heading),
                const SizedBox(width: Space.xxl),
                Expanded(flex: 4, child: _Facts(story.facts)),
              ],
            )
          else ...[
            heading,
            const SizedBox(height: Space.lg),
            _Facts(story.facts, columns: mobile ? 1 : 2),
          ],
          const SizedBox(height: Space.xl),
          // The irrigated fields lead, as on the project's own page.
          _Photos(
            images: [project.cover],
            title: story.title,
            leadRatio: mobile ? 4 / 3 : 21 / 9,
          ),
          SizedBox(height: mobile ? Space.xl : Space.xxl),
          wide ? const _ChapterTabs() : const _ChapterStack(),
          if (project.testimonial case final testimonial?) ...[
            SizedBox(height: mobile ? Space.xl : Space.xxl),
            _Quote(testimonial: testimonial),
          ],
          SizedBox(height: mobile ? Space.xl : Space.xxl),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ReportedOutcomes(story.outcomes, showReportLink: false)),
                const SizedBox(width: Space.xxl),
                Expanded(child: _Links(story.links)),
              ],
            )
          else ...[
            _ReportedOutcomes(story.outcomes, showReportLink: false),
            const SizedBox(height: Space.lg),
            _Links(story.links),
          ],
          SizedBox(height: mobile ? Space.xl : Space.xxl),
          const _Origin(),
          if (related.isNotEmpty) ...[
            SizedBox(height: mobile ? Space.xl : Space.xxl),
            Text('ALSO PART OF THIS PROGRAMME', style: AppType.eyebrow(Palette.n500)),
            const SizedBox(height: Space.sm),
            Wrap(
              spacing: Space.xl,
              runSpacing: Space.xs,
              children: [
                for (final s in related) ArrowLink(label: s.title, onTap: () => nav.jumpTo(s.id)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The chapters as tabs beside the open chapter (wide screens).
class _ChapterTabs extends StatefulWidget {
  const _ChapterTabs();

  @override
  State<_ChapterTabs> createState() => _ChapterTabsState();
}

class _ChapterTabsState extends State<_ChapterTabs> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('THE PROGRAMME, CHAPTER BY CHAPTER', style: AppType.eyebrow(Palette.n500)),
              const SizedBox(height: Space.sm),
              for (final (i, chapter) in kaplukChapters.indexed)
                Semantics(
                  selected: i == _selected,
                  child: Hoverable(
                    onTap: () => setState(() => _selected = i),
                    scale: 1.0,
                    lift: 0,
                    semanticLabel: 'Chapter ${i + 1} of ${kaplukChapters.length}: ${chapter.title}',
                    builder: (hovered) {
                      final selected = i == _selected;
                      return AnimatedContainer(
                        duration: Motion.fast,
                        padding:
                            const EdgeInsets.symmetric(vertical: Space.sm, horizontal: Space.md),
                        decoration: BoxDecoration(
                          color: selected ? Palette.n50 : null,
                          border: Border(
                            left: BorderSide(
                              color:
                                  selected ? Palette.ink : (hovered ? Palette.n400 : Palette.n200),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (i + 1).toString().padLeft(2, '0'),
                              style: AppType.theme.labelMedium?.copyWith(
                                color: Palette.n500,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(width: Space.sm),
                            Expanded(
                              child: Text(
                                chapter.title,
                                style: AppType.theme.labelLarge?.copyWith(
                                  color: selected || hovered ? Palette.ink : Palette.n600,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: Space.xxl),
        Expanded(
          child: AnimatedSwitcher(
            duration: Motion.base,
            switchInCurve: Motion.enter,
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topLeft,
              children: [...previous, if (current != null) current],
            ),
            child: _ChapterBody(
              key: ValueKey(_selected),
              chapter: kaplukChapters[_selected],
              number: _selected + 1,
              sideBySide: true,
            ),
          ),
        ),
      ],
    );
  }
}

/// The chapters one after another (narrow screens).
class _ChapterStack extends StatelessWidget {
  const _ChapterStack();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, chapter) in kaplukChapters.indexed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: Space.lg),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
            child: _ChapterBody(chapter: chapter, number: i + 1, sideBySide: false),
          ),
      ],
    );
  }
}

class _ChapterBody extends StatelessWidget {
  const _ChapterBody({
    super.key,
    required this.chapter,
    required this.number,
    required this.sideBySide,
  });

  final KaplukChapter chapter;
  final int number;
  final bool sideBySide;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number.toString().padLeft(2, '0'),
          style: AppType.theme.labelMedium?.copyWith(
            color: Palette.n500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: Space.xs),
        Text(chapter.title, style: AppType.theme.headlineSmall),
        const SizedBox(height: Space.md),
        for (final point in chapter.points)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.xs),
            child: chapter.points.length == 1
                ? Text(point, style: AppType.theme.bodyMedium)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: Space.sm),
                        child: Container(width: 5, height: 5, color: Palette.n400),
                      ),
                      Expanded(child: Text(point, style: AppType.theme.bodyMedium)),
                    ],
                  ),
          ),
        if (chapter.link case final link?) ...[
          const SizedBox(height: Space.xs),
          _Link(link),
        ],
      ],
    );
    final photos = _Photos(images: chapter.images, title: chapter.title);

    return sideBySide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: photos),
              const SizedBox(width: Space.xl),
              Expanded(flex: 4, child: text),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [photos, const SizedBox(height: Space.lg), text],
          );
  }
}

/// The community's own words, from the Kapluk project.
class _Quote extends StatelessWidget {
  const _Quote({required this.testimonial});

  final ProjectTestimonial testimonial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: Space.lg),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Palette.ink, width: 2)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '“${testimonial.quote}”',
              style: AppType.theme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                height: 1.55,
                color: Palette.ink,
              ),
            ),
            const SizedBox(height: Space.md),
            Text('— ${testimonial.attribution}', style: AppType.theme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

/// Where the Kapluk work led: the story of Kilimo Mkononi.
class _Origin extends StatelessWidget {
  const _Origin();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(originEyebrow, style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.sm),
        Text(originTitle, style: AppType.theme.headlineMedium),
      ],
    );
    const body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Paragraphs(originParagraphs, large: true),
        SizedBox(height: Space.md),
        _Link(originLink),
      ],
    );

    // Rounded by clipping: Flutter cannot round a border drawn on one side.
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.lg),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(width < 600 ? Space.lg : Space.xxl),
        decoration: const BoxDecoration(
          color: Palette.n50,
          border: Border(left: BorderSide(color: Palette.primary, width: 4)),
        ),
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: heading),
                  const SizedBox(width: Space.xxl),
                  const Expanded(flex: 5, child: body),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heading, const SizedBox(height: Space.lg), body],
              ),
      ),
    );
  }
}

// Other featured stories ------------------------------------------------------------

/// A featured story: photographs beside its text on wide screens (sides
/// alternating), above it on narrow ones.
class _StoryFeature extends StatelessWidget {
  const _StoryFeature({required this.story, required this.imageFirst});

  final ImpactStory story;
  final bool imageFirst;

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);
    final project = story.projectSlug == null
        ? null
        : agribusinessProjects.where((p) => p.slug == story.projectSlug).firstOrNull;
    final images = story.images.isNotEmpty ? story.images : [if (project != null) project.cover];
    final facts = [
      ...story.facts,
      if (project?.location case final location?) ('Location', location),
      if (project?.period case final period?)
        ('Period', period)
      else if (project?.status case final status?)
        ('Status', status),
    ];

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StoryLabel(story: story),
        const SizedBox(height: Space.sm),
        Semantics(
          header: true,
          child: Text(story.title, style: AppType.theme.headlineMedium),
        ),
        const SizedBox(height: Space.md),
        _Paragraphs(story.paragraphs),
        if (facts.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          _Facts(facts),
        ],
        if (story.outcomes.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          _ReportedOutcomes(story.outcomes),
        ],
        if (story.press.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          _Press(story.press),
        ],
        if (story.links.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          _Links(story.links),
        ],
      ],
    );
    final photos = images.isEmpty
        ? const SizedBox.shrink()
        : _Photos(
            images: images, title: story.title, leadRatio: images.length == 1 ? 4 / 3 : 16 / 10);

    return Container(
      padding: const EdgeInsets.only(top: Space.xl),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageFirst) ...[
                  Expanded(flex: 6, child: photos),
                  const SizedBox(width: Space.xxl),
                  Expanded(flex: 5, child: text),
                ] else ...[
                  Expanded(flex: 5, child: text),
                  const SizedBox(width: Space.xxl),
                  Expanded(flex: 6, child: photos),
                ],
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [photos, const SizedBox(height: Space.lg), text],
            ),
    );
  }
}

// 05 Working together -------------------------------------------------------------

class _WorkingTogether extends StatelessWidget {
  const _WorkingTogether();

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);
    final mobile = _isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHead(
          number: '05',
          label: 'Working together',
          title: workingTogetherTitle,
          lead: workingTogetherIntro,
        ),
        const SizedBox(height: Space.md),
        const _Link(workingTogetherLink),
        SizedBox(height: mobile ? Space.xl : Space.xxl),
        for (final role in CollaboratorRole.values)
          if (collaborators.where((c) => c.role == role).toList() case final group
              when group.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: Space.lg),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n300))),
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child:
                              Text(role.label.toUpperCase(), style: AppType.eyebrow(Palette.n600)),
                        ),
                        const SizedBox(width: Space.xxl),
                        Expanded(child: _CollaboratorGroup(group)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(role.label.toUpperCase(), style: AppType.eyebrow(Palette.n600)),
                        const SizedBox(height: Space.md),
                        _CollaboratorGroup(group),
                      ],
                    ),
            ),
      ],
    );
  }
}

class _CollaboratorGroup extends StatelessWidget {
  const _CollaboratorGroup(this.group);

  final List<Collaborator> group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < group.length; i++) ...[
          if (i > 0) const SizedBox(height: Space.lg),
          _CollaboratorEntry(group[i]),
        ],
      ],
    );
  }
}

class _CollaboratorEntry extends StatelessWidget {
  const _CollaboratorEntry(this.collaborator);

  final Collaborator collaborator;

  @override
  Widget build(BuildContext context) {
    final nav = _Nav.of(context);
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(collaborator.name, style: AppType.theme.titleLarge),
        const SizedBox(height: Space.xxs),
        Text(collaborator.relationship, style: AppType.theme.bodyMedium),
        if (collaborator.storyId case final id?) ...[
          const SizedBox(height: Space.xs),
          ArrowLink(label: 'Related story', onTap: () => nav.jumpTo(id)),
        ],
      ],
    );
    final logo = collaborator.logo;
    if (logo == null) return text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          image: true,
          label: '${collaborator.name} logo',
          child: Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(Space.xxs),
            decoration: BoxDecoration(
              color: Palette.n0,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(color: Palette.n200),
            ),
            child: CmsImage(
              source: logo,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(width: Space.md),
        Expanded(child: text),
      ],
    );
  }
}

// 06 Closing ----------------------------------------------------------------------

class _Closing extends StatelessWidget {
  const _Closing();

  @override
  Widget build(BuildContext context) {
    final wide = _isWide(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('06', 'Work with us'),
        const SizedBox(height: Space.sm),
        Text(
          closingTitle,
          style: AppType.theme.headlineLarge?.copyWith(
            fontSize: AppType.fluid(context, min: 24, max: 30),
          ),
        ),
        const SizedBox(height: Space.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(closingText, style: AppType.theme.bodyLarge),
        ),
      ],
    );
    final button = PrimaryButton(
      text: closingAction,
      icon: LucideIcons.arrowRight,
      onPressed: () => Navigator.pushNamed(context, '/contact'),
    );

    return _Column(
      padding: _sectionPadding(context),
      child: wide
          ? Row(
              children: [
                Expanded(child: text),
                const SizedBox(width: Space.xxl),
                button,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: Space.lg), button],
            ),
    );
  }
}
