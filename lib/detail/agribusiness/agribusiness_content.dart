/// Agribusiness content: the project portfolio, the institutions the
/// division works with, and its digital platforms. The single source for
/// the Agribusiness page and each project's own page.
///
/// To add a project, append it to [agribusinessProjects] with a unique
/// slug; its page, route and tab title follow automatically. Remember the
/// new URL in `web/index.html` (PAGES) and `web/sitemap.xml`.
library;

import '../portfolio/portfolio_project.dart';

export '../portfolio/portfolio_project.dart';

/// Route of the Agribusiness page.
const agribusinessRoute = '/agribusiness';

const agribusinessPortfolio = Portfolio(
  route: agribusinessRoute,
  unit: 'Agribusiness',
  projects: agribusinessProjects,
);

const _dir = 'assets/images/agribusiness';

const agribusinessProjects = <PortfolioProject>[
  PortfolioProject(
    section: agribusinessRoute,
    slug: 'sigor-wei-wei',
    title: 'Sigor Wei Wei Integrated Irrigation Scheme',
    client: 'Kerio Valley Development Authority (KVDA)',
    funder: 'Italian Agency for Development Cooperation (AICS)',
    location: 'West Pokot, Kenya',
    period: 'June 2017 – July 2020',
    description:
        'Between June 2017 and July 2020, JV ALMA C.I.S carried out the major civil works for the '
        'Sigor Wei Wei Integrated Irrigation Scheme, a large-scale scheme in a remote part of '
        'West Pokot, for the Kerio Valley Development Authority (KVDA) with funding from the '
        'Italian Agency for Development Cooperation (AICS).\n\n'
        'The project was launched by former President Uhuru Kenyatta.\n\n'
        'The project covered three areas:',
    focusAreas: [
      ProjectFocusArea('New irrigation', 'Installing pipelines to irrigate over 325 hectares.'),
      ProjectFocusArea(
        'Rehabilitation',
        'Bush clearing and refurbishment of 290 hectares of existing irrigation systems.',
      ),
      ProjectFocusArea(
        'Supporting facilities',
        'Construction of warehouses and support facilities for the scheme.',
      ),
    ],
    closing: 'In total, the works covered more than 600 hectares of new and refurbished '
        'irrigation.',
    images: [
      ProjectImage(
        '$_dir/sigor_1.jpg',
        caption: 'Former President Uhuru Kenyatta during the launch of the project',
      ),
      ProjectImage('$_dir/sigor_2.jpg'),
      ProjectImage('$_dir/sigor1.jpeg'),
      ProjectImage('$_dir/sigor2.jpeg'),
      ProjectImage('$_dir/sigor3.jpeg'),
    ],
    testimonial: ProjectTestimonial(
      "JV ALMA C.I.S. delivered extensive infrastructure in a complex rural setting, "
          "significantly boosting the region's agricultural productivity.",
      'Eng. Daniel Kimutai, KVDA',
    ),
  ),
  PortfolioProject(
    section: agribusinessRoute,
    slug: 'kapluk-solar-irrigation',
    title: 'Solar-Powered Irrigation Scheme – Kapluk',
    client: 'Italian Agency for Development Cooperation (AICS)',
    location: 'Kapluk, Baringo, Kenya',
    period: 'June 2021 – May 2023',
    // The story drawn from the project, its testimonial and the capacity-building
    // work now on Community & Impact (Kiptolelyo SHG is Kapluk's group).
    description: 'Between June 2021 and May 2023, JV ALMA C.I.S designed and built a solar-powered '
        'irrigation scheme for the farming community of Kapluk, in Baringo County, for the '
        'Italian Agency for Development Cooperation (AICS).\n\n'
        'It was a design-build project: JV ALMA C.I.S took the scheme from survey to completion, '
        'working alongside the community throughout.\n\n'
        'The project covered three areas:',
    focusAreas: [
      ProjectFocusArea(
        'Survey and design',
        'Surveying the site and designing the water distribution network and its pump system.',
      ),
      ProjectFocusArea(
        'Construction',
        'Building the solar-powered pumping system with 10,000-liter tanks, hydrants and all '
            'associated valves, under JV ALMA C.I.S technical supervision and quality control.',
      ),
      ProjectFocusArea(
        'Working with the community',
        'Employing local residents on the works, and organizing farmers into the Kiptolelyo '
            'Self Help Group, so they could move from fragmented subsistence farming to a '
            'coordinated, economically viable unit.',
      ),
    ],
    closing: 'For the community, the result is in their own words below: water, jobs, and a '
        'future.',
    images: [
      ProjectImage('$_dir/kapluk/kapluk_1.jpg'),
      ProjectImage('$_dir/kapluk/1.jpg'),
      ProjectImage('$_dir/kapluk/2.jpeg'),
      ProjectImage('$_dir/kapluk/3.jpeg'),
      ProjectImage('$_dir/kapluk/5-1.jpg'),
      ProjectImage('$_dir/kapluk/5.jpg'),
      ProjectImage('$_dir/kapluk/9.jpg'),
      ProjectImage('$_dir/kapluk/7.jpg'),
    ],
    // The irrigated field; the first photograph is small.
    coverIndex: 1,
    testimonial: ProjectTestimonial(
      'As a farmer and resident of Kapluk, I saw firsthand how JV ALMA C.I.S worked with our '
          'community—not just to build an irrigation system, but to build our confidence and '
          'capacity. Thanks to their commitment, we now have water, jobs, and a future.',
      'Simion Yator, Kiptolelyo Self Help Group Chairman',
    ),
  ),
  PortfolioProject(
    section: agribusinessRoute,
    slug: 'makueni-irrigation',
    title: 'Makueni Irrigation Scheme',
    client: 'Greenland Farm',
    location: 'Makueni County, Kenya',
    description: 'In Makueni County, JV ALMA C.I.S worked with Greenland Farm on a solar-powered '
        'irrigation system and an agri-enterprise pilot.\n\n'
        'The project went beyond construction: alongside the infrastructure, it changed how the '
        'farm is worked.\n\n'
        'The project covered three areas:',
    focusAreas: [
      ProjectFocusArea(
        'Solar-powered irrigation',
        'Delivering a solar-powered irrigation system for the farm.',
      ),
      ProjectFocusArea(
        'Organic farming and training',
        'Introducing organic farming methods and training farmers on sustainable practices, '
            'reducing the use of chemical inputs.',
      ),
      ProjectFocusArea(
        'Agri-enterprise',
        'A pilot that catalyzed local agri-enterprise for improved livelihoods.',
      ),
    ],
    closing: 'Greenland Farm reports adopting sustainable practices, improving yields and '
        'building stronger ties with the market.',
    images: [
      ProjectImage('$_dir/makueni1.jpeg'),
      ProjectImage('$_dir/makueni2.jpeg'),
      ProjectImage('$_dir/makueni_2.jpg'),
    ],
    // makueni_2.jpg leads.
    coverIndex: 2,
    testimonial: ProjectTestimonial(
      "As Greenland Farm, we witnessed how JV ALMA C.I.S combined innovation with hands-on "
          "support—delivering not just infrastructure, but real impact. With their guidance, "
          "we've adopted sustainable practices, improved our yields, and built stronger ties "
          'with the market.',
      'Greenland Farm Management',
    ),
  ),
  PortfolioProject(
    section: agribusinessRoute,
    slug: 'eni-technical-services',
    title: 'ENI – Provision of Technical Services & Operations Support',
    client: 'ENI',
    description:
        "JV ALMA C.I.S provided comprehensive technical services and operations support for ENI's "
        'projects, ensuring seamless execution through expert coordination, technical oversight, '
        'and operational efficiency. Our team delivered specialized support that enhanced project '
        'performance and maintained the highest standards of quality and safety.',
    images: [
      ProjectImage('$_dir/eni_1.jpeg'),
      ProjectImage('$_dir/eni_4.jpeg'),
      ProjectImage('$_dir/eni_5.jpeg'),
      ProjectImage('$_dir/eni_6.jpeg'),
      // Diagrams: shown whole rather than cropped.
      ProjectImage('$_dir/eni_2.jpg', isLogo: true),
      ProjectImage('$_dir/eni_3.jpg', isLogo: true),
    ],
  ),
  PortfolioProject(
    section: agribusinessRoute,
    slug: 'kalro-kabete-pilot',
    title: 'KALRO Kabete – Digital Agriculture Validation Pilot',
    clientLabel: 'In collaboration with',
    client:
        'Kenya Agricultural and Livestock Research Organization (KALRO) and Coffee Research Institute (CRI)',
    location: 'KALRO Food Crops Research Centre, Kabete, Kenya',
    status: 'Ongoing',
    description:
        'JV ALMA C.I.S is undertaking a collaborative pilot with the Kenya Agricultural and '
        'Livestock Research Organization (KALRO) at its Food Crops Research Centre in Kabete and Coffee Research Institute (CRI) in Ruiru to '
        'evaluate the application of digital technologies in agricultural decision-making.\n\n'
        'The pilot uses the Kilimo Mkononi platform alongside weather-station and soil-sensor '
        'data to investigate how digital agricultural information can be validated and improved '
        'under local field conditions.\n\n'
        'The work focuses on three areas:',
    focusAreas: [
      ProjectFocusArea(
        'Weather data validation',
        'Comparing satellite-derived weather information with measurements from on-site weather '
            'stations to assess differences and develop location-specific correction factors.',
      ),
      ProjectFocusArea(
        'AI agronomic advisory validation',
        'Comparing AI-generated agricultural recommendations with advice provided by qualified '
            'agronomists, using expert reviews to assess agreement and improve the advisory '
            'system.',
      ),
      ProjectFocusArea(
        'Soil monitoring and nutrient management',
        'Using soil-sensor measurements and soil nutrient information to support more informed '
            'crop management, including interpretation of soil conditions and agricultural '
            'recommendations.',
      ),
    ],
    closing:
        'Through this collaboration, JV ALMA C.I.S aims to strengthen the reliability of digital '
        'agricultural information and support the development of more locally relevant, '
        'data-informed farming decisions.',
    images: [
      ProjectImage('$_dir/kabete/1.jpeg'),
      ProjectImage('$_dir/kabete/3.jpeg'),
      ProjectImage('$_dir/kabete/4.jpeg'),
      ProjectImage('assets/apk/kilimo_2.jpg'),
      ProjectImage('assets/apk/kilimo_3.jpg'),
      ProjectImage('assets/apk/kilimo_4.jpg'),
    ],
    // 1.jpeg leads: the weather-station enclosure at the field site.
    coverIndex: 0,
  ),
];

