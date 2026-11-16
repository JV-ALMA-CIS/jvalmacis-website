// Widget tests for the IT Division page and the AlmaSafety and AlmaHub
// product pages: section order, the six products in their solution areas,
// screenshots only where real ones exist, product links, the development
// approach, the contact action, and what the new pages do and do not claim.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/detail/it/alma_works_page.dart';
import 'package:jv_alma_cis/detail/it/cmms_page.dart';
import 'package:jv_alma_cis/detail/it/coffee_core_page.dart';
import 'package:jv_alma_cis/detail/it/it_division_detail.dart';
import 'package:jv_alma_cis/detail/it/kilimo_mkononi_education_page.dart';
import 'package:jv_alma_cis/detail/it/kilimo_mkononi_enterprise_page.dart';
import 'package:jv_alma_cis/detail/it/kilimo_mkononi_landing_page.dart';
import 'package:jv_alma_cis/detail/it/it_products.dart';
import 'package:jv_alma_cis/detail/it/product_page.dart';
import 'package:jv_alma_cis/detail/it/product_visual.dart';
import 'package:jv_alma_cis/detail/portfolio/project_widgets.dart';
import 'package:jv_alma_cis/routing/page_titles.dart';
import 'package:jv_alma_cis/widgets/cms_image.dart';
import 'package:jv_alma_cis/widgets/hoverable.dart';

const _desktop = Size(1280, 900);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

