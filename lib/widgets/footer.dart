import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;
import '../admin/modules/business_units/business_unit_model.dart';
import '../admin/modules/business_units/business_units_provider.dart';
import '../admin/modules/site_settings/site_settings_model.dart';
import '../admin/modules/site_settings/site_settings_provider.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import 'brand_icons.dart';
import 'cms_image.dart';
import 'header.dart' show siteContentMax, siteGutter;
import 'hoverable.dart';

/// Footer text colours on the dark ground (contrast on Palette.ink:
/// n300 12.3:1, n400 7.4:1).
const _text = Palette.n300;
const _muted = Palette.n400;

/// Site footer: a brand row (logo, tagline, social links), link columns
/// (Explore, Business units, Contact), then copyright, legal links and
/// Back to top. Contact details, offices, social links and the copyright
/// come from site settings; the unit links from the business-unit data.
class Footer extends ConsumerWidget {
  const Footer({super.key});

  /// Clear space under the last row so the chat button (fixed to the
  /// bottom-right corner) never covers a footer link at the end of a page.
  static const double chatButtonClearance = 80;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final offices = List<OfficeLocation>.of(settings.officeLocations)
      ..sort((a, b) => a.order.compareTo(b.order));

    // Same fallback, publication and ordering rules as the Business Units page.
    final liveUnits = ref.watch(businessUnitsProvider).valueOrNull;
    final units = List<BusinessUnit>.of(
      (liveUnits == null || liveUnits.isEmpty) ? defaultBusinessUnits : liveUnits,
    )
      ..removeWhere((u) => !u.published)
      ..sort((a, b) => a.order.compareTo(b.order));

    final isMobile = MediaQuery.sizeOf(context).width < 600;

    Future<void> launch(String url) async {
      try {
        if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication) &&
            context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The link could not be opened.')),
          );
        }
      } catch (e) {
        developer.log('Footer link error for $url: $e', name: 'Footer');
      }
    }

    void go(String route) {
      if (ModalRoute.of(context)?.settings.name == route) return;
      Navigator.pushNamed(context, route);
    }

    // ---- Brand row ---------------------------------------------------------
    final logo = Hoverable(
      onTap: () => go('/'),
      scale: 1.0,
      lift: 0,
      semanticLabel: 'JV ALMA C.I.S home',
      // The logo is a JPEG on white, so it sits on a white tile by design.
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs),
        decoration: BoxDecoration(
          color: Palette.n0,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        child: SizedBox(
          width: 128,
          height: 40,
          child: CmsImage(
            source: settings.logoImageUrl.isNotEmpty
                ? settings.logoImageUrl
                : 'assets/images/clients/jv.jpg',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Center(
              child: Text('JV ALMA C.I.S', style: AppType.theme.titleSmall),
            ),
          ),
        ),
      ),
    );

    final social = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(
          icon: BrandIcons.linkedin,
          label: 'JV ALMA C.I.S on LinkedIn',
          onTap: () => launch(settings.linkedinUrl),
        ),
        const SizedBox(width: Space.xs),
        _SocialIcon(
          icon: BrandIcons.instagram,
          label: 'JV ALMA C.I.S on Instagram',
          onTap: () => launch(settings.instagramUrl),
        ),
      ],
    );

    final tagline = Text(
      settings.footerTagline,
      style: AppType.theme.bodySmall?.copyWith(color: _text, height: 1.6),
    );

    final brandRow = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 760) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo,
              const SizedBox(width: Space.xl),
              Expanded(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440), child: tagline)),
              const SizedBox(width: Space.xl),
              social,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logo,
            const SizedBox(height: Space.md),
            tagline,
            const SizedBox(height: Space.md),
            social,
          ],
        );
      },
    );

    // ---- Link columns ------------------------------------------------------
    final explore = _Column(
      title: 'Explore',
      children: [
        for (final (label, route) in const [
          ('About Us', '/about'),
          ('Business Units', '/business-units'),
          ('News & Updates', '/news'),
          ('Certificates', '/certificates'),
          ('Careers', '/careers'),
          ('Community & Impact', '/community-impact'),
        ])
          _FooterLink(label: label, onTap: () => go(route)),
      ],
    );

    final businessUnits = _Column(
      title: 'Business units',
      children: [
        for (final unit in units) _FooterLink(label: unit.title, onTap: () => go(unit.route)),
      ],
    );

    final contact = _Column(
      title: 'Contact',
      children: [
        _FooterLink(
          label: settings.companyEmail,
          icon: LucideIcons.mail,
          semanticLabel: 'Email ${settings.companyEmail}',
          onTap: () => launch('mailto:${settings.companyEmail}'),
        ),
        _FooterLink(
          label: settings.companyPhone,
          icon: LucideIcons.phone,
          semanticLabel: 'Call ${settings.companyPhone}',
          onTap: () => launch('tel:${settings.companyPhone.replaceAll(' ', '')}'),
        ),
        for (final office in offices)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(LucideIcons.mapPin, size: 14, color: _muted),
              ),
              const SizedBox(width: Space.xs),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '${office.label}\n', style: const TextStyle(color: Palette.n0)),
                      TextSpan(text: office.address),
                    ],
                  ),
                  style: AppType.theme.bodySmall?.copyWith(color: _text, height: 1.5),
                ),
              ),
            ],
          ),
      ],
    );

    final columns = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 760) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: explore),
              const SizedBox(width: Space.xl),
              Expanded(flex: 3, child: businessUnits),
              const SizedBox(width: Space.xl),
              Expanded(flex: 4, child: contact),
            ],
          );
        }
        if (constraints.maxWidth >= 440) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: explore),
                  const SizedBox(width: Space.lg),
                  Expanded(child: businessUnits),
                ],
              ),
              const SizedBox(height: Space.xl),
              contact,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            explore,
            const SizedBox(height: Space.xl),
            businessUnits,
            const SizedBox(height: Space.xl),
            contact,
          ],
        );
      },
    );

    // ---- Bottom row --------------------------------------------------------
    final legal = Wrap(
      spacing: Space.lg,
      runSpacing: Space.xs,
      children: [
        for (final (label, route) in const [
          ('Privacy Policy', '/privacy-policy'),
          ('Cookies Policy', '/cookies'),
          ('Terms and Conditions', '/terms'),
          ('Delete Account', '/delete-account'),
        ])
          _FooterLink(label: label, small: true, onTap: () => go(route)),
      ],
    );

    return Material(
      color: Palette.ink,
      // Gutter outside the content width, as on every page, so the footer
      // lines up with page content.
      child: Padding(
        padding: EdgeInsets.only(
          left: siteGutter(context),
          right: siteGutter(context),
          top: isMobile ? Space.xxl : Space.xxxl,
          bottom: chatButtonClearance,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: siteContentMax),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                brandRow,
                const SizedBox(height: Space.xl),
                const Divider(height: 1, thickness: 1, color: Palette.n700),
                const SizedBox(height: Space.xl),
                columns,
                const SizedBox(height: Space.xxl),
                const Divider(height: 1, thickness: 1, color: Palette.n700),
                const SizedBox(height: Space.lg),
                Wrap(
                  spacing: Space.lg,
                  runSpacing: Space.md,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      settings.copyrightText,
                      style: AppType.theme.bodySmall?.copyWith(color: _muted),
                    ),
                    legal,
                    const _BackToTop(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppType.eyebrow(_muted)),
        const SizedBox(height: Space.md),
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: Space.sm),
          children[i],
        ],
      ],
    );
  }
}

