// Widget tests for the Construction page and the construction project pages:
// every project in the carousel, the counter, buttons, keyboard and swipe,
// the next-project preview on wide screens only, opening a project,
// NyumbaSmart, and each project page's content, gallery, viewer and back
// navigation.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/detail/construction/construction_detail.dart';
import 'package:jv_alma_cis/detail/construction/construction_projects.dart';
import 'package:jv_alma_cis/detail/portfolio/project_carousel.dart';
import 'package:jv_alma_cis/detail/portfolio/project_page.dart';
import 'package:jv_alma_cis/detail/portfolio/project_widgets.dart';
import 'package:jv_alma_cis/routing/page_titles.dart';
import 'package:jv_alma_cis/widgets/cms_image.dart';
import 'package:jv_alma_cis/widgets/hoverable.dart';
import 'package:jv_alma_cis/widgets/logo_marquee.dart';

const _desktop = Size(1280, 900);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

/// A pushed route and its arguments.
typedef _Push = (String, Object?);

final _navigator = GlobalKey<NavigatorState>();

/// The shared project page for a construction project.
Widget _page(ConstructionProject project) =>
    PortfolioProjectPage(portfolio: constructionPortfolio, project: project);

ConstructionProject _project(String slug) => constructionProjects.firstWhere((p) => p.slug == slug);

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
          final project = constructionProjectForRoute(settings.name);
          // Project routes build the real shared project page.
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                project != null ? _page(project) : Scaffold(body: Text('route ${settings.name}')),
          );
        },
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  return pushed;
}

/// Lets slides, page transitions and dialogs finish. The partner logo strip
/// scrolls forever, so this steps through a fixed second instead of
/// waiting for every animation to stop.
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

/// A project's card in the carousel; [inView] narrows to cards in or out of view.
Finder _card(ConstructionProject p, {bool? inView}) => _hoverable(
      (l) => switch (inView) {
        true => l == 'Open project: ${p.title}',
        false => l == 'Show project: ${p.title}',
        null => l == 'Open project: ${p.title}' || l == 'Show project: ${p.title}',
      },
    );
final _cards = _hoverable((l) => l.startsWith('Open project: ') || l.startsWith('Show project: '));
final _inView = _hoverable((l) => l.startsWith('Open project: '));

/// The counter with the card at [first] leading and [visible] cards in view.
String _counter(int first, int visible) {
  String pad(int n) => n.toString().padLeft(2, '0');
  final total = pad(constructionProjects.length);
  return visible == 1
      ? '${pad(first + 1)} / $total'
      : '${pad(first + 1)}–${pad(first + visible)} / $total';
}

/// An arrow link by its label (the arrow is part of the same rich text).
Finder _link(String label) => find.descendant(
      of: find.byType(ArrowLink),
      matching: find.textContaining(label, findRichText: true),
    );

Finder _button(String label) => find.byWidgetPredicate(
      (w) => w is Tooltip && w.message == label,
    );

Future<void> _tapButton(WidgetTester tester, String label) async {
  await tester.ensureVisible(_button(label));
  await tester.tap(_button(label));
  await _settle(tester);
}

