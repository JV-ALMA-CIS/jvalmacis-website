// Consistency across the business unit pages: the same opening (back link,
// "Business unit" label, unit name, one paragraph) at the same position on
// all four; the Business Units defaults use the unit images; and edition and
// product pages go back to the page they came from instead of stacking copies.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_unit_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/detail/agribusiness/agribusiness_detail.dart';
import 'package:jv_alma_cis/detail/construction/construction_detail.dart';
import 'package:jv_alma_cis/detail/it/it_division_detail.dart';
import 'package:jv_alma_cis/detail/it/kilimo_mkononi_education_page.dart';
import 'package:jv_alma_cis/detail/it/kilimo_mkononi_enterprise_page.dart';
import 'package:jv_alma_cis/detail/it/kilimo_mkononi_landing_page.dart';
import 'package:jv_alma_cis/detail/oil/oil_gas_services_detail.dart';
import 'package:jv_alma_cis/detail/portfolio/project_widgets.dart';
import 'package:jv_alma_cis/detail/unit_intro.dart';

const _desktop = Size(1280, 900);
const _phone = Size(390, 844);

/// Pumps [home] with real Kilimo Mkononi pages behind their routes, recording
/// every route pushed.
Future<List<String>> _pump(WidgetTester tester, Widget home, {Size size = _desktop}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final pushed = <String>[];
  final pages = <String, Widget>{
    '/kilimo-mkononi': const KilimoMkononiLandingPage(),
    '/kilimo-mkononi-enterprise': const KilimoMkononiEnterprisePage(),
    '/kilimo-mkononi-education': const KilimoMkononiEducationPage(),
  };
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      ],
      child: MaterialApp(
        theme: buildAppTheme(),
        home: home,
        onGenerateRoute: (settings) {
          pushed.add(settings.name!);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => pages[settings.name] ?? Scaffold(body: Text('route ${settings.name}')),
          );
        },
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  return pushed;
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Finder _link(String label) => find.descendant(
      of: find.byType(ArrowLink),
      matching: find.textContaining(label, findRichText: true),
    );

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  test('Business Units defaults use the unit images', () {
    final images = {for (final u in defaultBusinessUnits) u.title: u.imageUrl};
    expect(images, {
      'Construction': 'assets/images/construction_1.jpg',
      'Agribusiness': 'assets/images/agribusiness_1.jpg',
      'Oil & Gas Services': 'assets/images/oil.jpg',
      'IT Division': 'assets/images/it.jpg',
    });
    for (final path in images.values) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });

  for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
    testWidgets('All four unit pages open the same way ($label)', (tester) async {
      final positions = <String, (double, double, double)>{};
      for (final (title, page) in [
        ('Construction & Facility Management', const ConstructionDetail() as Widget),
        ('Agribusiness', const AgribusinessDetail()),
        ('Oil & Gas Services', const OilAndGasServicesDetail()),
        ('IT Division', const ITDivisionDetail()),
      ]) {
        await _pump(tester, page, size: size);
        expect(find.byType(UnitIntro), findsOneWidget, reason: title);
        final intro = find.byType(UnitIntro);
        Finder inIntro(Finder f) => find.descendant(of: intro, matching: f);
        expect(inIntro(find.text('BUSINESS UNIT')), findsOneWidget, reason: title);
        expect(inIntro(find.text(title)), findsOneWidget, reason: title);
        final back = inIntro(_link('Business Units'));
        expect(back, findsOneWidget, reason: title);
        positions[title] = (
          tester.getTopLeft(back).dy,
          tester.getTopLeft(inIntro(find.text('BUSINESS UNIT'))).dy,
          tester.getTopLeft(inIntro(find.text(title))).dy,
        );
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      }
      // Same spacing at the top of every page.
      expect(positions.values.toSet(), hasLength(1), reason: '$positions');
    });
  }

  for (final (edition, route, page) in [
    ('Enterprise', '/kilimo-mkononi-enterprise', KilimoMkononiEnterprisePage),
    ('Education', '/kilimo-mkononi-education', KilimoMkononiEducationPage),
  ]) {
    testWidgets('$edition goes back to Kilimo Mkononi without stacking pages', (tester) async {
      final pushed = await _pump(tester, const KilimoMkononiLandingPage());

      for (final where in ['top', 'bottom']) {
        final open = _link('Explore $edition');
        await tester.ensureVisible(open);
        await _settle(tester);
        await tester.tap(open);
        await _settle(tester);
        expect(find.byType(page), findsOneWidget);

        // Both back links name Kilimo Mkononi, not the IT Division.
        final backs = _link('Kilimo Mkononi');
        expect(backs, findsNWidgets(2));
        expect(_link('All IT Division platforms'), findsNothing);
        final back = where == 'top' ? backs.first : backs.last;
        await tester.ensureVisible(back);
        await _settle(tester);
        await tester.tap(back);
        await _settle(tester);

        // Back on the same Kilimo Mkononi page: nothing new was opened.
        expect(find.byType(page), findsNothing);
        expect(find.byType(KilimoMkononiLandingPage), findsOneWidget);
      }
      expect(pushed, [route, route]);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('A product opened from the IT Division goes back to it', (tester) async {
    final pushed = await _pump(tester, const ITDivisionDetail());
    final open = _link('Explore Kilimo Mkononi');
    await tester.ensureVisible(open);
    await _settle(tester);
    await tester.tap(open);
    await _settle(tester);
    expect(find.byType(KilimoMkononiLandingPage), findsOneWidget);

    await tester.tap(_link('IT Division').first);
    await _settle(tester);
    expect(find.byType(KilimoMkononiLandingPage), findsNothing);
    expect(find.byType(ITDivisionDetail), findsOneWidget);
    expect(pushed, ['/kilimo-mkononi']);
    await _drainChatTimers(tester);
  });
}
