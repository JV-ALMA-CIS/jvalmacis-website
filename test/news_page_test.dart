// Widget tests for the News & Updates page: neutral header, conditional
// featured story, date ordering, undated items, social links, item
// interaction, and layout at desktop and phone widths (flutter_test fails on
// any RenderFlex overflow).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/design/palette.dart';
import 'package:jv_alma_cis/pages/news_page.dart';
import 'package:jv_alma_cis/widgets/brand_icons.dart';

const _westPokot = 'Pastoralists in West Pokot reap big from seed maize farming';
const _weiWei = 'Wei Wei irrigation scheme to be handed over to pastoralists';
const _giardiniera = 'Italian "giardiniera" helps Kenyan farmers';
const _kapluk = 'Pastoralists in Baringo Kapluk benefit from seed maize farming';
const _gourmet = 'From Abruzzo to Kenya: The Digital Revolution Transforming African Agriculture';
const _ilPescara =
    'With JV Almacis, Pescara Native Di Carmine is Leading Agriculture 2.0 in Kenya, Combining Business and Social Development';

Future<void> _pumpNews(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // The header, footer and social block read site settings from Firestore in
  // production; no Firebase app exists in tests, so use the same defaults the
  // app falls back to.
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        siteSettingsProvider.overrideWith((ref) => Stream.value(defaultSiteSettings)),
      ],
      child: MaterialApp(theme: buildAppTheme(), home: const NewsPage()),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _drainChatTimers(WidgetTester tester) =>
    // WebsiteChatFab schedules a 2s + 4s timer chain.
    tester.pump(const Duration(seconds: 7));

Finder _scrollable() => find.byType(Scrollable).first;

// .first: the page title comes before the footer's link of the same name.
double _top(WidgetTester tester, String text) => tester.getTopLeft(find.text(text).first).dy;

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  for (final (label, size) in [
    ('desktop', const Size(1280, 900)),
    ('phone', const Size(390, 844)),
  ]) {
    testWidgets('News page renders all three sections without overflow ($label)',
        (tester) async {
      await _pumpNews(tester, size);

      // Page title, plus the footer's Explore link.
      expect(find.text('News & Updates'), findsNWidgets(2));
      expect(
        find.text('Company announcements, developments and updates from across the group.'),
        findsOneWidget,
      );
      expect(find.text('FEATURED'), findsOneWidget);
      expect(find.text('More news'), findsOneWidget);

      for (final title in [_ilPescara, _gourmet, _westPokot, _weiWei, _giardiniera, _kapluk]) {
        await tester.scrollUntilVisible(find.text(title), 300, scrollable: _scrollable());
        expect(find.text(title), findsOneWidget);
      }

      await _drainChatTimers(tester);
    });
  }

  testWidgets('Header has no coloured hero band', (tester) async {
    await _pumpNews(tester, const Size(1280, 900));

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

  testWidgets('Featured story is the flagged article and is not repeated in the list',
      (tester) async {
    await _pumpNews(tester, const Size(1280, 900));

    // Featured sits between the header and the list heading.
    expect(_top(tester, 'News & Updates'), lessThan(_top(tester, _ilPescara)));
    expect(_top(tester, _ilPescara), lessThan(_top(tester, 'More news')));

    // Exactly one headline and one link for it: no duplicate in the listing.
    expect(find.text(_ilPescara), findsOneWidget);
    expect(find.text('Read on Il Pescara'), findsOneWidget);
    expect(find.text('Image: Il Pescara'), findsOneWidget);

    await _drainChatTimers(tester);
  });

  testWidgets('Dated articles come first, newest first; undated keep their order after',
      (tester) async {
    await _pumpNews(tester, const Size(1280, 900));

    final listOrder = [_gourmet, _westPokot, _weiWei, _giardiniera, _kapluk];
    for (var i = 1; i < listOrder.length; i++) {
      expect(
        _top(tester, listOrder[i - 1]),
        lessThan(_top(tester, listOrder[i])),
        reason: '"${listOrder[i - 1]}" should appear above "${listOrder[i]}"',
      );
    }

    await _drainChatTimers(tester);
  });

  testWidgets('Only confirmed dates are shown', (tester) async {
    await _pumpNews(tester, const Size(1280, 900));

    expect(find.text('March 6, 2026'), findsOneWidget);
    expect(find.text('March 2026'), findsOneWidget);

    // Unconfirmed clipping dates and the old pseudo-date labels never appear.
    expect(find.textContaining('2020'), findsNothing);
    expect(find.textContaining('2023'), findsNothing);
    for (final label in ['Project Highlight', 'Infrastructure', 'Partnership', 'Impact Story']) {
      expect(find.text(label), findsNothing);
    }

    await _drainChatTimers(tester);
  });

  testWidgets('Social accounts appear on the page and in the footer', (tester) async {
    await _pumpNews(tester, const Size(1280, 900));

    await tester.scrollUntilVisible(find.text('Follow JV ALMA C.I.S'), 300, scrollable: _scrollable());
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);

    // One icon in the page's social block plus one in the footer.
    expect(find.byIcon(BrandIcons.linkedin), findsNWidgets(2));
    expect(find.byIcon(BrandIcons.instagram), findsNWidgets(2));

    // The page uses the same configured accounts as the footer.
    expect(defaultSiteSettings.linkedinUrl, 'https://www.linkedin.com/company/jvalmacis/');
    expect(defaultSiteSettings.instagramUrl, 'https://www.instagram.com/jvalmacis/');

    await _drainChatTimers(tester);
  });

  testWidgets('Opening a clipping shows its image, and it closes', (tester) async {
    await _pumpNews(tester, const Size(1280, 900));

    await tester.scrollUntilVisible(find.text(_westPokot), 300, scrollable: _scrollable());
    await tester.tap(find.text(_westPokot));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Dialog), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(Dialog), findsNothing);

    await _drainChatTimers(tester);
  });
}
