import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/section.dart';

// ── Data classes ──────────────────────────────────────────────────────────────

class _Sub {
  final String heading;
  final List<String> bullets;
  const _Sub(this.heading, this.bullets);
}

class _Contact {
  final IconData icon;
  final String text;
  const _Contact(this.icon, this.text);
}

// ── Shared widget builders ────────────────────────────────────────────────────

Widget _hero(BuildContext ctx, bool mob,
    {required IconData icon,
    required String title,
    required String subtitle}) {
  final text = Theme.of(ctx).textTheme;
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(gradient: Palette.heroSurface),
    padding: Space.sectionPad(mob),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Space.proseMax),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(Space.md),
              decoration: const BoxDecoration(
                color: Palette.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: Palette.primary),
            ),
            const SizedBox(height: Space.lg),
            Text(title,
                style: (mob ? text.headlineMedium : text.displaySmall)
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center),
            const SizedBox(height: Space.sm),
            Text(subtitle,
                style: text.bodyLarge?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}

Widget _sec(BuildContext ctx, bool mob,
    {required IconData icon,
    required String title,
    String? body,
    List<String>? bullets,
    List<_Sub>? subs,
    List<_Contact>? contacts,
    String? footer}) {
  final text = Theme.of(ctx).textTheme;
  return Padding(
    padding: const EdgeInsets.only(bottom: Space.xl),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 20, color: Palette.primary),
        const SizedBox(width: Space.xs),
        Expanded(
          child: Text(title, style: text.titleLarge?.copyWith(color: Palette.ink)),
        ),
      ]),
      const SizedBox(height: Space.md),
      if (body != null) ...[
        Text(body,
            style: text.bodyMedium?.copyWith(color: Palette.n600, height: 1.6)),
        const SizedBox(height: Space.sm),
      ],
      if (subs != null)
        ...subs.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.heading,
                style: text.titleSmall?.copyWith(color: Palette.n600)),
            const SizedBox(height: Space.xs),
            ...s.bullets.map((b) => _bul(ctx, b)),
          ]),
        )),
      if (bullets != null) ...bullets.map((b) => _bul(ctx, b)),
      if (contacts != null)
        ...contacts.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: Space.xs),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(c.icon, size: 16, color: Palette.n500),
            const SizedBox(width: Space.xs),
            Expanded(
              child: Text(c.text, style: text.bodyMedium?.copyWith(color: Palette.n600)),
            ),
          ]),
        )),
      if (footer != null)
        Padding(
          padding: const EdgeInsets.only(top: Space.xs),
          child: Text(footer,
              style: text.bodyMedium?.copyWith(color: Palette.n600, height: 1.6)),
        ),
    ]),
  );
}

Widget _bul(BuildContext ctx, String text) => Padding(
  padding: const EdgeInsets.only(bottom: Space.xs),
  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('• ',
        style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: Palette.n500)),
    Expanded(
      child: Text(text,
          style: Theme.of(ctx)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Palette.n600, height: 1.5)),
    ),
  ]),
);

Widget _callout(BuildContext ctx, String text) => Container(
  margin: const EdgeInsets.only(bottom: Space.xl),
  padding: const EdgeInsets.all(Space.md),
  decoration: BoxDecoration(
    color: Palette.primarySubtle,
    borderRadius: BorderRadius.circular(Radii.sm),
    border: const Border(left: BorderSide(color: Palette.primary, width: 4)),
  ),
  child: Text(text,
      style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
          color: Palette.primaryHover, fontWeight: FontWeight.w500, height: 1.6)),
);

// ── Page ──────────────────────────────────────────────────────────────────────

class CookiesPage extends StatelessWidget {
  const CookiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final mob = sw < 600;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          _hero(context, mob,
              icon: LucideIcons.cookie,
              title: 'Cookies Policy',
              subtitle: 'Last updated: July 10, 2026'),

