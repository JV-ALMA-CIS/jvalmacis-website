// This is a basic Flutter widget test for the JV ALMA CIS website.
//
// Uses WidgetTester to verify the HomePage renders its CMS-backed content
// (business units, hero CTA) and that the nav drawer's item set reflects
// the CMS's showInDrawer/showInHeader split.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_unit_model.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_units_provider.dart';
import 'package:jv_alma_cis/admin/modules/homepage/homepage_model.dart';
import 'package:jv_alma_cis/admin/modules/homepage/homepage_provider.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/main.dart';

/// The CMS-backed pages read these providers from Firestore in production.
/// No Firebase app is initialized in this test binary, so every test
/// overrides them with the same hardcoded defaults the app itself falls
/// back to whenever Firestore is loading, empty, or unreachable.
List<Override> _cmsFallbackOverrides() => [
      siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      businessUnitsProvider.overrideWith((ref) => Stream.value(defaultBusinessUnits)),
      homepageProvider.overrideWith((ref) => Stream.value(defaultHomepageContent)),
    ];

void main() {
  // Every RevealOnScroll wraps a VisibilityDetector, which re-schedules its
  // own internal timer on every paint by design — that timer can never
  // fully drain via pump(), which would otherwise fail flutter_test's
  // "no pending timers" check at the end of any test that renders one of
  // these pages. Disabling the periodic check (visibility_detector's own
  // documented workaround for widget tests) keeps only paint-triggered,
  // non-recurring visibility updates.
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('HomePage renders CMS fallback content and the nav drawer',
      (WidgetTester tester) async {
    // Not pumpAndSettle: the home page's client-logo marquee animates on an
    // infinite loop, which would make pumpAndSettle time out while this
    // page is the current route. Bounded pumps let one-shot entrance/reveal
    // animations and route transitions finish without waiting on it.
    await tester.pumpWidget(
      ProviderScope(overrides: _cmsFallbackOverrides(), child: const MyApp()),
    );
    await tester.pump(const Duration(seconds: 1));

    // Business units (from the CMS fallback defaults) render on the home page.
    expect(find.text('Construction'), findsOneWidget);
    expect(find.text('Agribusiness'), findsOneWidget);
    expect(find.text('Oil & Gas Services'), findsOneWidget);
    expect(find.text('IT Division'), findsOneWidget);

    // Hero button, CTA band button, and the footer's "Contact Us" heading
    // all render this CMS-configured text.
    expect(find.text('Contact Us'), findsNWidgets(3));

    // Default test surface falls within the header's tablet breakpoint,
    // which shows the menu button instead of the inline desktop nav row.
    final menuButton = find.byIcon(LucideIcons.menu);
    expect(menuButton, findsOneWidget);

    // Opening the drawer shows the CMS-configured nav items — Careers isn't
    // in the header row (showInHeader: false in defaultSiteSettings), only
    // the drawer, so finding it here also proves showInDrawer filtering
    // works, not just that the drawer opens.
    await tester.tap(menuButton);
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.descendant(of: find.byType(Drawer), matching: find.text('Careers')),
      findsOneWidget,
    );

    // Drain WebsiteChatFab's timer chain (2s, then a further 4s = 6s
    // total) before it stops for good — flutter_test fails the test if
    // any timer is still outstanding when it ends.
    await tester.pump(const Duration(seconds: 7));
  });
}
