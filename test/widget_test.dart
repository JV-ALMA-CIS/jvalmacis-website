// Widget tests for the homepage, the shared header/drawer and the shared
// footer, run through the real app router (MyApp).
//
// The CMS-backed pages read their providers from Firestore in production.
// No Firebase app is initialized in this test binary, so every test
// overrides them with the same defaults the app falls back to whenever
// Firestore is loading, empty, or unreachable.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_unit_model.dart';
import 'package:jv_alma_cis/admin/modules/business_units/business_units_provider.dart';
import 'package:jv_alma_cis/admin/modules/homepage/homepage_model.dart';
import 'package:jv_alma_cis/admin/modules/homepage/homepage_provider.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/main.dart';
import 'package:jv_alma_cis/pages/contact_page.dart';
import 'package:jv_alma_cis/widgets/app_buttons.dart';
import 'package:jv_alma_cis/widgets/cms_image.dart';
import 'package:jv_alma_cis/widgets/header.dart';
import 'package:jv_alma_cis/widgets/logo_marquee.dart';
import 'package:jv_alma_cis/widgets/website_chat_service.dart';

const _sizes = [
  ('desktop', Size(1280, 900)),
  ('tablet', Size(820, 1180)),
  ('phone', Size(390, 844)),
];

Future<void> _pumpApp(
  WidgetTester tester, {
  Size size = const Size(1280, 900),
  List<BusinessUnit> units = const [],
  SiteSettings settings = defaultSiteSettings,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(settings)),
        businessUnitsProvider.overrideWith((ref) => Stream.value(units)),
        homepageProvider.overrideWith((ref) => Stream.value(defaultHomepageContent)),
      ],
      child: const MyApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

/// Text that ends with an inline arrow icon (a WidgetSpan, U+FFFC).
Finder _arrowText(String text) => find.byWidgetPredicate(
      (w) => w is RichText && w.text.toPlainText() == '$text ￼',
    );

