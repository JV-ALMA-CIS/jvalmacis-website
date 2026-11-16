/// Construction portfolio: the single source for the Construction page
/// carousel and each project's own page.
///
/// To add a project, append it to [constructionProjects] with a unique slug;
/// its page, route and tab title follow automatically. Remember the new URL
/// in `web/index.html` (PAGES) and `web/sitemap.xml`.
library;

import '../portfolio/portfolio_project.dart';

export '../portfolio/portfolio_project.dart';

/// Route of the Construction & Facility Management page.
const constructionRoute = '/construction-detail';

/// Construction projects use the shared portfolio model.
typedef ConstructionProject = PortfolioProject;

const constructionPortfolio = Portfolio(
  route: constructionRoute,
  unit: 'Construction',
  projects: constructionProjects,
);

const _dir = 'assets/images/construction';
const _navfacLogo = 'assets/images/clients/navfac.jpg';

const constructionProjects = <PortfolioProject>[
  PortfolioProject(
    section: constructionRoute,
    slug: 'american-center',
    title: 'United States Embassy – American Center Renov, Nairobi.',
    client: 'Embassy of United States in Kenya',
    period: 'Sep 2021 – May 2022',
    description:
        'Comprehensive renovation and interior redesign of the ground floor of the Embassy of '
        'the United States in Kenya, transforming it into a modern, multifunctional space. The '
        'scope included reconfiguration of key areas such as the Maker Lab, Education USA '
        'Workroom, Main Program Space, and Staff Offices.',
    images: [
      ProjectImage('$_dir/american_center_1.jpg'),
      ProjectImage('$_dir/american_center_2.jpg'),
      ProjectImage('$_dir/american_center_3.jpg'),
    ],
    // The opening photograph; the other two are design renderings.
    coverIndex: 2,
    testimonial: ProjectTestimonial(
      'Our team delivered an innovative and adaptable space that reflects American values '
          'while embracing local culture—a seamless fusion of design and function.',
      'Piergiorgio Di Carmine JV ALMA C.I.S.',
    ),
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'rosslyn-ridge',
    title: 'United States Embassy – Rosslyn Ridge Renov, Nairobi.',
    client: 'Embassy of United States, Nairobi',
    period: 'Sep 2019 – Ongoing',
    description: 'Multi-phase renovation across more than 50 residential single units including '
        'structural upgrades and modern exterior finishes for long-term resilience and '
        'performance.',
    images: [
      ProjectImage('$_dir/rosslyn_ridge_1.jpg'),
      ProjectImage('$_dir/rosslyn_ridge_2.jpg'),
      ProjectImage('$_dir/rosslyn_ridge_3.jpg'),
    ],
    // One of the residences; the first photograph has a white border.
    coverIndex: 1,
    testimonial: ProjectTestimonial(
      'JV ALMA C.I.S. performed reliably and professionally, meeting all regulatory standards '
          'and delivering a high-quality result we would trust again.',
      'Wencke Jacobsen, Contract Specialist, RPSO Frankfurt (PHASE 2)',
    ),
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'lonetree-compound',
    title: 'United States Embassy Residential Renovation – Lonetree Compound, Nairobi.',
    client: 'United States Embassy',
    period: 'Ongoing',
    description: 'Residential renovation at the Lonetree compound for the United States Embassy.',
    images: [
      ProjectImage('$_dir/lonetree1.jpg'),
      ProjectImage('$_dir/lonetree2.jpg'),
    ],
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'medical-research-unit-kisumu',
    title: 'United States – Medical Research Unit Renov, Kisumu.',
    client: 'NAVFAC',
    clientLogo: _navfacLogo,
    period: 'Sep 2018 – Mar 2021',
    description: 'Comprehensive renovation of a medical research facility including removal of the '
        'existing roof structure and upgrade of electrical and mechanical systems under '
        'challenging pandemic conditions.',
    images: [ProjectImage('$_dir/medical_research_1.jpg')],
    testimonial: ProjectTestimonial(
      'The contractor exceeded expectations during an extremely challenging period, delivering '
          'consistent quality and strong coordination.',
      'Brian Tiu, NAVFAC EURAFCENT',
    ),
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'mtongwe-naval-base',
    title: 'NAVFAC – Construction of new facilities for the Kenya Navy – Mtongwe Naval Base, Mombasa.',
    client: 'NAVFAC',
    clientLogo: _navfacLogo,
    period: 'Sep 2026 – Ongoing',
    description:
        'Construction of new facilities within the Kenya Navy base, Mtongwe Naval Base, Mombasa, '
        'Kenya.',
    images: [ProjectImage('$_dir/navy_1.jpg')],
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'italian-ambassadors-residence',
    title: "Italian Ambassador's Residence Renov, Nairobi.",
    client: 'Italian Embassy Nairobi',
    period: 'March 2025 – October 2026',
    description:
        "Comprehensive renovation of the Italian Ambassador's Residence in Karura Close, with a "
        'strong focus on modernizing and optimizing building systems for energy efficiency.',
    images: [
      // The residence; a sharper copy of the earlier italian_embassy.jpg.
      ProjectImage('$_dir/italy_6.jpg'),
      ProjectImage('$_dir/italy_1.jpg'),
      ProjectImage('$_dir/italy_2.jpg'),
      ProjectImage('$_dir/italy_3.jpg'),
      ProjectImage('$_dir/italy_4.jpg'),
      ProjectImage('$_dir/italy_5.jpg'),
    ],
    testimonial: ProjectTestimonial(
      'JV ALMA C.I.S provided a detailed and professional assessment, they are setting a clear '
          "path for renovation tailored to the building's age and structural needs.",
      'Paolo Rotilli',
    ),
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'portuguese-embassy',
    title: 'Portuguese Embassy Renov, Nairobi.',
    client: 'Embassy of Portugal',
    period: 'Mar 2025 – Aug 2025',
    description:
        'Adaptive renovation to transform an existing structure into a modern consular section '
        'for the Portuguese Embassy. The project involves full conversion of former spaces into '
        'biometric enrollment, visa production, and reception offices.',
    images: [
      ProjectImage('$_dir/portugese_embassy.jpg'),
      ProjectImage('$_dir/portugese_embassy_1.jpg'),
      ProjectImage('$_dir/portugese_embassy_2.jpg'),
      ProjectImage('$_dir/portugese_embassy_3.jpg'),
    ],
    // The sharpest photograph.
    coverIndex: 2,
    testimonial: ProjectTestimonial(
      'Thank you for all the thorough documentation and the great partnership throughout. Your '
          'support and professionalism have been truly appreciated, and it’s been a pleasure '
          'working with you.',
      'Miguel Antonio Luis',
    ),
  ),
  PortfolioProject(
    section: constructionRoute,
    slug: 'swedish-ambassadors-residence',
    title: "Swedish Ambassador's Residence Renov, Nairobi.",
    client: 'Embassy of Sweden',
    period: 'May 2025 – October 2025',
    description:
        'Overhaul of the electrical systems at the Swedish Ambassador’s residence, including '
        'upgrades to key electrical infrastructure to enhance system performance, improve energy '
        'efficiency, and ensure the reliability of the residence’s electrical operations.',
    images: [
      ProjectImage('$_dir/swedish_embassy.jpg', isLogo: true),
    ],
  ),
];

