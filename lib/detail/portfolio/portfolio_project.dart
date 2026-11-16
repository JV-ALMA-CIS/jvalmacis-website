/// Project portfolios shared by the business units: the data behind each
/// unit's project carousel and every project's own page.
///
/// A unit lists its projects as [PortfolioProject]s and describes itself
/// with a [Portfolio]; `portfolios.dart` registers each portfolio so its
/// project pages get routes and tab titles. Remember new URLs in
/// `web/index.html` (PAGES) and `web/sitemap.xml`.
library;

/// Route argument marking a project page opened from a carousel, so its
/// back link returns to that carousel instead of opening a new one.
const fromPortfolio = 'fromPortfolio';

class ProjectImage {
  const ProjectImage(this.path, {this.isLogo = false, this.caption});

  final String path;

  /// A logo or artwork rather than a photograph: shown whole on a light
  /// surface instead of cropped to fill the frame.
  final bool isLogo;

  /// Shown under the image and read out to screen readers.
  final String? caption;
}

class ProjectTestimonial {
  const ProjectTestimonial(this.quote, this.attribution);

  final String quote;
  final String attribution;
}

/// A numbered point in a project's overview, with a bold lead-in.
class ProjectFocusArea {
  const ProjectFocusArea(this.title, this.text);

  final String title;
  final String text;
}

class PortfolioProject {
  const PortfolioProject({
    required this.section,
    required this.slug,
    required this.title,
    this.client,
    this.clientLabel = 'Client',
    this.clientLogo,
    this.funder,
    this.location,
    this.period,
    this.status,
    required this.description,
    this.focusAreas = const [],
    this.closing,
    required this.images,
    this.coverIndex = 0,
    this.testimonial,
  });

  /// Route of the unit page the project belongs to.
  final String section;

  /// URL segment: `<section>/<slug>`.
  final String slug;
  final String title;
  final String? client;

  /// How [client] is labelled, e.g. "Collaboration" for a joint pilot.
  final String clientLabel;

  /// The client's logo, shown beside its name.
  final String? clientLogo;
  final String? funder;
  final String? location;

  /// When the work ran; left out when it has not been provided.
  final String? period;

  /// Shown instead of a period when there is none, e.g. "Ongoing".
  final String? status;

  /// Overview paragraphs, separated by blank lines.
  final String description;

  /// Numbered points after the description, if any.
  final List<ProjectFocusArea> focusAreas;

  /// A paragraph after the numbered points.
  final String? closing;

  /// Every image of the project, in gallery order.
  final List<ProjectImage> images;

  /// Which of [images] represents the project in the carousel and leads
  /// its page.
  final int coverIndex;
  final ProjectTestimonial? testimonial;

  ProjectImage get cover => images[coverIndex];
  String get route => '$section/$slug';

  /// The period, or the status when there is no period.
  String? get timing => period ?? status;
}

/// A business unit's portfolio.
class Portfolio {
  const Portfolio({
    required this.route,
    required this.unit,
    required this.projects,
  });

  /// Route of the unit page that holds the carousel.
  final String route;

  /// The unit's name, as in "Construction Projects" and tab titles.
  final String unit;
  final List<PortfolioProject> projects;

  String get projectsTitle => '$unit Projects';

  /// The project whose page lives at [path], if any.
  PortfolioProject? projectAt(String? path) {
    if (path == null || !path.startsWith('$route/')) return null;
    final slug = path.substring(route.length + 1).replaceAll(RegExp(r'/+$'), '');
    for (final project in projects) {
      if (project.slug == slug) return project;
    }
    return null;
  }
}