ScrollPosition _pagePosition(WidgetTester tester) =>
    tester.state<ScrollableState>(find.byType(Scrollable).first).position;

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  // ------------------------------------------------------------- homepage ---

  for (final (label, size) in _sizes) {
    testWidgets('Homepage shows only the agreed sections, in order ($label)', (tester) async {
      await _pumpApp(tester, size: size);

      final order = [
        find.text('Specialised services. Integrated solutions.'),
        find.textContaining('A multi-sector group delivering construction services'),
        find.text('Our areas of expertise'),
        find.text('Experience you can explore'),
        find.text('Looking for a specialised solution?'),
      ];
      // The page opens with the headline; the old sector label is gone.
      expect(find.textContaining('ENGINEERING ·'), findsNothing);
      for (var i = 0; i < order.length; i++) {
        expect(order[i], findsOneWidget);
        if (i > 0) {
          expect(tester.getTopLeft(order[i - 1]).dy, lessThan(tester.getTopLeft(order[i]).dy));
        }
      }
      for (final name in ['Construction', 'Agribusiness', 'Oil & Gas Services', 'IT Division']) {
        expect(_arrowText(name), findsOneWidget, reason: name);
      }

      // Exactly the two approved homepage CTAs.
      expect(find.byType(PrimaryButton), findsNWidgets(2));
      expect(find.text('Explore our business units'), findsOneWidget);
      expect(find.text('Contact JV ALMA C.I.S'), findsOneWidget);
      expect(find.text('Our Valued Clients'), findsNothing);

      await _drainChatTimers(tester);
    });
  }

  testWidgets('Hero CTA opens Business Units; closing CTA opens Contact', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Explore our business units'));
    await _settle(tester);
    expect(find.text('Our Business Units'), findsOneWidget);
    await _drainChatTimers(tester);

    await tester.pumpWidget(const SizedBox());
    await _pumpApp(tester);
    final closing = find.text('Contact JV ALMA C.I.S');
    await tester.ensureVisible(closing);
    await tester.tap(closing);
    await _settle(tester);
    expect(find.text("Let's discuss your requirements."), findsOneWidget);
    await _drainChatTimers(tester);
  });

  testWidgets('Homepage units: CMS data, published and featured only, in order', (tester) async {
    BusinessUnit unit(String id, String title, int order,
            {bool published = true, bool featured = true}) =>
        BusinessUnit.fromMap(id, {
          'title': title,
          'tagline': '$title tagline',
          'description': '$title scope',
          'route': '/$id',
          'order': order,
          'published': published,
          'featured': featured,
        });

    await _pumpApp(tester, units: [
      unit('b', 'Second', 1),
      unit('h', 'Hidden', 0, published: false),
      unit('n', 'NotFeatured', 2, featured: false),
      unit('a', 'First', 0),
    ]);

    expect(_arrowText('Hidden'), findsNothing);
    expect(_arrowText('NotFeatured'), findsNothing);
    expect(
      tester.getTopLeft(_arrowText('First')).dy,
      lessThanOrEqualTo(tester.getTopLeft(_arrowText('Second')).dy),
    );
    expect(
      tester.getTopLeft(_arrowText('First')).dx,
      lessThan(tester.getTopLeft(_arrowText('Second')).dx),
    );
    await _drainChatTimers(tester);
  });

  // --------------------------------------------------------------- header ---

  testWidgets('Desktop header: configured items, Contact Us, active page', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pumpApp(tester);

    // showInHeader items from the CMS defaults; Careers is drawer-only.
    for (final label in ['Home', 'About Us', 'Business Units', 'News']) {
      expect(find.descendant(of: find.byType(Header), matching: find.text(label)), findsOneWidget);
    }
    expect(find.descendant(of: find.byType(Header), matching: find.text('Careers')), findsNothing);
    expect(find.text('Contact Us'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'^Home, current page')), findsOneWidget);

    await tester.tap(find.descendant(of: find.byType(Header), matching: find.text('About Us')));
    await _settle(tester);
    expect(find.text('About JV ALMA C.I.S'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'^About Us, current page')), findsOneWidget);

    semantics.dispose();
    await _drainChatTimers(tester);
  });

  testWidgets('Drawer: configured items, no duplicate Contact, navigates and closes',
      (tester) async {
    await _pumpApp(tester, size: const Size(390, 844));

    await tester.tap(find.byTooltip('Open menu'));
    await _settle(tester);
    final drawer = find.byType(Drawer);
    for (final item in defaultSiteSettings.navigation.where((n) => n.showInDrawer)) {
      expect(find.descendant(of: drawer, matching: find.text(item.label)), findsOneWidget);
    }
    // The configured "Contact" item already links to /contact, so the
    // separate Contact Us button is not repeated.
    expect(find.descendant(of: drawer, matching: find.text('Contact Us')), findsNothing);

    await tester.tap(find.byTooltip('Close menu'));
    await _settle(tester);
    expect(drawer, findsNothing);

    await tester.tap(find.byTooltip('Open menu'));
    await _settle(tester);
    await tester.tap(find.descendant(of: drawer, matching: find.text('Careers')));
    await _settle(tester);
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Careers at JV ALMA C.I.S'), findsOneWidget);

    await _drainChatTimers(tester);
  });

  testWidgets('Logo falls back to the company name when the image fails', (tester) async {
    final broken = SiteSettings.fromMap({
      ...defaultSiteSettings.toMap(),
      'logoImageUrl': 'assets/does_not_exist.png',
    });
    await _pumpApp(tester, settings: broken);
    await tester.pump(const Duration(milliseconds: 200));

    // Header and footer both fall back.
    expect(find.text('JV ALMA C.I.S'), findsNWidgets(2));
    await _drainChatTimers(tester);
  });

  testWidgets('A page rebuild keeps the scroll position (stable scaffold key)', (tester) async {
    await _pumpApp(tester);
    _pagePosition(tester).jumpTo(400);
    await tester.pump();

    // Rebuild the page, as a CMS update would.
    final container = ProviderScope.containerOf(tester.element(find.byType(AppScaffold)));
    container.refresh(homepageProvider);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(_pagePosition(tester).pixels, 400);
    await _drainChatTimers(tester);
  });

  // --------------------------------------------------------------- footer ---

  testWidgets('Footer links, legal links and copyright', (tester) async {
    await _pumpApp(tester);

    for (final label in [
      'About Us',
      'Business Units',
      'News & Updates',
      'Certificates',
      'Careers',
      'Privacy Policy',
      'Cookies Policy',
      'Terms and Conditions',
      'Delete Account',
    ]) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.text(defaultSiteSettings.copyrightText), findsOneWidget);
    expect(find.text(defaultSiteSettings.companyEmail), findsOneWidget);
    expect(find.byTooltip('JV ALMA C.I.S on LinkedIn'), findsOneWidget);
    expect(find.byTooltip('JV ALMA C.I.S on Instagram'), findsOneWidget);

    final certificates = find.text('Certificates');
    await tester.ensureVisible(certificates);
    await tester.tap(certificates);
    await _settle(tester);
    expect(find.text('Certificates & Compliance'), findsOneWidget);

    await _drainChatTimers(tester);
  });

  for (final (label, size) in _sizes) {
    testWidgets('Back to top returns to the top of the page ($label)', (tester) async {
      await _pumpApp(tester, size: size);

      final position = _pagePosition(tester);
      position.jumpTo(position.maxScrollExtent);
      await tester.pump();
      expect(position.pixels, greaterThan(0));

      await tester.tap(find.text('Back to top'));
      await _settle(tester);
      expect(position.pixels, 0);

      await _drainChatTimers(tester);
    });
  }

  testWidgets('Back to top also works on a short page (Contact)', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
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

    final position = _pagePosition(tester);
    position.jumpTo(position.maxScrollExtent);
    await tester.pump();
    await tester.tap(find.text('Back to top'));
    await _settle(tester);
    expect(position.pixels, 0);

    await _drainChatTimers(tester);
  });

  // ------------------------------------------------- homepage additions ---

  testWidgets('Hero uses the optimized background image; client logos are shown', (tester) async {
    await _pumpApp(tester);

    final heroImage = tester.widget<CmsImage>(find.byType(CmsImage).first);
    expect(heroImage.source, 'assets/images/company_background_web.jpg');

    final clients = find.text('Our valued clients');
    await tester.ensureVisible(clients);
    expect(clients, findsOneWidget);
    final marquee = tester.widget<LogoMarquee>(find.byType(LogoMarquee));
    expect(
      marquee.assetPaths,
      [for (final logo in defaultHomepageContent.clientLogos) logo.imageUrl],
    );
    expect(
      tester.getTopLeft(find.text('Our areas of expertise')).dy,
      lessThan(tester.getTopLeft(clients).dy),
    );
    await _drainChatTimers(tester);
  });

  // ----------------------------------------------------------------- chat ---

  testWidgets('Chat button opens a labelled AI assistant panel and closes it', (tester) async {
    await _pumpApp(tester);

    expect(find.byTooltip('Ask ALMA, our AI assistant'), findsOneWidget);
    expect(find.text('Ask ALMA'), findsOneWidget);

    await tester.tap(find.text('Ask ALMA'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('AI assistant for JV ALMA C.I.S'), findsOneWidget);
    expect(find.text('What services do you offer?'), findsOneWidget);
    expect(find.textContaining('AI-generated answers can be wrong'), findsOneWidget);

    await tester.tap(find.byTooltip('Close chat').last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('AI assistant for JV ALMA C.I.S'), findsNothing);
    await _drainChatTimers(tester);
  });

  test('Reply cleanup keeps web addresses and removes Markdown markers', () {
    expect(
      cleanAiResponse('**Visit** https://www.jvalmacis.com\n- one\n- two'),
      'Visit https://www.jvalmacis.com\n• one\n• two',
    );
  });

  // --------------------------------------------------------------- footer ---

  testWidgets('Footer Business units links open the unit pages', (tester) async {
    await _pumpApp(tester);

    // The footer lists the units after the homepage's own unit grid.
    final link = find.text('Oil & Gas Services').last;
    await tester.ensureVisible(link);
    await tester.tap(link);
    await _settle(tester);
    expect(find.text('Oil & Gas Services'), findsWidgets);
    expect(find.text('Specialised services. Integrated solutions.'), findsNothing);
    await _drainChatTimers(tester);
  });
}