/// Moves keyboard focus into the carousel.
Future<void> _focusCarousel(WidgetTester tester) async {
  final inside = find.descendant(
    of: find.byType(ProjectCarousel),
    matching: find.byType(Column),
  );
  Focus.of(tester.element(inside.first)).requestFocus();
  await tester.pump();
}

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  test('the portfolio holds all eight projects with unique routes', () {
    expect(constructionProjects, hasLength(8));
    expect(constructionProjects.map((p) => p.client), [
      'Embassy of United States in Kenya',
      'Embassy of United States, Nairobi',
      'United States Embassy',
      'NAVFAC',
      'NAVFAC',
      'Italian Embassy Nairobi',
      'Embassy of Portugal',
      'Embassy of Sweden',
    ]);
    expect(constructionProjects.map((p) => p.slug).toSet(), hasLength(8));
    for (final p in constructionProjects) {
      expect(constructionProjectForRoute(p.route), same(p));
      expect(constructionProjectForRoute('${p.route}/'), same(p));
      expect(pageTitleFor(p.route), endsWith(' | Construction | JV ALMA C.I.S'));
      expect(p.coverIndex, inInclusiveRange(0, p.images.length - 1));
    }
    expect(constructionProjects.last.testimonial, isNull);
    // Every image the portfolio names is in the folder, and each is used once.
    final paths = [for (final p in constructionProjects) ...p.images.map((i) => i.path)];
    expect(paths.toSet(), hasLength(paths.length));
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    expect(_project('portuguese-embassy').images, hasLength(4));
    // Lonetree is its own project, and only NAVFAC's projects carry a logo.
    expect(_project('lonetree-compound').period, 'Ongoing');
    expect(pageTitleFor(_project('lonetree-compound').route),
        'United States Embassy Residential Renovation – Lonetree Compound | Construction | JV ALMA C.I.S');
    expect(pageTitleFor(_project('portuguese-embassy').route),
        'Portuguese Embassy Renov | Construction | JV ALMA C.I.S');
    expect(_project('lonetree-compound').images, hasLength(2));
    expect(_project('rosslyn-ridge').images, hasLength(3));
    expect(
      [
        for (final p in constructionProjects)
          if (p.clientLogo != null) p.slug
      ],
      ['medical-research-unit-kisumu', 'mtongwe-naval-base'],
    );
    expect(File(_project('mtongwe-naval-base').clientLogo!).existsSync(), isTrue);
    expect(_project('italian-ambassadors-residence').images, hasLength(6));
    expect(constructionProjectForRoute('/construction-detail'), isNull);
    expect(constructionProjectForRoute('/construction-detail/unknown'), isNull);
    expect(pageTitleFor('/construction-detail/unknown'), 'Page not found | JV ALMA C.I.S');
  });

  for (final (label, size, visible) in [
    ('desktop', _desktop, 3),
    ('tablet', _tablet, 2),
    ('phone', _phone, 1),
  ]) {
    testWidgets('Construction page sections and carousel layout ($label)', (tester) async {
      await _pump(tester, const ConstructionDetail(), size: size);

      expect(find.text('BUSINESS UNIT'), findsOneWidget);
      expect(find.text('Construction & Facility Management'), findsOneWidget);
      expect(find.text('Construction Projects'), findsOneWidget);
      expect(find.text('Facility Management'), findsOneWidget);
      expect(find.text('NyumbaSmart'), findsOneWidget);
      // The old Key Features list is gone.
      expect(find.text('Key Features'), findsNothing);
      expect(find.text('CMMS Integration'), findsNothing);

      // Sections in order.
      double y(String text) => tester.getTopLeft(find.text(text)).dy;
      expect(y('Construction & Facility Management'), lessThan(y('Construction Projects')));
      expect(y('Construction Projects'), lessThan(y('Facility Management')));

      // Every project has a card; the first [visible] are in view.
      expect(_cards, findsNWidgets(constructionProjects.length));
      expect(_inView, findsNWidgets(visible));
      expect(find.text(_counter(0, visible)), findsOneWidget);
      final first = tester.getRect(_card(constructionProjects.first));
      for (var i = 1; i < visible; i++) {
        final rect = tester.getRect(_card(constructionProjects[i]));
        expect(rect.width, closeTo(first.width, 0.01));
        expect(rect.top, first.top);
      }
      final next = tester.getRect(_card(constructionProjects[visible]));
      if (visible > 1) {
        // Part of the next card shows at the right edge, inside the window.
        expect(next.left, lessThan(size.width - 60));
        expect(next.left, greaterThan(first.right));
      } else {
        // Phones: one card within the gutters, the next fully off screen.
        expect(first.left, 20);
        expect(first.right, size.width - 20);
        expect(next.left, greaterThanOrEqualTo(size.width));
      }
      // Cards are much smaller than the window, unlike the old full-width slide.
      if (visible == 3) expect(first.width, lessThan(400));
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('Buttons step through every project and stop at the ends', (tester) async {
    await _pump(tester, const ConstructionDetail());
    const visible = 3;
    final last = constructionProjects.length - visible;

    await _tapButton(tester, 'Previous project');
    expect(find.text(_counter(0, visible)), findsOneWidget, reason: 'previous is disabled');

    for (var i = 0; i <= last; i++) {
      expect(find.text(_counter(i, visible)), findsOneWidget);
      for (var j = i; j < i + visible; j++) {
        expect(_card(constructionProjects[j], inView: true), findsOneWidget);
      }
      if (i < last) await _tapButton(tester, 'Next project');
    }
    // At the end: next is disabled and the last card ends at the column's edge.
    await _tapButton(tester, 'Next project');
    expect(find.text(_counter(last, visible)), findsOneWidget);
    expect(
      tester.getRect(_card(constructionProjects.last)).right,
      closeTo(tester.getRect(find.text('Facility Management')).left + 1080, 1),
    );

    for (var i = last; i > 0; i--) {
      await _tapButton(tester, 'Previous project');
    }
    expect(find.text(_counter(0, visible)), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('A press in the carousel lets the arrow keys move it', (tester) async {
    await _pump(tester, const ConstructionDetail());
    await _tapButton(tester, 'Next project');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await _settle(tester);
    expect(find.text(_counter(2, 3)), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Arrow keys move the carousel', (tester) async {
    await _pump(tester, const ConstructionDetail());
    await _focusCarousel(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await _settle(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await _settle(tester);
    expect(find.text(_counter(2, 3)), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await _settle(tester);
    expect(find.text(_counter(1, 3)), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Swiping moves one project at a time on phones', (tester) async {
    await _pump(tester, const ConstructionDetail(), size: _phone);
    final first = _card(constructionProjects.first);
    await tester.ensureVisible(first);
    await tester.pump();

    await tester.fling(first, const Offset(-200, 0), 800);
    await _settle(tester);
    expect(find.text(_counter(1, 1)), findsOneWidget);
    expect(_card(constructionProjects[1], inView: true), findsOneWidget);
    // Only the card in view is on screen.
    for (final p in constructionProjects) {
      if (p == constructionProjects[1]) continue;
      final rect = tester.getRect(_card(p));
      expect(rect.right <= 0 || rect.left >= _phone.width, isTrue, reason: p.title);
    }

    await tester.fling(_card(constructionProjects[1]), const Offset(200, 0), 800);
    await _settle(tester);
    expect(find.text(_counter(0, 1)), findsOneWidget);

    // A slow drag of under half a card still moves on; a short one settles back.
    await tester.timedDrag(first, const Offset(-150, 0), const Duration(seconds: 1));
    await _settle(tester);
    expect(find.text(_counter(1, 1)), findsOneWidget);
    await tester.timedDrag(
      _card(constructionProjects[1]),
      const Offset(-30, 0),
      const Duration(seconds: 1),
    );
    await _settle(tester);
    expect(find.text(_counter(1, 1)), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _drainChatTimers(tester);
  });

  testWidgets('Tapping the partly shown card brings it in; tapping a card in view opens it',
      (tester) async {
    final pushed = await _pump(tester, const ConstructionDetail());

    final peeking = _card(constructionProjects[3]);
    expect(_card(constructionProjects[3], inView: false), findsOneWidget);
    await tester.ensureVisible(peeking);
    await _settle(tester);
    final rect = tester.getRect(peeking);
    await tester.tapAt(Offset(rect.left + 30, rect.top + 60));
    await _settle(tester);
    expect(find.text(_counter(1, 3)), findsOneWidget);
    expect(pushed, isEmpty);

    await tester.tap(_card(constructionProjects[1]));
    await _settle(tester);
    expect(pushed, [('/construction-detail/rosslyn-ridge', fromPortfolio)]);
    expect(find.text(constructionProjects[1].title), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Cards show each project number, title, client and period', (tester) async {
    await _pump(tester, const ConstructionDetail());
    for (final (i, p) in constructionProjects.indexed) {
      final card = _card(p);
      Finder inCard(String text) => find.descendant(of: card, matching: find.text(text));
      expect(inCard((i + 1).toString().padLeft(2, '0')), findsOneWidget);
      expect(inCard(p.title), findsOneWidget);
      expect(inCard(p.client!), findsOneWidget);
      if (p.period case final period?) expect(inCard(period), findsOneWidget);
    }
    await _drainChatTimers(tester);
  });

  for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
    testWidgets('Partners sit between the projects and facility management ($label)',
        (tester) async {
      await _pump(tester, const ConstructionDetail(), size: size);

      double y(String text) => tester.getTopLeft(find.text(text)).dy;
      expect(y('Construction Projects'), lessThan(y('Construction Partners')));
      expect(y('Construction Partners'), lessThan(y('Facility Management')));
      expect(constructionPartners, hasLength(9));
      // One strip of logos, read out as a single list of every partner.
      expect(find.byType(LogoMarquee), findsOneWidget);
      final label = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .map((w) => w.properties.label)
          .firstWhere((l) => l != null && l.startsWith('Construction partners: '));
      for (final partner in constructionPartners) {
        expect(label, contains(partner.name));
        final logo = partner.logo!;
        expect(File(logo).existsSync(), isTrue, reason: logo);
        expect(
          find.byWidgetPredicate((w) => w is CmsImage && w.source == logo),
          findsWidgets,
          reason: logo,
        );
      }
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('NyumbaSmart opens the CMMS page', (tester) async {
    final pushed = await _pump(tester, const ConstructionDetail());
    final link = _link('Explore NyumbaSmart');
    await tester.ensureVisible(link);
    await tester.tap(link);
    await _settle(tester);
    expect(pushed, [('/cmms', null)]);
    await _drainChatTimers(tester);
  });

  testWidgets('Business Units link returns to the Business Units page', (tester) async {
    final pushed = await _pump(tester, const ConstructionDetail());
    await tester.tap(_link('Business Units'));
    await _settle(tester);
    expect(pushed.single.$1, '/business-units');
    await _drainChatTimers(tester);
  });

  for (final project in constructionProjects) {
    for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
      testWidgets('${project.slug} page shows its content ($label)', (tester) async {
        await _pump(tester, _page(project), size: size);

        // The heading, plus the breadcrumb when the title has no comma to shorten at.
        expect(find.text(project.title), findsWidgets);
        expect(find.text(project.client!), findsOneWidget);
        if (project.period case final period?) {
          expect(find.text(period), findsOneWidget);
        } else {
          expect(find.text('PERIOD'), findsNothing);
        }
        expect(find.text(project.description), findsOneWidget);
        expect(find.text('Overview'), findsOneWidget);

        final tiles = _hoverable((l) => l.startsWith('Enlarge photograph ') && l.contains(' of '));
        if (project.images.length > 1) {
          expect(find.text('Photographs'), findsOneWidget);
          expect(tiles, findsNWidgets(project.images.length));
        } else {
          expect(find.text('Photographs'), findsNothing);
          expect(tiles, findsNothing);
        }

        final t = project.testimonial;
        expect(find.text('Testimonial'), t == null ? findsNothing : findsOneWidget);
        if (t != null) {
          expect(find.text('“${t.quote}”'), findsOneWidget);
          expect(find.text('— ${t.attribution}'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      });
    }
  }

  testWidgets('Image viewer opens, steps through photographs and closes', (tester) async {
    final project = constructionProjects.first; // three images, cover is the third
    await _pump(tester, _page(project));

    await tester.tap(_hoverable((l) => l == 'Enlarge photograph'));
    await _settle(tester);
    expect(find.text('3 / 3'), findsOneWidget);
    await tester.tap(_button('Previous image'));
    await tester.pump();
    expect(find.text('2 / 3'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(find.text('1 / 3'), findsOneWidget);
    await tester.tap(_button('Close image viewer'));
    await _settle(tester);
    expect(find.text('1 / 3'), findsNothing);

    // Gallery tiles open at their own image; Escape closes.
    final second = _hoverable((l) => l == 'Enlarge photograph 2 of 3');
    await tester.ensureVisible(second);
    await _settle(tester);
    await tester.tap(second);
    await _settle(tester);
    expect(find.text('2 / 3'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _settle(tester);
    expect(find.text('2 / 3'), findsNothing);
    await _drainChatTimers(tester);
  });

  testWidgets('A single-image project opens the viewer without a counter', (tester) async {
    await _pump(tester, _page(_project('medical-research-unit-kisumu')));
    await tester.tap(_hoverable((l) => l == 'Enlarge photograph'));
    await _settle(tester);
    expect(_button('Close image viewer'), findsOneWidget);
    expect(_button('Next image'), findsNothing);
    await tester.tap(_button('Close image viewer'));
    await _settle(tester);
    await _drainChatTimers(tester);
  });

  testWidgets('Back from a project opened in the carousel returns to it', (tester) async {
    final pushed = await _pump(tester, const Scaffold(body: Text('portfolio')));
    _navigator.currentState!
        .pushNamed(_project('italian-ambassadors-residence').route, arguments: fromPortfolio);
    await _settle(tester);

    // Next project replaces this page, so back still leads to the portfolio.
    final next = _link(_project('portuguese-embassy').title);
    await tester.ensureVisible(next);
    await tester.tap(next);
    await _settle(tester);
    expect(find.text('Portuguese Embassy Renov'), findsOneWidget);

    await tester.tap(_link('Construction Projects'));
    await _settle(tester);
    expect(find.text('portfolio'), findsOneWidget);
    expect(pushed.map((p) => p.$1), [
      _project('italian-ambassadors-residence').route,
      _project('portuguese-embassy').route,
    ]);
    await _drainChatTimers(tester);
  });

  testWidgets('Back from a directly opened project opens the Construction page', (tester) async {
    final pushed = await _pump(tester, _page(constructionProjects[0]));
    final back = _link('All construction projects');
    await tester.ensureVisible(back);
    await tester.tap(back);
    await _settle(tester);
    expect(pushed.single.$1, constructionRoute);
    await _drainChatTimers(tester);
  });
}
