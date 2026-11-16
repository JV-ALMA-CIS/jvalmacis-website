// Widget tests for the Contact page: neutral introduction, contact details
// from site settings, two-column / stacked layout, business-unit selector,
// and client-side validation. Submission itself writes to Firestore and is
// not exercised here (no Firebase app in tests, and no real enquiries).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/design/palette.dart';
import 'package:jv_alma_cis/pages/contact_page.dart';
import 'package:jv_alma_cis/widgets/brand_icons.dart';

const _heading = "Let's discuss your requirements.";

Future<void> _pumpContact(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      ],
      child: MaterialApp(theme: buildAppTheme(), home: const ContactPage()),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Finder _scrollable() => find.byType(Scrollable).first;

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('Desktop: introduction, then details and form side by side',
      (tester) async {
    await _pumpContact(tester, const Size(1280, 900));

    expect(find.text(_heading), findsOneWidget);
    expect(find.textContaining('direct your enquiry to the appropriate business unit'), findsOneWidget);

    final details = tester.getTopLeft(find.text('Contact details'));
    final form = tester.getTopLeft(find.text('Send an enquiry'));
    expect(details.dx, lessThan(form.dx));
    expect((details.dy - form.dy).abs(), lessThan(4));

    await _drainChatTimers(tester);
  });

  testWidgets('Phone: details stacked above the form without overflow', (tester) async {
    await _pumpContact(tester, const Size(390, 844));

    final details = tester.getTopLeft(find.text('Contact details'));
    final form = tester.getTopLeft(find.text('Send an enquiry'));
    expect(details.dy, lessThan(form.dy));

    await tester.scrollUntilVisible(find.text('Submit enquiry'), 300, scrollable: _scrollable());
    expect(find.text('Submit enquiry'), findsOneWidget);

    await _drainChatTimers(tester);
  });

  testWidgets('No coloured hero band', (tester) async {
    await _pumpContact(tester, const Size(1280, 900));

    bool usesHeroSurface(Widget w) {
      final decoration = switch (w) {
        Container(:final decoration) => decoration,
        DecoratedBox(:final decoration) => decoration,
        _ => null,
      };
      return decoration is BoxDecoration && decoration.gradient == Palette.heroSurface;
    }

    expect(find.byWidgetPredicate(usesHeroSurface), findsNothing);
    await _drainChatTimers(tester);
  });

  testWidgets('Contact details and social links come from site settings', (tester) async {
    await _pumpContact(tester, const Size(1280, 900));

    // Contact details column, plus the footer's Contact column.
    expect(find.text(defaultSiteSettings.companyEmail), findsNWidgets(2));
    expect(find.text(defaultSiteSettings.companyPhone), findsNWidgets(2));
    for (final office in defaultSiteSettings.officeLocations) {
      expect(find.text(office.address), findsOneWidget);
    }
    expect(find.text('View on map'), findsNWidgets(defaultSiteSettings.officeLocations.length));

    // Social buttons on the page, plus the footer's icons.
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.byIcon(BrandIcons.linkedin), findsNWidgets(2));
    expect(find.byIcon(BrandIcons.instagram), findsNWidgets(2));

    await _drainChatTimers(tester);
  });

  testWidgets('Business-unit selector offers exactly the four approved units',
      (tester) async {
    await _pumpContact(tester, const Size(1280, 900));

    // The site's four standard displayed unit names.
    expect(businessUnitOptions, ['Construction', 'Agribusiness', 'Oil & Gas Services', 'IT Division']);
    expect(find.text('Select business unit'), findsOneWidget);

    await tester.tap(find.text('Select business unit'));
    await tester.pump(const Duration(milliseconds: 400));

    final menuItems = find.byType(DropdownMenuItem<String>);
    expect(menuItems, findsNWidgets(4));

    await tester.tap(find.text('IT Division').last);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Select business unit'), findsNothing);
    // The selected value, plus the footer's Business units link.
    expect(find.text('IT Division'), findsNWidgets(2));

    await _drainChatTimers(tester);
  });

  testWidgets('Empty submission shows every required-field error and no success',
      (tester) async {
    await _pumpContact(tester, const Size(1280, 900));

    await tester.scrollUntilVisible(find.text('Submit enquiry'), 300, scrollable: _scrollable());
    await tester.tap(find.text('Submit enquiry'));
    await tester.pump();

    for (final error in [
      'Please enter your name',
      'Please enter your email address',
      'Please enter your telephone number',
      'Please enter a subject',
      'Please enter your message',
    ]) {
      expect(find.text(error), findsOneWidget);
    }
    // Validation failed, so nothing was submitted and no success is claimed.
    expect(find.textContaining('enquiry has been received'), findsNothing);

    final emailField = find.widgetWithText(TextFormField, 'Email address');
    await tester.ensureVisible(emailField);
    await tester.enterText(emailField, 'not-an-email');
    await tester.pump();
    await tester.ensureVisible(find.text('Submit enquiry'));
    await tester.tap(find.text('Submit enquiry'));
    await tester.pump();
    expect(find.text('Please enter a valid email address'), findsOneWidget);

    await _drainChatTimers(tester);
  });
}
