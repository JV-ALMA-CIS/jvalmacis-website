import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessUnit {
  const BusinessUnit({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.iconKey,
    required this.accentColorKey,
    required this.imageUrl,
    required this.route,
    required this.ctaText,
    required this.featured,
    required this.order,
    required this.published,
  });

  final String id;
  final String title;

  /// Short teaser used on the homepage card.
  final String tagline;

  /// Full description used on the Business Units page.
  final String description;

  final String iconKey;
  final String accentColorKey;
  final String imageUrl;
  final String route;
  final String ctaText;
  final bool featured;
  final int order;
  final bool published;

  factory BusinessUnit.fromMap(String id, Map<String, dynamic> data) {
    return BusinessUnit(
      id: id,
      title: data['title'] as String? ?? '',
      tagline: data['tagline'] as String? ?? '',
      description: data['description'] as String? ?? '',
      iconKey: data['iconKey'] as String? ?? 'building',
      accentColorKey: data['accentColorKey'] as String? ?? 'primary',
      imageUrl: data['imageUrl'] as String? ?? '',
      route: data['route'] as String? ?? '',
      ctaText: data['ctaText'] as String? ?? 'Learn more',
      featured: data['featured'] as bool? ?? true,
      order: data['order'] as int? ?? 0,
      published: data['published'] as bool? ?? true,
    );
  }

  factory BusinessUnit.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return BusinessUnit.fromMap(doc.id, doc.data() ?? const {});
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'tagline': tagline,
        'description': description,
        'iconKey': iconKey,
        'accentColorKey': accentColorKey,
        'imageUrl': imageUrl,
        'route': route,
        'ctaText': ctaText,
        'featured': featured,
        'order': order,
        'published': published,
      };
}

/// The site's original hardcoded business units, used both as the seed
/// content written to Firestore on first setup and as the fallback shown
/// while Firestore is loading, empty, or unreachable.
final List<BusinessUnit> defaultBusinessUnits = [
  BusinessUnit.fromMap('seed-construction', const {
    'title': 'Construction',
    'tagline': 'Construction & Facility Management',
    'description': 'Construction and Facility management services.',
    'iconKey': 'building',
    'accentColorKey': 'construction',
    'imageUrl': 'assets/images/construction_1.jpg',
    'route': '/construction-detail',
    'ctaText': 'Explore capabilities',
    'featured': true,
    'order': 0,
    'published': true,
  }),
  BusinessUnit.fromMap('seed-agribusiness', const {
    'title': 'Agribusiness',
    'tagline': 'Infrastructure, Training and Capacity Building',
    'description': 'Agricultural services, community empowerment and capacity building.',
    'iconKey': 'sprout',
    'accentColorKey': 'agribusiness',
    'imageUrl': 'assets/images/agribusiness_1.jpg',
    'route': '/agribusiness',
    'ctaText': 'Explore capabilities',
    'featured': true,
    'order': 1,
    'published': true,
  }),
  BusinessUnit.fromMap('seed-oil-gas', const {
    'title': 'Oil & Gas Services',
    'tagline': 'Inspection and Regulatory Compliance',
    'description': 'Inspection and related operational services.',
    'iconKey': 'droplets',
    'accentColorKey': 'oilGas',
    'imageUrl': 'assets/images/oil.jpg',
    'route': '/oil-gas',
    'ctaText': 'Explore capabilities',
    'featured': true,
    'order': 2,
    'published': true,
  }),
  BusinessUnit.fromMap('seed-it-division', const {
    'title': 'IT Division',
    'tagline': 'Software Development & Digital Platforms',
    'description': 'Proprietary software for our own operations, and for the agricultural sector.',
    'iconKey': 'globe',
    'accentColorKey': 'it',
    'imageUrl': 'assets/images/it.jpg',
    'route': '/it-division',
    'ctaText': 'Explore capabilities',
    'featured': true,
    'order': 3,
    'published': true,
  }),
];
