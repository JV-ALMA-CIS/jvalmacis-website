import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import 'footer.dart';
import 'header.dart';

/// The site's legal documents, linked from each other's "Related" list.
const legalDocuments = <(String, String)>[
  ('Privacy Policy', '/privacy-policy'),
  ('Cookies Policy', '/cookies'),
  ('Terms and Conditions', '/terms'),
  ('Delete Account', '/delete-account'),
];

/// Contact details repeated at the end of each legal document.
const legalContactRows = <(String, String)>[
  ('Email', 'support@jvalmacis.co.ke'),
  ('Phone', '+254 795 802 020'),
  ('Address', "King'ara Heights PQ66+2FM Junction, James Gichuru Rd, Nairobi, Kenya"),
];

// ── Content model ────────────────────────────────────────────────────────────

/// One piece of a legal section.
sealed class LegalBlock {
  const LegalBlock();
}

/// A paragraph. Blank lines start new paragraphs.
class LegalText extends LegalBlock {
  const LegalText(this.text);
  final String text;
}

/// A bulleted list, optionally under a short heading.
class LegalList extends LegalBlock {
  const LegalList(this.items, {this.heading});
  final String? heading;
  final List<String> items;
}

/// A statement that needs to stand out from the surrounding text.
class LegalNote extends LegalBlock {
  const LegalNote(this.text);
  final String text;
}

/// Numbered steps: (title, description).
class LegalSteps extends LegalBlock {
  const LegalSteps(this.steps);
  final List<(String, String)> steps;
}

/// Label and value rows, such as contact details.
class LegalDetails extends LegalBlock {
  const LegalDetails(this.rows);
  final List<(String, String)> rows;
}

/// Anything else a document needs, such as an action button.
class LegalCustom extends LegalBlock {
  const LegalCustom(this.builder);
  final WidgetBuilder builder;
}

class LegalSection {
  const LegalSection(this.title, this.blocks);
  final String title;
  final List<LegalBlock> blocks;
}

// ── Page ─────────────────────────────────────────────────────────────────────

/// Layout shared by the legal pages: title and date, a contents list that
/// jumps to each section, numbered sections, and links to the related
/// documents. Text is selectable; emails and web addresses are links.
class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({
    super.key,
    required this.route,
    required this.title,
    required this.meta,
    required this.summary,
    required this.sections,
  });

  /// This page's route, left out of the "Related" list.
  final String route;
  final String title;

  /// Date and version line under the title.
  final String meta;
  final String summary;
  final List<LegalSection> sections;

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage> {
  late final List<GlobalKey> _keys = [for (final _ in widget.sections) GlobalKey()];

  void _jumpTo(int index) {
    final target = _keys[index].currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: Motion.reduced(context) ? Duration.zero : Motion.base,
      curve: Motion.enter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isWide = width >= 1024;
    final titles = [for (final s in widget.sections) s.title];
    final related = [
      for (final d in legalDocuments)
        if (d.$2 != widget.route) d
    ];

    Widget column(Widget child, EdgeInsets padding) => Container(
          width: double.infinity,
          color: Palette.n0,
          padding: padding.add(EdgeInsets.symmetric(horizontal: siteGutter(context))),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: siteContentMax),
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        );

    final sections = SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < widget.sections.length; i++)
            _Section(
              key: _keys[i],
              number: i + 1,
              section: widget.sections[i],
              isLast: i == widget.sections.length - 1,
            ),
        ],
      ),
    );

    final body = isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 248,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Contents(titles: titles, onSelect: _jumpTo),
                    const SizedBox(height: Space.xxl),
                    _Related(documents: related),
                  ],
                ),
              ),
              const SizedBox(width: Space.xxxl),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Space.proseMax),
                    child: sections,
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CollapsibleContents(titles: titles, onSelect: _jumpTo),
              const SizedBox(height: Space.xl),
              sections,
              const SizedBox(height: Space.xl),
              const Divider(height: 1, thickness: 1, color: Palette.n200),
              const SizedBox(height: Space.xl),
              _Related(documents: related),
            ],
          );

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            column(
              _Intro(title: widget.title, meta: widget.meta, summary: widget.summary),
              EdgeInsets.only(
                top: isMobile ? Space.xxl : Space.section - Space.lg,
                bottom: isMobile ? Space.xl : Space.xxl,
              ),
            ),
            column(body, EdgeInsets.only(bottom: isMobile ? Space.xxl : Space.section)),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.title, required this.meta, required this.summary});

  final String title;
  final String meta;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 32, max: 48),
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(meta, style: AppType.theme.bodySmall),
        const SizedBox(height: Space.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(summary, style: AppType.theme.bodyLarge),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).width < 600 ? Space.xl : Space.xxl),
        const Divider(height: 1, thickness: 1, color: Palette.ink),
      ],
    );
  }
}