/// The project whose page lives at [route], if any.
PortfolioProject? agribusinessProjectForRoute(String? route) =>
    agribusinessPortfolio.projectAt(route);

/// A research or academic institution the division works with.
class Institution {
  const Institution({
    required this.name,
    required this.logo,
    required this.summary,
    this.signatories = const [],
  });

  final String name;
  final String logo;
  final String summary;

  /// Who signed the memorandum of understanding, as "Name – Role".
  final List<String> signatories;
}

/// Institutions with a signed agreement. Add others only once their
/// agreement is signed.
const agribusinessInstitutions = <Institution>[
  Institution(
    name: 'KALRO',
    logo: '$_dir/kalro_logo.jpg',
    summary: 'The MoU empowers KALRO to provide technical support, capacity building, irrigation '
        'supervision, soil/water analysis, and ESIA services. This partnership grounds JV ALMA '
        "C.I.S's field projects in scientific rigor, enhancing sustainability and agricultural "
        'productivity.',
    signatories: [
      'Piergiorgio Di Carmine – CEO, JV ALMA C.I.S',
      'Dr. Eliud Kireger – Director General, KALRO',
      'Patricia Ngutu – Corporation Secretary, KALRO',
    ],
  ),
  Institution(
    name: 'Moi University',
    logo: '$_dir/moi_logo.jpg',
    summary: 'Through the agribusiness training program, Moi University trained students, '
        'developed business models, and coordinated local engagement. The MoU strengthens '
        'academic-practical collaboration and builds youth capacity for rural innovation.',
    signatories: [
      'Piergiorgio Di Carmine – CEO, JV ALMA C.I.S',
      'Prof. Eng. Simiyu Sitati – Dean School of Engineering, Moi University',
    ],
  ),
];

