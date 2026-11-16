import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin/modules/site_settings/site_settings_model.dart';
import '../admin/modules/site_settings/site_settings_provider.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import 'dart:developer' as developer;
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/hoverable.dart';
import '../widgets/brand_icons.dart';

/// The four approved business units an enquiry can be directed to.
const businessUnitOptions = ['Construction', 'Agribusiness', 'Oil & Gas Services', 'IT Division'];

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String? _businessUnit;
  bool _isSubmitting = false;

  /// Bumped after a successful submission so the business-unit dropdown is
  /// rebuilt empty (its initial value is only read when it is created).
  int _formGeneration = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Submit contact form - Saves to Firestore and triggers email notification
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // 1. Save the inquiry to the contacts collection
        final contactData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'businessUnit': _businessUnit,
          'subject': _subjectController.text.trim(),
          'message': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'new',
        };

        await FirebaseFirestore.instance.collection('contacts').add(contactData);

        // 2. Trigger email notification via firestore-send-email extension.
        // Visitor input is HTML-escaped before it goes into the email body.
        const esc = HtmlEscape();
        final emailSubject = 'New Contact Inquiry: ${_subjectController.text.trim()}';

        final emailHtml = '''
          <div style="font-family: Arial, sans-serif; line-height: 1.6; max-width: 600px;">
            <h2 style="color: #0F172A;">New Contact Form Submission</h2>
            <p><strong>Date:</strong> ${DateTime.now().toString()}</p>

            <hr style="border: 1px solid #E2E8F0;">

            <p><strong>Name:</strong> ${esc.convert(_nameController.text.trim())}</p>
            <p><strong>Email:</strong> ${esc.convert(_emailController.text.trim())}</p>
            <p><strong>Phone:</strong> ${esc.convert(_phoneController.text.trim())}</p>
            <p><strong>Business unit:</strong> ${esc.convert(_businessUnit ?? 'Not specified')}</p>
            <p><strong>Subject:</strong> ${esc.convert(_subjectController.text.trim())}</p>

            <h3 style="color: #0F172A; margin-top: 20px;">Message:</h3>
            <p style="white-space: pre-wrap; background-color: #F8FAFC; padding: 12px; border-radius: 6px;">
              ${esc.convert(_messageController.text.trim()).replaceAll('\n', '<br>')}
            </p>

            <hr style="border: 1px solid #E2E8F0; margin-top: 20px;">
            <small style="color: #64748B;">
              This message was submitted through the Jvalmacis website contact form.
            </small>
          </div>
        ''';

        await FirebaseFirestore.instance.collection('mail').add({
          'to': [
            'hr@jvalmacis.co.ke', // ← CHANGE TO HR'S ACTUAL EMAIL
            'info@jvalmacis.co.ke', // ← Add your company email here
          ],
          'message': {
            'subject': emailSubject,
            'html': emailHtml,
          },
          'replyTo': _emailController.text.trim(), // Allows HR to reply directly
        });

        // Success feedback. Both writes succeeded, which confirms the
        // enquiry was received — not that the notification email arrived.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Thank you. Your enquiry has been received and our team will be in touch.'),
              backgroundColor: Palette.success,
            ),
          );

          // Clear form fields
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _subjectController.clear();
          _messageController.clear();
          setState(() {
            _businessUnit = null;
            _formGeneration++;
          });
        }
      } catch (e) {
        developer.log('ContactPage: Form submission error: $e', name: 'ContactPage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Your enquiry could not be sent. Please try again, or email us directly.'),
              backgroundColor: Palette.danger,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  // ==================== Existing Helper Methods ====================

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot launch $url')),
        );
      }
    } catch (e) {
      developer.log('ContactPage: URL launch error: $e', name: 'ContactPage');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error launching URL')),
        );
      }
    }
  }

  Future<void> _launchPhone() async {
    try {
      final settings = ref.read(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
      final uri = Uri.parse('tel:${settings.companyPhone.replaceAll(' ', '')}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot launch phone')),
        );
      }
    } catch (e) {
      developer.log('ContactPage: Phone launch error: $e', name: 'ContactPage');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error launching phone')),
        );
      }
    }
  }

  Future<void> _launchEmail() async {
    try {
      final settings = ref.read(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
      final email = settings.companyEmail.isNotEmpty && settings.companyEmail.contains('@')
          ? settings.companyEmail
          : 'support@jvalmacis.co.ke';

      if (email.isEmpty || !email.contains('@')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email address configured')),
          );
        }
        return;
      }

      final uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot launch email')),
        );
      }
    } catch (e) {
      developer.log('ContactPage: Email launch error: $e', name: 'ContactPage');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error launching email')),
        );
      }
    }
  }

  Future<void> _openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    _launchURL(googleUrl);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final gutter = EdgeInsets.symmetric(horizontal: isMobile ? 20 : Space.lg);

    Widget column(Widget child, EdgeInsets padding) => Container(
          width: double.infinity,
          color: Palette.n0,
          padding: padding.add(gutter),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: child,
            ),
          ),
        );

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 01 — Introduction: neutral ground, hierarchy from type alone.
            column(
              const _Intro(),
              EdgeInsets.only(
                top: isMobile ? Space.xxl : Space.section - Space.lg,
                bottom: isMobile ? Space.xl : Space.xxl,
              ),
            ),

            // 02 — Contact details beside the enquiry form; stacked on phones.
            column(
              LayoutBuilder(
                builder: (context, constraints) {
                  final details = _ContactDetails(
                    settings: settings,
                    onEmail: _launchEmail,
                    onPhone: _launchPhone,
                    onMap: _openMap,
                    onLinkedIn: () => _launchURL(settings.linkedinUrl),
                    onInstagram: () => _launchURL(settings.instagramUrl),
                  );
                  final form = _buildForm(context, constraints.maxWidth < 600);

                  if (constraints.maxWidth >= 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inset to the form panel's padding + border so the
                        // two column headings share a baseline.
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: Space.xl + 1),
                            child: details,
                          ),
                        ),
                        const SizedBox(width: Space.xxxl),
                        Expanded(flex: 7, child: form),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [details, const SizedBox(height: Space.xxl), form],
                  );
                },
              ),
              EdgeInsets.only(bottom: isMobile ? Space.xxxl : Space.section),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  // ======================== Enquiry form ========================
  Widget _buildForm(BuildContext context, bool narrow) {
    final text = Theme.of(context).textTheme;

    InputDecoration decoration(String label, {String? hint}) => InputDecoration(
          labelText: label,
          hintText: hint,
          // Labels stay above the field at all times, filled or not; neutral
          // at rest so the focused field is the only one in brand blue.
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
            (states) => text.labelLarge!.copyWith(
              color: states.contains(WidgetState.error)
                  ? Palette.danger
                  : states.contains(WidgetState.focused)
                      ? Palette.primary
                      : Palette.n600,
            ),
          ),
          errorMaxLines: 3,
        );

    final email = TextFormField(
      controller: _emailController,
      decoration: decoration('Email address'),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email address';
        if (!value.contains('@')) return 'Please enter a valid email address';
        return null;
      },
    );

    final phone = TextFormField(
      controller: _phoneController,
      decoration: decoration('Telephone number'),
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      textInputAction: TextInputAction.next,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter your telephone number' : null,
    );

    return Container(
      padding: EdgeInsets.all(narrow ? Space.md : Space.xl),
      decoration: BoxDecoration(
        color: Palette.n0,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: Palette.n200),
      ),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send an enquiry', style: text.headlineMedium),
              const SizedBox(height: Space.xs),
              Text(
                'All fields are required unless marked optional.',
                style: text.bodySmall,
              ),
              const SizedBox(height: Space.xl),

              TextFormField(
                controller: _nameController,
                decoration: decoration('Your name'),
                autofillHints: const [AutofillHints.name],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: Space.lg),

              // Email and telephone share a row when there is room.
              if (narrow) ...[
                email,
                const SizedBox(height: Space.lg),
                phone,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: email),
                    const SizedBox(width: Space.md),
                    Expanded(child: phone),
                  ],
                ),
              const SizedBox(height: Space.lg),

              DropdownButtonFormField<String>(
                key: ValueKey('business-unit-$_formGeneration'),
                initialValue: _businessUnit,
                decoration: decoration('Business unit (optional)', hint: 'Select business unit'),
                isExpanded: true,
                icon: const Icon(LucideIcons.chevronDown, size: 18, color: Palette.n500),
                borderRadius: Radii.button,
                items: [
                  for (final unit in businessUnitOptions)
                    DropdownMenuItem(value: unit, child: Text(unit)),
                ],
                onChanged: (value) => setState(() => _businessUnit = value),
              ),
              const SizedBox(height: Space.lg),

              TextFormField(
                controller: _subjectController,
                decoration: decoration('Subject'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a subject' : null,
              ),
              const SizedBox(height: Space.lg),

              TextFormField(
                controller: _messageController,
                decoration: decoration('Your message', hint: 'Your message…'),
                minLines: 5,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your message' : null,
              ),
              const SizedBox(height: Space.xl),

              PrimaryButton(
                text: _isSubmitting ? 'Submitting…' : 'Submit enquiry',
                icon: LucideIcons.arrowRight,
                onPressed: _isSubmitting ? null : _submitForm,
                loading: _isSubmitting,
                large: true,
                expand: narrow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's discuss your requirements.",
          style: AppType.theme.displayMedium?.copyWith(
            fontSize: AppType.fluid(context, min: 32, max: 46),
          ),
        ),
        const SizedBox(height: Space.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Space.proseMax),
          child: Text(
            'Whether you are exploring a project, seeking a specialised service, or interested in '
            'working with us, contact our team and we will direct your enquiry to the appropriate '
            'business unit.',
            style: AppType.theme.bodyLarge,
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).width < 600 ? Space.xl : Space.xxl),
        const Divider(height: 1, thickness: 1, color: Palette.ink),
      ],
    );
  }
}

