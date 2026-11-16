// Widget tests for the Agribusiness page and its project pages: section
// order, the five-project carousel, institutions (only signed ones), platform
// links, each project's content, captions and back navigation. The Community
// & Impact page has its own tests (community_impact_page_test.dart).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/detail/agribusiness/agribusiness_content.dart';
import 'package:jv_alma_cis/detail/agribusiness/agribusiness_detail.dart';
import 'package:jv_alma_cis/detail/portfolio/portfolios.dart';
import 'package:jv_alma_cis/detail/portfolio/project_page.dart';
import 'package:jv_alma_cis/detail/portfolio/project_widgets.dart';
import 'package:jv_alma_cis/routing/page_titles.dart';
import 'package:jv_alma_cis/widgets/cms_image.dart';
import 'package:jv_alma_cis/widgets/hoverable.dart';

const _desktop = Size(1280, 900);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

typedef _Push = (String, Object?);

final _navigator = GlobalKey<NavigatorState>();

/// Pumps the app at [size] starting on [home], recording every route pushed.
/// Project routes build the real project page; others build a stub.
Future<List<_Push>> _pump(WidgetTester tester, Widget home, {Size size = _desktop}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final pushed = <_Push>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      ],
      child: MaterialApp(
        navigatorKey: _navigator,
        theme: buildAppTheme(),
        home: home,
        onGenerateRoute: (settings) {
          pushed.add((settings.name!, settings.arguments));
          final found = portfolioProjectForRoute(settings.name);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => found != null
                ? PortfolioProjectPage(portfolio: found.portfolio, project: found.project)
                : Scaffold(body: Text('route ${settings.name}')),
          );
        },
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  return pushed;
}

/// Lets slides, page transitions and dialogs finish.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Finder _hoverable(bool Function(String label) test) => find.byWidgetPredicate(
      (w) => w is Hoverable && w.semanticLabel != null && test(w.semanticLabel!),
    );

Finder _card(PortfolioProject p) => _hoverable(
      (l) => l == 'Open project: ${p.title}' || l == 'Show project: ${p.title}',
    );

Finder _link(String label) => find.descendant(
      of: find.byType(ArrowLink),
      matching: find.textContaining(label, findRichText: true),
    );

Finder _button(String label) => find.byWidgetPredicate((w) => w is Tooltip && w.message == label);

PortfolioProject _project(String slug) => agribusinessProjects.firstWhere((p) => p.slug == slug);

Widget _page(PortfolioProject project) =>
    PortfolioProjectPage(portfolio: agribusinessPortfolio, project: project);

