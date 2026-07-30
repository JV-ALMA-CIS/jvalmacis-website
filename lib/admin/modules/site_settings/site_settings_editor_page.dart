import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens.dart';
import '../../shared/admin_form_scaffold.dart';
import 'site_settings_model.dart';
import 'site_settings_provider.dart';

class SiteSettingsEditorPage extends ConsumerStatefulWidget {
  const SiteSettingsEditorPage({super.key});

  @override
  ConsumerState<SiteSettingsEditorPage> createState() => _SiteSettingsEditorPageState();
}

class _SiteSettingsEditorPageState extends ConsumerState<SiteSettingsEditorPage> {
  bool _initialized = false;
  String _logoImageUrl = '';
  late TextEditingController _companyName;
  late TextEditingController _companyEmail;
  late TextEditingController _companyPhone;
  late TextEditingController _linkedin;
  late TextEditingController _instagram;
  late TextEditingController _twitter;
  late TextEditingController _footerTagline;
  late TextEditingController _copyright;
  late List<OfficeLocation> _offices;
  late List<NavItem> _navItems;
  bool _saving = false;
  String? _error;

  void _initFrom(SiteSettings s) {
    _companyName = TextEditingController(text: s.companyName);
    _companyEmail = TextEditingController(text: s.companyEmail);
    _companyPhone = TextEditingController(text: s.companyPhone);
    _linkedin = TextEditingController(text: s.linkedinUrl);
    _instagram = TextEditingController(text: s.instagramUrl);
    _twitter = TextEditingController(text: s.twitterUrl);
    _footerTagline = TextEditingController(text: s.footerTagline);
    _copyright = TextEditingController(text: s.copyrightText);
    _offices = List.of(s.officeLocations);
    _navItems = List.of(s.navigation);
    _logoImageUrl = s.logoImageUrl;
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) {
      _companyName.dispose();
      _companyEmail.dispose();
      _companyPhone.dispose();
      _linkedin.dispose();
      _instagram.dispose();
      _twitter.dispose();
      _footerTagline.dispose();
      _copyright.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final settings = SiteSettings(
      companyName: _companyName.text.trim(),
      companyEmail: _companyEmail.text.trim(),
      companyPhone: _companyPhone.text.trim(),
      officeLocations: _offices,
      linkedinUrl: _linkedin.text.trim(),
      instagramUrl: _instagram.text.trim(),
      twitterUrl: _twitter.text.trim(),
      navigation: _navItems,
      footerTagline: _footerTagline.text.trim(),
      copyrightText: _copyright.text.trim(),
      logoImageUrl: _logoImageUrl,
    );
    try {
      await ref.read(siteSettingsRepositoryProvider).save(settings);
    } catch (e) {
      setState(() => _error = 'Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(siteSettingsProvider);

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Failed to load: $e'),
      data: (settings) {
        if (!_initialized) _initFrom(settings);

        return AdminFormScaffold(
          title: 'Site Settings',
          saving: _saving,
          error: _error,
          onSave: _save,
          onCancel: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _companyName,
                decoration: const InputDecoration(labelText: 'Company name'),
              ),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _companyEmail,
                decoration: const InputDecoration(labelText: 'Company email'),
              ),
              const SizedBox(height: Space.sm),
              TextField(
                controller: _companyPhone,
                decoration: const InputDecoration(labelText: 'Company phone'),
              ),
              const SizedBox(height: Space.lg),
              Text('Office locations', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: Space.xs),
              ..._offices.asMap().entries.map((e) => _officeRow(e.key, e.value)),
              TextButton.icon(
                onPressed: () => setState(() => _offices.add(OfficeLocation(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: '',
                      address: '',
                      mapQuery: '',
                      order: _offices.length,
                    ))),
                icon: const Icon(Icons.add),
                label: const Text('Add office'),
              ),
              const SizedBox(height: Space.lg),
              TextField(controller: _linkedin, decoration: const InputDecoration(labelText: 'LinkedIn URL')),
              const SizedBox(height: Space.sm),
              TextField(controller: _instagram, decoration: const InputDecoration(labelText: 'Instagram URL')),
              const SizedBox(height: Space.sm),
              TextField(controller: _twitter, decoration: const InputDecoration(labelText: 'Twitter URL')),
              const SizedBox(height: Space.lg),
              Text('Navigation', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: Space.xs),
              ..._navItems.asMap().entries.map((e) => _navRow(e.key, e.value)),
              TextButton.icon(
                onPressed: () => setState(() => _navItems.add(NavItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: '',
                      route: '',
                      iconKey: 'home',
                      order: _navItems.length,
                      showInHeader: false,
                      showInDrawer: true,
                    ))),
                icon: const Icon(Icons.add),
                label: const Text('Add nav item'),
              ),
              const SizedBox(height: Space.lg),
              TextField(
                controller: _footerTagline,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Footer tagline'),
              ),
              const SizedBox(height: Space.sm),
              TextField(controller: _copyright, decoration: const InputDecoration(labelText: 'Copyright text')),
            ],
          ),
        );
      },
    );
  }

  Widget _officeRow(int index, OfficeLocation office) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: office.label,
              decoration: const InputDecoration(labelText: 'Label'),
              onChanged: (v) => _offices[index] = office.copyWith(label: v),
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: office.address,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (v) => _offices[index] = office.copyWith(address: v, mapQuery: v),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => setState(() => _offices.removeAt(index)),
          ),
        ],
      ),
    );
  }

  Widget _navRow(int index, NavItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: item.label,
              decoration: const InputDecoration(labelText: 'Label'),
              onChanged: (v) => _navItems[index] = item.copyWith(label: v),
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: TextFormField(
              initialValue: item.route,
              decoration: const InputDecoration(labelText: 'Route'),
              onChanged: (v) => _navItems[index] = item.copyWith(route: v),
            ),
          ),
          Column(
            children: [
              Checkbox(
                value: item.showInHeader,
                onChanged: (v) => setState(() => _navItems[index] = item.copyWith(showInHeader: v ?? false)),
              ),
              const Text('Header', style: TextStyle(fontSize: 10)),
            ],
          ),
          Column(
            children: [
              Checkbox(
                value: item.showInDrawer,
                onChanged: (v) => setState(() => _navItems[index] = item.copyWith(showInDrawer: v ?? false)),
              ),
              const Text('Menu', style: TextStyle(fontSize: 10)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => setState(() => _navItems.removeAt(index)),
          ),
        ],
      ),
    );
  }
}
