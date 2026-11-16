/// Community & Impact content: the community, social, educational and
/// development work of JV ALMA C.I.S, as an editorial portfolio.
///
/// The page has two layers:
/// * [impactAreas]: the kinds of contribution, as a compact index. An area
///   is listed only while at least one published story belongs to it.
/// * [featuredStories]: the actual initiatives, led by the Kapluk case study
///   ([kaplukStory], told in [kaplukChapters]).
///
/// Everything here is drawn from company records: the original Community &
/// Development page, the Agribusiness project data, the photographs in
/// assets/images/, and the summary of activities JV ALMA C.I.S sent to the
/// Italian Agency for Development Cooperation (AICS) in May 2024
/// ([aicsReportUrl]). Do not add figures, dates or partners that are not
/// documented.
///
/// Adding a story: append an [ImpactStory] to [featuredStories]. Leave
/// `published: false` until its photographs, context, participants,
/// institutional roles and publication permissions are confirmed; an
/// unpublished story, and any area that only it would fill, never reaches
/// the page.
///
/// Adding a photograph: put it in assets/images/dev/ (registered in
/// pubspec.yaml) and add it to the story or chapter it belongs to.
library;

import '../detail/agribusiness/agribusiness_content.dart' show agribusinessRoute;
import '../detail/portfolio/portfolio_project.dart';

/// The page's route.
const communityImpactRoute = '/community-impact';

/// The page's former route, kept so old links and bookmarks still arrive.
const legacyCommunityRoute = '/community-development';

// Shared types ----------------------------------------------------------------

/// A link from the page: to another page ([route]), to a story further down
/// this page ([storyId]), or to an outside publication or document ([url]).
class StoryLink {
  const StoryLink.page(this.label, String this.route)
      : storyId = null,
        url = null;
  const StoryLink.story(this.label, String this.storyId)
      : route = null,
        url = null;
  const StoryLink.external(this.label, String this.url)
      : route = null,
        storyId = null;

  final String label;
  final String? route;
  final String? storyId;
  final String? url;
}

/// A press article about an initiative, linking to the original
/// publication. The article's text is not reproduced.
class PressLink {
  const PressLink({
    required this.title,
    required this.publication,
    required this.date,
    required this.url,
  });

  final String title;
  final String publication;
  final String date;
  final String url;
}

/// One line of a story's details, e.g. ('Location', 'Kapluk, Baringo County').
typedef StoryFact = (String label, String value);

/// The kinds of contribution the page indexes.
enum ImpactArea {
  livelihoods,
  childrenAndSchools,
  education,
  sustainableAgriculture,
  knowledge,
  collaboration,
  socialSupport,
  communityEngagement,
}

class ImpactAreaInfo {
  const ImpactAreaInfo(this.area, this.title, this.summary);

  final ImpactArea area;
  final String title;
  final String summary;
}

/// One featured initiative.
class ImpactStory {
  const ImpactStory({
    required this.id,
    required this.title,
    required this.areas,
    this.partOfKapluk = false,
    this.facts = const [],
    required this.paragraphs,
    this.images = const [],
    this.outcomes = const [],
    this.links = const [],
    this.press = const [],
    this.projectSlug,
    this.published = true,
  });

  /// Anchor for links within the page.
  final String id;
  final String title;

  /// The areas the story is indexed under; the first is shown as its label.
  final List<ImpactArea> areas;

  /// Whether the activity took place within the Kapluk programme.
  final bool partOfKapluk;
  final List<StoryFact> facts;
  final List<String> paragraphs;

  /// Photographs, the first leading. When empty, the cover of the
  /// Agribusiness project [projectSlug] is used.
  final List<ProjectImage> images;

  /// Figures from [aicsReportUrl], shown with [reportedOutcomesSource].
  final List<String> outcomes;
  final List<StoryLink> links;
  final List<PressLink> press;

  /// The Agribusiness project the story is drawn from, if any: its location,
  /// timing and cover come from there rather than being repeated here.
  final String? projectSlug;

  /// False keeps the story, and any area only it would fill, off the page.
  final bool published;
}

// Source documents ------------------------------------------------------------

/// The summary of activities JV ALMA C.I.S sent to AICS, published by AICS.
const aicsReportUrl = 'https://www.aics.gov.it/wp-content/uploads/2023/12/'
    'JV-Alma-CIS-AICS-Summary-of-Activities-16-th-May-2024.pdf';

/// Shown with every figure taken from [aicsReportUrl].
const reportedOutcomesSource = 'As reported by JV ALMA C.I.S to the Italian Agency for Development '
    'Cooperation (AICS) in its summary of activities, May 2024.';