/// Everything the page and project pages say, for wording checks.
String _allText() => [
      for (final p in agribusinessProjects) ...[
        p.title,
        p.description,
        p.closing ?? '',
        for (final a in p.focusAreas) '${a.title} ${a.text}',
      ],
      for (final i in agribusinessInstitutions) '${i.name} ${i.summary}',
    ].join('\n');

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  test('the portfolio holds the five projects in order, with their routes and images', () {
    expect(agribusinessProjects.map((p) => p.title), [
      'Sigor Wei Wei Integrated Irrigation Scheme',
      'Solar-Powered Irrigation Scheme – Kapluk',
      'Makueni Irrigation Scheme',
      'ENI – Provision of Technical Services & Operations Support',
      'KALRO Kabete – Digital Agriculture Validation Pilot',
    ]);
    expect(agribusinessProjects.map((p) => p.slug).toSet(), hasLength(5));
    final paths = [for (final p in agribusinessProjects) ...p.images.map((i) => i.path)];
    expect(paths.toSet(), hasLength(paths.length));
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    for (final p in agribusinessProjects) {
      expect(portfolioProjectForRoute(p.route)?.project, same(p));
      expect(pageTitleFor(p.route), endsWith(' | Agribusiness | JV ALMA C.I.S'));
      expect(p.coverIndex, inInclusiveRange(0, p.images.length - 1));
    }
    // No invented periods.
    expect(_project('makueni-irrigation').period, isNull);
    expect(_project('eni-technical-services').period, isNull);
    // The pilot is ongoing and uses its own photographs, plus Kilimo Mkononi
    // screens showing the platform it tests.
    final pilot = _project('kalro-kabete-pilot');
    expect(pilot.period, isNull);
    expect(pilot.status, 'Ongoing');
    expect(
      pilot.images.every(
        (i) => i.path.contains('/kabete/') || i.path.startsWith('assets/apk/kilimo_'),
      ),
      isTrue,
    );
    expect(pilot.images.where((i) => i.path.contains('/kabete/')), isNotEmpty);
    expect(pilot.focusAreas, hasLength(3));
    expect(pilot.cover.path, 'assets/images/agribusiness/kabete/1.jpeg');
    expect(_project('makueni-irrigation').cover.path, 'assets/images/agribusiness/makueni_2.jpg');
    // Kapluk tells its story the same way: overview, three areas, closing.
    final kapluk = _project('kapluk-solar-irrigation');
    expect(kapluk.focusAreas.map((a) => a.title),
        ['Survey and design', 'Construction', 'Working with the community']);
    expect(kapluk.description, contains('Kapluk, in Baringo County'));
    expect(kapluk.focusAreas.last.text, contains('Kiptolelyo Self Help Group'));
    expect(kapluk.closing, isNotNull);
    // Sigor and Makueni follow the same structure.
    for (final slug in ['sigor-wei-wei', 'makueni-irrigation']) {
      final p = _project(slug);
      expect(p.focusAreas, hasLength(3), reason: slug);
      expect(p.closing, isNotNull, reason: slug);
    }
    expect(_project('sigor-wei-wei').focusAreas.first.text, contains('325 hectares'));
    expect(_project('makueni-irrigation').description, contains('Greenland Farm'));
    // Testimonials only where they existed.
    expect(
      [for (final p in agribusinessProjects) p.testimonial != null],
      [true, true, true, false, false],
    );
    expect(_project('kapluk-solar-irrigation').client,
        'Italian Agency for Development Cooperation (AICS)');
  });

  test('only signed institutions appear, and the pilot claims no results', () {
    expect(agribusinessInstitutions.map((i) => i.name), ['KALRO', 'Moi University']);
    for (final i in agribusinessInstitutions) {
      expect(File(i.logo).existsSync(), isTrue, reason: i.logo);
    }
    final text = _allText();
    // CRI now collaborates on the Kabete pilot.
    for (final unsigned in ['KMD', 'Planetek', 'Meteorological']) {
      expect(text, isNot(contains(unsigned)), reason: unsigned);
    }
    for (final claim in ['has validated', 'validated the', 'improved accuracy', 'rollout']) {
      expect(text.toLowerCase(), isNot(contains(claim)), reason: claim);
    }
    expect(text, isNot(contains('JV ALMA CIS')));
  });

  for (final (label, size, counter) in [
    ('desktop', _desktop, '01–03 / 05'),
    ('tablet', _tablet, '01–02 / 05'),
    ('phone', _phone, '01 / 05'),
  ]) {
    testWidgets('Agribusiness sections, carousel and old content ($label)', (tester) async {
      await _pump(tester, const AgribusinessDetail(), size: size);

      // The first match is the page's own; the footer lists the unit too.
      double y(String text) => tester.getTopLeft(find.text(text).first).dy;
      expect(y('Agribusiness'), lessThan(y('Agribusiness Projects')));
      expect(y('Agribusiness Projects'), lessThan(y('Working with Institutions')));
      expect(y('Working with Institutions'), lessThan(y('Technology in Agriculture')));

      for (final p in agribusinessProjects) {
        expect(_card(p), findsOneWidget, reason: p.title);
      }
      expect(find.text(counter), findsOneWidget);

      // Institutions: the two logos and their details.
      for (final i in agribusinessInstitutions) {
        expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == i.logo), findsOneWidget);
        expect(find.text(i.name), findsOneWidget);
      }

      // Moved or removed content.
      for (final gone in [
        'Capacity Building',
        'Core Services',
        'Partnership With Institutions',
        'Training Programs',
        'Formation of Self-Help Groups',
      ]) {
        expect(find.textContaining(gone), findsNothing, reason: gone);
      }
      expect(find.byType(ExpansionTile), findsNothing);
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('The carousel steps to the end and opens a project', (tester) async {
    final pushed = await _pump(tester, const AgribusinessDetail());
    for (var i = 0; i < 3; i++) {
      await tester.ensureVisible(_button('Next project'));
      await tester.tap(_button('Next project'));
      await _settle(tester);
    }
    expect(find.text('03–05 / 05'), findsOneWidget);

    final pilot = _project('kalro-kabete-pilot');
    await tester.tap(_card(pilot));
    await _settle(tester);
    expect(pushed, [(pilot.route, fromPortfolio)]);
    expect(find.text(pilot.title), findsWidgets);
    await _drainChatTimers(tester);
  });

  for (final (name, route) in [
    ('Kilimo Mkononi', '/kilimo-mkononi'),
    ('CoffeeCore', '/coffee-core')
  ]) {
    testWidgets('$name link opens its page', (tester) async {
      final pushed = await _pump(tester, const AgribusinessDetail());
      final link = _link('Explore $name');
      await tester.ensureVisible(link);
      await _settle(tester);
      await tester.tap(link);
      await _settle(tester);
      expect(pushed.single.$1, route);
      await _drainChatTimers(tester);
    });
  }

  for (final project in agribusinessProjects) {
    for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
      testWidgets('${project.slug} page shows its content ($label)', (tester) async {
        await _pump(tester, _page(project), size: size);

        // The heading, and the breadcrumb's current-page label on wide screens.
        expect(find.text(project.title), findsWidgets);
        expect(find.text('AGRIBUSINESS PROJECT'), findsOneWidget);
        if (project.client case final client?) expect(find.text(client), findsOneWidget);
        if (project.funder case final funder?) expect(find.text(funder), findsOneWidget);
        if (project.location case final location?) expect(find.text(location), findsOneWidget);
        if (project.period case final period?) {
          expect(find.text(period), findsOneWidget);
        } else if (project.status case final status?) {
          expect(find.text('STATUS'), findsOneWidget);
          expect(find.text(status), findsOneWidget);
        } else {
          expect(find.text('PERIOD'), findsNothing);
        }
        final firstParagraph = project.description.split('\n\n').first;
        expect(find.text(firstParagraph), findsOneWidget);

        final tiles = _hoverable((l) => l.startsWith('Enlarge photograph ') && l.contains(' of '));
        expect(tiles, findsNWidgets(project.images.length > 1 ? project.images.length : 0));

        final t = project.testimonial;
        expect(find.text('Testimonial'), t == null ? findsNothing : findsOneWidget);
        if (t != null) expect(find.text('— ${t.attribution}'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      });
    }
  }

  testWidgets('The pilot lists its three focus areas', (tester) async {
    final pilot = _project('kalro-kabete-pilot');
    await _pump(tester, _page(pilot));
    for (final area in pilot.focusAreas) {
      expect(find.textContaining(area.title, findRichText: true), findsOneWidget);
    }
    expect(find.text(pilot.closing!), findsOneWidget);
    expect(find.text('In collaboration with'.toUpperCase()), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Sigor keeps its launch caption, also in the image viewer', (tester) async {
    const caption = 'Former President Uhuru Kenyatta during the launch of the project';
    await _pump(tester, _page(_project('sigor-wei-wei')));
    // Under the lead photograph and under its gallery tile.
    expect(find.text(caption), findsNWidgets(2));

    final lead = _hoverable((l) => l == 'Enlarge photograph');
    await tester.ensureVisible(lead);
    await _settle(tester);
    await tester.tap(lead);
    await _settle(tester);
    expect(find.text(caption), findsNWidgets(3));
    await tester.tap(_button('Close image viewer'));
    await _settle(tester);
    await _drainChatTimers(tester);
  });

  testWidgets('Back from a project returns to the Agribusiness page', (tester) async {
    final pushed = await _pump(tester, _page(_project('makueni-irrigation')));
    final back = _link('All agribusiness projects');
    await tester.ensureVisible(back);
    await _settle(tester);
    await tester.tap(back);
    await _settle(tester);
    expect(pushed.single.$1, agribusinessRoute);
    await _drainChatTimers(tester);
  });
}