/// Footer link: light text that turns white and underlines on hover or
/// keyboard focus.
class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    this.icon,
    this.small = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool small;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final base = (small ? AppType.theme.bodySmall : AppType.theme.bodyMedium)!;
    return Hoverable(
      onTap: onTap,
      scale: 1.0,
      lift: 0,
      semanticLabel: semanticLabel ?? label,
      builder: (hovered) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: hovered ? Palette.n0 : _muted),
            const SizedBox(width: Space.xs),
          ],
          Flexible(
            child: Text(
              label,
              style: base.copyWith(
                color: hovered ? Palette.n0 : _text,
                decoration: hovered ? TextDecoration.underline : null,
                decorationColor: Palette.n0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Hoverable(
        onTap: onTap,
        scale: 1.0,
        lift: 0,
        semanticLabel: label,
        builder: (hovered) => AnimatedContainer(
          duration: Motion.fast,
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.sm),
            color: hovered ? Palette.n700 : Colors.transparent,
            border: Border.all(color: hovered ? Palette.n400 : Palette.n600),
          ),
          child: Icon(icon, size: 18, color: hovered ? Palette.n0 : _text),
        ),
      ),
    );
  }
}

/// Scrolls the page containing the footer back to the top. Uses the nearest
/// scrollable ancestor (every page's scroll view), falling back to the
/// primary scroll controller; jumps instead of animating under reduced
/// motion.
class _BackToTop extends StatelessWidget {
  const _BackToTop();

  @override
  Widget build(BuildContext context) {
    void toTop() {
      final position = Scrollable.maybeOf(context)?.position ??
          (PrimaryScrollController.maybeOf(context)?.hasClients ?? false
              ? PrimaryScrollController.of(context).position
              : null);
      if (position == null) return;
      if (Motion.reduced(context)) {
        position.jumpTo(0);
      } else {
        position.animateTo(0, duration: Motion.base, curve: Motion.enter);
      }
    }

    return Hoverable(
      onTap: toTop,
      scale: 1.0,
      lift: 0,
      semanticLabel: 'Back to top',
      builder: (hovered) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Back to top',
            style: AppType.theme.bodySmall?.copyWith(color: hovered ? Palette.n0 : _text),
          ),
          const SizedBox(width: Space.xs),
          Icon(LucideIcons.arrowUp, size: 14, color: hovered ? Palette.n0 : _text),
        ],
      ),
    );
  }
}