const aicsReportLink = StoryLink.external(
  'Summary of activities reported to AICS, May 2024 (PDF)',
  aicsReportUrl,
);

const aicsName = 'Italian Agency for Development Cooperation (AICS)';

// 01 Introduction ---------------------------------------------------------------

const introTitle = 'Our Impact';
const introHeadline =
    'Supporting people, strengthening communities and contributing to sustainable development.';
const introText =
    'Through knowledge sharing, technical engagement, institutional collaboration and community '
    'initiatives, JV ALMA C.I.S contributes to development beyond its core commercial activities.';

// 02 Our approach ---------------------------------------------------------------

const approachTitle = 'Development through practical engagement.';
const approachParagraphs = [
  'Our approach brings together technical experience, knowledge sharing and collaboration to '
      'support practical development initiatives. Through engagement with communities, '
      'institutions and other stakeholders, we contribute expertise and resources in areas '
      'connected to our wider business activities.',
  'We aim to equip people and communities with the skills, knowledge and structures to drive '
      'their own development. Where it is practical, communities invest alongside us: in Kapluk, '
      'farmers co-invested in their own irrigation scheme.',
];

// 03 Impact areas ---------------------------------------------------------------

/// Every area, in index order. The page lists only those with a published
/// story (or, for [ImpactArea.collaboration], with [collaborators]).
const impactAreas = <ImpactAreaInfo>[
  ImpactAreaInfo(
    ImpactArea.livelihoods,
    'Community Empowerment & Livelihoods',
    'Helping communities organise, produce and reach markets.',
  ),
  ImpactAreaInfo(
    ImpactArea.childrenAndSchools,
    'Children & Schools',
    'Supporting pupils and bringing agribusiness into the classroom.',
  ),
  ImpactAreaInfo(
    ImpactArea.education,
    'Education & Skills',
    'Practical training for farmers and young professionals.',
  ),
  ImpactAreaInfo(
    ImpactArea.sustainableAgriculture,
    'Sustainable Agriculture',
    'Soil health, responsible use of inputs and organic practices.',
  ),
  ImpactAreaInfo(
    ImpactArea.knowledge,
    'Knowledge, Research & Digital Inclusion',
    'Farm records, research pilots and digital tools for farmers.',
  ),
  ImpactAreaInfo(
    ImpactArea.collaboration,
    'Institutional Collaboration',
    'Working with universities, research bodies and community groups.',
  ),
  // No published story yet: listed once one is confirmed for publication.
  ImpactAreaInfo(
    ImpactArea.socialSupport,
    'Social Support & Giving',
    'Support and giving for people in the communities around us.',
  ),
  ImpactAreaInfo(
    ImpactArea.communityEngagement,
    'Community Engagement',
    'Time spent with children and communities by our team.',
  ),
];

// 04 Featured initiatives -------------------------------------------------------

const _dir = 'assets/images/agribusiness';
const _kapluk = 'assets/images/agribusiness/kapluk';
const _dev = 'assets/images/dev';

/// The Agribusiness project the Kapluk programme built.
const kaplukProjectSlug = 'kapluk-solar-irrigation';

const kaplukStory = ImpactStory(
  id: 'kapluk',
  title: 'Kapluk Community Programme',
  areas: [
    ImpactArea.livelihoods,
    ImpactArea.education,
    ImpactArea.sustainableAgriculture,
    ImpactArea.knowledge,
  ],
  facts: [
    ('Location', 'Kapluk, Baringo County'),
    ('Period', 'June 2021 – May 2023'),
    ('Status', 'Completed'),
    ('Programme', 'Bando Profit 2019: Agribusiness for the Development of Rural Areas in Kenya'),
    ('Funded by', aicsName),
    ('Community partner', 'Kiptolelyo Farmers Self Help Group'),
  ],
  paragraphs: [
    'Kapluk is a semi-arid area where most families have lived from pastoralism and livestock. '
        'While JV ALMA C.I.S built the solar-powered irrigation scheme there, we stayed and worked '
        'with the community: bringing water, helping farmers organize, providing seeds and '
        'training, and connecting their harvests to the market.',
    'The training of young professionals with Moi University, the work in Kapluk\'s schools and '
        'the giardiniera made with Kenya Utalii College were all part of this programme.',
  ],
  outcomes: [
    'Five people found work in catering at the local market that grew from the farmers\' shared '
        'produce store.',
  ],
  links: [
    StoryLink.page(
        'Solar-Powered Irrigation Scheme – Kapluk', '$agribusinessRoute/$kaplukProjectSlug'),
    aicsReportLink,
  ],
);

