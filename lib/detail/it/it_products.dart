/// IT Division products: the single source for the IT Division page's
/// portfolio and for the product pages.
///
/// To show a product visual, add the file under `assets/apk/` and set
/// [SoftwareProduct.visual]. Products without one get a neutral name panel.
///
/// Public visuals must never expose client, employee, farmer, project or
/// operational information. AlmaWorks, NyumbaSmart and AlmaHub use the
/// company's prepared illustrative visuals for this reason.
library;

/// How a product image is framed.
enum ScreenshotKind {
  /// A desktop screen, shown whole in a light frame.
  desktop,

  /// A phone screen, shown upright in a light frame.
  phone,

  /// A prepared illustrative visual (not a real screen), shown edge to edge
  /// and captioned as illustrative.
  illustration,
}

class ProductScreenshot {
  const ProductScreenshot(
    this.path, {
    required this.kind,
    required this.description,
    this.aspectRatio,
  });

  final String path;
  final ScreenshotKind kind;

  /// What the image shows, read out to screen readers.
  final String description;

  /// The image's width / height, for illustrations shown uncropped.
  final double? aspectRatio;
}

/// Caption under illustrative visuals.
const illustrativeCaption = 'Illustrative product visual';

class SoftwareProduct {
  const SoftwareProduct({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.capabilities,
    required this.route,
    this.visual,
  });

  final String name;
  final String subtitle;
  final String description;

  /// A few verified capabilities shown on the IT Division page.
  final List<String> capabilities;

  /// The product's page on this site.
  final String route;

  /// The image representing the product, if an approved one exists.
  final ProductScreenshot? visual;
}

/// A group of products on the IT Division page. Its layout follows its size:
/// three products put the first in the lead with two beside each other
/// below, two sit side by side, one gets a wide presentation.
class SolutionArea {
  const SolutionArea({
    required this.category,
    required this.heading,
    required this.intro,
    required this.products,
  });

  /// Short label, e.g. "Construction & Facility Operations".
  final String category;
  final String heading;
  final String intro;
  final List<SoftwareProduct> products;
}

const almaWorks = SoftwareProduct(
  name: 'AlmaWorks',
  subtitle: 'Construction Management Software',
  description: 'Construction management software supporting project and contract management, '
      'financial tracking and billing.',
  capabilities: ['Project management', 'Contract management', 'Financial tracking', 'Billing'],
  route: '/alma-works',
  visual: ProductScreenshot(
    'assets/apk/almaworks.jpg',
    kind: ScreenshotKind.illustration,
    description: 'Illustration of AlmaWorks on a laptop and a phone',
    aspectRatio: 1137 / 391,
  ),
);

const nyumbaSmart = SoftwareProduct(
  name: 'NyumbaSmart',
  subtitle: 'Facility Management Platform',
  description: 'Facility management software for coordinating facilities, maintenance work '
      'orders and operational documentation.',
  capabilities: [
    'Multi-facility management',
    'Work orders and maintenance',
    'Document tracking and security',
  ],
  route: '/cmms',
  visual: ProductScreenshot(
    'assets/apk/nyumbasmart.jpg',
    kind: ScreenshotKind.illustration,
    description: 'Illustration of NyumbaSmart on a laptop and a phone',
    aspectRatio: 571 / 355,
  ),
);

const almaSafety = SoftwareProduct(
  name: 'AlmaSafety',
  subtitle: 'Construction Safety Management',
  description: 'A construction safety management platform connecting safety learning with '
      'project-specific safety information, hazards and corrective actions.',
  capabilities: [
    'Safety videos, learning documents and knowledge questions',
    'Project-specific safety requirements',
    'Hazard records and corrective actions',
    'OSHA-related records and other site information',
  ],
  route: '/alma-safety',
  visual: ProductScreenshot(
    'assets/apk/alma_safety.jpg',
    kind: ScreenshotKind.desktop,
    description: 'AlmaSafety sign-in screen',
    aspectRatio: 646 / 378,
  ),
);

const kilimoMkononi = SoftwareProduct(
  name: 'Kilimo Mkononi',
  subtitle: 'Agricultural Platform Suite',
  description: 'An agricultural platform supporting farmers and agricultural education through '
      'farm information, weather, crop management and learning resources.',
  capabilities: [
    'Enterprise and Education editions',
    'Weather information',
    'Crop management',
    'Farm management tools',
  ],
  route: '/kilimo-mkononi',
  visual: ProductScreenshot(
    'assets/apk/kilimo_mkononi.jpg',
    kind: ScreenshotKind.desktop,
    description: 'Kilimo Mkononi edition choice: Enterprise or Education',
  ),
);

