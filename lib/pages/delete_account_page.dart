import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../widgets/app_card.dart';
import '../widgets/section.dart';
import '../widgets/reveal_on_scroll.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Palette.heroSurface),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: Space.sectionPad(isMobile),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.shield,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: Space.lg),
                        Text(
                          'Account & Data Deletion',
                          textAlign: TextAlign.center,
                          style: (isMobile
                                  ? Theme.of(context).textTheme.headlineLarge
                                  : Theme.of(context).textTheme.displaySmall)
                              ?.copyWith(color: Palette.n0),
                        ),
                        const SizedBox(height: Space.md),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: Space.proseMax + 80),
                          child: Text(
                            'Official account deletion request page for all JV ALMA C.I.S mobile applications and digital platforms available through Google Play and other distribution channels.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white70,
                                  height: 1.7,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Privacy + Applications Covered
            SectionWrapper(
              background: Palette.n0,
              maxWidth: 1100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Your Privacy Matters',
                    align: TextAlign.start,
                  ),

                  const SizedBox(height: Space.md),

                  Text(
                    'JV ALMA C.I.S is committed to protecting user privacy and providing users with control over their personal data. Users may request the deletion of their account and associated personal information for any application or platform developed and operated by JV ALMA C.I.S.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.8,
                        ),
                  ),

                  const SizedBox(height: Space.xxl),

                  const SectionHeader(
                    title: 'Applications Covered',
                    align: TextAlign.start,
                  ),

                  const SizedBox(height: Space.lg),

                  const AppCard(
                    interactive: false,
                    child: Wrap(
                      spacing: Space.sm,
                      runSpacing: Space.sm,
                      children: [
                        Chip(
                          avatar: Icon(
                            LucideIcons.smartphone,
                            size: 16,
                          ),
                          label: Text('Kilimo Mkononi'),
                        ),
                        Chip(
                          avatar: Icon(
                            LucideIcons.coffee,
                            size: 16,
                          ),
                          label: Text('CoffeeCore'),
                        ),
                        Chip(
                          avatar: Icon(
                            LucideIcons.briefcase,
                            size: 16,
                          ),
                          label: Text('Alma Works'),
                        ),
                        Chip(
                          avatar: Icon(
                            LucideIcons.layoutDashboard,
                            size: 16,
                          ),
                          label: Text('Alma Hub'),
                        ),
                        Chip(
                          avatar: Icon(
                            LucideIcons.home,
                            size: 16,
                          ),
                          label: Text('Nyumba Smart'),
                        ),
                        Chip(
                          avatar: Icon(
                            LucideIcons.plusCircle,
                            size: 16,
                          ),
                          label:
                              Text('Future JV ALMA C.I.S Applications'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // How to Request Account Deletion
            SectionWrapper(
              background: Palette.n50,
              maxWidth: 1100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'How to Request Account Deletion',
                    align: TextAlign.start,
                  ),

                  const SizedBox(height: Space.xl),

                  RevealOnScroll(
                    delayMs: 0,
                    child: _timelineStep(
                      context,
                      '1',
                      'Send an Email',
                      'Email your deletion request to support@jvalmacis.co.ke.',
                    ),
                  ),

                  RevealOnScroll(
                    delayMs: 60,
                    child: _timelineStep(
                      context,
                      '2',
                      'Provide Account Information',
                      'Include your full name, registered email address, and the application or service associated with the account.',
                    ),
                  ),

                  RevealOnScroll(
                    delayMs: 120,
                    child: _timelineStep(
                      context,
                      '3',
                      'Identity Verification',
                      'Our team may contact you to verify account ownership before processing the request.',
                    ),
                  ),

                  RevealOnScroll(
                    delayMs: 180,
                    child: _timelineStep(
                      context,
                      '4',
                      'Deletion Processing',
                      'Once verified, your account and associated data will be deleted within 30 days.',
                    ),
                  ),

                  const SizedBox(height: Space.md),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Space.xl),
                    decoration: BoxDecoration(
                      gradient: Palette.heroSurface,
                      borderRadius: Radii.card,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          LucideIcons.mail,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: Space.md),
                        Text(
                          'Request Account Deletion',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Palette.n0,
                              ),
                        ),
                        const SizedBox(height: Space.md),
                        SelectableText(
                          'support@jvalmacis.co.ke',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Palette.n0,
                              ),
                        ),
                        const SizedBox(height: Space.sm),
                        Text(
                          'Please include your registered email address and application name when submitting your request.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                height: 1.6,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Data Handling
            SectionWrapper(
              background: Palette.n0,
              maxWidth: 1100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Data Handling',
                    align: TextAlign.start,
                  ),

                  const SizedBox(height: Space.lg),

                  isMobile
                      ? Column(
                          children: [
                            RevealOnScroll(delayMs: 0, child: _deletedDataCard(context)),
                            const SizedBox(height: Space.lg),
                            RevealOnScroll(delayMs: 60, child: _retainedDataCard(context)),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RevealOnScroll(delayMs: 0, child: _deletedDataCard(context)),
                            ),
                            const SizedBox(width: Space.lg),
                            Expanded(
                              child: RevealOnScroll(delayMs: 60, child: _retainedDataCard(context)),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            // What Happens After + Contact
            SectionWrapper(
              background: Palette.n50,
              maxWidth: 1100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'What Happens After Your Request',
                    align: TextAlign.start,
                  ),

                  const SizedBox(height: Space.md),

                  AppCard(
                    interactive: false,
                    accent: Palette.primary,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          LucideIcons.checkCircle,
                          color: Palette.primary,
                        ),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Text(
                            'After verification, your request will be processed and your account data permanently removed. A confirmation will be sent once the deletion process has been completed.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Space.xxl),

                  AppCard(
                    interactive: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: Space.lg),
                        SelectableText(
                          'Email: support@jvalmacis.co.ke',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Space.xs),
                        SelectableText(
                          'Website: https://jvalmacis.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Space.xl),

                  Center(
                    child: Text(
                      'Last Updated: June 2026',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  static Widget _timelineStep(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Palette.ink,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Palette.n0,
                    ),
              ),
            ),
          ),
          const SizedBox(width: Space.lg),
          Expanded(
            child: AppCard(
              interactive: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _deletedDataCard(
    BuildContext context,
  ) {
    return AppCard(
      interactive: false,
      accent: Palette.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconChip(icon: LucideIcons.trash2, color: Palette.danger),
          const SizedBox(height: Space.md),
          Text(
            'Data That May Be Deleted',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Space.md),
          Text(
            '• User account information\n'
            '• Profile details\n'
            '• Uploaded files and content\n'
            '• Application usage records\n'
            '• Farm and business records\n'
            '• Preferences and settings\n'
            '• Other personal data associated with your account',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  static Widget _retainedDataCard(
    BuildContext context,
  ) {
    return AppCard(
      interactive: false,
      accent: Palette.oilGas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconChip(icon: LucideIcons.shieldCheck, color: Palette.oilGas),
          const SizedBox(height: Space.md),
          Text(
            'Data That May Be Retained',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Space.md),
          Text(
            '• Legal and regulatory compliance records\n'
            '• Fraud prevention and security investigations\n'
            '• Financial, tax, and accounting obligations\n'
            '• System backup and disaster recovery processes for a limited period',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