/// One chapter of the Kapluk case study: photographs beside its text.
class KaplukChapter {
  const KaplukChapter({
    required this.title,
    required this.points,
    required this.images,
    this.link,
  });

  final String title;

  /// One point is shown as prose; several as a bulleted list.
  final List<String> points;

  /// The first photograph leads.
  final List<ProjectImage> images;
  final StoryLink? link;
}

const kaplukChapters = <KaplukChapter>[
  KaplukChapter(
    title: 'Water for the Community',
    points: [
      'The solar-powered irrigation scheme brought water to the community, making crop farming '
          'possible in a semi-arid area.',
      'Most of the work to install the system was carried out by members of the local community, '
          'and the use of the communal stream was agreed with the chief.',
    ],
    images: [
      ProjectImage('$_kapluk/3.jpeg'),
      // The solar array that pumps the water.
      ProjectImage('$_kapluk/kapluk_1.jpg'),
    ],
  ),
  KaplukChapter(
    title: 'Organizing Farmers: Kiptolelyo Self Help Group',
    points: [
      'Organizing the community into a formal self-help group, the Kiptolelyo Farmers Self Help '
          'Group, to move from fragmented subsistence farming to a coordinated, economically '
          'viable unit. The group was registered with the Department of Social Development in '
          '2022.',
      'Farmers co-invested in the scheme: under formal agreements, they committed to repay half of '
          'the irrigation system\'s cost to JV ALMA C.I.S, each in proportion to the land they '
          'irrigated.',
    ],
    images: [
      ProjectImage('$_dir/community_empowerment_2.jpg'),
      ProjectImage('$_dir/community_empowerment_1.jpg'),
      // The group's registration certificate: a document, shown whole.
      ProjectImage(
        '$_dev/6.jpeg',
        isLogo: true,
        caption: 'Registration certificate of the Kiptolelyo Farmers Self Help Group',
      ),
    ],
  ),
  KaplukChapter(
    title: 'Seeds and Training',
    points: [
      'Providing seeds for farming',
      'Training with agricultural officers in good farming practices and the use of the '
          'irrigation scheme',
      'Teaching the community crop farming, with a farmers\' training manual prepared for the '
          'group',
    ],
    images: [
      ProjectImage(
        '$_dir/building_leadership.jpg',
        caption: 'A community training meeting in Kapluk',
      ),
      // The training manual: a document, shown whole.
      ProjectImage(
        '$_dev/4.jpeg',
        isLogo: true,
        caption: 'Farmers\' training manual for watermelon cultivation',
      ),
    ],
  ),
  KaplukChapter(
    title: 'Soil Health and Controlled Use of Pesticides',
    points: [
      'Soil sampling and analysis to support fertility management',
      'Recommendations for responsible fertilizer and pesticide use',
      'Tailored nutrient application plans based on farm-specific data',
      'Introducing organic fertilizers, with a trial plot comparing organic and inorganic inputs',
    ],
    images: [
      ProjectImage('$_dir/soil_health_1.jpg'),
      ProjectImage('$_dir/soil_health_2.jpg'),
      ProjectImage('$_dir/data_collection.jpg', caption: 'A farmer in Kapluk'),
    ],
  ),
  KaplukChapter(
    title: 'Keeping Records',
    points: [
      'Collection and analysis of field data with the farmers',
      'Recording inputs bought and used, crop by crop',
      'Crop and pest tracking',
    ],
    images: [
      ProjectImage('$_dir/data_processing.jpg'),
      ProjectImage('$_dir/data_extraction.jpg'),
    ],
  ),
  KaplukChapter(
    title: 'From Harvest to Market',
    points: [
      'Selling the first bean harvest at an auction advertised through the self-help group',
      'Connecting the group\'s harvest to the market under its own name, "A taste of Baringo": '
          'Nyota Beans and Kiptolelyo Community Watermelon',
      'Adding value: vegetables harvested by the farmers were turned into pickled vegetables, '
          'prepared with a chef and Kenya Utalii College',
    ],
    images: [
      ProjectImage('$_dir/value_chain_1.jpg'),
      ProjectImage('$_dir/value_chain_2.jpg'),
      ProjectImage('$_dir/sustainability.jpg'),
      ProjectImage('$_dev/7.jpeg'),
    ],
    link: StoryLink.story('The giardiniera story', 'giardiniera'),
  ),
];