const coffeeCore = SoftwareProduct(
  name: 'CoffeeCore',
  subtitle: 'Coffee Farmers Network',
  description: 'A digital platform supporting coffee farmers and cooperative operations, '
      'including farming guidance and production information.',
  capabilities: [
    'Cooperative integration',
    'Farming guidance',
    'Market and production information',
  ],
  route: '/coffee-core',
  visual: ProductScreenshot(
    'assets/apk/coffee_core.jpg',
    kind: ScreenshotKind.desktop,
    description: 'CoffeeCore opening screen',
  ),
);

const almaHub = SoftwareProduct(
  name: 'AlmaHub',
  subtitle: 'Human Resource Management Platform',
  description: 'A human resource management platform supporting employee records, leave '
      'administration, recruitment and workforce management.',
  capabilities: [
    'Employee records',
    'Leave applications and tracking',
    'Recruitment and job applications',
    'Workforce and employee administration',
  ],
  route: '/alma-hub',
  visual: ProductScreenshot(
    'assets/apk/almahub.jpg',
    kind: ScreenshotKind.illustration,
    description: 'Illustration of AlmaHub on a laptop and a phone',
    aspectRatio: 579 / 345,
  ),
);

const solutionAreas = <SolutionArea>[
  SolutionArea(
    category: 'Construction & Facility Operations',
    heading: 'Managing projects, facilities and site safety.',
    intro: 'Digital tools supporting construction project management, facility operations and '
        'workplace safety.',
    products: [almaWorks, nyumbaSmart, almaSafety],
  ),
  SolutionArea(
    category: 'Agricultural Technology',
    heading: 'Connecting agriculture with digital technology.',
    intro: 'Digital platforms supporting agricultural information, farmer services and coffee '
        'production networks.',
    products: [kilimoMkononi, coffeeCore],
  ),
  SolutionArea(
    category: 'People & Workforce Management',
    heading: 'Supporting the people behind organisations.',
    intro: 'Digital tools for employee administration, recruitment and workforce management.',
    products: [almaHub],
  ),
];

/// One functional area of a product, with what it covers.
class ProductArea {
  const ProductArea(this.title, this.items);

  final String title;
  final List<String> items;
}

/// Functional areas under one heading, e.g. what workers use on site.
class ProductAreaGroup {
  const ProductAreaGroup({required this.heading, this.note, required this.areas});

  final String heading;
  final String? note;
  final List<ProductArea> areas;
}

/// A feature with a short explanation.
class ProductFeature {
  const ProductFeature(this.title, this.description);

  final String title;
  final String description;
}

/// Features under one heading, e.g. "Security & access control".
class FeatureGroup {
  const FeatureGroup({required this.heading, this.intro, required this.features});

  final String heading;
  final String? intro;
  final List<ProductFeature> features;
}

/// An edition of a product with its own page, e.g. Kilimo Mkononi Enterprise.
class ProductEdition {
  const ProductEdition({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.route,
    required this.status,
    this.visual,
  });

  final String name;
  final String subtitle;
  final String description;
  final List<String> features;
  final String route;

  /// Shown as text, e.g. "Available now" or "Coming soon".
  final String status;

  /// A screenshot of this edition; without one its card shows its name.
  final ProductScreenshot? visual;
}

/// Where the app can be installed, as already published.
class StoreLink {
  const StoreLink(this.url, {this.note});

  final String url;
  final String? note;
}

/// The content of a product page built from this file.
class ProductPageContent {
  const ProductPageContent({
    required this.product,
    this.tagline,
    required this.overview,
    this.audience = const [],
    this.editions = const [],
    this.groups = const [],
    this.featureGroups = const [],
    this.screenshots = const [],
    this.storeLink,
    this.eyebrow = 'IT DIVISION · PLATFORM',
    this.parent = const ('IT Division', '/it-division'),
    this.status,
    this.ctaTitle,
    this.ctaText,
    this.showVisualInHeader = false,
  });

  final SoftwareProduct product;

  /// Label above the product name.
  final String eyebrow;

  /// The page the back link returns to, as (label, route).
  final (String, String) parent;

