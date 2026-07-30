import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens.dart';
import '../../shared/admin_form_scaffold.dart';
import '../../shared/color_key_registry.dart';
import '../../shared/icon_key_registry.dart';
import '../../shared/image_upload_field.dart';
import 'business_unit_model.dart';
import 'business_units_provider.dart';

class BusinessUnitEditorPage extends ConsumerStatefulWidget {
  const BusinessUnitEditorPage({super.key, this.unit});

  final BusinessUnit? unit;

  @override
  ConsumerState<BusinessUnitEditorPage> createState() => _BusinessUnitEditorPageState();
}

class _BusinessUnitEditorPageState extends ConsumerState<BusinessUnitEditorPage> {
  late final TextEditingController _title;
  late final TextEditingController _tagline;
  late final TextEditingController _description;
  late final TextEditingController _route;
  late final TextEditingController _ctaText;
  late String _iconKey;
  late String _accentColorKey;
  late bool _featured;
  late bool _published;
  late String _imageUrl;
  late final String _storageId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final u = widget.unit;
    _title = TextEditingController(text: u?.title ?? '');
    _tagline = TextEditingController(text: u?.tagline ?? '');
    _description = TextEditingController(text: u?.description ?? '');
    _route = TextEditingController(text: u?.route ?? '');
    _ctaText = TextEditingController(text: u?.ctaText ?? 'Learn more');
    _iconKey = u?.iconKey ?? IconKeyRegistry.fallbackKey;
    _accentColorKey = u?.accentColorKey ?? ColorKeyRegistry.fallbackKey;
    _featured = u?.featured ?? true;
    _published = u?.published ?? true;
    _imageUrl = u?.imageUrl ?? '';
    _storageId = u?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    _title.dispose();
    _tagline.dispose();
    _description.dispose();
    _route.dispose();
    _ctaText.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _route.text.trim().isEmpty) {
      setState(() => _error = 'Title and route are required.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final repo = ref.read(businessUnitsRepositoryProvider);
    final existing = widget.unit;
    try {
      final order = existing?.order ?? await repo.nextOrder();
      final unit = BusinessUnit(
        id: existing?.id ?? '',
        title: _title.text.trim(),
        tagline: _tagline.text.trim(),
        description: _description.text.trim(),
        iconKey: _iconKey,
        accentColorKey: _accentColorKey,
        imageUrl: _imageUrl,
        route: _route.text.trim(),
        ctaText: _ctaText.text.trim(),
        featured: _featured,
        order: order,
        published: _published,
      );
      if (existing == null) {
        await repo.create(unit);
      } else {
        await repo.update(unit);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminFormScaffold(
      title: widget.unit == null ? 'Add business unit' : 'Edit business unit',
      saving: _saving,
      error: _error,
      onSave: _save,
      onCancel: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: Space.sm),
          TextField(
            controller: _tagline,
            decoration: const InputDecoration(labelText: 'Tagline (short, homepage card)'),
          ),
          const SizedBox(height: Space.sm),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Description (full, Business Units page)'),
          ),
          const SizedBox(height: Space.sm),
          TextField(
            controller: _route,
            decoration: const InputDecoration(labelText: 'Route (e.g. /construction-detail)'),
          ),
          const SizedBox(height: Space.sm),
          TextField(controller: _ctaText, decoration: const InputDecoration(labelText: 'Button text')),
          const SizedBox(height: Space.md),
          DropdownButtonFormField<String>(
            initialValue: _iconKey,
            decoration: const InputDecoration(labelText: 'Icon'),
            items: IconKeyRegistry.keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) => setState(() => _iconKey = v ?? _iconKey),
          ),
          const SizedBox(height: Space.sm),
          DropdownButtonFormField<String>(
            initialValue: _accentColorKey,
            decoration: const InputDecoration(labelText: 'Accent color'),
            items: ColorKeyRegistry.keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) => setState(() => _accentColorKey = v ?? _accentColorKey),
          ),
          const SizedBox(height: Space.md),
          ImageUploadField(
            label: 'Card image (optional)',
            currentImageUrl: _imageUrl,
            storagePathBuilder: (filename) => 'business-units/$_storageId/$filename',
            onUploaded: (url) => setState(() => _imageUrl = url),
          ),
          const SizedBox(height: Space.md),
          SwitchListTile(
            title: const Text('Featured on homepage'),
            value: _featured,
            onChanged: (v) => setState(() => _featured = v),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Published'),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
