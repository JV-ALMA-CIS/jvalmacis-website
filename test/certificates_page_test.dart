// Widget tests for the Certificates & Compliance page: section structure,
// document entries and their files, removed promotional claims, the page
// rendering its documents immediately, and the document viewer (navigation,
// close) at desktop, tablet and phone widths.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/design/palette.dart';
import 'package:jv_alma_cis/pages/certificates_page.dart';

const _sections = [
  'ISO Certificate',
  'Company & Operational Certificates',
  'Software Copyright Certificates',
  'Data Protection',
];

final _allDocs = [for (final s in certificateSections) ...s.documents];

Future<void> _pumpPage(WidgetTester tester, {Size size = const Size(1280, 900)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      ],
      child: MaterialApp(
        theme: buildAppTheme(),
        home: const CertificatesPage(),
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Finder _inDialog(Finder f) => find.descendant(of: find.byType(Dialog), matching: f);

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  test('Every listed document has its file in assets/certificates', () {
    for (final doc in _allDocs) {
      expect(File(doc.asset).existsSync(), isTrue, reason: doc.asset);
    }
  });

  test('Entries, titles and asset paths', () {
    expect(
      [for (final s in certificateSections) [for (final d in s.documents) (d.title, d.asset)]],
      [
        [
          ('JV Certificate', 'assets/certificates/iso_2027.jpg'),
        ],
        [
          ('Building Works Certificate', 'assets/certificates/Building_Works_Certificate_2026.jpg'),
          ('Mechanical Service Certificate', 'assets/certificates/Mechanical_Service_Certificate_2028.jpg'),
          ('Water Works Certificate', 'assets/certificates/Water_Works_Certificate_2028.jpg'),
        ],
        [
          ('Kilimo Mkononi', 'assets/certificates/kilimomkononi.jpg'),
          ('CoffeeCore', 'assets/certificates/coffeecore.jpg'),
          ('AlmaWorks', 'assets/certificates/almaworks.jpg'),
          ('AlmaSafety', 'assets/certificates/almasafety.jpg'),
          ('AlmaHub', 'assets/certificates/almahub.jpg'),
          ('NyumbaSmart', 'assets/certificates/nyumbasmart.jpg'),
        ],
        [
          ('Data Processor Certificate', 'assets/certificates/data_processor.jpg'),
        ],
      ],
    );
  });

  for (final (label, size) in [
    ('desktop', const Size(1280, 900)),
    ('tablet', const Size(820, 1180)),
    ('phone', const Size(390, 844)),
  ]) {
    testWidgets('All sections and documents render without overflow ($label)', (tester) async {
      await _pumpPage(tester, size: size);

      expect(find.text('Certificates & Compliance'), findsOneWidget);
      for (var i = 1; i < _sections.length; i++) {
        expect(
          tester.getTopLeft(find.text(_sections[i - 1])).dy,
          lessThan(tester.getTopLeft(find.text(_sections[i])).dy),
        );
      }
      for (final doc in _allDocs) {
        expect(find.text(doc.title), findsOneWidget, reason: doc.title);
      }
      expect(find.text('View document'), findsNWidgets(_allDocs.length));
      expect(find.textContaining('to be added'), findsNothing);

      await _drainChatTimers(tester);
    });
  }

  testWidgets('Promotional claims and the hero band are gone', (tester) async {
    await _pumpPage(tester);

    for (final claim in [
      'ISO 9001:2015',
      'Fully Compliant',
      'Internationally Recognized',
      'All regulatory requirements',
      'accepted globally',
      'Our Commitment',
      'highest standards',
    ]) {
      expect(find.textContaining(claim), findsNothing, reason: claim);
    }

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

  testWidgets('Documents appear on the first frame, without waiting on anything',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
        ],
        child: MaterialApp(theme: buildAppTheme(), home: const CertificatesPage()),
      ),
    );

    // No extra pumps: the sections and their documents are already built.
    for (final section in _sections) {
      expect(find.text(section), findsOneWidget, reason: section);
    }
    expect(find.text('6 documents'), findsOneWidget);
    expect(find.text('3 documents'), findsOneWidget);
    expect(find.text('1 document'), findsNWidgets(2));

    await _drainChatTimers(tester);
  });

  testWidgets('Viewer opens, moves through every document and closes', (tester) async {
    await _pumpPage(tester);
    final total = _allDocs.length;

    await tester.tap(find.text('JV Certificate'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Dialog), findsOneWidget);
    expect(_inDialog(find.text('JV Certificate')), findsOneWidget);
    expect(_inDialog(find.text('1 of $total')), findsOneWidget);

    await tester.tap(find.byTooltip('Next document'));
    await tester.pump();
    expect(_inDialog(find.text(_allDocs[1].title)), findsOneWidget);
    expect(_inDialog(find.text('2 of $total')), findsOneWidget);

    await tester.tap(find.byTooltip('Previous document'));
    await tester.pump();
    expect(_inDialog(find.text('1 of $total')), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Dialog), findsNothing);

    await _drainChatTimers(tester);
  });

  testWidgets('Viewer fits a phone screen without overflow', (tester) async {
    await _pumpPage(tester, size: const Size(360, 640));

    final tile = find.text('Data Processor Certificate');
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pump(const Duration(milliseconds: 400));
    expect(_inDialog(find.text('Data Processor Certificate')), findsOneWidget);
    expect(_inDialog(find.text('${_allDocs.length} of ${_allDocs.length}')), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pump(const Duration(milliseconds: 400));
    await _drainChatTimers(tester);
  });

  for (final (label, size, beside) in [
    ('desktop', const Size(1280, 900), true),
    ('phone', const Size(390, 844), false),
  ]) {
    testWidgets('Single-document sections place the document beside the heading ($label)',
        (tester) async {
      await _pumpPage(tester, size: size);
      for (final (section, doc) in [
        ('ISO Certificate', 'JV Certificate'),
        ('Data Protection', 'Data Processor Certificate'),
      ]) {
        final heading = find.text(section);
        final tile = find.text(doc);
        await tester.ensureVisible(heading);
        await tester.pump();
        final h = tester.getTopLeft(heading);
        final t = tester.getTopLeft(tile);
        if (beside) {
          // To the right, starting level with the heading's section.
          expect(t.dx, greaterThan(h.dx + 400), reason: section);
          expect((t.dy - h.dy).abs(), lessThan(400), reason: section);
        } else {
          // Below the heading, on the same left edge.
          expect(t.dy, greaterThan(h.dy), reason: section);
          expect(t.dx, closeTo(h.dx, 1), reason: section);
        }
      }
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }
}