/// Where the Kapluk work led: the idea for Kilimo Mkononi came out of the
/// work as a whole, so it closes the case study.
const originEyebrow = 'WHERE IT LED';
const originTitle = 'From exercise books to Kilimo Mkononi';
const originParagraphs = [
  'After many months, with water reaching the community and farmers keeping records of their '
      'production, we saw how those records were kept: parents wrote their cost of production '
      'in exercise books. Books are easily lost, and the records go with them.',
  'That is where the idea for Kilimo Mkononi came from: one platform that keeps a farmer\'s '
      'records together and safe, instead of in a book that can be lost.',
];
const originLink = StoryLink.page('Kilimo Mkononi', '/kilimo-mkononi');

const moiStory = ImpactStory(
  id: 'moi-university',
  title: 'Training Young Professionals with Moi University',
  areas: [ImpactArea.education, ImpactArea.collaboration],
  partOfKapluk: true,
  facts: [
    ('Institution', 'Moi University School of Engineering'),
    ('Programme', 'Bando Profit 2019'),
  ],
  paragraphs: [
    'Training young professionals in multidisciplinary skills (engineering, agribusiness, '
        'irrigation design) through technical modules delivered in partnership with academic '
        'institutions.',
    'Through the agribusiness training program with Moi University School of Engineering, '
        'students were trained, business models developed, and local engagement coordinated. The '
        'memorandum of understanding with the university was the programme\'s first step: Moi '
        'University also took part in selecting the community the programme would work with.',
  ],
  images: [
    // The classroom session leads.
    ProjectImage('$_dev/9.jpg'),
    ProjectImage('$_dir/training_2.jpg'),
    ProjectImage('$_dev/8.jpg'),
    ProjectImage('$_dir/training_1.jpg', caption: 'The Moi University training group'),
  ],
  outcomes: [
    'Eight trainees took part in the training; three of them went on to stable employment with '
        'a regular contract.',
  ],
  links: [StoryLink.page('Our partnership with Moi University', agribusinessRoute)],
);

const schoolsStory = ImpactStory(
  id: 'kapluk-schools',
  title: 'Learning in Kapluk\'s Schools',
  areas: [ImpactArea.childrenAndSchools, ImpactArea.education],
  partOfKapluk: true,
  facts: [('Location', 'Kapluk, Baringo County')],
  paragraphs: [
    'Alongside the irrigation scheme, the programme worked with the schools in Kapluk: '
        'encouraging children to stay in school, and buying books for pupils.',
    'A school-tracking programme brought agribusiness into lessons, both in class and at the '
        'irrigation scheme, to show students that farming can be a source of work and income.',
  ],
  images: [
    ProjectImage('$_dir/agribusiness_in_schools_1.jpg'),
    ProjectImage('$_dev/3.jpeg'),
    ProjectImage('$_dir/agribusiness_in_schools_2.jpg', caption: 'A school in Kapluk'),
  ],
  outcomes: [
    'More than 300 students took part in the school-tracking programme, which involved the '
        'entire Kapluk school community.',
  ],
);

const giardinieraStory = ImpactStory(
  id: 'giardiniera',
  title: 'From Kapluk to Nairobi: Giardiniera with Kenya Utalii College',
  areas: [ImpactArea.livelihoods, ImpactArea.collaboration],
  partOfKapluk: true,
  facts: [
    ('Collaborators', 'Kenya Utalii College; Italian chef Luca Mastromattei'),
  ],
  paragraphs: [
    'To add value to the farmers\' harvest, JV ALMA C.I.S worked with Kenya Utalii College and '
        'Italian chef Luca Mastromattei to turn vegetables grown in Kapluk into giardiniera: '
        'Italian-style pickled vegetables.',
    'The aim was a direct link between the Kapluk farmers and the market in Nairobi. Larger-scale '
        'production was planned once the farmers could supply vegetables steadily.',
  ],
  images: [ProjectImage('$_dev/1.jpeg')],
  press: [
    PressLink(
      title: 'Italian "giardiniera" helps Kenyan farmers',
      publication: 'MalindiKenya.net',
      date: 'November 2023',
      url: 'https://www.malindikenya.net/en/articles/social/solidarity/'
          'italian--giardiniera--helps-kenyan-farmers.html',
    ),
  ],
);

