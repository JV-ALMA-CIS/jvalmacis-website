import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:developer' as developer;
import 'website_chat_widget.dart';
import '../admin/modules/site_settings/site_settings_model.dart';
import '../admin/modules/site_settings/site_settings_provider.dart';
import '../admin/shared/icon_key_registry.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import 'app_buttons.dart';
import 'cms_image.dart';
import 'hoverable.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    developer.log('AppScaffold: Building scaffold with endDrawer', name: 'AppScaffold');
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Header(
            onMenuPressed: () {
              developer.log('AppScaffold: Opening endDrawer', name: 'AppScaffold');
              _scaffoldKey.currentState?.openEndDrawer();
            },
            scaffoldKey: _scaffoldKey,
          ),
        ),
        endDrawer: AppDrawer(scaffoldKey: _scaffoldKey),
        body: body,
        floatingActionButton: const WebsiteChatFab(),
        endDrawerEnableOpenDragGesture: true,
      ),
    );
  }
}

class Header extends ConsumerWidget {
  final VoidCallback onMenuPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const Header({super.key, required this.onMenuPressed, this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final navigation = settings.navigation.where((n) => n.showInHeader).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final screenWidth = MediaQuery.of(context).size.width.clamp(300.0, double.infinity);
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      decoration: const BoxDecoration(
        color: Palette.n0,
        boxShadow: Elevation.card,
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 12,
          ),
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Hoverable(
                  onTap: () => _navigate(context, '/'),
                  scale: 1.04,
                  lift: -1,
                  semanticLabel: 'JV ALMA C.I.S home',
                  builder: (hovered) => SizedBox(
                    width: isMobile ? 120 : 150,
                    height: isMobile ? 50 : 60,
                    child: CmsImage(
                      source: settings.logoImageUrl.isNotEmpty
                          ? settings.logoImageUrl
                          : 'assets/images/clients/jv.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log('Header: Image load error: $error', name: 'Header');
                        return Container(
                          decoration: BoxDecoration(
                            color: Palette.ink,
                            borderRadius: Radii.button,
                          ),
                          child: const Center(
                            child: Text(
                              'JV ALMA C.I.S',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 16 : 24),
                // Navigation for desktop
                if (!isMobile && !isTablet)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...navigation.map((item) {
                        return _NavItem(
                          text: item.label,
                          onTap: () => _navigate(context, item.route),
                        );
                      }),
                      const SizedBox(width: Space.md),
                      SecondaryButton(
                        text: 'Contact Us',
                        onPressed: () => _navigate(context, '/contact'),
                      ),
                    ],
                  ),
                // Menu button for mobile and tablet
                if (isMobile || isTablet)
                  Hoverable(
                    onTap: onMenuPressed,
                    scale: 1.1,
                    semanticLabel: 'Open menu',
                    builder: (hovered) => Icon(
                      LucideIcons.menu,
                      color: hovered ? Palette.primary : Palette.ink,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String href) {
    developer.log('Header: Navigating to $href', name: 'Header');
    scaffoldKey?.currentState?.closeEndDrawer();
    Navigator.pushNamed(context, href).catchError((e) {
      developer.log('Header: Navigation error to $href: $e', name: 'Header');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigation error: $e')),
        );
      }
      return null;
    });
  }
}

class _NavItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavItem({required this.text, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: (isHovered && !reduced) ? 1.06 : 1.0,
          duration: Motion.fast,
          curve: Motion.hover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isHovered ? Palette.primary : Palette.ink,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppDrawer({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final navigation = settings.navigation.where((n) => n.showInDrawer).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final screenWidth = MediaQuery.of(context).size.width;
    developer.log('AppDrawer: Building endDrawer with ${navigation.length} items', name: 'AppDrawer');

    return SizedBox(
      width: screenWidth * 0.75 > 300 ? 300 : screenWidth * 0.75,
      child: Drawer(
        child: Material(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CmsImage(
                            source: settings.logoImageUrl.isNotEmpty
                                ? settings.logoImageUrl
                                : 'assets/images/clients/jv.jpg',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              developer.log('Drawer: Image load error: $error', name: 'AppDrawer');
                              return const Center(
                                child: Text(
                                  'JV ALMA C.I.S',
                                  style: TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton(
                          icon: const Icon(
                            LucideIcons.x,
                            color: Palette.ink,
                            size: 24,
                          ),
                          onPressed: () {
                            developer.log('AppDrawer: Close button tapped', name: 'AppDrawer');
                            scaffoldKey?.currentState?.closeEndDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: navigation.length,
                    itemBuilder: (context, index) {
                      final item = navigation[index];
                      developer.log('AppDrawer: Building item ${item.label}', name: 'AppDrawer');
                      return ListTile(
                        leading: Icon(
                          IconKeyRegistry.resolve(item.iconKey),
                          color: Palette.ink,
                          size: 20,
                        ),
                        title: Text(
                          item.label,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Palette.ink,
                              ),
                        ),
                        onTap: () {
                          developer.log('AppDrawer: Tapped ${item.label}', name: 'AppDrawer');
                          scaffoldKey?.currentState?.closeEndDrawer();
                          Navigator.pushNamed(context, item.route).catchError((e) {
                            developer.log('Drawer: Navigation error to ${item.route}: $e', name: 'AppDrawer');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Navigation error: $e')),
                              );
                            }
                            return null;
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(Space.md),
                  child: PrimaryButton(
                    text: 'Contact Us',
                    large: true,
                    expand: true,
                    onPressed: () {
                      developer.log('AppDrawer: Tapped Get Quote', name: 'AppDrawer');
                      scaffoldKey?.currentState?.closeEndDrawer();
                      Navigator.pushNamed(context, '/contact').catchError((e) {
                        developer.log('Drawer: Navigation error to /contact: $e', name: 'AppDrawer');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Navigation error: $e')),
                          );
                        }
                        return null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
