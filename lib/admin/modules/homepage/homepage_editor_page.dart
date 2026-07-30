import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/palette.dart';
import '../../../design/tokens.dart';
import '../../../widgets/cms_image.dart';
import '../../shared/admin_form_scaffold.dart';
import '../../shared/image_upload_field.dart';
import 'homepage_model.dart';
import 'homepage_provider.dart';

class HomepageEditorPage extends ConsumerStatefulWidget {
  const HomepageEditorPage({super.key});

  @override
  ConsumerState<HomepageEditorPage> createState() => _HomepageEditorPageState();
}

class _HomepageEditorPageState extends ConsumerState<HomepageEditorPage> {
  bool _initialized = false;
  String _heroBackgroundImageUrl = '';
  late TextEditingController _heroTitle;
  late TextEditingController _heroCtaText;
  late TextEditingController _heroCtaRoute;
  late TextEditingController _ctaBandTitle;
  late TextEditingController _ctaBandSubtitle;
  late TextEditingController _ctaBandButtonText;
  late TextEditingController _ctaBandButtonRoute;
  late List<ClientLogo> _clientLogos;
  bool _saving = false;
  String? _error;

  void _initFrom(HomepageContent c) {
    _heroTitle = TextEditingController(text: c.heroTitle);
    _heroCtaText = TextEditingController(text: c.heroCtaText);
    _heroCtaRoute = TextEditingController(text: c.heroCtaRoute);
    _ctaBandTitle = TextEditingController(text: c.ctaBandTitle);
    _ctaBandSubtitle = TextEditingController(text: c.ctaBandSubtitle);
    _ctaBandButtonText = TextEditingController(text: c.ctaBandButtonText);
    _ctaBandButtonRoute = TextEditingController(text: c.ctaBandButtonRoute);
    _clientLogos = List.of(c.clientLogos);
    _heroBackgroundImageUrl = c.heroBackgroundImageUrl;
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) {
      _heroTitle.dispose();
      _heroCtaText.dispose();
      _heroCtaRoute.dispose();
      _ctaBandTitle.dispose();
      _ctaBandSubtitle.dispose();
      _ctaBandButtonText.dispose();
      _ctaBandButtonRoute.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final content = HomepageContent(
      heroTitle: _heroTitle.text.trim(),
      heroCtaText: _heroCtaText.text.trim(),
      heroCtaRoute: _heroCtaRoute.text.trim(),
      heroBackgroundImageUrl: _heroBackgroundImageUrl,
      ctaBandTitle: _ctaBandTitle.text.trim(),
      ctaBandSubtitle: _ctaBandSubtitle.text.trim(),
      ctaBandButtonText: _ctaBandButtonText.text.trim(),
      ctaBandButtonRoute: _ctaBandButtonRoute.text.trim(),
      clientLogos: _clientLogos,
    );
    try {
      await ref.read(homepageRepositoryProvider).save(content);
    } catch (e) {
      setState(() => _error = 'Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(homepageProvider);

    return contentAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Failed to load: $e'),
      data: (content) {
        if (!_initialized) _initFrom(content);

        return AdminFormScaffold(
          title: 'Homepage',
          saving: _saving,
          error: _error,
          onSave: _save,
          onCancel: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hero', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: Space.xs),
              TextField(
                controller: _heroTitle,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Hero title'),
              ),
              const SizedBox(height: Space.sm),
              TextField(controller: _heroCtaText, decoration: const InputDecoration(labelText: 'Hero button text')),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _heroCtaRoute,
                decoration: const InputDecoration(labelText: 'Hero button route'),
              ),
              const SizedBox(height: Space.md),
              ImageUploadField(
                label: 'Hero background image',
                currentImageUrl: _heroBackgroundImageUrl,
                storagePathBuilder: (filename) => 'homepage/hero/$filename',
                onUploaded: (url) => setState(() => _heroBackgroundImageUrl = url),
              ),
              const SizedBox(height: Space.lg),
              Text('CTA band', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: Space.xs),
              TextField(
                controller: _ctaBandTitle,
                decoration: const InputDecoration(labelText: 'CTA band title'),
              ),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _ctaBandSubtitle,
                decoration: const InputDecoration(labelText: 'CTA band subtitle'),
              ),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _ctaBandButtonText,
                decoration: const InputDecoration(labelText: 'CTA band button text'),
              ),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _ctaBandButtonRoute,
                decoration: const InputDecoration(labelText: 'CTA band button route'),
              ),
              const SizedBox(height: Space.lg),
              Text('Client logos', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: Space.xs),
              ..._clientLogos.asMap().entries.map((e) => _logoRow(e.key, e.value)),
              TextButton.icon(
                onPressed: () => setState(() => _clientLogos.add(ClientLogo(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      imageUrl: '',
                      name: '',
                      order: _clientLogos.length,
                    ))),
                icon: const Icon(Icons.add),
                label: const Text('Add client logo'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _logoRow(int index, ClientLogo logo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 32,
            child: CmsImage(
              source: logo.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Palette.n100),
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: TextFormField(
              initialValue: logo.name,
              decoration: const InputDecoration(labelText: 'Client name'),
              onChanged: (v) => _clientLogos[index] = logo.copyWith(name: v),
            ),
          ),
          const SizedBox(width: Space.sm),
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: 'Upload logo',
            onPressed: () async {
              // Delegates to a one-off ImageUploadField shown in a dialog so
              // the row stays compact — a full field would be too tall for
              // a repeated-row list.
              await showDialog<void>(
                context: context,
                builder: (_) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.lg),
                    child: SizedBox(
                      width: 360,
                      child: ImageUploadField(
                        label: 'Logo image',
                        currentImageUrl: logo.imageUrl,
                        storagePathBuilder: (filename) => 'homepage/clients/${logo.id}/$filename',
                        onUploaded: (url) {
                          setState(() => _clientLogos[index] = logo.copyWith(imageUrl: url));
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => setState(() => _clientLogos.removeAt(index)),
          ),
        ],
      ),
    );
  }
}