const kalroStory = ImpactStory(
  id: 'kalro-kabete',
  title: 'KALRO Kabete Digital Agriculture Pilot',
  areas: [ImpactArea.knowledge, ImpactArea.collaboration],
  facts: [
    ('Collaborators', 'KALRO and Coffee Research Institute (CRI)'),
  ],
  paragraphs: [
    'With the Kenya Agricultural and Livestock Research Organization (KALRO) and the Coffee '
        'Research Institute, JV ALMA C.I.S is piloting how digital agricultural information, '
        'from the Kilimo Mkononi platform, weather stations and soil sensors, can be validated '
        'and improved under local field conditions.',
  ],
  links: [StoryLink.page('The pilot in full', '$agribusinessRoute/kalro-kabete-pilot')],
  projectSlug: 'kalro-kabete-pilot',
);

/// The featured initiatives in page order, best documented first. Stories
/// not yet confirmed for publication stay out of this list until they are
/// (or are added with `published: false`).
const featuredStories = <ImpactStory>[
  kaplukStory,
  moiStory,
  schoolsStory,
  giardinieraStory,
  kalroStory,
];

/// [stories] that may appear on the page.
List<ImpactStory> publishedStories(List<ImpactStory> stories) => [
      for (final s in stories)
        if (s.published) s
    ];

/// The areas to index for [stories]: those with at least one published
/// story, plus collaboration while [collaborators] is not empty.
List<ImpactAreaInfo> visibleAreas(
  List<ImpactStory> stories, {
  List<Collaborator> withCollaborators = collaborators,
}) {
  final published = publishedStories(stories);
  return [
    for (final info in impactAreas)
      if (published.any((s) => s.areas.contains(info.area)) ||
          (info.area == ImpactArea.collaboration && withCollaborators.isNotEmpty))
        info,
  ];
}

// 05 Working together -----------------------------------------------------------

/// How an institution relates to the work. Each role is described as it is
/// documented; none implies endorsement.
enum CollaboratorRole {
  institutional('Institutional collaboration'),
  funding('Funding institution'),
  collaborator('Collaborator'),
  community('Community partner');

  const CollaboratorRole(this.label);
  final String label;
}

class Collaborator {
  const Collaborator({
    required this.name,
    required this.role,
    required this.relationship,
    this.logo,
    this.storyId,
  });

  final String name;
  final CollaboratorRole role;

  /// What the documented relationship is, in one or two sentences.
  final String relationship;
  final String? logo;

  /// The story on this page the relationship belongs to, if any.
  final String? storyId;
}

const workingTogetherTitle = 'Working Together';
const workingTogetherIntro =
    'The institutions and groups we have worked with on this work, and the role each has '
    'played. Memoranda of understanding and their signatories are set out on the Agribusiness '
    'page.';
const workingTogetherLink =
    StoryLink.page('Agreements on the Agribusiness page', agribusinessRoute);

/// Grouped by role in [CollaboratorRole] order.
const collaborators = <Collaborator>[
  Collaborator(
    name: 'Moi University',
    role: CollaboratorRole.institutional,
    relationship: 'Memorandum of understanding. The School of Engineering trained young '
        'professionals for the Kapluk programme.',
    logo: '$_dir/moi_logo.jpg',
    storyId: 'moi-university',
  ),
  Collaborator(
    name: 'Kenya Agricultural and Livestock Research Organization (KALRO)',
    role: CollaboratorRole.institutional,
    relationship: 'Memorandum of understanding, and collaboration on the Kabete digital '
        'agriculture pilot.',
    logo: '$_dir/kalro_logo.jpg',
    storyId: 'kalro-kabete',
  ),
  Collaborator(
    name: aicsName,
    role: CollaboratorRole.funding,
    relationship: 'Funded the Kapluk programme under Bando Profit 2019.',
    storyId: 'kapluk',
  ),
  Collaborator(
    name: 'Kenya Utalii College',
    role: CollaboratorRole.collaborator,
    relationship: 'Prepared giardiniera from vegetables grown in Kapluk.',
    storyId: 'giardiniera',
  ),
  Collaborator(
    name: 'Coffee Research Institute (CRI)',
    role: CollaboratorRole.collaborator,
    relationship: 'Collaborator in the Kabete digital agriculture pilot.',
    storyId: 'kalro-kabete',
  ),
  Collaborator(
    name: 'Kiptolelyo Farmers Self Help Group',
    role: CollaboratorRole.community,
    relationship: 'The Kapluk farmers\' group, registered in 2022, that the programme worked with.',
    storyId: 'kapluk',
  ),
];

// 06 Closing ------------------------------------------------------------------

const closingTitle = 'Progress through collaboration.';
const closingText =
    'We welcome opportunities to work with institutions, organisations and development partners '
    'on initiatives that contribute to practical and sustainable development.';
const closingAction = 'Discuss a Partnership';