/// A firm JV ALMA C.I.S has worked with on construction projects.
class ConstructionPartner {
  const ConstructionPartner(this.name, {this.logo});

  /// Shown when there is no logo, and read out by screen readers.
  final String name;

  /// Logo in `assets/icons/construction/`; until one is set the name is shown.
  final String? logo;
}

const _logos = 'assets/icons/construction';

/// Names follow the firms' own logos.
const constructionPartners = <ConstructionPartner>[
  ConstructionPartner('Trident Plumbers', logo: '$_logos/trident.jpg'),
  ConstructionPartner('Central Electricals', logo: '$_logos/central.jpg'),
  ConstructionPartner('Velka Engineering', logo: '$_logos/velka.jpg'),
  ConstructionPartner('Renocon', logo: '$_logos/renocon.jpg'),
  ConstructionPartner('Almar Containers', logo: '$_logos/almar.jpg'),
  ConstructionPartner('Sidland Constructions', logo: '$_logos/sidland.jpg'),
  ConstructionPartner('ASL', logo: '$_logos/asl.jpg'),
  ConstructionPartner('Kitchens & Beyond', logo: '$_logos/kitchens.jpg'),
  ConstructionPartner('Snaidero', logo: '$_logos/snaidero.jpg'),
];

/// The project whose page lives at [route], if any.
PortfolioProject? constructionProjectForRoute(String? route) =>
    constructionPortfolio.projectAt(route);
