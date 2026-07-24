import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../widgets/header.dart';
import '../widgets/footer.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 40,
                      vertical: isMobile ? 60 : 90,
                    ),
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
                        const SizedBox(height: 24),
                        Text(
                          'Account & Data Deletion',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: 800),
                          child: const Text(
                            'Official account deletion request page for all JV ALMA C.I.S mobile applications and digital platforms available through Google Play and other distribution channels.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
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

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 60,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        context,
                        'Your Privacy Matters',
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'JV ALMA C.I.S is committed to protecting user privacy and providing users with control over their personal data. Users may request the deletion of their account and associated personal information for any application or platform developed and operated by JV ALMA C.I.S.',
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.8,
                                ),
                      ),

                      const SizedBox(height: 50),

                      _sectionTitle(
                        context,
                        'Applications Covered',
                      ),

                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: const Wrap(
                          spacing: 12,
                          runSpacing: 12,
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

                      const SizedBox(height: 60),

                      _sectionTitle(
                        context,
                        'How to Request Account Deletion',
                      ),

                      const SizedBox(height: 30),

                      _timelineStep(
                        context,
                        '1',
                        'Send an Email',
                        'Email your deletion request to support@jvalmacis.co.ke.',
                      ),

                      _timelineStep(
                        context,
                        '2',
                        'Provide Account Information',
                        'Include your full name, registered email address, and the application or service associated with the account.',
                      ),

                      _timelineStep(
                        context,
                        '3',
                        'Identity Verification',
                        'Our team may contact you to verify account ownership before processing the request.',
                      ),

                      _timelineStep(
                        context,
                        '4',
                        'Deletion Processing',
                        'Once verified, your account and associated data will be deleted within 30 days.',
                      ),

                      const SizedBox(height: 50),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0F172A),
                              Color(0xFF1E293B),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              LucideIcons.mail,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Request Account Deletion',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            SelectableText(
                              'support@jvalmacis.co.ke',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Please include your registered email address and application name when submitting your request.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      _sectionTitle(
                        context,
                        'Data Handling',
                      ),

                      const SizedBox(height: 24),

                      isMobile
                          ? Column(
                              children: [
                                _deletedDataCard(context),
                                const SizedBox(height: 20),
                                _retainedDataCard(context),
                              ],
                            )
                          : Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child:
                                      _deletedDataCard(context),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child:
                                      _retainedDataCard(context),
                                ),
                              ],
                            ),

                      const SizedBox(height: 60),

                      _sectionTitle(
                        context,
                        'What Happens After Your Request',
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.blue.shade100,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              LucideIcons.checkCircle,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'After verification, your request will be processed and your account data permanently removed. A confirmation will be sent once the deletion process has been completed.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            const SelectableText(
                              'Email: support@jvalmacis.co.ke',
                            ),
                            const SizedBox(height: 10),
                            const SelectableText(
                              'Website: https://jvalmacis.com',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: Text(
                          'Last Updated: June 2026',
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(
            fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade50,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red.shade50,
          border: Border.all(
            color: Colors.red.shade100,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              LucideIcons.trash2,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Data That May Be Deleted',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              '• User account information\n'
              '• Profile details\n'
              '• Uploaded files and content\n'
              '• Application usage records\n'
              '• Farm and business records\n'
              '• Preferences and settings\n'
              '• Other personal data associated with your account',
            ),
          ],
        ),
      ),
    );
  }

  static Widget _retainedDataCard(
    BuildContext context,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber.shade50,
          border: Border.all(
            color: Colors.amber.shade100,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              LucideIcons.shieldCheck,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Data That May Be Retained',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              '• Legal and regulatory compliance records\n'
              '• Fraud prevention and security investigations\n'
              '• Financial, tax, and accounting obligations\n'
              '• System backup and disaster recovery processes for a limited period',
            ),
          ],
        ),
      ),
    );
  }
}