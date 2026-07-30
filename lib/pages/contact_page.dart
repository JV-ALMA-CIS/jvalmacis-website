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
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/section.dart';
import '../widgets/hoverable.dart';
import '../widgets/brand_icons.dart';

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
  bool _isSubmitting = false;

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
          'subject': _subjectController.text.trim(),
          'message': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'new',
        };

        await FirebaseFirestore.instance.collection('contacts').add(contactData);

        // 2. Trigger email notification via firestore-send-email extension
        final emailSubject = 'New Contact Inquiry: ${_subjectController.text.trim()}';

        final emailHtml = '''
          <div style="font-family: Arial, sans-serif; line-height: 1.6; max-width: 600px;">
            <h2 style="color: #0F172A;">New Contact Form Submission</h2>
            <p><strong>Date:</strong> ${DateTime.now().toString()}</p>

            <hr style="border: 1px solid #E2E8F0;">

            <p><strong>Name:</strong> ${_nameController.text.trim()}</p>
            <p><strong>Email:</strong> ${_emailController.text.trim()}</p>
            <p><strong>Phone:</strong> ${_phoneController.text.trim()}</p>
            <p><strong>Subject:</strong> ${_subjectController.text.trim()}</p>

            <h3 style="color: #0F172A; margin-top: 20px;">Message:</h3>
            <p style="white-space: pre-wrap; background-color: #F8FAFC; padding: 12px; border-radius: 6px;">
              ${_messageController.text.trim().replaceAll('\n', '<br>')}
            </p>

            <hr style="border: 1px solid #E2E8F0; margin-top: 20px;">
            <small style="color: #64748B;">
              This message was submitted through the Jvalmacis website contact form.
            </small>
          </div>
        ''';

        await FirebaseFirestore.instance.collection('mail').add({
          'to': [
            'hr@jvalmacis.co.ke',        // ← CHANGE TO HR'S ACTUAL EMAIL
            'info@jvalmacis.co.ke',      // ← Add your company email here
          ],
          'message': {
            'subject': emailSubject,
            'html': emailHtml,
          },
          'replyTo': _emailController.text.trim(), // Allows HR to reply directly
        });

        // Success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message sent successfully! We will get back to you soon.'),
              backgroundColor: Palette.success,
            ),
          );

          // Clear form fields
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _subjectController.clear();
          _messageController.clear();
        }
      } catch (e) {
        developer.log('ContactPage: Form submission error: $e', name: 'ContactPage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message. Please try again later.'),
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

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(siteSettingsProvider).valueOrNull ?? defaultSiteSettings;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Palette.heroSurface),
              padding: Space.sectionPad(isMobile),
              child: Center(
                child: Text(
                  'Contact Us',
                  style: (isMobile
                          ? Theme.of(context).textTheme.headlineLarge
                          : Theme.of(context).textTheme.displaySmall)
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Main Content
            SectionWrapper(
              background: Palette.n0,
              child: isMobile
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildForm(context, isMobile),
                        const SizedBox(height: Space.lg),
                        _buildContactInfo(context, isMobile, settings),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildForm(context, isMobile)),
                        const SizedBox(width: Space.xl),
                        Expanded(child: _buildContactInfo(context, isMobile, settings)),
                      ],
                    ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }

  // ====================== Contact Info Section ======================
  Widget _buildContactInfo(BuildContext context, bool isMobile, SiteSettings settings) {
    final offices = List<OfficeLocation>.of(settings.officeLocations)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: Space.md),

        for (final office in offices) ...[
          _buildContactInfoCard(
            context,
            icon: LucideIcons.mapPin,
            title: office.label,
            content: office.address,
            onTap: () => _openMap(office.mapQuery),
          ),
          const SizedBox(height: Space.sm),
        ],

        _buildContactInfoCard(
          context,
          icon: LucideIcons.phone,
          title: 'Phone',
          content: settings.companyPhone,
          onTap: _launchPhone,
        ),
        const SizedBox(height: Space.sm),

        _buildContactInfoCard(
          context,
          icon: LucideIcons.mail,
          title: 'Email',
          content: settings.companyEmail,
          onTap: _launchEmail,
        ),
        const SizedBox(height: Space.xl),

        Text(
          'Follow Us',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Space.sm),

        Wrap(
          spacing: Space.md,
          children: [
            _buildSocialButton(icon: BrandIcons.linkedin, onTap: () => _launchURL(settings.linkedinUrl)),
            _buildSocialButton(icon: BrandIcons.instagram, onTap: () => _launchURL(settings.instagramUrl)),
          ],
        ),
      ],
    );
  }

  Widget _buildContactInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback? onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Space.md),
      child: Row(
        children: [
          IconChip(icon: icon, color: Palette.ink, size: 20),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Palette.n500),
                ),
                const SizedBox(height: Space.xxs),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(LucideIcons.externalLink, size: 16, color: Palette.n500),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Hoverable(
      onTap: onTap,
      builder: (hovered) => AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.hover,
        padding: const EdgeInsets.all(Space.sm),
        decoration: BoxDecoration(
          color: hovered ? Palette.primaryHover : Palette.ink,
          borderRadius: Radii.chip,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isMobile) {
    return AppCard(
      interactive: false,
      padding: EdgeInsets.all(isMobile ? Space.lg : Space.xl),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send us a message',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Space.xl),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
            ),
            const SizedBox(height: Space.md),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter your email address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your email address';
                if (!value.contains('@')) return 'Please enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: Space.md),

            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
            ),
            const SizedBox(height: Space.md),

            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'Enter the subject',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a subject' : null,
            ),
            const SizedBox(height: Space.md),

            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Enter your message',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                contentPadding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter your message' : null,
            ),
            const SizedBox(height: Space.xl),

            PrimaryButton(
              text: _isSubmitting ? 'Sending...' : 'Send Message',
              onPressed: _isSubmitting ? () {} : _submitForm,
              loading: _isSubmitting,
              large: true,
              expand: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    _launchURL(googleUrl);
  }
}
