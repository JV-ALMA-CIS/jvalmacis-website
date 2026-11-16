// Widget tests for the Business Units page: CMS fallback, published
// filtering, ordering and numbering, alternating desktop rows, stacked phone
// layout, image fallback, and navigation to unit and product pages.

import 'dart:io';

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
import 'package:jv_alma_cis/pages/business_units_page.dart';
import 'package:jv_alma_cis/widgets/app_card.dart';
import 'package:jv_alma_cis/widgets/cms_image.dart';

const _officialNames = ['Construction', 'Agribusiness', 'Oil & Gas Services', 'IT Division'];

BusinessUnit _unit(String id, String title, int order,
        {bool published = true, String imageUrl = '', String route = '/x'}) =>
    BusinessUnit.fromMap(id, {
      'title': title,
      'tagline': '$title tagline',
      'description': '$title description',
      'iconKey': 'building',
      'accentColorKey': 'primary',
      'imageUrl': imageUrl,
      'route': route,
      'ctaText': 'Explore capabilities',
      'featured': true,
      'order': order,
      'published': published,
    });

/// Pumps the page with [units] as the live CMS result and records every
/// route pushed, so navigation can be checked without the real pages.
Future<List<String>> _pumpUnits(
  WidgetTester tester,
  List<BusinessUnit> units, {
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
        home: const BusinessUnitsPage(),
        onGenerateRoute: (settings) {
          pushed.add(settings.name!);
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: Text('route ${settings.name}')),
          );
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

double _y(WidgetTester tester, Finder f) => tester.getTopLeft(f).dy;

/// A unit name in the page body. The footer also lists the units, after
/// the page content, so the first match is the page's own row title.
Finder _row(String name) => find.text(name).first;

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  for (final (label, size) in [
    ('desktop', const Size(1280, 900)),
    ('phone', const Size(390, 844)),
  ]) {
    testWidgets('Empty CMS falls back to the four official units, numbered ($label)',
        (tester) async {
      await _pumpUnits(tester, const [], size: size);

      expect(find.text('Our Business Units'), findsOneWidget);
      expect(
        find.text('Four specialised areas of activity, brought together under one group.'),
        findsOneWidget,
      );

      for (var i = 0; i < _officialNames.length; i++) {
        // Row title plus the footer's Business units link.
        expect(find.text(_officialNames[i]), findsNWidgets(2));
        expect(find.text('0${i + 1}'), findsOneWidget);
        if (i > 0) {
          expect(
            _y(tester, _row(_officialNames[i - 1])),
            lessThan(_y(tester, _row(_officialNames[i]))),
          );
        }
      }
      expect(find.textContaining('Explore capabilities', findRichText: true), findsNWidgets(4));
      expect(find.text('Why Choose Us'), findsNothing);
      expect(find.textContaining('Decades'), findsNothing);

      await _drainChatTimers(tester);
    });
  }

  testWidgets('No coloured hero band', (tester) async {
    await _pumpUnits(tester, const []);

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

  testWidgets('Desktop rows alternate image sides; phone stacks image above text',
      (tester) async {
    await _pumpUnits(tester, const []);

    final images = find.byType(CmsImage);
    double imageX(int i) => tester.getTopLeft(images.at(i)).dx;
    double titleX(String t) => tester.getTopLeft(_row(t)).dx;

    expect(imageX(0), lessThan(titleX('Construction')));
    expect(imageX(1), greaterThan(titleX('Agribusiness')));
    expect(imageX(2), lessThan(titleX('Oil & Gas Services')));
    expect(imageX(3), greaterThan(titleX('IT Division')));

    await _drainChatTimers(tester);

    await _pumpUnits(tester, const [], size: const Size(390, 844));
    expect(
      tester.getBottomLeft(find.byType(CmsImage).first).dy,
      lessThan(_y(tester, _row('Construction'))),
    );
    await _drainChatTimers(tester);
  });

  testWidgets('Live CMS data: unpublished hidden, sorted by order, renumbered',
      (tester) async {
    await _pumpUnits(tester, [
      _unit('b', 'Second', 2),
      _unit('c', 'Hidden', 0, published: false),
      _unit('a', 'First', 1),
    ]);

    expect(find.text('Hidden'), findsNothing);
    expect(_y(tester, _row('First')), lessThan(_y(tester, _row('Second'))));
    expect(find.text('01'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
    expect(find.text('03'), findsNothing);
    // Live data replaces the defaults entirely.
    expect(find.text('Construction'), findsNothing);

    await _drainChatTimers(tester);
  });

  testWidgets('Missing or broken images fall back to the unit icon', (tester) async {
    await _pumpUnits(tester, [
      _unit('a', 'No image', 0),
      _unit('b', 'Broken image', 1, imageUrl: 'assets/does_not_exist.jpg'),
    ]);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(IconChip), findsNWidgets(2));
    await _drainChatTimers(tester);
  });

  test('Every default unit image exists in the bundled assets', () {
    for (final unit in defaultBusinessUnits) {
      expect(unit.imageUrl, isNotEmpty, reason: unit.title);
      expect(File(unit.imageUrl).existsSync(), isTrue, reason: unit.imageUrl);
    }
  });

  testWidgets('"Explore capabilities" opens the unit detail route', (tester) async {
    final pushed = await _pumpUnits(tester, const []);

    await tester.tap(find.textContaining('Explore capabilities', findRichText: true).first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(pushed, ['/construction-detail']);
    await _drainChatTimers(tester);
  });

  testWidgets('Related platform links open the product routes', (tester) async {
    final pushed = await _pumpUnits(tester, const []);
    final coffee = find.textContaining('CoffeeCore', findRichText: true).first;
    await tester.ensureVisible(coffee);
    await tester.tap(coffee);
    await tester.pump(const Duration(milliseconds: 400));
    expect(pushed, ['/coffee-core']);
    await _drainChatTimers(tester);
  });

  test('Default unit routes and product links point at existing routes', () {
    final mainSource = File('lib/main.dart').readAsStringSync();
    final routes = {
      for (final u in defaultBusinessUnits) u.route,
      '/cmms', '/alma-works', '/kilimo-mkononi', '/coffee-core',
    };
    for (final route in routes) {
      expect(mainSource.contains("case '$route':"), isTrue, reason: route);
    }
  });
}
