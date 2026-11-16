// Widget tests for the legal pages (Terms, Privacy, Cookies, Delete Account):
// shared layout at desktop and phone widths, the contents list jumping to
// sections, related links, the Ask ALMA privacy section and the deletion
// request email.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/pages/cookies_page.dart';
import 'package:jv_alma_cis/pages/delete_account_page.dart';
import 'package:jv_alma_cis/pages/privacy_policy_page.dart';
import 'package:jv_alma_cis/pages/terms_page.dart';
import 'package:jv_alma_cis/widgets/legal_document.dart';

final _pages = <(String, String, Widget, int, String)>[
  ('/terms', 'Terms and Conditions', const TermsPage(), 17, 'Governing Law'),
  ('/privacy-policy', 'Privacy Policy', const PrivacyPolicyPage(), 12, "Children's Privacy"),
  ('/cookies', 'Cookies Policy', const CookiesPage(), 8, 'Third-Party Cookies'),
  ('/delete-account', 'Account & Data Deletion', const DeleteAccountPage(), 6, 'Data Handling'),
];

Future<void> _pump(WidgetTester tester, Widget page, {Size size = const Size(1280, 900)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      ],
      child: MaterialApp(theme: buildAppTheme(), home: page),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Finder _heading(int number, String title) => find.text('$number.  $title', findRichText: true);

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  for (final (route, title, page, count, sample) in _pages) {
    for (final (label, size) in [
      ('desktop', const Size(1280, 900)),
      ('phone', const Size(390, 844)),
    ]) {
      testWidgets('$title renders its numbered sections without overflow ($label)', (tester) async {
        await _pump(tester, page, size: size);

        // The title, plus the footer's legal link for the three policies.
        expect(find.text(title), findsWidgets);
        expect(find.textContaining('Last updated'), findsWidgets);
        expect(find.textContaining(RegExp(r'^\d+\.  '), findRichText: true), findsNWidgets(count));
        expect(find.textContaining('JV ALMA CIS', findRichText: true), findsNothing);

        // Related documents list the other legal pages, not this one.
        for (final (docLabel, docRoute) in legalDocuments) {
          if (docRoute == route) continue;
          expect(find.text(docLabel), findsWidgets, reason: docLabel);
        }
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      });
    }

    testWidgets('$title contents list jumps to a section', (tester) async {
      await _pump(tester, page);

      final target = find.text(sample);
      expect(target, findsOneWidget, reason: 'contents entry for $sample');
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      final heading = find.textContaining(sample, findRichText: true).last;
      final y = tester.getTopLeft(heading).dy;
      expect(y, lessThan(200), reason: '"$sample" scrolled to the top');
      await _drainChatTimers(tester);
    });
  }

  testWidgets('Contents start closed on phones and open on tap', (tester) async {
    await _pump(tester, const TermsPage(), size: const Size(390, 844));

    expect(find.text('On this page (17 sections)'), findsOneWidget);
    expect(find.text('Governing Law'), findsNothing);
    await tester.tap(find.text('On this page (17 sections)'));
    await tester.pump();
    expect(find.text('Governing Law'), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Privacy Policy explains the Ask ALMA assistant', (tester) async {
    await _pump(tester, const PrivacyPolicyPage());

    expect(_heading(4, 'The Ask ALMA Assistant'), findsOneWidget);
    expect(find.textContaining('Gemini', findRichText: true), findsOneWidget);
    expect(find.textContaining('We do not store the content', findRichText: true), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Delete Account offers a prepared deletion email', (tester) async {
    await _pump(tester, const DeleteAccountPage());

    expect(find.text('Email a deletion request'), findsOneWidget);
    expect(deletionRequestUri.scheme, 'mailto');
    expect(deletionRequestUri.path, 'support@jvalmacis.co.ke');
    expect(deletionRequestUri.query, contains('Account%20deletion%20request'));
    for (final app in ['Kilimo Mkononi', 'CoffeeCore', 'AlmaWorks', 'Alma Hub', 'NyumbaSmart']) {
      expect(find.text(app, findRichText: true), findsOneWidget, reason: app);
    }
    await _drainChatTimers(tester);
  });
}