  /// Availability shown in words, e.g. "Coming soon".
  final String? status;

  /// Show the product's screenshot under the title, as illustrations are.
  final bool showVisualInHeader;

  /// Closing section heading and text; defaults name the product.
  final String? ctaTitle;
  final String? ctaText;

  /// The product's own line, e.g. "Sow, Safeguard, Soar".
  final String? tagline;

  /// Paragraphs explaining what the product is for.
  final List<String> overview;

  /// Who the product is for.
  final List<String> audience;
  final List<ProductEdition> editions;

  /// Bulleted areas, e.g. user roles and what each does.
  final List<ProductAreaGroup> groups;
  final List<FeatureGroup> featureGroups;

  /// Real screenshots of the product, in gallery order.
  final List<ProductScreenshot> screenshots;
  final StoreLink? storeLink;
}

const almaSafetyPage = ProductPageContent(
  product: almaSafety,
  showVisualInHeader: true,
  overview: [
    'AlmaSafety is a digital platform supporting construction-site safety management, worker '
        'learning and the documentation of site safety activities.',
    'It provides a central environment where foremen and workers can access safety videos, '
        'documents, knowledge questions and safety requirements relevant to the projects they '
        'are currently working on.',
    'The platform also supports the recording and tracking of hazards, corrective actions, '
        'OSHA-related records and other site safety information, connecting what people learn '
        'with how safety is managed on site.',
  ],
  audience: [
    'Construction companies',
    'Safety managers',
    'Site supervisors',
    'Foremen',
    'Workers',
  ],
  groups: [
    ProductAreaGroup(
      heading: 'Learning on site',
      note: 'For foremen and workers on the projects they are working on.',
      areas: [
        ProductArea('Safety Learning', [
          'Safety videos',
          'Safety documents and reference materials',
          'Knowledge questions and learning activities',
          'Project-specific safety requirements',
          'Learning resources relevant to the work being undertaken on site',
        ]),
      ],
    ),
    ProductAreaGroup(
      heading: 'Managing site safety',
      areas: [
        ProductArea('Site Safety Management', [
          'Hazard identification and recording',
          'Corrective action tracking',
          'Site safety observations and related records',
        ]),
        ProductArea('Safety Documentation', [
          'Project and site safety records',
          'Documentation of relevant safety activities',
          'Accessible safety information for authorised users',
        ]),
        ProductArea('Safety Oversight', [
          'Monitoring of site safety information',
          'Tracking of hazards and corrective actions',
          'OSHA-related documentation and records',
        ]),
      ],
    ),
  ],
  // safety.jpg, safety_1.jpg and safety_3.jpg name a client project, so they
  // are not used.
  screenshots: [
    ProductScreenshot(
      'assets/apk/safety_4.jpg',
      kind: ScreenshotKind.desktop,
      description: 'AlmaSafety learning, safety reports and corrective actions',
    ),
    ProductScreenshot(
      'assets/apk/safety_2.jpg',
      kind: ScreenshotKind.desktop,
      description: 'AlmaSafety safety videos',
    ),
  ],
);

const almaHubPage = ProductPageContent(
  product: almaHub,
  overview: [
    'AlmaHub is a human resource management platform designed to support employee '
        'administration and workforce management.',
    'It provides tools for managing employee records, leave applications, recruitment and job '
        'applications, and related workforce processes.',
  ],
  audience: [
    'HR teams',
    'Employers',
    'Workforce administrators',
    'Organisations managing employees and recruitment',
  ],
  groups: [
    ProductAreaGroup(
      heading: 'What AlmaHub covers',
      areas: [
        ProductArea('Employee Management', [
          'Employee records',
          'Workforce information and administration',
          'Staff management',
        ]),
        ProductArea('Leave Management', [
          'Leave applications',
          'Leave tracking',
          'Leave administration',
        ]),
        ProductArea('Recruitment', [
          'New job applications',
          'Applicant management',
          'Recruitment-related administration',
        ]),
        ProductArea('HR Administration', [
          'Centralised workforce information',
          'Employee-related records',
          'HR processes and administration',
        ]),
      ],
    ),
  ],
);

