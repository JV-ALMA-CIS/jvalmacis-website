import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/legal_document.dart';

const deletionEmail = 'support@jvalmacis.co.ke';

/// Opens the visitor's email app with a deletion request ready to fill in.
final deletionRequestUri = Uri(
  scheme: 'mailto',
  path: deletionEmail,
  query: 'subject=${Uri.encodeComponent('Account deletion request')}'
      '&body=${Uri.encodeComponent('Full name:\nRegistered email address:\nApplication or service:\n')}',
);

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      route: '/delete-account',
      title: 'Account & Data Deletion',
      meta: 'Last updated June 2026',
      summary: 'Official account deletion request page for all JV ALMA C.I.S mobile '
          'applications and digital platforms available through Google Play and other '
          'distribution channels.',
      sections: _sections,
    );
  }
}

const _sections = <LegalSection>[
  LegalSection('Your Privacy Matters', [
    LegalText(
      'JV ALMA C.I.S is committed to protecting user privacy and providing users with control '
      'over their personal data. Users may request the deletion of their account and associated '
      'personal information for any application or platform developed and operated by '
      'JV ALMA C.I.S.',
    ),
  ]),
  LegalSection('Applications Covered', [
    LegalList([
      'Kilimo Mkononi',
      'CoffeeCore',
      'AlmaWorks',
      'Alma Hub',
      'NyumbaSmart',
      'Future JV ALMA C.I.S applications',
    ]),
  ]),
  LegalSection('How to Request Account Deletion', [
    LegalSteps([
      ('Send an email', 'Email your deletion request to support@jvalmacis.co.ke.'),
      (
        'Provide account information',
        'Include your full name, registered email address, and the application or service '
            'associated with the account.',
      ),
      (
        'Identity verification',
        'Our team may contact you to verify account ownership before processing the request.',
      ),
      (
        'Deletion processing',
        'Once verified, your account and associated data will be deleted within 30 days.',
      ),
    ]),
    LegalCustom(_requestPanel),
  ]),
  LegalSection('Data Handling', [
    LegalList(heading: 'Data that may be deleted', [
      'User account information',
      'Profile details',
      'Uploaded files and content',
      'Application usage records',
      'Farm and business records',
      'Preferences and settings',
      'Other personal data associated with your account',
    ]),
    LegalList(heading: 'Data that may be retained', [
      'Legal and regulatory compliance records',
      'Fraud prevention and security investigations',
      'Financial, tax, and accounting obligations',
      'System backup and disaster recovery processes for a limited period',
    ]),
  ]),
  LegalSection('What Happens After Your Request', [
    LegalText(
      'After verification, your request will be processed and your account data permanently '
      'removed. A confirmation will be sent once the deletion process has been completed.',
    ),
  ]),
  LegalSection('Contact Information', [
    LegalDetails([
      ('Email', deletionEmail),
      ('Website', 'https://jvalmacis.com'),
    ]),
  ]),
];

Widget _requestPanel(BuildContext context) => const _RequestPanel();

class _RequestPanel extends StatelessWidget {
  const _RequestPanel();

  Future<void> _compose(BuildContext context) async {
    final opened = await launchUrl(deletionRequestUri);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email app opened. Please write to $deletionEmail.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: Palette.n50,
        borderRadius: Radii.card,
        border: Border.all(color: Palette.n200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request account deletion',
            style: AppType.theme.headlineSmall?.copyWith(color: Palette.ink),
          ),
          const SizedBox(height: Space.xs),
          Text(
            'Please include your registered email address and application name when '
            'submitting your request.',
            style: AppType.theme.bodyMedium,
          ),
          const SizedBox(height: Space.lg),
          Wrap(
            spacing: Space.lg,
            runSpacing: Space.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PrimaryButton(
                text: 'Email a deletion request',
                icon: LucideIcons.mail,
                onPressed: () => _compose(context),
              ),
              const LinkedText(deletionEmail, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
