// Tests for the Community & Impact page: its content (every original
// photograph kept, only documented figures, correct institution names and
// roles), hidden stories and areas, links within and beyond the page, the
// Kapluk chapters at each size, and its place in the navigation.

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
import 'package:jv_alma_cis/detail/portfolio/project_widgets.dart';
import 'package:jv_alma_cis/pages/community_impact_content.dart';
import 'package:jv_alma_cis/pages/community_impact_page.dart';
import 'package:jv_alma_cis/routing/page_titles.dart';
import 'package:jv_alma_cis/widgets/header.dart';
import 'package:jv_alma_cis/widgets/hoverable.dart';

const _desktop = Size(1280, 900);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

final _navigator = GlobalKey<NavigatorState>();

/// Pumps [home] at [size], recording the name of every route pushed.
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
        navigatorKey: _navigator,
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

Finder _hoverable(String label) =>
    find.byWidgetPredicate((w) => w is Hoverable && w.semanticLabel == label);

Finder _link(String label) => find.descendant(
      of: find.byType(ArrowLink),
      matching: find.textContaining(label, findRichText: true),
    );

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await _settle(tester);
  await tester.tap(finder);
  await _settle(tester);
}

/// Every photograph the page can show.
Set<String> _pagePhotos() => {
      for (final c in kaplukChapters) ...c.images.map((i) => i.path),
      for (final s in featuredStories) ...s.images.map((i) => i.path),
    };

/// Everything the page says, for wording checks.
String _allText() => [
      introTitle,
      introHeadline,
      introText,
      ...approachParagraphs,
      for (final a in impactAreas) '${a.title} ${a.summary}',
      for (final s in featuredStories) ...[
        s.title,
        ...s.paragraphs,
        ...s.outcomes,
        for (final (l, v) in s.facts) '$l $v',
      ],
      for (final c in kaplukChapters) ...[c.title, ...c.points],
      ...originParagraphs,
      for (final c in collaborators) '${c.name} ${c.relationship}',
      workingTogetherIntro,
      closingTitle,
      closingText,
    ].join('\n');