const almaWorksPage = ProductPageContent(
  product: almaWorks,
  overview: [
    'Proprietary construction management platform designed for sensitive construction '
        'operations with comprehensive role-based security.',
    'AlmaWorks is currently used internally by JV ALMA C.I.S for managing our construction '
        'projects.',
  ],
  groups: [
    ProductAreaGroup(
      heading: 'User roles & permissions',
      note: 'AlmaWorks features hierarchical access control for construction project management:',
      areas: [
        ProductArea('JV Admin', [
          'Approves client and employee registrations',
          'Manages system-wide permissions and access',
          'Oversees all construction projects',
          'Controls document access and visibility',
        ]),
        ProductArea('Project Managers', [
          'Manage project timelines and milestones',
          'Assign tasks to contractors and teams',
          'Monitor project progress and budgets',
          'Generate progress reports and documentation',
        ]),
        ProductArea('Contractors', [
          'Access assigned work orders and tasks',
          'Update work progress and completion status',
          'Upload site photos and documentation',
          'Submit billing and cost information',
        ]),
        ProductArea('Clients', [
          'View project progress and updates',
          'Access approved drawings and documents',
          'Communicate with project managers',
          'Track project milestones and deliverables',
        ]),
      ],
    ),
  ],
  featureGroups: [
    FeatureGroup(
      heading: 'Core features',
      intro: 'Essential tools for construction management.',
      features: [
        ProductFeature(
          'Role-Based Access Control',
          'Hierarchical user management with customizable permissions for administrators, '
              'project managers, contractors, and clients.',
        ),
        ProductFeature(
          'Client & Employee Management',
          'Comprehensive database for managing construction clients, employees, and team '
              'assignments across multiple projects.',
        ),
        ProductFeature(
          'Contract Administration',
          'Centralized contract management system tracking agreements, milestones, '
              'deliverables, and contractual obligations.',
        ),
        ProductFeature(
          'Supplier & Client Contacts',
          'Organized contact database for suppliers, subcontractors, and clients with '
              'communication history and interaction logs.',
        ),
        ProductFeature(
          'Drawing & Document Storage',
          'Secure storage and version control for architectural drawings, blueprints, permits, '
              'and project documentation.',
        ),
        ProductFeature(
          'Financial Management',
          'Comprehensive financial tracking for clients and contractors including invoicing, '
              'payments, budgets, and cost analysis.',
        ),
      ],
    ),
    FeatureGroup(
      heading: 'Advanced capabilities',
      intro: 'Enhanced functionality for project oversight.',
      features: [
        ProductFeature(
          'Client-Contractor Communication',
          'Built-in messaging system facilitating communication between clients and contractors '
              'with threaded conversations.',
        ),
        ProductFeature(
          'Quality & Safety Management',
          'Tools for quality inspections, safety checklists, incident reporting, and compliance '
              'tracking to maintain construction standards.',
        ),
        ProductFeature(
          'Progress Reports',
          'Automated generation of weekly and monthly progress reports with customizable '
              'templates and data visualization.',
        ),
        ProductFeature(
          'Photo Gallery & Documentation',
          'Organized photo gallery for documenting construction progress, before/after '
              'comparisons, and site inspections with geo-tagging.',
        ),
      ],
    ),
    FeatureGroup(
      heading: 'Security & access control',
      features: [
        ProductFeature(
          'Approval-Based Access',
          'All users require JV Admin approval before accessing the platform, ensuring secure '
              'access control.',
        ),
        ProductFeature(
          'Role-Based Permissions',
          'Hierarchical access control ensures users only see data relevant to their role and '
              'projects.',
        ),
        ProductFeature(
          'Audit Trail',
          'Complete tracking of who viewed, edited, or downloaded documents with timestamps for '
              'accountability.',
        ),
        ProductFeature(
          'Project-Based Access',
          'Users only access projects they are authorized for, ensuring complete data '
              'separation.',
        ),
      ],
    ),
  ],
);

