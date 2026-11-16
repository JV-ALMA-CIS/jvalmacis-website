// Widget tests for the Careers page: section order, single page title,
// removed claims, the empty vacancy state, the unchanged CV address, social
// links from site settings, CMS-driven units (fallback, publication, order,
// navigation), and layout at desktop, tablet and phone widths.

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
import 'package:jv_alma_cis/pages/careers_page.dart';
import 'package:jv_alma_cis/widgets/brand_icons.dart';

const _headings = [
  'Careers at JV ALMA C.I.S',
  'Working across our business units',
  'What we value',
  'Open positions',
  'Future opportunities',
  'Follow our updates',
];

Future<List<String>> _pumpCareers(
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
        home: const CareersPage(),
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

/// The linked unit name: the name followed by its inline arrow (a
/// WidgetSpan, which reads as U+FFFC in the plain text).
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
      await _pumpCareers(tester, size: size);

      for (var i = 1; i < _headings.length; i++) {
        expect(
          tester.getTopLeft(find.text(_headings[i - 1])).dy,
          lessThan(tester.getTopLeft(find.text(_headings[i])).dy),
          reason: '"${_headings[i - 1]}" above "${_headings[i]}"',
        );
      }
      for (final unit in defaultBusinessUnits) {
        expect(_unitName(unit.title), findsOneWidget, reason: unit.title);
      }
      for (final value in ['Excellence', 'Innovation', 'Teamwork']) {
        expect(find.text(value), findsOneWidget);
      }

      await _drainChatTimers(tester);
    });
  }

  testWidgets('One page title, no hero band, no unsupported claims', (tester) async {
    await _pumpCareers(tester);

    expect(find.text('Careers at JV ALMA C.I.S'), findsOneWidget);
    for (final removed in [
      'leading team',
      'shape the future',
      'innovation and impact',
      'keep it on file',
      'always growing',
      'Apply',
    ]) {
      expect(find.textContaining(removed), findsNothing, reason: removed);
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

  testWidgets('Empty vacancy state and the unchanged CV address', (tester) async {
    await _pumpCareers(tester);

    expect(find.text('No open positions at the moment'), findsOneWidget);
    expect(find.textContaining("We don't currently have any advertised vacancies"), findsOneWidget);
    expect(careersEmail, 'hr@jvalmacis.co.ke');
    expect(find.text(careersEmail), findsOneWidget);

    await _drainChatTimers(tester);
  });

  testWidgets('Social buttons on the page plus the footer icons', (tester) async {
    await _pumpCareers(tester);

    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.byIcon(BrandIcons.linkedin), findsNWidgets(2));
    expect(find.byIcon(BrandIcons.instagram), findsNWidgets(2));

    await _drainChatTimers(tester);
  });

  testWidgets('Live units: unpublished hidden, ordered', (tester) async {
    BusinessUnit unit(String id, String title, int order, {bool published = true}) =>
        BusinessUnit.fromMap(id, {
          'title': title,
          'description': '$title scope',
          'route': '/$id',
          'order': order,
          'published': published,
        });

    await _pumpCareers(tester, units: [
      unit('b', 'Second', 1),
      unit('h', 'Hidden', 0, published: false),
      unit('a', 'First', 0),
    ]);

    expect(_unitName('Hidden'), findsNothing);
    expect(
      tester.getTopLeft(_unitName('First')).dy,
      lessThan(tester.getTopLeft(_unitName('Second')).dy),
    );
    await _drainChatTimers(tester);
  });

  testWidgets('Each unit line opens its business-unit route', (tester) async {
    for (final unit in defaultBusinessUnits) {
      final pushed = await _pumpCareers(tester);
      final line = _unitName(unit.title);
      await tester.ensureVisible(line);
      await tester.tap(line);
      await tester.pump(const Duration(milliseconds: 400));
      expect(pushed, [unit.route], reason: unit.title);
      await _drainChatTimers(tester);
      await tester.pumpWidget(const SizedBox());
    }
  });
}