/// A digital platform supporting agricultural work.
class DigitalPlatform {
  const DigitalPlatform({
    required this.name,
    required this.tagline,
    required this.description,
    this.editions = const [],
    required this.route,
    this.screenshot,
  });

  final String name;
  final String tagline;
  final String description;

  /// Named editions with a short description each.
  final List<(String, String)> editions;
  final String route;

  /// A phone screenshot of the app, if one without personal or cooperative
  /// details is available.
  final String? screenshot;
}

const agribusinessPlatforms = <DigitalPlatform>[
  DigitalPlatform(
    name: 'Kilimo Mkononi',
    tagline: 'Grow, Protect, Prosper',
    description:
        'Kilimo Mkononi delivers comprehensive agricultural solutions through two specialized '
        'editions:',
    editions: [
      (
        'Enterprise Edition',
        'Empowers professional farmers and agricultural businesses with crop-specific advice, '
            'real-time market prices, 5-day weather forecasts, soil health management, '
            'pest/disease control, and financial tracking for crops like maize, beans, carrots, '
            'and tomatoes.',
      ),
      (
        'Education Edition',
        'Interactive learning platform for schools featuring quizzes, farm simulations, and a '
            'three-tier safety approval system (JV Admin → Headteachers → Teachers → Students), '
            'making agricultural education safe, engaging, and accessible.',
      ),
    ],
    route: '/kilimo-mkononi',
    screenshot: 'assets/apk/kilimo_mkononi.jpg',
  ),
  DigitalPlatform(
    name: 'CoffeeCore',
    tagline: 'Sow – Safeguard – Soar',
    description:
        'Designed specifically for coffee farmers and cooperatives, CoffeeCore offers farm '
        'management tools, real-time market prices, soil and weather data, pest solutions, and '
        'financial oversight. It streamlines cooperative coordination while promoting '
        'sustainable coffee farming and data-driven decisions from seed to sale.',
    route: '/coffee-core',
    screenshot: 'assets/apk/coffee_core.jpg',
  ),
];