// ── Contents and related documents ───────────────────────────────────────────

class _AsideLabel extends StatelessWidget {
  const _AsideLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
        header: true,
        child: Text(text.toUpperCase(), style: AppType.eyebrow(Palette.n500)),
      );
}

class _Contents extends StatelessWidget {
  const _Contents({required this.titles, required this.onSelect});

  final List<String> titles;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AsideLabel('On this page'),
        const SizedBox(height: Space.sm),
        for (var i = 0; i < titles.length; i++)
          _AsideLink(
            leading: '${i + 1}.',
            text: titles[i],
            onTap: () => onSelect(i),
          ),
      ],
    );
  }
}

/// Contents list for narrower screens, closed by default so the document
/// starts near the top.
class _CollapsibleContents extends StatefulWidget {
  const _CollapsibleContents({required this.titles, required this.onSelect});

  final List<String> titles;
  final ValueChanged<int> onSelect;

  @override
  State<_CollapsibleContents> createState() => _CollapsibleContentsState();
}

class _CollapsibleContentsState extends State<_CollapsibleContents> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Palette.n200),
        borderRadius: Radii.button,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _open,
            child: InkWell(
              borderRadius: Radii.button,
              onTap: () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'On this page (${widget.titles.length} sections)',
                        style: AppType.theme.titleSmall?.copyWith(color: Palette.ink),
                      ),
                    ),
                    Icon(
                      _open ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                      size: 18,
                      color: Palette.n600,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < widget.titles.length; i++)
                    _AsideLink(
                      leading: '${i + 1}.',
                      text: widget.titles[i],
                      onTap: () => widget.onSelect(i),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Related extends StatelessWidget {
  const _Related({required this.documents});

  final List<(String, String)> documents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AsideLabel('Related'),
        const SizedBox(height: Space.sm),
        for (final (label, route) in documents)
          _AsideLink(
            text: label,
            trailing: LucideIcons.arrowRight,
            onTap: () => Navigator.pushNamed(context, route),
          ),
        _AsideLink(
          text: 'Contact us',
          trailing: LucideIcons.arrowRight,
          onTap: () => Navigator.pushNamed(context, '/contact'),
        ),
      ],
    );
  }
}

class _AsideLink extends StatefulWidget {
  const _AsideLink({required this.text, required this.onTap, this.leading, this.trailing});

  final String text;
  final String? leading;
  final IconData? trailing;
  final VoidCallback onTap;

  @override
  State<_AsideLink> createState() => _AsideLinkState();
}

