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
    'tagline': 'Civil Works & Systems',
    'description':
        'Comprehensive civil works including diplomatic and residential projects, infrastructure development, and facility maintenance management.',
    'iconKey': 'building',
    'accentColorKey': 'construction',
    'imageUrl': '',
    'route': '/construction-detail',
    'ctaText': 'Learn more',
    'featured': true,
    'order': 0,
    'published': true,
  }),
  BusinessUnit.fromMap('seed-agribusiness', const {
    'title': 'Agribusiness',
    'tagline': 'Infrastructure, Training and Digitization',
    'description':
        'Empowering farmers with modern agricultural solutions, technical services, and smart digital farming tools promoting sustainable agriculture.',
    'iconKey': 'sprout',
    'accentColorKey': 'agribusiness',
    'imageUrl': '',
    'route': '/agribusiness',
    'ctaText': 'Learn more',
    'featured': true,
    'order': 1,
    'published': true,
  }),
  BusinessUnit.fromMap('seed-oil-gas', const {
    'title': 'Oil & Gas Services',
    'tagline': 'Inspection and Regulatory Compliance',
    'description':
        'Specialized inspection services and regulatory compliance for the oil and gas industry with certified expertise.',
    'iconKey': 'droplets',
    'accentColorKey': 'oilGas',
    'imageUrl': '',
    'route': '/oil-gas',
    'ctaText': 'Learn more',
    'featured': true,
    'order': 2,
    'published': true,
  }),
  BusinessUnit.fromMap('seed-it-division', const {
    'title': 'IT Division',
    'tagline': 'Digital Solutions',
    'description':
        'Cutting-edge software solutions including NyumbaSmart CMMS, CoffeeCore, and KilimoMkononi agricultural applications.',
    'iconKey': 'globe',
    'accentColorKey': 'it',
    'imageUrl': '',
    'route': '/it-division',
    'ctaText': 'Learn more',
    'featured': true,
    'order': 3,
    'published': true,
  }),
];
