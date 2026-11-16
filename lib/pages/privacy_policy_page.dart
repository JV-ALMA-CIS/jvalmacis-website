import 'package:flutter/material.dart';

import '../widgets/legal_document.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      route: '/privacy-policy',
      title: 'Privacy Policy',
      meta: 'Last updated 10 July 2026',
      summary: 'How JV ALMA C.I.S collects, uses, shares and protects personal data across '
          'our website, our applications and our business units, and the rights you have '
          'under the Kenya Data Protection Act, 2019.',
      sections: _sections,
    );
  }
}

const _sections = <LegalSection>[
  LegalSection('About This Notice', [
    LegalText(
      'This Privacy Policy explains how JV ALMA C.I.S ("JV", "we", "us", "our"), '
      'established in 2017 and registered in Kenya, collects and processes your '
      'personal data when you interact with our website (jvalmacis.com), mobile '
      'applications (Kilimo Mkononi, CoffeeCore, NyumbaSmart), or engage with our '
      'services across our Construction, Oil & Gas Services, Agribusiness, and '
      'IT Division business units.\n\n'
      'JV is the Data Controller for all personal data collected through these '
      'platforms, in accordance with the Kenya Data Protection Act, 2019 (DPA).',
    ),
    LegalNote(
      'JOINT VENTURE ALMA C.I.S S.C.A.R.L is additionally registered as a Data Processor '
      'with the Office of the Data Protection Commissioner (ODPC) of Kenya '
      '(Identification No. 529-4780-F76F, Certificate Serial No. 19082), '
      'valid from 10 March 2026 to 10 March 2028, in compliance with the Kenya Data '
      'Protection Act, 2019.',
    ),
    LegalText('Data Controller contact: support@jvalmacis.co.ke'),
  ]),
  LegalSection('The Data We Collect About You', [
    LegalText(
      'We collect personal data to deliver and improve our services. The types of data we '
      'collect include:',
    ),
    LegalList(heading: 'Information you provide to us', [
      'Kilimo Mkononi (Enterprise & Education): Full name, email, county, constituency, ward, phone number, farming type, primary crops, and password for registration and login. Education users additionally provide school name, class/grade, and role (student, teacher, head teacher).',
      'CoffeeCore: Full name, email, county, constituency, ward, phone number, password, and cooperative information.',
      'NyumbaSmart: Username, email, password, and facility information (e.g. facility name and location).',
      'Website: Email for newsletter sign-ups; full name, email, phone number, and relevant details for careers applications and contact form submissions.',
      'Additional data such as identity data, contact data, billing information, or project-specific details provided during service requests.',
    ]),
    LegalList(heading: 'Information on your use of our platforms', [
      'We automatically collect data about your interactions, including searches, views, downloads, project submissions, and app usage across Kilimo Mkononi, CoffeeCore, and NyumbaSmart.',
      'Mobile apps: We may collect approximate location data and device information (e.g. unique device identifiers) to provide location-based services such as agricultural insights, facility management updates, or weather forecasts. You can disable location services in your device settings at any time.',
    ]),
    LegalList(heading: 'Information from third parties and public sources', [
      'We may receive data from partners (e.g. KALRO, Moi University), service providers, or public sources related to our construction, agribusiness, or oil and gas services.',
    ]),
  ]),
  LegalSection('What About Cookies?', [
    LegalText(
      'Cookies are small files of letters and numbers placed on your device with your consent. '
      'They help us distinguish you from other users, improving your experience on our website '
      'and apps. For more information, see our Cookies Policy at jvalmacis.com/cookies.',
    ),
  ]),
  LegalSection('The Ask ALMA Assistant', [
    LegalText(
      'Our website includes Ask ALMA, an AI assistant that answers questions about JV ALMA C.I.S '
      'and its services. When you use it:',
    ),
    LegalList([
      "Your question and the earlier messages of the same conversation are sent to Google's Gemini service, which generates the reply. Google processes these messages under its own terms.",
      'We do not store the content of your conversations. Our server records only the length of each message, not what it says.',
      'To prevent abuse, we keep a one-way scrambled (hashed) form of your IP address for a short period to limit how many questions can be sent.',
    ]),
    LegalText(
      'Please do not share sensitive personal information in the chat. AI-generated answers can be '
      'wrong; for anything important, contact us directly.',
    ),
  ]),
  LegalSection('How We Use Your Personal Data', [
    LegalText(
      'We use your personal data to operate, provide, develop, and improve our offerings, including:',
    ),
    LegalList([
      'Registering and managing user accounts for Kilimo Mkononi, CoffeeCore, and NyumbaSmart.',
      'Processing and fulfilling project requests, service orders, or software subscriptions.',
      'Managing client and partner relationships, including customer support, project updates, and career application processing.',
      'Enabling participation in agribusiness training, community infrastructure projects, or software trials.',
      'Managing newsletter subscriptions and delivering tailored communications.',
      'Improving our website, apps, and services across all business units.',
      'Recommending relevant services or products, such as facility management tools or agricultural solutions.',
      'Complying with legal obligations, including identity verification for contracts or partnerships.',
      'Detecting fraud or misuse of our services.',
    ]),
    LegalNote(
      'We do not use your data for third-party advertising or profiling unrelated to JV ALMA C.I.S '
      'services. We do not sell or rent your personal data to any third party.',
    ),
  ]),
  LegalSection('How We Share Your Personal Data', [
    LegalText('We may share your personal data with third parties for the following purposes:'),
    LegalList([
      'Service delivery: To provide services in Construction, Oil & Gas Services, Agribusiness (e.g. training with KALRO or Moi University), or IT Division, we may share data with partners or subcontractors.',
      'Third-party service providers: We engage third parties for functions like project logistics, data analysis, marketing, or customer support.',
      'Fraud prevention and legal compliance: We may share data with organisations to prevent fraud, manage risks, or comply with Kenyan law or court orders.',
      'Kenyan authorities: Including the Office of the Data Protection Commissioner (ODPC) where required by law.',
    ]),
    LegalText(
      'When sharing data, we require third parties to use your data only for specified purposes, '
      'per our instructions, and in accordance with this Privacy Policy and applicable law.',
    ),
  ]),
  LegalSection('International Transfers', [
    LegalText(
      'We may transfer your personal data to locations in another country where permissible under '
      'applicable laws. We implement appropriate safeguards to protect your data and respect your '
      'legal rights in accordance with this notice and local regulations.',
    ),
  ]),
  LegalSection('Data Security', [
    LegalText(
      'We maintain appropriate technical and organisational security measures to prevent your '
      'personal data from being accidentally lost, used, accessed, altered, or disclosed without '
      'authorisation. Measures include:',
    ),
    LegalList([
      'AES-256 encryption at rest and TLS 1.2+ encryption in transit for all stored and transmitted data.',
      'Role-based access controls restricting data access to authorised personnel only.',
      'Multi-factor authentication (MFA) for administrator accounts.',
      'Automated alerts for anomalous activity or repeated authentication failures.',
      'Regular security reviews of our platforms and third-party integrations.',
    ]),
    LegalText(
      'We have procedures to address suspected data breaches and will notify you and any '
      'applicable regulator as required by law. If you believe your account has been '
      'compromised, contact us immediately at support@jvalmacis.co.ke.',
    ),
  ]),
  LegalSection("Children's Privacy", [
    LegalText(
      'The Kilimo Mkononi Education Module is accessible to students who may be under 18. '
      'For minor users we apply the highest level of data protection:',
    ),
    LegalList([
      'We collect minimum data only: name, school-assigned email, school name, and role.',
      'Minor accounts are only created under institutional supervision (Head Teacher, then Teacher, then Student). No minor may self-register.',
      "No minor's personal phone number, home address, or photograph is collected.",
      'Minor user data is never shared with third parties for marketing or profiling.',
      "A parent or legal guardian may request access to, correction of, or deletion of their child's data at any time: infojvalmacis@gmail.com",
    ]),
    LegalText(
      'Our general website and other apps (CoffeeCore, NyumbaSmart) are not directed at children '
      'under 18.',
    ),
  ]),
  LegalSection('Your Legal Rights', [
    LegalText(
      'Under the Kenya Data Protection Act, 2019 and other applicable laws, you may have rights to:',
    ),
    LegalList([
      'Access a copy of the personal data we hold about you.',
      'Request correction of inaccurate or incomplete data.',
      'Request deletion of your personal data, subject to legal retention obligations.',
      'Object to certain processing, including direct marketing.',
      'Withdraw consent at any time (e.g. unsubscribe from newsletters).',
      'Lodge a complaint with the ODPC at info@odpc.go.ke or www.odpc.go.ke.',
    ]),
    LegalText(
      'To exercise any right, contact us at support@jvalmacis.co.ke. We will respond within 21 days.',
    ),
  ]),
  LegalSection('Changes to This Policy', [
    LegalText(
      'We may update this Privacy Policy from time to time to reflect changes in our practices, '
      'technology, or legal requirements. We will notify you of material changes by posting the '
      'updated policy on this page and updating the "Last updated" date.',
    ),
  ]),
  LegalSection('Contact Us', [
    LegalText('For questions, data requests, or to exercise your rights:'),
    LegalDetails(legalContactRows),
    LegalText(
      'Office of the Data Protection Commissioner (ODPC): info@odpc.go.ke or www.odpc.go.ke',
    ),
  ]),
];
