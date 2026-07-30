import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_buttons.dart';

/// Consistent Save/Cancel form shell reused by every admin editor.
class AdminFormScaffold extends StatelessWidget {
  const AdminFormScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
    required this.onCancel,
    this.saving = false,
    this.error,
  });

  final String title;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool saving;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: Space.lg),
        if (error != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              color: Palette.danger.withValues(alpha: 0.08),
              borderRadius: Radii.card,
              border: Border.all(color: Palette.danger.withValues(alpha: 0.3)),
            ),
            child: Text(error!, style: const TextStyle(color: Palette.danger)),
          ),
          const SizedBox(height: Space.md),
        ],
        child,
        const SizedBox(height: Space.xl),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: saving ? 'Saving...' : 'Save',
              onPressed: saving ? null : onSave,
              loading: saving,
            ),
            const SizedBox(width: Space.md),
            SecondaryButton(
              text: 'Cancel',
              onPressed: saving ? null : onCancel,
            ),
          ],
        ),
      ],
    );
  }
}