const nyumbaSmartPage = ProductPageContent(
  product: nyumbaSmart,
  overview: [
    'A facility management platform supporting building operations, maintenance activities, '
        'work orders, document management and operational records.',
    'Users select their facility (Houses, Garages, Storerooms, Office Buildings, etc.) on login '
        'and only access authorized data.',
  ],
  groups: [
    ProductAreaGroup(
      heading: 'User roles & permissions',
      note: 'Secure, role-based access to manage multiple facilities efficiently.',
      areas: [
        ProductArea('JV Admin', [
          'Approves client and JV employee registrations',
          'Grants or denies access based on employee functions',
          'Controls document access permissions',
          'Tracks who viewed what and when for accountability',
        ]),
        ProductArea('JV Employees', [
          'Create work orders from client requests',
          'Upload, view, edit, or download documentation',
          'Manage preventive maintenance schedules',
          'Access varies based on assigned function',
        ]),
        ProductArea('Clients', [
          'Submit work requests for facility maintenance',
          'View approved documentation and drawings',
          'Track work order progress',
          'Access limited to authorized facilities only',
        ]),
        ProductArea('Contractors', [
          'Access assigned work orders',
          'Update work progress and completion status',
          'View relevant facility documentation',
          'Limited access based on project scope',
        ]),
      ],
    ),
  ],
  featureGroups: [
    FeatureGroup(
      heading: 'Core features',
      features: [
        ProductFeature(
          'Facility Management',
          'Manage multiple facilities with facility selection on login.',
        ),
        ProductFeature('Building Information', 'Access surveys, documentation, and drawings.'),
        ProductFeature('Scope of Work', 'Upload documents or schedule activities.'),
        ProductFeature('Preventive Maintenance', 'Schedule and automate routine maintenance.'),
        ProductFeature('Reports & Analytics', 'Generate detailed performance reports.'),
        ProductFeature('Work Requests', 'Client submission and tracking system.'),
        ProductFeature('Work Orders', 'Full lifecycle management and tracking.'),
        ProductFeature('Billing Management', 'Track costs and generate invoices.'),
      ],
    ),
    FeatureGroup(
      heading: 'Security & access control',
      features: [
        ProductFeature(
          'Approval-Based Access',
          'JV Admin approval required after login, even for Play Store downloads.',
        ),
        ProductFeature(
          'Role-Based Permissions',
          'Strict access control based on user roles and functions.',
        ),
        ProductFeature(
          'Document Tracking',
          'Complete audit trail with timestamps for accountability.',
        ),
        ProductFeature(
          'Facility-Based Access',
          'Users only see authorized facility data ensuring privacy.',
        ),
      ],
    ),
  ],
  screenshots: [
    ProductScreenshot(
      'assets/apk/cmms_desktop_view.jpg',
      kind: ScreenshotKind.desktop,
      description: 'NyumbaSmart dashboard interface',
    ),
    ProductScreenshot(
      'assets/apk/cmms_desktop_view1.jpg',
      kind: ScreenshotKind.desktop,
      description: 'NyumbaSmart dashboard section',
    ),
    ProductScreenshot(
      'assets/apk/nyumba_dashboard.jpg',
      kind: ScreenshotKind.phone,
      description: 'NyumbaSmart mobile app view',
    ),
    ProductScreenshot(
      'assets/apk/nyumba_mobile_section.jpg',
      kind: ScreenshotKind.phone,
      description: 'NyumbaSmart mobile section view',
    ),
    ProductScreenshot(
      'assets/apk/cmms_overview.jpg',
      kind: ScreenshotKind.phone,
      description: 'What a CMMS is used for',
    ),
  ],
  storeLink: StoreLink(
    'https://play.google.com/store/apps/details?id=com.jvalmacis.cmms',
    note: 'JV Admin approval required after login.',
  ),
);

