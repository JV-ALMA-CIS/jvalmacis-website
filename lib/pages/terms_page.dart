import 'package:flutter/material.dart';

import '../widgets/legal_document.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      route: '/terms',
      title: 'Terms and Conditions',
      meta: 'Last updated 10 July 2026 · Version 1.0',
      summary: 'The terms that apply when you use the JV ALMA C.I.S website and our '
          'applications: Kilimo Mkononi, CoffeeCore and NyumbaSmart.',
      sections: _sections,
    );
  }
}

const _sections = <LegalSection>[
  LegalSection('Introduction', [
    LegalText(
      'These Terms and Conditions ("Terms") govern your access to and use of the '
      'JV ALMA C.I.S website (jvalmacis.com) and mobile applications (Kilimo Mkononi, '
      'CoffeeCore, NyumbaSmart), operated by JV ALMA C.I.S ("JV", "we", "us", "our"), '
      'a company established in 2017 and registered in Kenya.\n\n'
      'By accessing or using our website or applications, you agree to be bound by '
      'these Terms. If you do not agree, please do not use our platforms.',
    ),
  ]),
  LegalSection('About JV ALMA C.I.S', [
    LegalText('JV ALMA C.I.S is a multi-sector company operating across four business units:'),
    LegalList([
      'Construction: Facility remodeling, renovation, landscaping, and civil works.',
      'Oil & Gas Services: Technical services for the energy sector.',
      'Agribusiness: Agricultural training, market connectivity, and field management through Kilimo Mkononi and partnerships with KALRO and Moi University.',
      'IT Division: Software products including Kilimo Mkononi (Enterprise & Education), CoffeeCore, NyumbaSmart CMMS, and AlmaWorks.',
    ]),
  ]),
  LegalSection('Who May Use Our Platforms', [
    LegalList(heading: 'Website (jvalmacis.com)', [
      'Any individual may browse the website for informational purposes.',
      'Users must be 18 or older to submit contact forms, career applications, or newsletter sign-ups.',
    ]),
    LegalList(heading: 'Kilimo Mkononi Enterprise', [
      'Any individual aged 18 and above may register to access farming tools, market data, and weather features.',
    ]),
    LegalList(heading: 'Kilimo Mkononi Education', [
      'Students may only access the app under the supervision and explicit approval of a registered Teacher at a registered institution.',
      'Students under 18 are considered minor users and are subject to additional data protections.',
      'Teachers must be registered and approved by the Head Teacher of a registered institution.',
      'Head Teachers are responsible for approving Teachers and for the proper use of the app within their institution.',
    ]),
    LegalList(heading: 'CoffeeCore', [
      'Open to registered cooperative members and administrators aged 18 and above.',
    ]),
    LegalList(heading: 'NyumbaSmart', [
      'Open to registered facility managers, clients, and administrators aged 18 and above.',
    ]),
  ]),
  LegalSection('Account Registration', [
    LegalList([
      'You must provide accurate, complete, and current information at registration on all platforms.',
      'You are responsible for maintaining the confidentiality of your login credentials. Do not share your password.',
      'Notify us immediately at support@jvalmacis.co.ke if you suspect unauthorised access to your account.',
      'JV reserves the right to suspend or terminate accounts that provide false information or violate these Terms.',
    ]),
  ]),
  LegalSection('Permitted and Prohibited Conduct', [
    LegalList(heading: 'Permitted use', [
      'Our platforms are provided for personal and professional use appropriate to your registered role.',
      'You may access and use features available within your registered platform and role.',
    ]),
    LegalList(heading: 'You must not', [
      'Use any platform for unlawful purposes.',
      "Attempt to access another user's account, data, or features beyond your assigned role.",
      'Upload false, misleading, or harmful information.',
      "Attempt to reverse-engineer, copy, distribute, or exploit any platform's source code.",
      'Use the platforms to send unsolicited communications or spam.',
      'Attempt to bypass, circumvent, or disable any security control.',
      'Allow a minor student to create a Kilimo Mkononi Education account independently, without Teacher and Head Teacher approval.',
      "Access any platform using someone else's credentials.",
      'Scrape, data-mine, or harvest information from any platform by automated means.',
    ]),
  ]),
  LegalSection('Kilimo Mkononi Education: Institutional Obligations', [
    LegalText(
      'By registering their institution on the Education Module, the Head Teacher and the '
      'institution agree to:',
    ),
    LegalList([
      'Ensure all student accounts are for genuine enrolled students only.',
      'Obtain written parental or guardian consent for each minor student before creating their account.',
      'Notify JV immediately if a student leaves the institution so the account can be deactivated.',
      "Report any concern, complaint, or incident relating to a minor user's safety or data to JV immediately at support@jvalmacis.co.ke.",
      'Ensure no direct communication is facilitated between minor students and adult users outside the defined teacher-student class structure.',
    ]),
  ]),
  LegalSection('Content and Information Accuracy', [
    LegalText(
      'Farming tips, market prices, weather data, pest and disease information, '
      'construction project details, and other content provided on our platforms are '
      'for informational and educational purposes only.',
    ),
    LegalNote(
      'JV does not guarantee the accuracy, completeness, or timeliness of any content provided '
      'on our platforms. Users should exercise independent judgement before making business, '
      'farming, or construction decisions based on platform content. JV is not liable for any '
      'agricultural, financial, or commercial loss resulting from reliance on platform information.',
    ),
  ]),
  LegalSection('Partner Content (KALRO & Moi University)', [
    LegalText(
      'Certain agronomic content within Kilimo Mkononi is developed in collaboration with '
      'KALRO and Moi University under formal agreements. Such content is provided for '
      'educational purposes only and is the intellectual property of the respective partners. '
      'You may not reproduce or commercially exploit partner content outside the app.',
    ),
  ]),
  LegalSection('Intellectual Property', [
    LegalText(
      'All content, software, design, trademarks, and data on our website and applications '
      'are the intellectual property of JV ALMA C.I.S or its licensed partners. All rights '
      'reserved. You may not reproduce, distribute, modify, or create derivative works from '
      'any platform content without prior written permission from JV. Our platforms are '
      'licensed to you for personal or professional use only; they are not sold to you.',
    ),
  ]),
  LegalSection('Service Availability', [
    LegalText(
      'JV targets high platform availability but does not guarantee uninterrupted service. '
      'Platforms may be temporarily unavailable due to:',
    ),
    LegalList([
      'Planned maintenance (notified via in-app message or website notice at least 24 hours in advance).',
      'Google Firebase or third-party infrastructure issues.',
      'Network outages or force majeure events.',
      'Emergency security updates.',
    ]),
    LegalText(
        'JV is not liable for any loss or inconvenience arising from platform unavailability.'),
  ]),
  LegalSection('Third-Party Services', [
    LegalText('Our platforms rely on third-party services including:'),
    LegalList([
      'Google Firebase (Google LLC): database, authentication, storage, and hosting.',
      'OpenWeather API: weather forecast data for Kilimo Mkononi.',
      'KALRO and Moi University: agricultural content partners.',
    ]),
    LegalText(
      'JV is not responsible for any data loss, outage, or security incident caused by these '
      'third-party services.',
    ),
  ]),
  LegalSection('Privacy', [
    LegalText(
      'Your use of our platforms is governed by our Privacy Policy, accessible at '
      'jvalmacis.com/privacy-policy. By using our platforms, you consent to data collection '
      'and processing as described in that policy.',
    ),
  ]),
  LegalSection('Limitation of Liability', [
    LegalText(
        'To the fullest extent permitted by Kenyan law, JV ALMA C.I.S shall not be liable for:'),
    LegalList([
      'Any indirect, incidental, special, or consequential loss arising from use of our platforms.',
      'Agricultural, financial, or commercial loss arising from reliance on platform content.',
      "Loss of data due to infrastructure outages beyond JV's reasonable control.",
      "Unauthorised access caused by a user's breach of these Terms (e.g. sharing credentials).",
    ]),
    LegalText(
      "JV's total aggregate liability for any claim shall not exceed the amount (if any) paid by "
      'you for the relevant platform in the twelve months preceding the claim.',
    ),
  ]),
  LegalSection('Termination', [
    LegalText('JV reserves the right to suspend or permanently terminate your access if you:'),
    LegalList([
      'Violate any of these Terms.',
      'Provide false registration information.',
      'Engage in conduct harmful to other users, the platform, or the integrity of its data.',
      'Breach the minor user protection requirements for Kilimo Mkononi Education.',
    ]),
    LegalText(
      'Upon termination, your personal data will be handled in accordance with our Privacy Policy. '
      'You may request deletion of your account at any time by contacting support@jvalmacis.co.ke.',
    ),
  ]),
  LegalSection('Governing Law', [
    LegalText(
      'These Terms are governed by and construed in accordance with the laws of Kenya. '
      'Any dispute arising from or relating to these Terms shall be subject to the exclusive '
      'jurisdiction of the Kenyan courts.',
    ),
  ]),
  LegalSection('Changes to These Terms', [
    LegalText(
      'JV may update these Terms from time to time. We will notify users of material changes '
      'via in-app notification and/or a prominent notice on this website at least 14 days '
      'before the change takes effect. Continued use of our platforms after the effective '
      'date constitutes your acceptance of the revised Terms.',
    ),
  ]),
  LegalSection('Contact Us', [
    LegalText('For questions about these Terms or to exercise your rights:'),
    LegalDetails(legalContactRows),
  ]),
];
