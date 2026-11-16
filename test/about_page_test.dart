// Widget tests for the About page: section structure, omitted unconfirmed
// content, CMS-driven units and offices (fallback, publication, ordering),
// unit navigation, and layout at desktop, tablet and phone widths.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_unit_model.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_units_provider.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/design/palette.dart';
import 'package:jv_alma_cis/pages/about_page.dart';

const _officialNames = ['Construction', 'Agribusiness', 'Oil & Gas Services', 'IT Division'];

Future<List<String>> _pumpAbout(
  WidgetTester tester, {
  List<BusinessUnit> units = const [],
  Size size = const Size(1280, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final pushed = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
        businessUnitsProvider.overrideWith((ref) => Stream.value(units)),
      ],
      child: MaterialApp(
        theme: buildAppTheme(),
        home: const AboutPage(),
        onGenerateRoute: (settings) {
          pushed.add(settings.name!);
          return MaterialPageRoute(builder: (_) => Text('route ${settings.name}'));
        },
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  return pushed;
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

/// The linked unit name in the story list: the name followed by its inline
/// arrow (a WidgetSpan, which reads as U+FFFC in the plain text). Matching
/// exactly avoids the same words in the surrounding prose.
Finder _unitName(String name) => find.byWidgetPredicate(
      (w) => w is RichText && w.text.toPlainText() == '$name ￼',
    );

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  for (final (label, size) in [
    ('desktop', const Size(1280, 900)),
    ('tablet', const Size(820, 1180)),
    ('phone', const Size(390, 844)),
  ]) {
    testWidgets('Sections render in order without overflow ($label)', (tester) async {
      await _pumpAbout(tester, size: size);

      final headings = [
        'About JV ALMA C.I.S',
        'One group. Four areas of expertise.',
        'Our journey',
        'Our purpose',
      ];
      for (var i = 1; i < headings.length; i++) {
        expect(
          tester.getTopLeft(find.text(headings[i - 1])).dy,
          lessThan(tester.getTopLeft(find.text(headings[i])).dy),
        );
      }
      for (final name in _officialNames) {
        expect(_unitName(name), findsOneWidget);
      }

      await _drainChatTimers(tester);
    });
  }

  testWidgets('Journey keeps the existing milestone years, in order', (tester) async {
    await _pumpAbout(tester);

    // Founding year in the introduction and on the identity panel.
    expect(find.textContaining('Founded in 2017'), findsOneWidget);

    const years = ['2017', '2021', '2022', '2024'];
    const events = [
      'Company founded',
      'Expansion into Agribusiness',
      'Oil & Gas Services launched',
      'IT Division established',
    ];
    for (var i = 0; i < years.length; i++) {
      // .last: "2017" also appears on the identity panel above the journey.
      final year = find.text(years[i]).last;
      expect(
        (tester.getTopLeft(year).dy - tester.getTopLeft(find.text(events[i])).dy).abs(),
        lessThan(24),
        reason: '${years[i]} sits beside "${events[i]}"',
      );
      if (i > 0) {
        expect(
          tester.getTopLeft(find.text(years[i - 1]).last).dy,
          lessThan(tester.getTopLeft(year).dy),
        );
      }
    }

    await _drainChatTimers(tester);
  });

  testWidgets('Revised wording; removed claims and selected work are not shown',
      (tester) async {
    await _pumpAbout(tester);

    // Standard display name, no final full stop.
    expect(find.textContaining('C.I.S.'), findsNothing);

    // Oil & Gas: partnership, not shareholding or pipeline construction.
    expect(find.textContaining('in partnership with Brisma Africa and TIC East Africa'), findsWidgets);
    for (final removed in [
      'shareholding',
      'pipelines',
      'Our Story',
      'Featured Work',
      'seven years',
      'a leader',
      "Building Africa's future",
      'US Embassy Renovation',
      'exceptional infrastructure',
      'most trusted',
    ]) {
      expect(find.textContaining(removed), findsNothing, reason: removed);
    }
    expect(find.textContaining('reliable facility management, agricultural, inspection and digital services'),
        findsOneWidget);
    expect(find.textContaining('To become a trusted partner for integrated solutions'), findsOneWidget);

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

  testWidgets('Mission and vision: side by side on desktop, stacked on phone',
      (tester) async {
    await _pumpAbout(tester);
    expect(
      (tester.getTopLeft(find.text('MISSION')).dy - tester.getTopLeft(find.text('VISION')).dy).abs(),
      lessThan(1),
    );
    await _drainChatTimers(tester);

    await _pumpAbout(tester, size: const Size(390, 844));
    expect(
      tester.getTopLeft(find.text('MISSION')).dy,
      lessThan(tester.getTopLeft(find.text('VISION')).dy),
    );
    await _drainChatTimers(tester);
  });

  testWidgets('Offices come from site settings', (tester) async {
    await _pumpAbout(tester);
    for (final office in defaultSiteSettings.officeLocations) {
      expect(find.text(office.address), findsWidgets);
    }
    await _drainChatTimers(tester);
  });

  testWidgets('Live units: unpublished hidden, ordered, descriptions shown', (tester) async {
    BusinessUnit unit(String id, String title, int order, {bool published = true}) =>
        BusinessUnit.fromMap(id, {
          'title': title,
          'description': '$title scope',
          'route': '/$id',
          'order': order,
          'published': published,
        });

    await _pumpAbout(tester, units: [
      unit('b', 'Second', 1),
      unit('h', 'Hidden', 0, published: false),
      unit('a', 'First', 0),
    ]);

    expect(_unitName('Hidden'), findsNothing);
    expect(find.text('First scope'), findsOneWidget);
    expect(
      tester.getTopLeft(_unitName('First')).dy,
      lessThan(tester.getTopLeft(_unitName('Second')).dy),
    );
    await _drainChatTimers(tester);
  });

  testWidgets('Each unit line opens its business-unit route', (tester) async {
    for (final unit in defaultBusinessUnits) {
      final pushed = await _pumpAbout(tester);
      final line = _unitName(unit.title);
      await tester.ensureVisible(line);
      await tester.tap(line);
      await tester.pump(const Duration(milliseconds: 400));
      expect(pushed, [unit.route], reason: unit.title);
      await _drainChatTimers(tester);

      // Reset the navigator so the next unit starts from the About page.
      await tester.pumpWidget(const SizedBox());
    }
  });
}
