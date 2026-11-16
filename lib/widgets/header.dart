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
import '../design/typography.dart';
import 'app_buttons.dart';
import 'cms_image.dart';
import 'hoverable.dart';

/// Shared content width for the header, footer and redesigned pages.
const double siteContentMax = 1080;

/// Horizontal gutter used with [siteContentMax].
double siteGutter(BuildContext context) => MediaQuery.sizeOf(context).width < 600 ? 20 : Space.lg;

const _fallbackLogo = 'assets/images/clients/jv.jpg';

/// The page currently shown, for active navigation states.
String? _currentRoute(BuildContext context) => ModalRoute.of(context)?.settings.name;

/// Navigates to [route] unless it is already the current page, closing the
/// drawer first when one is open.
void _navigate(BuildContext context, String route, GlobalKey<ScaffoldState>? scaffoldKey) {
  scaffoldKey?.currentState?.closeEndDrawer();
  if (_currentRoute(context) == route) return;
  Navigator.pushNamed(context, route).catchError((Object e) {
    developer.log('Navigation error to $route: $e', name: 'Header');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That page could not be opened.')),
      );
    }
    return null;
  });
}

/// Page shell: header, end drawer, body and the chat button.
///
/// Stateful so the scaffold key survives rebuilds of the page. A key created
/// per build (as before) made every page rebuild remount the whole scaffold,
/// which reset the scroll position.
class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.body});

  final Widget body;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(Header.height),
        child: Header(
          onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          scaffoldKey: _scaffoldKey,
        ),
      ),
      endDrawer: AppDrawer(scaffoldKey: _scaffoldKey),
      body: widget.body,
      floatingActionButton: const WebsiteChatFab(),
      endDrawerEnableOpenDragGesture: true,
    );
  }
}

/// Logo with the configured image and the existing fallbacks.
class _Logo extends StatelessWidget {
  const _Logo({required this.settings, required this.width, required this.height});

  final SiteSettings settings;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CmsImage(
        source: settings.logoImageUrl.isNotEmpty ? settings.logoImageUrl : _fallbackLogo,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        errorBuilder: (context, error, stackTrace) {
          developer.log('Logo load error: $error', name: 'Header');
          return Align(
            alignment: Alignment.centerLeft,
            child: Text('JV ALMA C.I.S', style: AppType.theme.titleMedium),
          );
        },
      ),
    );
  }
}

/// Header: logo on the left; on desktop, the CMS-configured navigation and
/// the Contact Us action on the right; below 1024px, a menu button that
/// opens [AppDrawer].
class Header extends ConsumerWidget {
  const Header({super.key, required this.onMenuPressed, this.scaffoldKey});

  static const double height = 72;

  final VoidCallback onMenuPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final navigation = settings.navigation.where((n) => n.showInHeader).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1024;
    final current = _currentRoute(context);

    return Material(
      color: Palette.n0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Palette.n200)),
        ),
        child: SafeArea(
          bottom: false,
          // Gutter outside the content width, as on every page, so the logo
          // lines up with page content.
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: siteGutter(context)),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: siteContentMax),
                child: SizedBox(
                  height: height - 1,
                  child: Row(
                    children: [
                      Hoverable(
                        onTap: () => _navigate(context, '/', scaffoldKey),
                        scale: 1.0,
                        lift: 0,
                        semanticLabel: 'JV ALMA C.I.S home',
                        builder: (_) => _Logo(
                          settings: settings,
                          width: width < 600 ? 116 : 136,
                          height: 44,
                        ),
                      ),
                      if (isDesktop)
                        // Right-aligned; scaled down rather than overflowing
                        // if the CMS-configured labels outgrow the width.
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (final item in navigation)
                                    _NavItem(
                                      text: item.label,
                                      active: current == item.route,
                                      onTap: () => _navigate(context, item.route, scaffoldKey),
                                    ),
                                  const SizedBox(width: Space.md),
                                  SecondaryButton(
                                    text: 'Contact Us',
                                    onPressed: () => _navigate(context, '/contact', scaffoldKey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else ...[
                        const Spacer(),
                        IconButton(
                          tooltip: 'Open menu',
                          onPressed: onMenuPressed,
                          icon: const Icon(LucideIcons.menu, color: Palette.ink, size: 24),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A header link: ink text, brand blue with an underline when hovered,
/// focused or the current page. No scaling.
class _NavItem extends StatelessWidget {
  const _NavItem({required this.text, required this.active, required this.onTap});

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: active ? '$text, current page' : text,
      builder: (hovered) {
        final highlighted = hovered || active;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: AppType.theme.titleSmall?.copyWith(
                  fontSize: 15,
                  color: highlighted ? Palette.primary : Palette.ink,
                ),
              ),
              const SizedBox(height: Space.xxs),
              AnimatedContainer(
                duration: Motion.fast,
                height: 2,
                width: highlighted ? 20 : 0,
                color: Palette.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Navigation drawer for tablet and mobile: configured logo, the
/// CMS-configured items with showInDrawer, and the Contact Us action
/// (omitted when a configured item already links to /contact).
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final navigation = settings.navigation.where((n) => n.showInDrawer).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final hasContactItem = navigation.any((n) => n.route == '/contact');
    final current = _currentRoute(context);
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: width * 0.85 > 320 ? 320 : width * 0.85,
      child: Drawer(
        backgroundColor: Palette.n0,
        shape: const RoundedRectangleBorder(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.xs, Space.md),
                child: Row(
                  children: [
                    _Logo(settings: settings, width: 116, height: 44),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Close menu',
                      onPressed: () => scaffoldKey?.currentState?.closeEndDrawer(),
                      icon: const Icon(LucideIcons.x, color: Palette.ink, size: 22),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Palette.n200),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: Space.sm, horizontal: Space.sm),
                  children: [
                    for (final item in navigation)
                      ListTile(
                        selected: current == item.route,
                        selectedColor: Palette.primary,
                        selectedTileColor: Palette.primarySubtle,
                        iconColor: Palette.n500,
                        textColor: Palette.ink,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                        leading: Icon(IconKeyRegistry.resolve(item.iconKey), size: 20),
                        title: Text(
                          item.label,
                          style: AppType.theme.titleMedium?.copyWith(
                            color: current == item.route ? Palette.primary : Palette.ink,
                          ),
                        ),
                        onTap: () => _navigate(context, item.route, scaffoldKey),
                      ),
                  ],
                ),
              ),
              if (!hasContactItem)
                Padding(
                  padding: const EdgeInsets.all(Space.md),
                  child: PrimaryButton(
                    text: 'Contact Us',
                    expand: true,
                    onPressed: () => _navigate(context, '/contact', scaffoldKey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
