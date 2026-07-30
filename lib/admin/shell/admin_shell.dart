import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../auth/admin_auth_provider.dart';
import '../modules/business_units/business_units_list_page.dart';
import '../modules/homepage/homepage_editor_page.dart';
import '../modules/site_settings/site_settings_editor_page.dart';

enum _AdminModule { siteSettings, businessUnits, homepage }

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  _AdminModule _module = _AdminModule.siteSettings;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    return Scaffold(
      backgroundColor: Palette.n50,
      body: SafeArea(
        child: isMobile ? _mobileLayout() : _desktopLayout(),
      ),
    );
  }

  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sideNav(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.xl),
            child: _activeModule(),
          ),
        ),
      ],
    );
  }

  Widget _mobileLayout() {
    return Column(
      children: [
        _mobileModulePicker(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.md),
            child: _activeModule(),
          ),
        ),
      ],
    );
  }

  Widget _sideNav() {
    return Container(
      width: 220,
      color: Palette.ink,
      padding: const EdgeInsets.symmetric(vertical: Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.md),
            child: Text(
              'Admin',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          _navItem('Site Settings', _AdminModule.siteSettings),
          _navItem('Business Units', _AdminModule.businessUnits),
          _navItem('Homepage', _AdminModule.homepage),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.md),
            child: TextButton(
              onPressed: () => ref.read(adminAuthControllerProvider).signOut(),
              child: const Text('Sign out', style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileModulePicker() {
    return Container(
      color: Palette.ink,
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<_AdminModule>(
              value: _module,
              dropdownColor: Palette.ink,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: _AdminModule.siteSettings, child: Text('Site Settings')),
                DropdownMenuItem(value: _AdminModule.businessUnits, child: Text('Business Units')),
                DropdownMenuItem(value: _AdminModule.homepage, child: Text('Homepage')),
              ],
              onChanged: (m) => setState(() => _module = m ?? _module),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: () => ref.read(adminAuthControllerProvider).signOut(),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String label, _AdminModule module) {
    final active = _module == module;
    return InkWell(
      onTap: () => setState(() => _module = module),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        color: active ? Palette.primary.withValues(alpha: 0.2) : Colors.transparent,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _activeModule() {
    switch (_module) {
      case _AdminModule.siteSettings:
        return const SiteSettingsEditorPage();
      case _AdminModule.businessUnits:
        return const BusinessUnitsListPage();
      case _AdminModule.homepage:
        return const HomepageEditorPage();
    }
  }
}