class _AsideLinkState extends State<_AsideLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = _hover ? Palette.ink : Palette.n600;
    final style = AppType.theme.bodySmall?.copyWith(
      color: color,
      decoration: _hover ? TextDecoration.underline : null,
    );
    return Semantics(
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.leading != null)
                  SizedBox(
                    width: 28,
                    child: Text(widget.leading!, style: style?.copyWith(color: Palette.n400)),
                  ),
                Flexible(child: Text(widget.text, style: style)),
                if (widget.trailing != null) ...[
                  const SizedBox(width: Space.xs),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(widget.trailing, size: 14, color: color),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sections and blocks ───────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({super.key, required this.number, required this.section, required this.isLast});

  final int number;
  final LegalSection section;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final headingStyle = AppType.theme.headlineMedium?.copyWith(
      fontSize: AppType.fluid(context, min: 20, max: 24),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: '$number.  ', style: headingStyle?.copyWith(color: Palette.n400)),
                TextSpan(text: section.title),
              ]),
              style: headingStyle,
            ),
          ),
          const SizedBox(height: Space.md),
          for (var i = 0; i < section.blocks.length; i++) ...[
            if (i > 0) const SizedBox(height: Space.md),
            _block(context, section.blocks[i]),
          ],
        ],
      ),
    );
  }

  Widget _block(BuildContext context, LegalBlock block) {
    final body = AppType.theme.bodyMedium;
    switch (block) {
      case LegalText(:final text):
        final paragraphs = text.split('\n\n');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < paragraphs.length; i++) ...[
              if (i > 0) const SizedBox(height: Space.md),
              LinkedText(paragraphs[i], style: body),
            ],
          ],
        );
      case LegalList(:final heading, :final items):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (heading != null) ...[
              Text(heading, style: AppType.theme.titleMedium?.copyWith(color: Palette.ink)),
              const SizedBox(height: Space.xs),
            ],
            for (final item in items) _Bullet(item),
          ],
        );
      case LegalNote(:final text):
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Space.md),
          decoration: const BoxDecoration(
            color: Palette.n50,
            border: Border(left: BorderSide(color: Palette.ink, width: 3)),
          ),
          child: LinkedText(
            text,
            style: body?.copyWith(color: Palette.ink, fontWeight: FontWeight.w500),
          ),
        );
      case LegalSteps(:final steps):
        return Column(
          children: [
            for (var i = 0; i < steps.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: Space.md),
                decoration: BoxDecoration(
                  border: Border(
                    top: const BorderSide(color: Palette.n200),
                    bottom: i == steps.length - 1
                        ? const BorderSide(color: Palette.n200)
                        : BorderSide.none,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${i + 1}'.padLeft(2, '0'),
                        style: AppType.theme.titleMedium?.copyWith(color: Palette.n400),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(steps[i].$1,
                              style: AppType.theme.titleMedium?.copyWith(color: Palette.ink)),
                          const SizedBox(height: Space.xxs),
                          LinkedText(steps[i].$2, style: body),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      case LegalDetails(:final rows):
        final stacked = MediaQuery.sizeOf(context).width < 600;
        final label = AppType.theme.titleSmall?.copyWith(color: Palette.ink);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (name, value) in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.xs),
                child: stacked
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(name, style: label), LinkedText(value, style: body)],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 96,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(name, style: label),
                            ),
                          ),
                          Expanded(child: LinkedText(value, style: body)),
                        ],
                      ),
              ),
          ],
        );
      case LegalCustom(:final builder):
        return builder(context);
    }
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = AppType.theme.bodyMedium;
    // "Label: explanation" items lead with the label in bold.
    final colon = text.indexOf(': ');
    final hasLabel = colon > 0 && colon <= 45 && !text.substring(0, colon).contains('.');
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11, right: Space.sm),
            child: Container(width: 5, height: 5, color: Palette.n400),
          ),
          Expanded(
            child: hasLabel
                ? LinkedText(
                    text.substring(colon + 2),
                    style: style,
                    lead: '${text.substring(0, colon)}: ',
                  )
                : LinkedText(text, style: style),
          ),
        ],
      ),
    );
  }
}

// ── Links inside text ─────────────────────────────────────────────────────────

final _linkPattern = RegExp(
  r'[\w.+-]+@[\w-]+(?:\.[\w-]+)+'
  r'|(?:https?://)?(?:www\.)?(?:jvalmacis\.com|odpc\.go\.ke|aboutcookies\.org)(?:/[\w-]+)?',
);

/// Text in which email addresses and the known web addresses are links.
/// Addresses on this site open the page in place.
class LinkedText extends StatefulWidget {
  const LinkedText(this.text, {super.key, this.style, this.lead});

  final String text;
  final TextStyle? style;

  /// Optional bold lead-in before [text].
  final String? lead;

  @override
  State<LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<LinkedText> {
  final _recognizers = <TapGestureRecognizer>[];

  void _clear() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _clear();
    super.dispose();
  }

  Future<void> _open(String match) async {
    if (match.contains('@')) {
      await launchUrl(Uri(scheme: 'mailto', path: match));
      return;
    }
    final uri = Uri.parse(match.startsWith('http') ? match : 'https://$match');
    if (uri.host.endsWith('jvalmacis.com')) {
      if (!mounted) return;
      Navigator.pushNamed(context, uri.path.isEmpty ? '/' : uri.path);
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    _clear();
    final spans = <InlineSpan>[];
    if (widget.lead != null) {
      spans.add(TextSpan(
        text: widget.lead,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Palette.ink),
      ));
    }
    var start = 0;
    for (final m in _linkPattern.allMatches(widget.text)) {
      if (m.start > start) spans.add(TextSpan(text: widget.text.substring(start, m.start)));
      final match = m.group(0)!;
      final recognizer = TapGestureRecognizer()..onTap = () => _open(match);
      _recognizers.add(recognizer);
      spans.add(TextSpan(
        text: match,
        recognizer: recognizer,
        mouseCursor: SystemMouseCursors.click,
        style: const TextStyle(
          color: Palette.primary,
          decoration: TextDecoration.underline,
          decorationColor: Palette.primary,
        ),
      ));
      start = m.end;
    }
    if (start < widget.text.length) spans.add(TextSpan(text: widget.text.substring(start)));
    return Text.rich(TextSpan(children: spans), style: widget.style);
  }
}