Future<List<String>> _pump(WidgetTester tester, Widget home, {Size size = _desktop}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final pushed = <String>[];
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
            builder: (_) => Scaffold(body: Text('route ${settings.name}')),
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

/// An arrow link by its label.
Finder _link(String label) => find.descendant(
      of: find.byType(ArrowLink),
      matching: find.textContaining(label, findRichText: true),
    );

final _products = [for (final a in solutionAreas) ...a.products];

String _pageText(ProductPageContent c) => [
      ...c.overview,
      ...c.audience,
      for (final g in c.groups) ...[
        g.heading,
        g.note ?? '',
        for (final a in g.areas) ...[a.title, ...a.items],
      ],
      ...c.product.capabilities,
      c.product.description,
    ].join('\n').toLowerCase();

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  test('six products in three solution areas, with their routes', () {
    expect(solutionAreas.map((a) => a.category), [
      'Construction & Facility Operations',
      'Agricultural Technology',
      'People & Workforce Management',
    ]);
    expect(solutionAreas.map((a) => a.heading), [
      'Managing projects, facilities and site safety.',
      'Connecting agriculture with digital technology.',
      'Supporting the people behind organisations.',
    ]);
    expect([
      for (final a in solutionAreas) a.products.map((p) => p.name).toList()
    ], [
      ['AlmaWorks', 'NyumbaSmart', 'AlmaSafety'],
      ['Kilimo Mkononi', 'CoffeeCore'],
      ['AlmaHub'],
    ]);
    expect(_products.map((p) => p.route), [
      '/alma-works',
      '/cmms',
      '/alma-safety',
      '/kilimo-mkononi',
      '/coffee-core',
      '/alma-hub',
    ]);
    // Internal pages only; no invented links.
    for (final p in _products) {
      expect(p.route, startsWith('/'));
      expect(p.route, isNot(contains('http')));
    }
    // Each visual used once and on disk; the sensitive platforms use the
    // prepared illustrations, and two products have none yet.
    final visuals = [
      for (final p in _products)
        if (p.visual case final v?) v.path
    ];
    expect(visuals.toSet(), hasLength(visuals.length));
    for (final path in visuals) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    for (final (product, path) in [
      (almaWorks, 'assets/apk/almaworks.jpg'),
      (nyumbaSmart, 'assets/apk/nyumbasmart.jpg'),
      (almaHub, 'assets/apk/almahub.jpg'),
    ]) {
      expect(product.visual?.path, path);
      expect(product.visual?.kind, ScreenshotKind.illustration);
    }
    // Real screens without names or client projects.
    expect(almaSafety.visual?.path, 'assets/apk/alma_safety.jpg');
    expect(coffeeCore.visual?.path, 'assets/apk/coffee_core.jpg');
    expect(kilimoMkononi.visual?.path, 'assets/apk/kilimo_mkononi.jpg');
    expect(pageTitleFor('/alma-safety'), 'AlmaSafety | JV ALMA C.I.S');
    expect(pageTitleFor('/alma-hub'), 'AlmaHub | JV ALMA C.I.S');
    expect(pageTitleFor('/cmms'), 'NyumbaSmart | JV ALMA C.I.S');
  });

  test('no public page uses screens with private data', () {
    // Production screens with project details or a person's or cooperative's
    // name must not be published.
    final code = [
      for (final f in Directory('lib').listSync(recursive: true))
        if (f is File && f.path.endsWith('.dart')) f.readAsStringSync(),
    ].join('\n');
    for (final path in [
      'works_1.jpg',
      'works_2.jpg',
      'kilimo_mobile_view.jpg',
      'coffee_mobile_view.jpg',
      'coffee_dashboard.jpg',
      // Name a client project (Rosslyn Roofing).
      'safety.jpg',
      'safety_1.jpg',
      'safety_3.jpg',
    ]) {
      // As an asset path; comments may still name the file.
      expect(code, isNot(contains('assets/apk/$path')), reason: path);
    }
  });

  test('the new product pages make no unsupported claims', () {
    final safety = _pageText(almaSafetyPage);
    for (final claim in ['guarantee', 'certif', 'compliant', 'automat', 'integrat']) {
      expect(safety, isNot(contains(claim)), reason: claim);
    }
    // Learning and site safety management are both there.
    expect(safety, contains('safety videos'));
    expect(safety, contains('hazard'));
    expect(safety, contains('corrective action'));

    final hub = _pageText(almaHubPage);
    for (final missing in ['payroll', 'attendance', 'performance']) {
      expect(hub, isNot(contains(missing)), reason: missing);
    }
    expect(_pageText(almaHubPage), isNot(contains('thousands')));
    expect(kilimoMkononi.description, isNot(contains('thousands')));
  });

  for (final (label, size) in [('desktop', _desktop), ('tablet', _tablet), ('phone', _phone)]) {
    testWidgets('IT Division sections and products ($label)', (tester) async {
      await _pump(tester, const ITDivisionDetail(), size: size);

      double y(String text) => tester.getTopLeft(find.text(text).first).dy;
      final order = [
        'BUSINESS UNIT',
        'IT Division',
        'Our Digital Platforms',
        '01  CONSTRUCTION & FACILITY OPERATIONS',
        'Managing projects, facilities and site safety.',
        '02  AGRICULTURAL TECHNOLOGY',
        'Connecting agriculture with digital technology.',
        '03  PEOPLE & WORKFORCE MANAGEMENT',
        'Supporting the people behind organisations.',
        'Technology shaped around real operations.',
        'Have an operational challenge to solve?',
      ];
      for (var i = 1; i < order.length; i++) {
        expect(y(order[i - 1]), lessThan(y(order[i])), reason: order[i]);
      }

      for (final p in _products) {
        expect(find.text(p.name), findsWidgets, reason: p.name);
        expect(find.text(p.subtitle), findsOneWidget, reason: p.subtitle);
        expect(find.text(p.description), findsOneWidget, reason: p.description);
        expect(_link('Explore ${p.name}'), findsOneWidget, reason: p.name);
        if (p.visual case final v?) {
          expect(
              find.byWidgetPredicate((w) => w is CmsImage && w.source == v.path), findsOneWidget);
        }
      }
      // Captioned once per illustration.
      expect(find.text(illustrativeCaption), findsNWidgets(3));

      // Layout: AlmaWorks leads; NyumbaSmart and AlmaSafety, and the two
      // agricultural products, sit side by side on wide screens.
      double top(String name) => tester.getTopLeft(_link('Explore $name')).dy;
      double left(String name) => tester.getTopLeft(_link('Explore $name')).dx;
      if (size.width >= 760) {
        expect(left('NyumbaSmart'), lessThan(left('AlmaSafety')));
        expect(left('Kilimo Mkononi'), lessThan(left('CoffeeCore')));
      } else {
        expect(top('NyumbaSmart'), lessThan(top('AlmaSafety')));
        expect(top('Kilimo Mkononi'), lessThan(top('CoffeeCore')));
      }
      expect(top('AlmaWorks'), lessThan(top('NyumbaSmart')));

      for (final step in ['Understand', 'Design', 'Develop', 'Improve']) {
        expect(find.text(step), findsOneWidget);
      }
      expect(find.text('Identify operational needs and user requirements.'), findsOneWidget);
      expect(find.text('Refine platforms as operational needs evolve.'), findsOneWidget);
      // On phones the steps form one aligned sequence.
      if (size.width < 600) {
        final lefts = {
          for (final step in ['Understand', 'Design', 'Develop', 'Improve'])
            tester.getTopLeft(find.text(step)).dx,
        };
        expect(lefts, hasLength(1));
      }

      // Removed content.
      for (final gone in [
        'Technical Capabilities',
        'Cloud-Based',
        'Enterprise Security',
        'Request Info',
        'Schedule a Demo',
        'Coffee Core',
        'NyumbaSmart - CMMS',
        'Explore platform',
      ]) {
        expect(find.textContaining(gone), findsNothing, reason: gone);
      }
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }

  for (final product in _products) {
    testWidgets('${product.name} links to ${product.route}', (tester) async {
      final pushed = await _pump(tester, const ITDivisionDetail());
      final link = _link('Explore ${product.name}');
      await tester.ensureVisible(link);
      await _settle(tester);
      await tester.tap(link);
      await _settle(tester);
      expect(pushed, [product.route]);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('A missing visual falls back to the product name panel', (tester) async {
    const broken = SoftwareProduct(
      name: 'Missing',
      subtitle: 'Test',
      description: '',
      capabilities: [],
      route: '/x',
      visual: ProductScreenshot(
        'assets/apk/does_not_exist.jpg',
        kind: ScreenshotKind.illustration,
        description: 'Missing image',
        aspectRatio: 16 / 9,
      ),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SizedBox(width: 600, child: ProductVisual(product: broken))),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Missing'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('The closing action opens the contact page', (tester) async {
    final pushed = await _pump(tester, const ITDivisionDetail());
    final cta = find.text('Contact JV ALMA C.I.S →');
    await tester.ensureVisible(cta);
    await _settle(tester);
    await tester.tap(cta);
    await _settle(tester);
    expect(pushed, ['/contact']);
    await _drainChatTimers(tester);
  });

  for (final (name, page, content) in [
    ('AlmaSafety', const AlmaSafetyPage(), almaSafetyPage),
    ('AlmaHub', const AlmaHubPage(), almaHubPage),
  ]) {
    for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
      testWidgets('$name page shows its content ($label)', (tester) async {
        await _pump(tester, page, size: size);

        expect(find.text(name), findsWidgets);
        expect(find.text(content.product.subtitle), findsOneWidget);
        for (final paragraph in content.overview) {
          expect(find.text(paragraph), findsOneWidget);
        }
        for (final who in content.audience) {
          expect(find.text(who), findsOneWidget, reason: who);
        }
        for (final group in content.groups) {
          expect(find.text(group.heading), findsOneWidget);
          for (final area in group.areas) {
            expect(find.text(area.title), findsOneWidget, reason: area.title);
            for (final item in area.items) {
              expect(find.text(item), findsOneWidget, reason: item);
            }
          }
        }
        // AlmaSafety shows its approved screens; AlmaHub its captioned
        // illustration only.
        expect(
            find.text('Screenshots'), content.screenshots.isEmpty ? findsNothing : findsOneWidget);
        for (final shot in content.screenshots) {
          expect(File(shot.path).existsSync(), isTrue, reason: shot.path);
          expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == shot.path),
              findsOneWidget);
        }
        final visual = content.product.visual;
        if (visual != null && visual.kind == ScreenshotKind.illustration) {
          expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == visual.path),
              findsOneWidget);
          expect(find.text(illustrativeCaption), findsOneWidget);
        } else {
          expect(find.text(illustrativeCaption), findsNothing);
        }
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      });
    }

    testWidgets('$name page contact action opens the contact page', (tester) async {
      final pushed = await _pump(tester, page);
      final cta = find.text('Contact JV ALMA C.I.S →');
      await tester.ensureVisible(cta);
      await _settle(tester);
      await tester.tap(cta);
      await _settle(tester);
      expect(pushed, ['/contact']);
      await _drainChatTimers(tester);
    });

    testWidgets('$name page links back to the IT Division', (tester) async {
      final pushed = await _pump(tester, page);
      await tester.tap(_link('IT Division').first);
      await _settle(tester);
      expect(pushed, ['/it-division']);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('AlmaSafety separates learning from site safety management', (tester) async {
    await _pump(tester, const AlmaSafetyPage());
    double y(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(y('Learning on site'), lessThan(y('Managing site safety')));
    expect(
        find.text('For foremen and workers on the projects they are working on.'), findsOneWidget);
    await _drainChatTimers(tester);
  });

  for (final (page, content, store) in [
    (const AlmaWorksPage(), almaWorksPage, false),
    (const CmmsPage(), nyumbaSmartPage, true),
    (const CoffeeCorePage(), coffeeCorePage, true),
    (const KilimoMkononiLandingPage(), kilimoMkononiPage, false),
  ]) {
    final name = content.product.name;
    for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
      testWidgets('$name page keeps its content ($label)', (tester) async {
        await _pump(tester, page, size: size);

        expect(find.text(name), findsWidgets);
        expect(find.text(content.product.subtitle), findsOneWidget);
        if (content.tagline case final tagline?) expect(find.text(tagline), findsOneWidget);
        for (final paragraph in content.overview) {
          expect(find.text(paragraph), findsOneWidget);
        }
        for (final group in content.groups) {
          expect(find.text(group.heading), findsOneWidget);
          for (final area in group.areas) {
            expect(find.text(area.title), findsOneWidget, reason: area.title);
            for (final item in area.items) {
              expect(find.text(item), findsOneWidget, reason: item);
            }
          }
        }
        for (final group in content.featureGroups) {
          expect(find.text(group.heading), findsOneWidget);
          for (final f in group.features) {
            expect(find.text(f.title), findsWidgets, reason: f.title);
            expect(find.text(f.description), findsOneWidget, reason: f.description);
          }
        }
        for (final shot in content.screenshots) {
          expect(File(shot.path).existsSync(), isTrue, reason: shot.path);
          expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == shot.path),
              findsOneWidget);
        }
        expect(
            find.text('Screenshots'), content.screenshots.isEmpty ? findsNothing : findsOneWidget);
        expect(find.text('Get it on Google Play'), store ? findsOneWidget : findsNothing);
        expect(find.textContaining('Why Choose'), findsNothing);
        expect(find.textContaining('NyumbaSmart - CMMS'), findsNothing);
        expect(find.textContaining('Coffee Core'), findsNothing);
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      });
    }
  }

  test('Google Play links are the ones already published', () {
    expect(nyumbaSmartPage.storeLink?.url,
        'https://play.google.com/store/apps/details?id=com.jvalmacis.cmms');
    expect(coffeeCorePage.storeLink?.url,
        'https://play.google.com/store/apps/details?id=com.jvalmacis.coffeecore');
    expect(almaWorksPage.storeLink, isNull);
    expect(kilimoMkononiPage.storeLink, isNull);
    expect(almaSafetyPage.storeLink, isNull);
    expect(almaHubPage.storeLink, isNull);
  });

  for (final (edition, route) in [
    ('Enterprise', '/kilimo-mkononi-enterprise'),
    ('Education', '/kilimo-mkononi-education'),
  ]) {
    testWidgets('Kilimo Mkononi links to its $edition edition', (tester) async {
      final pushed = await _pump(tester, const KilimoMkononiLandingPage());
      expect(find.text('AVAILABLE NOW'), findsOneWidget);
      expect(find.text('COMING SOON'), findsOneWidget);
      // The two edition links line up.
      expect(
        tester.getTopLeft(_link('Explore Enterprise')).dy,
        tester.getTopLeft(_link('Explore Education')).dy,
      );
      final link = _link('Explore $edition');
      await tester.ensureVisible(link);
      await _settle(tester);
      await tester.tap(link);
      await _settle(tester);
      expect(pushed, [route]);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('Screenshots open in the image viewer', (tester) async {
    await _pump(tester, const CmmsPage());
    final tile = find.byWidgetPredicate(
      (w) => w is Hoverable && (w.semanticLabel ?? '').startsWith('Enlarge screenshot 1 of 5'),
    );
    await tester.ensureVisible(tile);
    await _settle(tester);
    await tester.tap(tile);
    await _settle(tester);
    expect(find.text('1 / 5'), findsOneWidget);
    expect(find.text('NyumbaSmart dashboard interface'), findsWidgets);
    await tester
        .tap(find.byWidgetPredicate((w) => w is Tooltip && w.message == 'Close image viewer'));
    await _settle(tester);
    await _drainChatTimers(tester);
  });

  for (final (page, content, store, status) in [
    (const KilimoMkononiEnterprisePage(), kilimoEnterprisePage, true, 'AVAILABLE NOW'),
    (const KilimoMkononiEducationPage(), kilimoEducationPage, false, 'COMING SOON'),
  ]) {
    final name = content.product.name;
    for (final (label, size) in [('desktop', _desktop), ('phone', _phone)]) {
      testWidgets('$name page keeps its content ($label)', (tester) async {
        await _pump(tester, page, size: size);

        expect(find.text(name), findsOneWidget);
        expect(find.text('KILIMO MKONONI · EDITION'), findsOneWidget);
        expect(find.text(status), findsOneWidget);
        expect(find.text(content.product.subtitle), findsOneWidget);
        for (final paragraph in content.overview) {
          expect(find.text(paragraph), findsOneWidget);
        }
        for (final group in content.groups) {
          for (final area in group.areas) {
            expect(find.text(area.title), findsOneWidget, reason: area.title);
            for (final item in area.items) {
              expect(find.text(item), findsOneWidget, reason: item);
            }
          }
        }
        for (final group in content.featureGroups) {
          expect(find.text(group.heading), findsOneWidget);
          for (final f in group.features) {
            expect(find.text(f.description), findsOneWidget, reason: f.description);
          }
        }
        expect(find.text('Get it on Google Play'), store ? findsOneWidget : findsNothing);
        if (content.ctaTitle case final title?) expect(find.text(title), findsOneWidget);
        // Each edition shows only its own screenshots.
        expect(
            find.text('Screenshots'), content.screenshots.isEmpty ? findsNothing : findsOneWidget);
        for (final shot in content.screenshots) {
          expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == shot.path),
              findsOneWidget);
        }
        // No impact section (the header and footer link to Community & Impact).
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Text &&
                (w.data ?? '').contains('Impact') &&
                w.data != 'Community & Impact',
          ),
          findsNothing,
        );
        expect(tester.takeException(), isNull);
        await _drainChatTimers(tester);
      });
    }

    testWidgets('$name page links back to Kilimo Mkononi', (tester) async {
      final pushed = await _pump(tester, page);
      await tester.tap(_link('Kilimo Mkononi').first);
      await _settle(tester);
      expect(pushed, ['/kilimo-mkononi']);
      await _drainChatTimers(tester);
    });
  }

  test('edition pages keep their published Google Play link and tab titles', () {
    expect(kilimoEnterprisePage.storeLink?.url,
        'https://play.google.com/store/apps/details?id=com.jvalmacis.kilimomkononi&pli=1');
    expect(kilimoEducationPage.storeLink, isNull);
    expect(pageTitleFor('/kilimo-mkononi-enterprise'), 'Kilimo Mkononi Enterprise | JV ALMA C.I.S');
    expect(pageTitleFor('/kilimo-mkononi-education'), 'Kilimo Mkononi Education | JV ALMA C.I.S');
  });

  test('Kilimo Mkononi screenshots belong to their edition', () {
    // The overview shows only the screen that covers both editions.
    expect(kilimoMkononiPage.screenshots.map((s) => s.path), ['assets/apk/kilimo_mkononi.jpg']);
    expect(kilimoEducationPage.screenshots, isEmpty);
    expect(kilimoEnterprisePage.screenshots.map((s) => s.path), [
      'assets/apk/kilimo_2.jpg',
      'assets/apk/kilimo_3.jpg',
      'assets/apk/kilimo_4.jpg',
      'assets/apk/kilimo_1.jpg',
      'assets/apk/kilimo_dashboard.jpg',
    ]);
    final editions = {for (final e in kilimoMkononiPage.editions) e.name: e};
    expect(editions['Kilimo Mkononi Enterprise']?.visual?.path, 'assets/apk/kilimo_2.jpg');
    expect(editions['Kilimo Mkononi Education']?.visual, isNull);
  });

  testWidgets('Kilimo Mkononi edition cards show their own visual', (tester) async {
    await _pump(tester, const KilimoMkononiLandingPage());
    expect(find.text('Screenshots'), findsOneWidget);
    for (final path in ['kilimo_2.jpg', 'kilimo_3.jpg', 'kilimo_4.jpg', 'kilimo_1.jpg']) {
      expect(
        find.byWidgetPredicate((w) => w is CmsImage && w.source == 'assets/apk/$path'),
        path == 'kilimo_2.jpg' ? findsOneWidget : findsNothing,
        reason: path,
      );
    }
    expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == 'assets/apk/kilimo_2.jpg'),
        findsOneWidget);
    // Education has no screenshot yet: its name panel stands in.
    expect(find.text('FOR SCHOOLS & EDUCATIONAL INSTITUTIONS'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _drainChatTimers(tester);
  });

  testWidgets('Each platform links to its copyright certificate', (tester) async {
    await _pump(tester, const ITDivisionDetail());
    for (final p in _products) {
      final link = find.byWidgetPredicate(
        (w) =>
            w is Hoverable &&
            w.semanticLabel == 'View the ${p.name} copyright registration certificate',
      );
      expect(link, findsOneWidget, reason: p.name);
      final path = 'assets/certificates/${p.name.toLowerCase().replaceAll(' ', '')}.jpg';
      expect(File(path).existsSync(), isTrue, reason: path);
      expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == path), findsWidgets,
          reason: path);
    }
    expect(find.text('COPYRIGHT REGISTERED'), findsNWidgets(_products.length));

    // Opens the certificate enlarged.
    final first = find.byWidgetPredicate(
      (w) =>
          w is Hoverable &&
          w.semanticLabel == 'View the AlmaWorks copyright registration certificate',
    );
    await tester.ensureVisible(first);
    await _settle(tester);
    await tester.tap(first);
    await _settle(tester);
    expect(find.text('AlmaWorks copyright registration certificate'), findsOneWidget);
    await tester
        .tap(find.byWidgetPredicate((w) => w is Tooltip && w.message == 'Close image viewer'));
    await _settle(tester);
    await _drainChatTimers(tester);
  });

  testWidgets('AlmaSafety shows its screen at the top of its page', (tester) async {
    await _pump(tester, const AlmaSafetyPage());
    final image = find.byWidgetPredicate(
      (w) => w is CmsImage && w.source == 'assets/apk/alma_safety.jpg',
    );
    expect(image, findsOneWidget);
    expect(tester.getTopLeft(image).dy, lessThan(tester.getTopLeft(find.text('Overview')).dy));
    // A real screen, so not captioned as illustrative.
    expect(find.text(illustrativeCaption), findsNothing);
    expect(tester.takeException(), isNull);
    await _drainChatTimers(tester);
  });

  test('only AlmaSafety puts a real screenshot in its header', () {
    for (final page in [
      almaWorksPage,
      nyumbaSmartPage,
      almaHubPage,
      coffeeCorePage,
      kilimoMkononiPage,
      kilimoEnterprisePage,
      kilimoEducationPage,
    ]) {
      expect(page.showVisualInHeader, isFalse, reason: page.product.name);
    }
    expect(almaSafetyPage.showVisualInHeader, isTrue);
  });
}
