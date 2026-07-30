import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/palette.dart';
import '../../../design/tokens.dart';
import '../../../widgets/app_buttons.dart';
import '../../shared/color_key_registry.dart';
import '../../shared/icon_key_registry.dart';
import 'business_unit_editor_page.dart';
import 'business_unit_model.dart';
import 'business_units_provider.dart';

class BusinessUnitsListPage extends ConsumerWidget {
  const BusinessUnitsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(businessUnitsProvider);
    final repo = ref.read(businessUnitsRepositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Business Units', style: Theme.of(context).textTheme.headlineSmall),
            ),
            PrimaryButton(text: 'Add unit', onPressed: () => _openEditor(context, null)),
          ],
        ),
        const SizedBox(height: Space.lg),
        unitsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(Space.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Failed to load: $e'),
          data: (units) {
            if (units.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No business units yet.'),
                  const SizedBox(height: Space.md),
                  SecondaryButton(
                    text: 'Seed default content',
                    onPressed: () => repo.seedDefaults(),
                  ),
                ],
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: Space.sm),
                  child: ListTile(
                    leading: Icon(
                      IconKeyRegistry.resolve(unit.iconKey),
                      color: ColorKeyRegistry.resolve(unit.accentColorKey),
                    ),
                    title: Text(unit.title),
                    subtitle: Text(unit.tagline),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          tooltip: 'Move up',
                          onPressed: index == 0 ? null : () => repo.swapOrder(units, index, index - 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          tooltip: 'Move down',
                          onPressed: index == units.length - 1
                              ? null
                              : () => repo.swapOrder(units, index, index + 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () => _openEditor(context, unit),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Palette.danger),
                          tooltip: 'Delete',
                          onPressed: () => repo.delete(unit.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _openEditor(BuildContext context, BusinessUnit? unit) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: SingleChildScrollView(child: BusinessUnitEditorPage(unit: unit)),
          ),
        ),
      ),
    );
  }
}
