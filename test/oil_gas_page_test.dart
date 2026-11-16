// Widget tests for the Oil & Gas Services page: section order, the three
// services, the partnership wording (no shareholding or pipeline claims),
// TIC East Africa and the TIC Group companies, labelling of the group's
// certifications and references, the image viewer and the back link.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_model.dart';
import 'package:jv_alma_cis/admin/modules/site_settings/site_settings_provider.dart';
import 'package:jv_alma_cis/design/app_theme.dart';
import 'package:jv_alma_cis/detail/oil/oil_gas_content.dart';
import 'package:jv_alma_cis/detail/oil/oil_gas_services_detail.dart';
import 'package:jv_alma_cis/detail/portfolio/project_widgets.dart';
import 'package:jv_alma_cis/widgets/cms_image.dart';
import 'package:jv_alma_cis/widgets/hoverable.dart';

const _desktop = Size(1280, 900);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

Future<List<String>> _pump(WidgetTester tester, {Size size = _desktop}) async {
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
        home: const OilAndGasServicesDetail(),
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

String _allText() => [
      oilGasIntro,
      ...oilGasPartnership,
      for (final s in oilGasServices) ...[s.title, ...s.paragraphs],
    ].join('\n');

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  test('wording keeps to the partnership and makes no removed claims', () {
    final text = _allText();
    expect(text, contains('in partnership with Brisma Africa and TIC Group'));
    for (final removed in ['shareholder', 'pipeline', 'guarantee', 'a leader', 'decades']) {
      expect(text.toLowerCase(), isNot(contains(removed)), reason: removed);
    }
    // Every image is on disk; the group's credentials are labelled as its own.
    final images = [
      for (final s in oilGasServices) s.image.path,
      oilGasPartnershipImage.path,
      ticGroupLogo,
      ticEastAfricaLogo,
      for (final c in ticGroupCredentials) c.path,
    ];
    for (final path in images) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    for (final c in ticGroupCredentials) {
      expect(c.caption, startsWith('TIC Group'));
    }
  });

  for (final (label, size) in [('desktop', _desktop), ('tablet', _tablet), ('phone', _phone)]) {
    testWidgets('Oil & Gas sections and content ($label)', (tester) async {
      await _pump(tester, size: size);

      double y(String text) => tester.getTopLeft(find.text(text).first).dy;
      final order = [
        'Oil & Gas Services',
        'Inspection and Regulatory Compliance',
        'Working with Brisma Africa and TIC Group',
        'Certifications and References',
        'TIC GROUP CERTIFICATIONS AND REFERENCES',
      ];
      for (var i = 1; i < order.length; i++) {
        expect(y(order[i - 1]), lessThan(y(order[i])), reason: order[i]);
      }

      expect(find.text(oilGasIntro), findsOneWidget);
      for (final service in oilGasServices) {
        expect(find.text(service.title), findsOneWidget);
        for (final p in service.paragraphs) {
          expect(find.text(p), findsOneWidget);
        }
      }
      for (final p in oilGasPartnership) {
        expect(find.text(p), findsOneWidget);
      }
      expect(find.text(ticGroup.name), findsOneWidget);
      expect(find.text(ticGroup.origin), findsOneWidget);
      expect(find.text(ticGroup.phone!), findsOneWidget);
      for (final c in ticGroupCredentials) {
        expect(find.text(c.caption!), findsOneWidget);
        expect(find.byWidgetPredicate((w) => w is CmsImage && w.source == c.path), findsOneWidget);
      }

      // Old wording and labels are gone.
      for (final gone in [
        'shareholders',
        'pipelines',
        'guarantees',
        'a leader',
        'Subsidiaries',
        'Featured Subsidiary',
        'Clients',
      ]) {
        expect(find.textContaining(gone), findsNothing, reason: gone);
      }
      expect(tester.takeException(), isNull);
      await _drainChatTimers(tester);
    });
  }

  testWidgets('Images open in the viewer', (tester) async {
    await _pump(tester);
    final photo = find.byWidgetPredicate(
      (w) => w is Hoverable && w.semanticLabel == 'Enlarge image: TIC Group references',
    );
    await tester.ensureVisible(photo);
    await _settle(tester);
    await tester.tap(photo);
    await _settle(tester);
    expect(find.text('2 / 2'), findsOneWidget);
    await tester
        .tap(find.byWidgetPredicate((w) => w is Tooltip && w.message == 'Close image viewer'));
    await _settle(tester);
    await _drainChatTimers(tester);
  });

  testWidgets('Business Units link returns to the Business Units page', (tester) async {
    final pushed = await _pump(tester);
    await tester.tap(find.descendant(
      of: find.byType(ArrowLink),
      matching: find.textContaining('Business Units', findRichText: true),
    ));
    await _settle(tester);
    expect(pushed, ['/business-units']);
    await _drainChatTimers(tester);
  });
}