const coffeeCorePage = ProductPageContent(
  product: coffeeCore,
  tagline: 'Sow, Safeguard, Soar',
  overview: [
    'CoffeeCore, developed by JV ALMA C.I.S, empowers coffee farmers with specialized tools for '
        'cultivation, market access, and farm management through a cooperative-based system.',
  ],
  groups: [
    ProductAreaGroup(
      heading: 'Administrative system',
      note: 'CoffeeCore features a role-based management system:',
      areas: [
        ProductArea('JV Admin', [
          'Approves cooperative administrator applications',
          'Oversees platform operations and integrity',
          'Manages system-wide configurations',
          'Monitors cooperative registrations',
        ]),
        ProductArea('Cooperative Admin', [
          'Registers cooperative name for farmer selection',
          'Assigns Market Manager and Loan Manager roles',
          'Manages cooperative member database',
          'Oversees cooperative operations on the platform',
        ]),
        ProductArea('Market Manager', [
          'Sets coffee varieties available to cooperative members',
          'Updates market prices for different coffee grades',
          'Provides tailored market insights to members',
          'Manages buyer connections for the cooperative',
        ]),
        ProductArea('Loan Manager', [
          'Reviews and approves member loan applications',
          'Tracks loan repayment schedules',
          'Manages cooperative credit facilities',
          'Provides direct loan access to verified farmers',
        ]),
      ],
    ),
  ],
  featureGroups: [
    FeatureGroup(
      heading: 'Features',
      features: [
        ProductFeature(
          'Cultivation Guidance',
          'Expert tips for coffee planting and growth optimization.',
        ),
        ProductFeature(
          'Cooperative-Specific Pricing',
          'Real-time market prices tailored to your cooperative membership.',
        ),
        ProductFeature('Weather Monitoring', 'Tailored forecasts to protect coffee crops.'),
        ProductFeature('Field Data Input', 'Soil management for sustainable coffee farming.'),
        ProductFeature(
          'Pest and Disease Management',
          'Solutions for coffee-specific pests like berry borers.',
        ),
        ProductFeature(
          'Farm and Loan Management',
          'Track your cooperative loans and repayment schedules.',
        ),
      ],
    ),
    FeatureGroup(
      heading: 'Benefits for farmers',
      features: [
        ProductFeature(
          'Tailored Market Access',
          'Receive market prices and information specific to your cooperative membership, '
              'filtering out irrelevant data from other cooperatives.',
        ),
        ProductFeature(
          'Direct Loan Access',
          'Get loans directly from your cooperative and affiliates without dealing with unknown '
              'creditors or middlemen.',
        ),
        ProductFeature(
          'Streamlined Operations',
          'Cooperatives manage members and loans efficiently through the platform.',
        ),
        ProductFeature(
          'Protected Transactions',
          'Avoid being duped by unauthorized creditors - all loans are managed through verified '
              'cooperative channels.',
        ),
      ],
    ),
  ],
  screenshots: [
    ProductScreenshot(
      'assets/apk/coffee_2.jpg',
      kind: ScreenshotKind.desktop,
      description: 'CoffeeCore farm health centre',
    ),
    ProductScreenshot(
      'assets/apk/coffee_1.jpg',
      kind: ScreenshotKind.desktop,
      description: 'CoffeeCore soil advisor',
    ),
    ProductScreenshot(
      'assets/apk/coffee_3.jpg',
      kind: ScreenshotKind.desktop,
      description: 'CoffeeCore pest diagnostic centre',
    ),
    ProductScreenshot(
      'assets/apk/coffee_4.jpg',
      kind: ScreenshotKind.desktop,
      description: 'CoffeeCore farming guides',
    ),
  ],
  storeLink: StoreLink('https://play.google.com/store/apps/details?id=com.jvalmacis.coffeecore'),
);

const kilimoMkononiPage = ProductPageContent(
  product: kilimoMkononi,
  tagline: 'Farming in the Palm of Your Hand',
  overview: [
    "Choose the platform that fits your needs - whether you're a professional farmer looking to "
        'optimize your operations or an educator bringing agricultural learning to your students.',
  ],
  editions: [
    ProductEdition(
      name: 'Kilimo Mkononi Enterprise',
      subtitle: 'For Farmers & Agricultural Businesses',
      description: 'Professional farming solutions with market insights, weather forecasting, '
          'pest management, and financial tracking tools.',
      features: [
        'Real-time market prices',
        'Comprehensive pest & disease management',
        'Farm Management Financial planning tools',
        'Expert farming guidance',
        'Comprehensive field data input & analysis',
      ],
      route: '/kilimo-mkononi-enterprise',
      status: 'Available now',
      visual: ProductScreenshot(
        'assets/apk/kilimo_2.jpg',
        kind: ScreenshotKind.desktop,
        description: 'Kilimo Mkononi Enterprise farm summary',
      ),
    ),
    ProductEdition(
      name: 'Kilimo Mkononi Education',
      subtitle: 'For Schools & Educational Institutions',
      description: 'Interactive agricultural learning platform with quizzes, simulations, and '
          'built-in student protection features.',
      features: [
        'Safe, verified user system',
        'Interactive quizzes & simulations',
        'Teacher-created content',
        'Progress tracking & reporting',
      ],
      route: '/kilimo-mkononi-education',
      status: 'Coming soon',
    ),
  ],
  featureGroups: [
    FeatureGroup(
      heading: 'Shared core features',
      intro: 'Both platforms are built on the same foundation of agricultural knowledge and tools.',
      features: [
        ProductFeature('Weather Forecasting', '5-day forecasts for better planning'),
        ProductFeature('Market Insights', 'Real-time agricultural market data'),
        ProductFeature('Pest & Disease Management', 'Identification and control strategies'),
        ProductFeature('Farming Guidance', 'Expert tips for multiple crops'),
        ProductFeature('Field Data Input', 'Testing and fertility recommendations'),
        ProductFeature(
          'Financial Farm Management Tracking',
          'Manage cost of production, revenues and loans',
        ),
      ],
    ),
  ],
  // Edition-specific screens are on each edition's page.
  screenshots: [
    ProductScreenshot(
      'assets/apk/kilimo_mkononi.jpg',
      kind: ScreenshotKind.desktop,
      description: 'Kilimo Mkononi edition choice: Enterprise or Education',
    ),
  ],
);

