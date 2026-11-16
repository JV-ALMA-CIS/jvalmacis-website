import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/cms_image.dart';
import '../../widgets/logo_marquee.dart';
import 'agribusiness_content.dart';

/// The institutions side by side, each with its logo above what its
/// agreement covers. Past [maxInRow] the logos move into a scrolling strip
/// and the details follow in a grid.
class InstitutionList extends StatelessWidget {
  const InstitutionList({
    super.key,
    required this.institutions,
    required this.wide,
    this.maxInRow = 3,
  });

  final List<Institution> institutions;
  final bool wide;
  final int maxInRow;

  @override
  Widget build(BuildContext context) {
    final strip = institutions.length > maxInRow;
    final blocks = [
      for (final institution in institutions)
        _InstitutionBlock(institution: institution, showLogo: !strip, compact: !wide),
    ];

    Widget layout;
    if (!wide) {
      layout = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < blocks.length; i++) ...[
            if (i > 0) const SizedBox(height: Space.xl),
            blocks[i],
          ],
        ],
      );
    } else {
      final columns = strip ? maxInRow : institutions.length.clamp(1, maxInRow);
      layout = LayoutBuilder(
        builder: (context, box) {
          const gap = Space.xxl;
          final cell = (box.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: Space.xxl,
            children: [for (final b in blocks) SizedBox(width: cell, child: b)],
          );
        },
      );
    }

    if (!strip) return layout;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Institutions: ${[for (final i in institutions) i.name].join(', ')}',
          child: ExcludeSemantics(
            child: LogoMarquee(assetPaths: [for (final i in institutions) i.logo], logoHeight: 64),
          ),
        ),
        const SizedBox(height: Space.xl),
        layout,
      ],
    );
  }
}

class _InstitutionBlock extends StatelessWidget {
  const _InstitutionBlock({
    required this.institution,
    required this.showLogo,
    required this.compact,
  });

  final Institution institution;
  final bool showLogo;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLogo) ...[
          Semantics(
            image: true,
            label: '${institution.name} logo',
            // A white tile, so logos with white margins sit cleanly on any
            // background.
            child: Container(
              width: compact ? 112 : 136,
              height: compact ? 104 : 128,
              padding: const EdgeInsets.all(Space.xs),
              decoration: BoxDecoration(
                color: Palette.n0,
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(color: Palette.n200),
              ),
              child: CmsImage(
                source: institution.logo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(height: Space.lg),
        ],
        Text(institution.name, style: AppType.theme.headlineSmall),
        const SizedBox(height: Space.sm),
        Text(institution.summary, style: AppType.theme.bodyMedium),
        if (institution.signatories.isNotEmpty) ...[
          const SizedBox(height: Space.md),
          Text('SIGNATORIES', style: AppType.eyebrow(Palette.n500)),
          const SizedBox(height: Space.xs),
          for (final signatory in institution.signatories)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xxs),
              child: Text(signatory, style: AppType.theme.bodySmall?.copyWith(color: Palette.n600)),
            ),
        ],
      ],
    );
  }
}
