import 'package:flutter/material.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/legal_document.dart';

class CookiesPage extends StatelessWidget {
  const CookiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      route: '/cookies',
      title: 'Cookies Policy',
      meta: 'Last updated 10 July 2026',
      summary: 'How JV ALMA C.I.S uses cookies and similar technologies on our website and '
          'applications, and how you can manage them.',
      sections: _sections,
    );
  }
}

const _sections = <LegalSection>[
  LegalSection('About This Cookies Policy', [
    LegalText(
      'This Cookies Policy explains how JV ALMA C.I.S ("JV", "we", "us", "our"), '
      'established in 2017, uses cookies and similar technologies on our website '
      '(jvalmacis.com) and mobile applications (Kilimo Mkononi, CoffeeCore, NyumbaSmart) '
      'to enhance your experience across our Construction, Oil & Gas Services, '
      'Agribusiness, and IT Division services.',
    ),
  ]),
  LegalSection('What Are Cookies?', [
    LegalText(
      'Cookies are small files of letters and numbers placed on your device with your '
      'consent. They help us distinguish you from other users, improving your experience '
      'on our website and apps. We may also use similar technologies, such as web beacons '
      'or pixel tags, to track user interactions.',
    ),
  ]),
  LegalSection('Types of Cookies We Use', [
    LegalText('We use the following categories of cookies:'),
    LegalList([
      'Strictly Necessary Cookies: Required for basic site and app functionality, including session management, user authentication for Kilimo Mkononi, CoffeeCore, and NyumbaSmart, and maintaining website navigation. These cannot be disabled.',
      'Analytics Cookies: Help us understand how visitors interact with our website and apps, tracking visitor numbers, navigation patterns, and app usage to improve performance. All data is anonymised.',
      'Preference Cookies: Save your settings such as language preferences, project types, or app configurations to provide a tailored experience.',
      'Marketing Cookies (website only): Used to deliver relevant updates such as newsletters, project alerts, or software notifications based on your interests. You can opt out at any time.',
    ]),
  ]),
  LegalSection('Cookie Summary', [
    LegalCustom(_cookieTable),
    LegalNote(
      'JV ALMA C.I.S does not use advertising tracking pixels, social media trackers, '
      'or any cookie that shares your personal data with a third party for commercial purposes.',
    ),
  ]),
  LegalSection('Third-Party Cookies', [
    LegalText(
      'Our approved third parties (e.g. analytics providers, search engines, or project '
      'management platforms) may set cookies when you use our services to support analytics, '
      'functionality, or communications. These third parties are required to use cookies in '
      'accordance with this Cookies Policy and applicable laws.\n\n'
      'The App uses Google Firebase for authentication and database services. Firebase may '
      'use its own technical identifiers (not marketing cookies) to maintain your authenticated '
      "session, operating under Google's Privacy Policy.\n\n"
      'Weather data within Kilimo Mkononi and CoffeeCore is provided via the OpenWeather API. '
      'Only your approximate county-level location is used; no personally identifiable data is '
      'transmitted to the weather provider.',
    ),
  ]),
  LegalSection('Managing Your Cookie Preferences', [
    LegalText(
      'You can manage your cookie preferences through your browser or device settings. '
      'Disabling strictly necessary cookies may prevent login or navigation on our platforms.',
    ),
    LegalList(heading: 'To manage cookies in your browser', [
      'Chrome: Settings → Privacy and security → Cookies and other site data',
      'Firefox: Preferences → Privacy & Security → Cookies and Site Data',
      'Safari: Preferences → Privacy → Manage Website Data',
      'Edge: Settings → Cookies and site permissions',
    ]),
    LegalList(heading: 'For mobile apps', [
      'Adjust location and tracking permissions in your device Settings → Privacy.',
      'For Kilimo Mkononi specifically, analytics and performance cookies can be toggled in Settings → Cookie Preferences within the app.',
    ]),
    LegalText('For general guidance on managing cookies, visit www.aboutcookies.org.'),
  ]),
  LegalSection('Changes to This Policy', [
    LegalText(
      'We may update this Cookies Policy from time to time. We will notify you of any '
      'changes by posting the updated policy on this page and updating the "Last updated" date. '
      'Material changes will also be notified via in-app notification on our mobile applications.',
    ),
  ]),
  LegalSection('Contact Us', [
    LegalText(
      'If you have questions about this Cookies Policy or our use of cookies, please contact us:',
    ),
    LegalDetails(legalContactRows),
  ]),
];

const _headers = ['Type', 'Purpose', 'Duration', 'Control'];
const _rows = [
  [
    'Strictly Necessary',
    'Session management, authentication, security (CSRF), consent record',
    'Session / up to 1 year',
    'Cannot be disabled'
  ],
  [
    'Analytics',
    'Anonymised usage stats: pages visited, session duration, app feature usage',
    'Up to 12 months',
    'Toggle off in app or browser settings'
  ],
  [
    'Preference',
    'Saves display preferences and cookie consent choice',
    'Up to 1 year',
    'Can be disabled (may affect experience)'
  ],
  [
    'Marketing',
    'Newsletter and product update delivery (website only)',
    'Up to 12 months',
    'Opt out via unsubscribe link'
  ],
];

/// Ruled table on wide screens; one block per cookie type on phones.
Widget _cookieTable(BuildContext context) {
  final body = AppType.theme.bodySmall?.copyWith(color: Palette.n600);
  final label = AppType.theme.titleSmall?.copyWith(color: Palette.ink);

  if (MediaQuery.sizeOf(context).width < 720) {
    return Column(
      children: [
        for (final row in _rows)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row[0], style: AppType.theme.titleMedium?.copyWith(color: Palette.ink)),
                for (var i = 1; i < _headers.length; i++) ...[
                  const SizedBox(height: Space.xs),
                  Text(_headers[i], style: label),
                  Text(row[i], style: body),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget cell(String text, TextStyle? style) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm, horizontal: Space.xs),
        child: Text(text, style: style),
      );

  return Table(
    columnWidths: const {
      0: FlexColumnWidth(1.4),
      1: FlexColumnWidth(3),
      2: FlexColumnWidth(1.5),
      3: FlexColumnWidth(2),
    },
    border: const TableBorder(horizontalInside: BorderSide(color: Palette.n200)),
    children: [
      TableRow(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ink))),
        children: [for (final h in _headers) cell(h, label)],
      ),
      for (final row in _rows)
        TableRow(children: [
          cell(row[0], label),
          for (var i = 1; i < row.length; i++) cell(row[i], body),
        ]),
    ],
  );
}