const kilimoEnterprise = SoftwareProduct(
  name: 'Kilimo Mkononi Enterprise',
  subtitle: 'Professional Farming Solutions for Farmers & Enterprises',
  description: 'Professional farming solutions with market insights, weather forecasting, pest '
      'management, and financial tracking tools.',
  capabilities: [],
  route: '/kilimo-mkononi-enterprise',
);

const kilimoEducation = SoftwareProduct(
  name: 'Kilimo Mkononi Education',
  subtitle: 'Safe, Interactive Agricultural Learning for Schools',
  description: 'Interactive agricultural learning platform with quizzes, simulations, and '
      'built-in student protection features.',
  capabilities: [],
  route: '/kilimo-mkononi-education',
);

const kilimoEnterprisePage = ProductPageContent(
  product: kilimoEnterprise,
  eyebrow: 'KILIMO MKONONI · EDITION',
  parent: ('Kilimo Mkononi', '/kilimo-mkononi'),
  status: 'Available now',
  overview: [
    'Developed through hands-on work with farming communities and real-world feedback, Kilimo '
        'Mkononi Enterprise provides farmers with accessible, actionable tools directly on their '
        'mobile phones. Designed for professional farmers and agricultural enterprises growing '
        'Beans, Maize, Carrots, Tomatoes, Onions, Courgettes, and Green Peppers to Grow, Protect, '
        'and Prosper.',
  ],
  featureGroups: [
    FeatureGroup(
      heading: 'Key features',
      features: [
        ProductFeature(
          'Tailored Crop Tips',
          'Practical planting, spacing, soil, and pest guidance specific to selected crops.',
        ),
        ProductFeature(
          'Market Price Advantage',
          'Access to region-specific price predictions to support direct, profitable sales.',
        ),
        ProductFeature(
          'Weather Planning',
          '5-day forecasts to inform planting, irrigation, and harvest schedules.',
        ),
        ProductFeature(
          'Soil Health Mastery',
          'Fertility and pH recommendations based on entered soil test data.',
        ),
        ProductFeature(
          'Crop Protection',
          'Stage-based identification and guidance on managing pests and diseases using chemical '
              'or natural options.',
        ),
        ProductFeature(
          'Farm Finance Tracking',
          'Record-keeping tools for expenses, income, and loan tracking to improve financial '
              'planning.',
        ),
        ProductFeature(
          'Innovative Guides',
          'Certified agricultural techniques to improve yields and introduce sustainable '
              'practices.',
        ),
      ],
    ),
  ],
  // kilimo_1 shows the company account's email; kilimo_2-4 show records
  // from a test farm account. Approved for publication on 5 November 2026.
  screenshots: [
    ProductScreenshot(
      'assets/apk/kilimo_2.jpg',
      kind: ScreenshotKind.desktop,
      description: 'Kilimo Mkononi Enterprise farm summary',
    ),
    ProductScreenshot(
      'assets/apk/kilimo_3.jpg',
      kind: ScreenshotKind.desktop,
      description: 'Kilimo Mkononi Enterprise soil and plot records',
    ),
    ProductScreenshot(
      'assets/apk/kilimo_4.jpg',
      kind: ScreenshotKind.desktop,
      description: 'Kilimo Mkononi Enterprise pest and disease reports',
    ),
    ProductScreenshot(
      'assets/apk/kilimo_1.jpg',
      kind: ScreenshotKind.desktop,
      description: 'Kilimo Mkononi Enterprise menu',
    ),
    ProductScreenshot(
      'assets/apk/kilimo_dashboard.jpg',
      kind: ScreenshotKind.phone,
      description: 'Kilimo Mkononi Enterprise home screen on a phone',
    ),
  ],
  storeLink: StoreLink(
    'https://play.google.com/store/apps/details?id=com.jvalmacis.kilimomkononi&pli=1',
  ),
);