          SectionWrapper(
            background: Palette.n0,
            maxWidth: Space.proseMax,
            reveal: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _sec(context, mob,
                  icon: LucideIcons.info,
                  title: 'About This Cookies Policy',
                  body: 'This Cookies Policy explains how JV ALMA C.I.S ("JV", "we", "us", "our"), '
                        'established in 2017, uses cookies and similar technologies on our website '
                        '(jvalmacis.com) and mobile applications (KilimoMkononi, CoffeeCore, NyumbaSmart) '
                        'to enhance your experience across our Construction, Oil and Gas Services, '
                        'Agribusiness, and IT Division services.',
                ),

                _sec(context, mob,
                  icon: LucideIcons.cookie,
                  title: 'What Are Cookies?',
                  body: 'Cookies are small files of letters and numbers placed on your device with your '
                        'consent. They help us distinguish you from other users, improving your experience '
                        'on our website and apps. We may also use similar technologies, such as web beacons '
                        'or pixel tags, to track user interactions.',
                ),

                _sec(context, mob,
                  icon: LucideIcons.list,
                  title: 'Types of Cookies We Use',
                  body: 'We use the following categories of cookies:',
                  bullets: [
                    'Strictly Necessary Cookies: Required for basic site and app functionality, including session management, user authentication for KilimoMkononi, CoffeeCore, and NyumbaSmart, and maintaining website navigation. These cannot be disabled.',
                    'Analytics Cookies: Help us understand how visitors interact with our website and apps — tracking visitor numbers, navigation patterns, and app usage to improve performance. All data is anonymised.',
                    'Preference Cookies: Save your settings such as language preferences, project types, or app configurations to provide a tailored experience.',
                    'Marketing Cookies (website only): Used to deliver relevant updates such as newsletters, project alerts, or software notifications based on your interests. You can opt out at any time.',
                  ],
                ),

                // Cookie table
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(LucideIcons.table2, size: 20, color: Palette.primary),
                        const SizedBox(width: Space.xs),
                        Text('Cookie Summary',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Palette.ink)),
                      ]),
                      const SizedBox(height: Space.md),
                      _cookieTable(context, mob),
                    ],
                  ),
                ),

                _callout(context,
                  'JV ALMA CIS does NOT use advertising tracking pixels, social media trackers, '
                  'or any cookie that shares your personal data with a third party for commercial purposes.'),

                _sec(context, mob,
                  icon: LucideIcons.users,
                  title: 'Third-Party Cookies',
                  body: 'Our approved third parties (e.g. analytics providers, search engines, or project '
                        'management platforms) may set cookies when you use our services to support analytics, '
                        'functionality, or communications. These third parties are required to use cookies in '
                        'accordance with this Cookies Policy and applicable laws.\n\n'
                        'The App uses Google Firebase for authentication and database services. Firebase may '
                        'use its own technical identifiers (not marketing cookies) to maintain your authenticated '
                        'session, operating under Google\'s Privacy Policy.\n\n'
                        'Weather data within KilimoMkononi and CoffeeCore is provided via the OpenWeather API. Only your '
                        'approximate county-level location is used — no personally identifiable data is '
                        'transmitted to the weather provider.',
                ),

                _sec(context, mob,
                  icon: LucideIcons.settings,
                  title: 'Managing Your Cookie Preferences',
                  body: 'You can manage your cookie preferences through your browser or device settings. '
                        'Disabling strictly necessary cookies may prevent login or navigation on our platforms.',
                  subs: [
                    const _Sub('To manage cookies in your browser:', [
                      'Chrome: Settings → Privacy and security → Cookies and other site data',
                      'Firefox: Preferences → Privacy & Security → Cookies and Site Data',
                      'Safari: Preferences → Privacy → Manage Website Data',
                      'Edge: Settings → Cookies and site permissions',
                    ]),
                    const _Sub('For mobile apps:', [
                      'Adjust location and tracking permissions in your device Settings → Privacy.',
                      'For KilimoMkononi specifically, analytics and performance cookies can be toggled in Settings → Cookie Preferences within the app.',
                    ]),
                  ],
                  footer: 'For general guidance on managing cookies, visit: www.aboutcookies.org',
                ),

                _sec(context, mob,
                  icon: LucideIcons.refreshCw,
                  title: 'Changes to This Policy',
                  body: 'We may update this Cookies Policy from time to time. We will notify you of any '
                        'changes by posting the updated policy on this page and updating the "Last updated" date. '
                        'Material changes will also be notified via in-app notification on our mobile applications.',
                ),

                _sec(context, mob,
                  icon: LucideIcons.mail,
                  title: 'Contact Us',
                  body: 'If you have questions about this Cookies Policy or our use of cookies, please contact us:',
                  contacts: [
                    const _Contact(LucideIcons.mail,   'Email: support@jvalmacis.co.ke'),
                    const _Contact(LucideIcons.phone,  'Phone: +254 795 802 020'),
                    const _Contact(LucideIcons.mapPin, 'Address: Kin\'gara Heights PQ66+2FM Junction, James Gichuru Rd, P.O. Box 12345-00100, Nairobi, Kenya'),
                  ],
                ),

              ],
            ),
          ),

          const SizedBox(height: Space.xl),
          const Footer(),
        ]),
      ),
    );
  }

  Widget _cookieTable(BuildContext context, bool mob) {
    final text = Theme.of(context).textTheme;
    final headers = ['Type', 'Purpose', 'Duration', 'Control'];
    final rows = [
      ['Strictly Necessary', 'Session management, authentication, security (CSRF), consent record', 'Session / up to 1 year', 'Cannot be disabled'],
      ['Analytics', 'Anonymised usage stats — pages visited, session duration, app feature usage', 'Up to 12 months', 'Toggle off in app or browser settings'],
      ['Preference', 'Saves display preferences and cookie consent choice', 'Up to 1 year', 'Can be disabled (may affect experience)'],
      ['Marketing', 'Newsletter and product update delivery (website only)', 'Up to 12 months', 'Opt out via unsubscribe link'],
    ];

    if (mob) {
      return Column(
        children: rows.map((row) => Container(
          margin: const EdgeInsets.only(bottom: Space.sm),
          padding: const EdgeInsets.all(Space.sm),
          decoration: BoxDecoration(
            border: Border.all(color: Palette.n200),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(headers.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: Space.xxs),
              child: RichText(
                text: TextSpan(
                  style: text.bodyMedium?.copyWith(color: Palette.n600, height: 1.5),
                  children: [
                    TextSpan(text: '${headers[i]}: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.ink)),
                    TextSpan(text: row[i]),
                  ],
                ),
              ),
            )),
          ),
        )).toList(),
      );
    }

    return Table(
      border: TableBorder.all(color: Palette.n200, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(1.4),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Palette.ink),
          children: headers.map((h) => Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Text(h, style: text.labelLarge?.copyWith(color: Colors.white)),
          )).toList(),
        ),
        ...rows.asMap().entries.map((e) => TableRow(
          decoration: BoxDecoration(color: e.key.isOdd ? Palette.n50 : Palette.n0),
          children: e.value.map((cell) => Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Text(cell, style: text.bodyMedium?.copyWith(color: Palette.n600)),
          )).toList(),
        )),
      ],
    );
  }
}