/// Email, telephone, offices and social accounts — all from site settings,
/// the same source the footer uses.
class _ContactDetails extends StatelessWidget {
  const _ContactDetails({
    required this.settings,
    required this.onEmail,
    required this.onPhone,
    required this.onMap,
    required this.onLinkedIn,
    required this.onInstagram,
  });

  final SiteSettings settings;
  final VoidCallback onEmail;
  final VoidCallback onPhone;
  final void Function(String query) onMap;
  final VoidCallback onLinkedIn;
  final VoidCallback onInstagram;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final offices = List<OfficeLocation>.of(settings.officeLocations)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact details', style: text.headlineMedium),
        const SizedBox(height: Space.lg),
        _DetailRow(
          icon: LucideIcons.mail,
          label: 'Email',
          value: settings.companyEmail,
          action: 'Email ${settings.companyEmail}',
          onTap: onEmail,
        ),
        _DetailRow(
          icon: LucideIcons.phone,
          label: 'Telephone',
          value: settings.companyPhone,
          action: 'Call ${settings.companyPhone}',
          onTap: onPhone,
        ),
        for (final office in offices)
          _DetailRow(
            icon: LucideIcons.mapPin,
            label: office.label,
            value: office.address,
            action: 'View ${office.label} on Google Maps',
            linkText: 'View on map',
            onTap: () => onMap(office.mapQuery),
          ),
        const SizedBox(height: Space.xl),
        Text('Follow us', style: text.titleMedium),
        const SizedBox(height: Space.sm),
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            SecondaryButton(text: 'LinkedIn', icon: BrandIcons.linkedin, onPressed: onLinkedIn),
            SecondaryButton(text: 'Instagram', icon: BrandIcons.instagram, onPressed: onInstagram),
          ],
        ),
      ],
    );
  }
}

/// Label above a value. The whole row is the link; when [linkText] is set,
/// the value stays plain text and a separate link sits below it.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.action,
    required this.onTap,
    this.linkText,
  });

  final IconData icon;
  final String label;
  final String value;
  final String action;
  final VoidCallback onTap;
  final String? linkText;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.n200)),
      ),
      child: Hoverable(
        onTap: onTap,
        scale: 1.0,
        lift: 0,
        semanticLabel: action,
        builder: (hovered) {
          final link = TextStyle(
            color: Palette.primary,
            decoration: hovered ? TextDecoration.underline : null,
            decorationColor: Palette.primary,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, size: 18, color: Palette.n500),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label.toUpperCase(), style: AppType.eyebrow(Palette.n500)),
                      const SizedBox(height: Space.xs),
                      Text(
                        value,
                        style: linkText == null
                            ? text.titleMedium?.merge(link)
                            : text.bodyMedium?.copyWith(color: Palette.ink),
                      ),
                      if (linkText != null) ...[
                        const SizedBox(height: Space.xxs),
                        Text(linkText!, style: text.labelLarge?.merge(link)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