/// A story that must never reach the page.
const _unpublished = ImpactStory(
  id: 'unpublished-test',
  title: 'Unpublished test story',
  areas: [ImpactArea.socialSupport],
  paragraphs: ['Not for publication.'],
  published: false,
);

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('content', () {
    test('every photograph of the former page is kept, with the four confirmed ones', () {
      const original = [
        'assets/images/agribusiness/kapluk/3.jpeg',
        'assets/images/agribusiness/kapluk/kapluk_1.jpg',
        'assets/images/agribusiness/community_empowerment_2.jpg',
        'assets/images/agribusiness/community_empowerment_1.jpg',
        'assets/images/dev/6.jpeg',
        'assets/images/dev/4.jpeg',
        'assets/images/agribusiness/soil_health_1.jpg',
        'assets/images/agribusiness/soil_health_2.jpg',
        'assets/images/agribusiness/data_processing.jpg',
        'assets/images/agribusiness/data_extraction.jpg',
        'assets/images/agribusiness/value_chain_1.jpg',
        'assets/images/agribusiness/value_chain_2.jpg',
        'assets/images/agribusiness/sustainability.jpg',
        'assets/images/dev/1.jpeg',
        'assets/images/dev/7.jpeg',
        'assets/images/agribusiness/agribusiness_in_schools_1.jpg',
        'assets/images/dev/3.jpeg',
        'assets/images/dev/9.jpg',
        'assets/images/agribusiness/training_2.jpg',
        'assets/images/dev/8.jpg',
      ];
      const confirmed = {
        'assets/images/agribusiness/training_1.jpg': 'moi-university',
        'assets/images/agribusiness/agribusiness_in_schools_2.jpg': 'kapluk-schools',
      };
      final photos = _pagePhotos();
      for (final path in [...original, ...confirmed.keys]) {
        expect(photos, contains(path), reason: path);
      }
      for (final MapEntry(key: path, value: id) in confirmed.entries) {
        final story = featuredStories.firstWhere((s) => s.id == id);
        expect(story.images.map((i) => i.path), contains(path), reason: path);
      }
      // building_leadership.jpg (training meetings) and data_collection.jpg (a
      // Kapluk farmer) are Kapluk chapter photographs.
      expect(kaplukChapters[2].images.map((i) => i.path),
          contains('assets/images/agribusiness/building_leadership.jpg'));
      expect(kaplukChapters[3].images.map((i) => i.path),
          contains('assets/images/agribusiness/data_collection.jpg'));
      for (final path in photos) {
        expect(File(path).existsSync(), isTrue, reason: path);
      }
      for (final c in collaborators) {
        if (c.logo case final logo?) expect(File(logo).existsSync(), isTrue, reason: logo);
      }
    });

    test('the Kapluk chapters keep their history; separated stories keep their link to it', () {
      expect(kaplukChapters.map((c) => c.title), [
        'Water for the Community',
        'Organizing Farmers: Kiptolelyo Self Help Group',
        'Seeds and Training',
        'Soil Health and Controlled Use of Pesticides',
        'Keeping Records',
        'From Harvest to Market',
      ]);
      final market = kaplukChapters.last.points.join(' ');
      for (final kept in ['Nyota Beans', 'Kiptolelyo Community Watermelon', 'A taste of Baringo']) {
        expect(market, contains(kept));
      }
      expect(
          kaplukChapters.last.images.map((i) => i.path),
          containsAll(
              ['assets/images/dev/7.jpeg', 'assets/images/agribusiness/value_chain_2.jpg']));
      expect(featuredStories.first.id, kaplukStory.id);
      for (final id in ['moi-university', 'kapluk-schools', 'giardiniera']) {
        expect(featuredStories.firstWhere((s) => s.id == id).partOfKapluk, isTrue, reason: id);
      }
      expect(kalroStory.partOfKapluk, isFalse);
      expect(
          giardinieraStory.paragraphs.join(' '),
          allOf(contains('Kenya Utalii College'), contains('Luca Mastromattei'),
              contains('Nairobi')));
      expect(kaplukStory.links.map((l) => l.url), contains(aicsReportUrl));
      expect(giardinieraStory.press.single.url, startsWith('https://www.malindikenya.net/'));
    });

    test('only the approved reported figures appear, each attributed to the AICS report', () {
      final outcomes = [for (final s in featuredStories) ...s.outcomes];
      expect(outcomes, hasLength(3));
      expect(
          outcomes.join(' '),
          allOf(contains('More than 300 students'), contains('Eight trainees'), contains('three'),
              contains('Five people')));
      expect(reportedOutcomesSource, contains('As reported by JV ALMA C.I.S'));
      expect(reportedOutcomesSource, contains('May 2024'));
      final text = _allText();
      for (final unsupported in [
        'beyond the mentality of grants',
        'structured loan repayment',
        'shared ownership',
        '40 farmers',
        '120',
        'verified',
        'audited',
        'phase two',
        'Phase two',
      ]) {
        expect(text, isNot(contains(unsupported)), reason: unsupported);
      }
      // No placeholder for activities awaiting material.
      expect(text, isNot(contains('Embassy')));
      expect(text, isNot(contains('CEO')));
    });

    test('institutions are named correctly, each in its documented role', () {
      final roles = {for (final c in collaborators) c.name: c.role};
      expect(roles, {
        'Moi University': CollaboratorRole.institutional,
        'Kenya Agricultural and Livestock Research Organization (KALRO)':
            CollaboratorRole.institutional,
        'Italian Agency for Development Cooperation (AICS)': CollaboratorRole.funding,
        'Kenya Utalii College': CollaboratorRole.collaborator,
        'Coffee Research Institute (CRI)': CollaboratorRole.collaborator,
        'Kiptolelyo Farmers Self Help Group': CollaboratorRole.community,
      });
      final everything = [
        _allText(),
        for (final p in agribusinessProjects) '${p.client} ${p.funder} ${p.description}',
      ].join('\n');
      expect(everything, isNot(contains('Cooperation Development')));
      expect(everything.toLowerCase(), isNot(contains('endorse')));
    });

    test('unpublished stories, and areas only they would fill, stay hidden', () {
      final shown = visibleAreas(featuredStories).map((a) => a.area);
      expect(shown, isNot(contains(ImpactArea.socialSupport)));
      expect(shown, isNot(contains(ImpactArea.communityEngagement)));
      expect(
          shown,
          containsAll([
            ImpactArea.livelihoods,
            ImpactArea.childrenAndSchools,
            ImpactArea.education,
            ImpactArea.sustainableAgriculture,
            ImpactArea.knowledge,
            ImpactArea.collaboration,
          ]));

      final withHidden = [...featuredStories, _unpublished];
      expect(publishedStories(withHidden), isNot(contains(_unpublished)));
      expect(
          visibleAreas(withHidden).map((a) => a.area), isNot(contains(ImpactArea.socialSupport)));

      const published = ImpactStory(
        id: 'published-test',
        title: 'Published test story',
        areas: [ImpactArea.socialSupport],
        paragraphs: ['Text.'],
      );
      expect(visibleAreas([...featuredStories, published]).map((a) => a.area),
          contains(ImpactArea.socialSupport));
    });

    test('routes, tab titles and navigation defaults', () {
      expect(communityImpactRoute, '/community-impact');
      expect(pageTitleFor('/community-impact'), 'Community & Impact | JV ALMA C.I.S');
      expect(pageTitleFor(legacyCommunityRoute), 'Community & Impact | JV ALMA C.I.S');
      final header = defaultSiteSettings.navigation.where((n) => n.showInHeader).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      expect(header.map((n) => n.label),
          ['Home', 'About Us', 'Business Units', 'Community & Impact', 'News']);
      final ids = defaultSiteSettings.navigation.map((n) => n.id).toList();
      expect(ids.toSet(), hasLength(ids.length), reason: 'no duplicate entries');
      expect(defaultSiteSettings.navigation.where((n) => n.route == communityImpactRoute),
          hasLength(1));

      final index = File('web/index.html').readAsStringSync();
      expect(index, contains("'/community-impact'"));
      expect(index, isNot(contains("'/community-development'")));
      final sitemap = File('web/sitemap.xml').readAsStringSync();
      expect(sitemap, contains('https://jvalmacis.com/community-impact</loc>'));
      expect(sitemap, isNot(contains('community-development')));
      final hosting = File('firebase.json').readAsStringSync();
      expect(hosting, contains('"source": "/community-development{,/}"'));
      expect(hosting, contains('"destination": "/community-impact"'));
    });
  });

  for (final (label, size) in [('desktop', _desktop), ('tablet', _tablet), ('phone', _phone)]) {
    testWidgets('The page shows its sections in order ($label)', (tester) async {
      await _pump(tester, const CommunityImpactPage(), size: size);

      double top(Finder f) => tester.getTopLeft(f.first).dy;
      final order = [
        find.text(introTitle),
        find.text(introHeadline),
        find.text(approachTitle),
        find.text('Where We Contribute'),
        find.text('Initiatives in Focus'),
        find.text(kaplukStory.title),
        find.text(moiStory.title),
        find.text(schoolsStory.title),
        find.text(giardinieraStory.title),
        find.text(kalroStory.title),
        find.text(workingTogetherTitle),
        find.text(closingTitle),
      ];
      for (final f in order) {
        expect(f, findsWidgets, reason: f.describeMatch(Plurality.zero));
      }
      for (var i = 1; i < order.length; i++) {
        expect(top(order[i]), greaterThan(top(order[i - 1])), reason: '$i');
      }
      // Every visible area is listed; areas without a published story are not.
      for (final area in visibleAreas(featuredStories)) {
        expect(find.text(area.title), findsOneWidget, reason: area.title);
      }
      expect(find.text('Social Support & Giving'), findsNothing);
      expect(find.text('Community Engagement'), findsNothing);
      // Reported figures, each with its attribution.
      for (final s in featuredStories) {
        for (final outcome in s.outcomes) {
          expect(find.text(outcome), findsOneWidget, reason: outcome);
        }
      }
      expect(find.text(reportedOutcomesSource), findsNWidgets(3));
      // The community's words and where the work led.
      final kapluk = agribusinessProjects.firstWhere((p) => p.slug == kaplukProjectSlug);
      expect(find.text('“${kapluk.testimonial!.quote}”'), findsOneWidget);
      expect(find.text(originTitle), findsOneWidget);
      // Each collaborator under its role (AICS is also named as the Kapluk
      // programme's funder).
      for (final c in collaborators) {
        expect(find.text(c.name), findsWidgets, reason: c.name);
      }
      for (final role in CollaboratorRole.values) {
        // ("Community partner" is also a Kapluk detail.)
        expect(find.text(role.label.toUpperCase()), findsWidgets, reason: role.label);
      }
      expect(find.text('IN THE PRESS'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('An unpublished story and its area never appear', (tester) async {
    await _pump(tester, const CommunityImpactPage(stories: [...featuredStories, _unpublished]));
    expect(find.text(_unpublished.title), findsNothing);
    expect(find.textContaining(_unpublished.title, findRichText: true), findsNothing);
    expect(find.text('Social Support & Giving'), findsNothing);
    await _drainChatTimers(tester);
  });

  testWidgets('Wide screens show one Kapluk chapter at a time, as tabs', (tester) async {
    await _pump(tester, const CommunityImpactPage());
    final last = kaplukChapters.last;
    expect(find.text(last.points.first), findsNothing);
    expect(find.text(kaplukChapters.first.points.first), findsOneWidget);

    await _tap(tester, _hoverable('Chapter 6 of 6: ${last.title}'));
    for (final point in last.points) {
      expect(find.text(point), findsOneWidget, reason: point);
    }
    expect(find.text(kaplukChapters.first.points.first), findsNothing);
    expect(tester.takeException(), isNull);
    await _drainChatTimers(tester);
  });

  testWidgets('Narrow screens show every Kapluk chapter in turn', (tester) async {
    await _pump(tester, const CommunityImpactPage(), size: _phone);
    for (final chapter in kaplukChapters) {
      expect(find.text(chapter.title), findsOneWidget, reason: chapter.title);
      for (final point in chapter.points) {
        expect(find.text(point), findsOneWidget, reason: point);
      }
    }
    await _drainChatTimers(tester);
  });

  testWidgets('Area links and the programme label move within the page', (tester) async {
    await _pump(tester, const CommunityImpactPage());

    // An area's story link scrolls to the story.
    await _tap(tester, _link(schoolsStory.title).first);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.getTopLeft(find.text(schoolsStory.title)).dy, inInclusiveRange(-1, 600));

    // Its label leads back to the Kapluk case study.
    final label = _hoverable('Part of the Kapluk programme: go to the case study');
    await _tap(tester, label.at(1));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.getTopLeft(find.text(kaplukStory.title)).dy, inInclusiveRange(-1, 600));
    await _drainChatTimers(tester);
  });

  testWidgets('Links open the project, Kilimo Mkononi, Agribusiness and Contact pages',
      (tester) async {
    final pushed = await _pump(tester, const CommunityImpactPage());
    for (final (finder, route) in [
      (_link('Solar-Powered Irrigation Scheme – Kapluk'), '$agribusinessRoute/$kaplukProjectSlug'),
      (_link('Kilimo Mkononi'), '/kilimo-mkononi'),
      (_link('Our partnership with Moi University'), agribusinessRoute),
      (_link('The pilot in full'), '$agribusinessRoute/kalro-kabete-pilot'),
      (find.text(closingAction), '/contact'),
    ]) {
      await _tap(tester, finder.last);
      expect(pushed.last, route);
      _navigator.currentState!.pop();
      await _settle(tester);
    }
    await _drainChatTimers(tester);
  });

  testWidgets('The footer links to Community & Impact', (tester) async {
    final pushed = await _pump(tester, const AgribusinessDetail());
    await _tap(tester, find.text('Community & Impact').last);
    expect(pushed.last, communityImpactRoute);
    await _drainChatTimers(tester);
  });

  testWidgets('The header lists Community & Impact between Business Units and News',
      (tester) async {
    await _pump(tester, const CommunityImpactPage());
    double left(String label) =>
        tester.getTopLeft(find.descendant(of: find.byType(Header), matching: find.text(label))).dx;
    expect(left('Community & Impact'), greaterThan(left('Business Units')));
    expect(left('News'), greaterThan(left('Community & Impact')));
    await _drainChatTimers(tester);
  });

  testWidgets('The mobile menu lists Community & Impact after Business Units', (tester) async {
    await _pump(tester, const CommunityImpactPage(), size: _phone);
    await tester.tap(find.byTooltip('Open menu').first);
    await _settle(tester);
    final drawer = find.byType(Drawer);
    double top(String label) =>
        tester.getTopLeft(find.descendant(of: drawer, matching: find.text(label))).dy;
    expect(top('Community & Impact'), greaterThan(top('Business Units')));
    expect(top('News'), greaterThan(top('Community & Impact')));
    expect(tester.takeException(), isNull);
    await _drainChatTimers(tester);
  });
}
