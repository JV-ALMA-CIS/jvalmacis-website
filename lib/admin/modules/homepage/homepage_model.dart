class ClientLogo {
  const ClientLogo({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.order,
  });

  final String id;
  final String imageUrl;
  final String name;
  final int order;

  factory ClientLogo.fromMap(Map<String, dynamic> m) => ClientLogo(
        id: m['id'] as String? ?? '',
        imageUrl: m['imageUrl'] as String? ?? '',
        name: m['name'] as String? ?? '',
        order: m['order'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'imageUrl': imageUrl,
        'name': name,
        'order': order,
      };

  ClientLogo copyWith({String? imageUrl, String? name, int? order}) => ClientLogo(
        id: id,
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        order: order ?? this.order,
      );
}

class HomepageContent {
  const HomepageContent({
    required this.heroTitle,
    required this.heroCtaText,
    required this.heroCtaRoute,
    required this.heroBackgroundImageUrl,
    required this.ctaBandTitle,
    required this.ctaBandSubtitle,
    required this.ctaBandButtonText,
    required this.ctaBandButtonRoute,
    required this.clientLogos,
  });

  final String heroTitle;
  final String heroCtaText;
  final String heroCtaRoute;
  final String heroBackgroundImageUrl;
  final String ctaBandTitle;
  final String ctaBandSubtitle;
  final String ctaBandButtonText;
  final String ctaBandButtonRoute;
  final List<ClientLogo> clientLogos;

  factory HomepageContent.fromMap(Map<String, dynamic> data) {
    return HomepageContent(
      heroTitle: data['heroTitle'] as String? ?? defaultHomepageContent.heroTitle,
      heroCtaText: data['heroCtaText'] as String? ?? defaultHomepageContent.heroCtaText,
      heroCtaRoute: data['heroCtaRoute'] as String? ?? defaultHomepageContent.heroCtaRoute,
      heroBackgroundImageUrl: data['heroBackgroundImageUrl'] as String? ??
          defaultHomepageContent.heroBackgroundImageUrl,
      ctaBandTitle: data['ctaBandTitle'] as String? ?? defaultHomepageContent.ctaBandTitle,
      ctaBandSubtitle: data['ctaBandSubtitle'] as String? ?? defaultHomepageContent.ctaBandSubtitle,
      ctaBandButtonText:
          data['ctaBandButtonText'] as String? ?? defaultHomepageContent.ctaBandButtonText,
      ctaBandButtonRoute:
          data['ctaBandButtonRoute'] as String? ?? defaultHomepageContent.ctaBandButtonRoute,
      clientLogos: (data['clientLogos'] as List<dynamic>?)
              ?.map((e) => ClientLogo.fromMap(e as Map<String, dynamic>))
              .toList() ??
          defaultHomepageContent.clientLogos,
    );
  }

  Map<String, dynamic> toMap() => {
        'heroTitle': heroTitle,
        'heroCtaText': heroCtaText,
        'heroCtaRoute': heroCtaRoute,
        'heroBackgroundImageUrl': heroBackgroundImageUrl,
        'ctaBandTitle': ctaBandTitle,
        'ctaBandSubtitle': ctaBandSubtitle,
        'ctaBandButtonText': ctaBandButtonText,
        'ctaBandButtonRoute': ctaBandButtonRoute,
        'clientLogos': clientLogos.map((e) => e.toMap()).toList(),
      };
}

/// The site's original hardcoded homepage content — hero, CTA band and
/// client logo strip. Used as seed content and as the fallback while
/// Firestore is loading, empty, or unreachable.
const defaultHomepageContent = HomepageContent(
  heroTitle: 'For Construction, Agribusiness, Oil & Gas Services, and IT Solutions',
  heroCtaText: 'Contact Us',
  heroCtaRoute: '/contact',
  heroBackgroundImageUrl: 'assets/images/company_background.jpg',
  ctaBandTitle: 'Ready to Collaborate?',
  ctaBandSubtitle: "Let's build a sustainable future together.",
  ctaBandButtonText: 'Contact Us',
  ctaBandButtonRoute: '/contact',
  clientLogos: [
    ClientLogo(id: 'kvda', imageUrl: 'assets/images/clients/kvda.jpg', name: 'KVDA', order: 0),
    ClientLogo(id: 'sweden', imageUrl: 'assets/images/clients/sweden.jpg', name: 'Sweden', order: 1),
    ClientLogo(id: 'italy', imageUrl: 'assets/images/clients/italy.jpg', name: 'Italy', order: 2),
    ClientLogo(id: 'usa', imageUrl: 'assets/images/clients/usa.jpg', name: 'USA', order: 3),
    ClientLogo(id: 'navfac', imageUrl: 'assets/images/clients/navfac.jpg', name: 'NAVFAC', order: 4),
    ClientLogo(id: 'portugal', imageUrl: 'assets/images/clients/portugal.jpg', name: 'Portugal', order: 5),
    ClientLogo(id: 'iadc', imageUrl: 'assets/images/clients/iadc.jpg', name: 'IADC', order: 6),
    ClientLogo(id: 'total', imageUrl: 'assets/images/clients/total.jpg', name: 'Total', order: 7),
    ClientLogo(id: 'eni', imageUrl: 'assets/images/clients/eni.jpg', name: 'ENI', order: 8),
  ],
);
