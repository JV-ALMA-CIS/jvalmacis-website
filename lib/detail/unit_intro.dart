import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import 'portfolio/project_widgets.dart';

/// The opening of every business unit page, so all four read the same way:
/// a link back to Business Units, the "Business unit" label, the unit's
/// name and one paragraph on what it does.
class UnitIntro extends StatelessWidget {
  const UnitIntro({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArrowLink(
          label: 'Business Units',
          back: true,
          onTap: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/business-units', (route) => false),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).width < 600 ? Space.xl : Space.xxl),
        Text('BUSINESS UNIT', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.md),
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppType.theme.displayMedium?.copyWith(
              fontSize: AppType.fluid(context, min: 34, max: 52),
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(description, style: AppType.theme.bodyLarge),
        ),
      ],
    );
  }
}
