import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/custom_widgets.dart';
import '../config.dart';
import 'dart:developer' as developer;

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
              backgroundColor: Color(0xFF059669),
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
              backgroundColor: Colors.redAccent,
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
      final uri = Uri.parse('tel:${Config.companyPhone.replaceAll(' ', '')}');
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
      final email = Config.companyEmail.isNotEmpty && Config.companyEmail.contains('@')
          ? Config.companyEmail
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return AppScaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Header
            ClipRRect(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? screenHeight * 0.06 : screenHeight * 0.08,
                  horizontal: screenWidth * 0.04,
                ),
                child: Center(
                  child: Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: isMobile ? 24 : 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.06,
                horizontal: screenWidth * 0.04,
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.95 : 1200),
                child: isMobile
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildForm(context, screenWidth, screenHeight, isMobile, isTablet),
                          const SizedBox(height: 24),
                          _buildContactInfo(context, isMobile),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildForm(context, screenWidth, screenHeight, isMobile, isTablet)),
                          const SizedBox(width: 32),
                          Expanded(child: _buildContactInfo(context, isMobile)),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 32),
            const Footer(),
          ],
        ),
      ),
    );
  }

  // ====================== Contact Info Section ======================
  Widget _buildContactInfo(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: isMobile ? 18 : 20,
                color: const Color(0xFF111827),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        _buildContactInfoCard(
          icon: LucideIcons.mapPin,
          title: 'HQ Office',
          content: 'Kingara Heights, Nairobi, Kenya',
          onTap: () => _openMap('Kingara Heights, Nairobi, Kenya'),
        ),
        const SizedBox(height: 12),

        _buildContactInfoCard(
          icon: LucideIcons.mapPin,
          title: 'Branch Office',
          content: 'Manipur Plaza, Mombasa, Kenya',
          onTap: () => _openMap('Manipur Plaza, Mombasa, Kenya'),
        ),
        const SizedBox(height: 12),

        _buildContactInfoCard(
          icon: LucideIcons.phone,
          title: 'Phone',
          content: Config.companyPhone,
          onTap: _launchPhone,
        ),
        const SizedBox(height: 12),

        _buildContactInfoCard(
          icon: LucideIcons.mail,
          title: 'Email',
          content: Config.companyEmail,
          onTap: _launchEmail,
        ),
        const SizedBox(height: 32),

        Text(
          'Follow Us',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 14 : 16,
                color: const Color(0xFF111827),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 16,
          children: [
            _buildSocialButton(icon: LucideIcons.linkedin, onTap: () => _launchURL(Config.linkedinUrl)),
            _buildSocialButton(icon: LucideIcons.instagram, onTap: () => _launchURL(Config.instagramUrl)),
          ],
        ),
      ],
    );
  }

  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(LucideIcons.externalLink, size: 16, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildForm(BuildContext context, double screenWidth, double screenHeight, bool isMobile, bool isTablet) {
    return Card(
      elevation: 4,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.03,
          horizontal: screenWidth * 0.03,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send us a message',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: isMobile ? 18 : 20,
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: screenHeight * 0.03),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
              ),
              SizedBox(height: screenHeight * 0.02),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email address';
                  if (!value.contains('@')) return 'Please enter a valid email address';
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
              ),
              SizedBox(height: screenHeight * 0.02),

              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Enter the subject',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a subject' : null,
              ),
              SizedBox(height: screenHeight * 0.02),

              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Enter your message',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your message' : null,
              ),
              SizedBox(height: screenHeight * 0.03),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _isSubmitting ? 'Sending...' : 'Send Message',
                  onPressed: _isSubmitting ? () {} : _submitForm,
                  isLarge: true,
                ),
              ),
            ],
          ),
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