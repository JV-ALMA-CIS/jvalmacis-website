/// Oil & Gas Services content: the services, the partnership with Brisma
/// Africa and TIC East Africa, and the TIC Group network.
///
/// JV ALMA C.I.S works in partnership with Brisma Africa and TIC East
/// Africa; do not describe the relationship as a shareholding. Certifications
/// and references shown here are the TIC Group's, and are labelled as such.
library;

import '../portfolio/portfolio_project.dart';

/// One service, with the paragraphs that describe it.
class OilGasService {
  const OilGasService({required this.title, required this.paragraphs, required this.image});

  final String title;
  final List<String> paragraphs;
  final ProjectImage image;
}

const _tic = 'assets/images/tic';

const oilGasIntro = 'Inspection, integrity and regulatory compliance services for the oil and gas '
    'sector, delivered in partnership with Brisma Africa and TIC East Africa.';

const oilGasServices = <OilGasService>[
  OilGasService(
    title: 'Inspection and Integrity Management',
    paragraphs: [
      "TIC East Africa provides the information and resources needed to support the safety of "
          "customers' activities and products, with a focus on facility integrity and risk "
          'management for the oil and gas industry.',
    ],
    image: ProjectImage('$_tic/tic_3.jpg', caption: 'Inspection team on site'),
  ),
  OilGasService(
    title: 'Non-Destructive Examination',
    paragraphs: [
      'TIC East Africa specializes in non-destructive testing of materials and metal '
          'structures, helping customers characterize the state of integrity of their equipment '
          'without damaging it, during production, use or maintenance.',
      'Its inspectors are certified and qualified to international standards. A wide range of '
          'conventional and advanced control methods helps to control risks and reduce lead '
          'times and costs.',
    ],
    image: ProjectImage('$_tic/tic_4.jpg', caption: 'Non-destructive examination of equipment'),
  ),
  OilGasService(
    title: 'Regulatory Compliance Services',
    paragraphs: [
      'Regulatory auditing and inspection is a service-focused process that goes beyond routine '
          'compliance checks. Its purpose is to identify and address a range of risks that can '
          'directly impact operational safety, integrity, and continuity.',
    ],
    image: ProjectImage('$_tic/tic_5.jpg', caption: 'Regulatory compliance review'),
  ),
];

const oilGasPartnership = [
  'JV ALMA C.I.S works in partnership with Brisma Africa and TIC Group.',
  'TIC East Africa is a company specializing in inspection services, built on the experience '
      'of the TIC Group, a global organization with a presence in multiple countries and a '
      'workforce of over 500 employees, 70% of whom are specialized technicians.',
];

const oilGasPartnershipImage = ProjectImage('$_tic/tic_1.jpg', caption: 'TIC inspector at work');

/// A company in the TIC Group, with its published contact details.
class TicCompany {
  const TicCompany({
    required this.name,
    this.country,
    required this.year,
    this.address,
    this.phone,
    this.email,
  });

  final String name;
  final String? country;
  final String year;
  final String? address;
  final String? phone;
  final String? email;

  /// "Kenya · 2022", or just the year without a country.
  String get origin => country == null ? year : '$country · $year';
}

const ticEastAfrica = TicCompany(
  name: 'TIC East Africa',
  country: 'Kenya',
  year: '2022',
  address: '5th-floor Brisma Towers, Off Magadi 74429-00200 Nairobi, Kenya',
  phone: '+254 72 28 46 458',
  email: 'tic@tic-inspectiongroup.com',
);

const ticEastAfricaLogo = 'assets/images/subsidiaries/TIC-ea.jpg';
const ticGroupLogo = 'assets/images/subsidiaries/TIC-hq.jpg';

/// The group, with the details of its original company in Tunisia.
const ticGroup = TicCompany(
  name: 'TIC Group',
  country: 'Tunisia',
  year: '1993',
  phone: '+216 71 180 140',
  email: 'tic@tic-inspectiongroup.com',
);

/// The TIC Group's own certifications and client references.
const ticGroupCredentials = <ProjectImage>[
  ProjectImage('$_tic/tic_6.jpg', caption: 'TIC Group certifications and qualifications'),
  ProjectImage('$_tic/tic_7.jpg', caption: 'TIC Group references', isLogo: true),
];