const kilimoEducationPage = ProductPageContent(
  product: kilimoEducation,
  eyebrow: 'KILIMO MKONONI · EDITION',
  parent: ('Kilimo Mkononi', '/kilimo-mkononi'),
  status: 'Coming soon',
  overview: [
    'Kilimo Mkononi Education brings agricultural learning to life through interactive tools, '
        'hands-on simulations, and a secure platform designed specifically for schools, with '
        'built-in student protection measures and educational content.',
    'Its three-tier approval system ensures every user is verified by trusted educational '
        'authorities, protecting students from fraudulent accounts and inappropriate '
        'interactions.',
    "Kilimo Mkononi Education is currently in development, and we're working with schools "
        'to create it.',
  ],
  audience: ['Schools', 'Headteachers', 'Teachers', 'Students'],
  groups: [
    ProductAreaGroup(
      heading: 'Verified roles & responsibilities',
      note: 'The platform uses a hierarchical approval system to ensure accountability and '
          'safety at every level.',
      areas: [
        ProductArea('JV Admin', [
          'Approve and manage headteachers',
          'Oversee platform integrity',
          'Monitor school registrations',
          'Ensure compliance with safety standards',
        ]),
        ProductArea('Headteacher', [
          'Register and verify school teachers',
          'Manage school-level settings',
          'Monitor teacher and student activities',
          'Generate school-wide reports',
        ]),
        ProductArea('Teacher', [
          'Approve and manage students',
          'Create quizzes and simulations',
          'Track student progress',
          'Provide feedback and guidance',
        ]),
        ProductArea('Student', [
          'Complete assigned quizzes',
          'Participate in farm simulations',
          'Access educational materials',
          'Track personal learning progress',
        ]),
      ],
    ),
  ],
  featureGroups: [
    FeatureGroup(
      heading: 'Educational enhancements',
      intro: 'Purpose-built features for interactive agricultural education.',
      features: [
        ProductFeature(
          'Three-Tier Approval System',
          'JV Admin approves headteachers, headteachers approve teachers, and teachers approve '
              'students - ensuring a safe, verified learning environment.',
        ),
        ProductFeature(
          'Role-Based Access',
          'Distinct roles for headteachers, teachers, and students with appropriate permissions '
              'and safeguards for each level.',
        ),
        ProductFeature(
          'Interactive Quizzes',
          'Teachers create custom quizzes to test student knowledge on farming concepts, crop '
              'management, and agricultural science.',
        ),
        ProductFeature(
          'Farm Simulations',
          'Simulation exercises where students can practice farming decisions in a virtual '
              'environment without real-world risks.',
        ),
        ProductFeature(
          'Progress Tracking',
          'Teachers monitor student performance, quiz results, and simulation outcomes to guide '
              'learning paths.',
        ),
        ProductFeature(
          'Curriculum Integration',
          'Content aligned with educational standards, making it easy to integrate into existing '
              'agricultural education programs.',
        ),
      ],
    ),
    FeatureGroup(
      heading: 'Core agricultural features',
      features: [
        ProductFeature(
          'Farming Tips & Best Practices',
          'Comprehensive agricultural guidance tailored for educational purposes and student '
              'learning.',
        ),
        ProductFeature(
          'Market Insights',
          'Real-time market data and pricing trends to teach students about agricultural '
              'economics.',
        ),
        ProductFeature(
          'Weather Forecasting',
          '5-day weather forecasts integrated with lessons on climate impact on agriculture.',
        ),
        ProductFeature(
          'Field Data Input',
          'Hands-on data collection tools for students to document their agricultural projects.',
        ),
        ProductFeature(
          'Pest & Disease Management',
          'Interactive pest identification and management strategies for student research.',
        ),
        ProductFeature(
          'Farm Management Tools',
          'Digital tools for students to plan, track, and manage agricultural projects.',
        ),
        ProductFeature(
          'Educational Manuals',
          'Curriculum-aligned agricultural manuals and reference materials for students.',
        ),
      ],
    ),
  ],
  ctaTitle: 'Interested in bringing this to your school?',
  ctaText: "Let's discuss how Kilimo Mkononi Education can support your school.",
);
