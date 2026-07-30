class OfficeLocation {
  const OfficeLocation({
    required this.id,
    required this.label,
    required this.address,
    required this.mapQuery,
    required this.order,
  });

  final String id;
  final String label;
  final String address;
  final String mapQuery;
  final int order;

  factory OfficeLocation.fromMap(Map<String, dynamic> m) => OfficeLocation(
        id: m['id'] as String? ?? '',
        label: m['label'] as String? ?? '',
        address: m['address'] as String? ?? '',
        mapQuery: m['mapQuery'] as String? ?? '',
        order: m['order'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'address': address,
        'mapQuery': mapQuery,
        'order': order,
      };

  OfficeLocation copyWith({String? label, String? address, String? mapQuery, int? order}) {
    return OfficeLocation(
      id: id,
      label: label ?? this.label,
      address: address ?? this.address,
      mapQuery: mapQuery ?? this.mapQuery,
      order: order ?? this.order,
    );
  }
}

class NavItem {
  const NavItem({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
    required this.order,
    required this.showInHeader,
    required this.showInDrawer,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
  final int order;
  final bool showInHeader;
  final bool showInDrawer;

  factory NavItem.fromMap(Map<String, dynamic> m) => NavItem(
        id: m['id'] as String? ?? '',
        label: m['label'] as String? ?? '',
        route: m['route'] as String? ?? '',
        iconKey: m['iconKey'] as String? ?? 'home',
        order: m['order'] as int? ?? 0,
        showInHeader: m['showInHeader'] as bool? ?? true,
        showInDrawer: m['showInDrawer'] as bool? ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'route': route,
        'iconKey': iconKey,
        'order': order,
        'showInHeader': showInHeader,
        'showInDrawer': showInDrawer,
      };

  NavItem copyWith({
    String? label,
    String? route,
    String? iconKey,
    int? order,
    bool? showInHeader,
    bool? showInDrawer,
  }) {
    return NavItem(
      id: id,
      label: label ?? this.label,
      route: route ?? this.route,
      iconKey: iconKey ?? this.iconKey,
      order: order ?? this.order,
      showInHeader: showInHeader ?? this.showInHeader,
      showInDrawer: showInDrawer ?? this.showInDrawer,
    );
  }
}

class SiteSettings {
  const SiteSettings({
    required this.companyName,
    required this.companyEmail,
    required this.companyPhone,
    required this.officeLocations,
    required this.linkedinUrl,
    required this.instagramUrl,
    required this.twitterUrl,
    required this.navigation,
    required this.footerTagline,
    required this.copyrightText,
    required this.logoImageUrl,
  });

  final String companyName;
  final String companyEmail;
  final String companyPhone;
  final List<OfficeLocation> officeLocations;
  final String linkedinUrl;
  final String instagramUrl;
  final String twitterUrl;
  final List<NavItem> navigation;
  final String footerTagline;
  final String copyrightText;
  final String logoImageUrl;

  factory SiteSettings.fromMap(Map<String, dynamic> data) {
    final social = data['social'] as Map<String, dynamic>?;
    final footer = data['footer'] as Map<String, dynamic>?;
    return SiteSettings(
      companyName: data['companyName'] as String? ?? defaultSiteSettings.companyName,
      companyEmail: data['companyEmail'] as String? ?? defaultSiteSettings.companyEmail,
      companyPhone: data['companyPhone'] as String? ?? defaultSiteSettings.companyPhone,
      officeLocations: (data['officeLocations'] as List<dynamic>?)
              ?.map((e) => OfficeLocation.fromMap(e as Map<String, dynamic>))
              .toList() ??
          defaultSiteSettings.officeLocations,
      linkedinUrl: social?['linkedin'] as String? ?? defaultSiteSettings.linkedinUrl,
      instagramUrl: social?['instagram'] as String? ?? defaultSiteSettings.instagramUrl,
      twitterUrl: social?['twitter'] as String? ?? defaultSiteSettings.twitterUrl,
      navigation: (data['navigation'] as List<dynamic>?)
              ?.map((e) => NavItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          defaultSiteSettings.navigation,
      footerTagline: footer?['tagline'] as String? ?? defaultSiteSettings.footerTagline,
      copyrightText: footer?['copyrightText'] as String? ?? defaultSiteSettings.copyrightText,
      logoImageUrl: data['logoImageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'companyName': companyName,
        'companyEmail': companyEmail,
        'companyPhone': companyPhone,
        'officeLocations': officeLocations.map((e) => e.toMap()).toList(),
        'social': {
          'linkedin': linkedinUrl,
          'instagram': instagramUrl,
          'twitter': twitterUrl,
        },
        'navigation': navigation.map((e) => e.toMap()).toList(),
        'footer': {
          'tagline': footerTagline,
          'copyrightText': copyrightText,
        },
        'logoImageUrl': logoImageUrl,
      };
}

/// The site's original hardcoded contact/nav/footer content — collapses
/// what used to be three drifting sources (config.dart, footer.dart,
/// header.dart's two separate nav lists) into one. Used as seed content and
/// as the fallback while Firestore is loading/empty/unreachable.
const defaultSiteSettings = SiteSettings(
  companyName: 'JV Alma CIS Kenya',
  companyEmail: 'support@jvalmacis.co.ke',
  companyPhone: '+254 795 802 020',
  officeLocations: [
    OfficeLocation(
      id: 'hq',
      label: 'HQ Office',
      address: 'Kingara Heights, Nairobi, Kenya',
      mapQuery: 'Kingara Heights, Nairobi, Kenya',
      order: 0,
    ),
    OfficeLocation(
      id: 'branch',
      label: 'Branch Office',
      address: 'Manipur Plaza, Mombasa, Kenya',
      mapQuery: 'Manipur Plaza, Mombasa, Kenya',
      order: 1,
    ),
  ],
  linkedinUrl: 'https://www.linkedin.com/company/jvalmacis/',
  instagramUrl: 'https://www.instagram.com/jvalmacis/',
  twitterUrl: 'https://twitter.com/jvalmacis',
  navigation: [
    NavItem(
      id: 'home',
      label: 'Home',
      route: '/',
      iconKey: 'home',
      order: 0,
      showInHeader: true,
      showInDrawer: true,
    ),
    NavItem(
      id: 'about',
      label: 'About Us',
      route: '/about',
      iconKey: 'info',
      order: 1,
      showInHeader: true,
      showInDrawer: true,
    ),
    NavItem(
      id: 'business-units',
      label: 'Business Units',
      route: '/business-units',
      iconKey: 'building2',
      order: 2,
      showInHeader: true,
      showInDrawer: true,
    ),
    NavItem(
      id: 'careers',
      label: 'Careers',
      route: '/careers',
      iconKey: 'users',
      order: 3,
      showInHeader: false,
      showInDrawer: true,
    ),
    NavItem(
      id: 'news',
      label: 'News',
      route: '/news',
      iconKey: 'newspaper',
      order: 4,
      showInHeader: true,
      showInDrawer: true,
    ),
    NavItem(
      id: 'contact',
      label: 'Contact',
      route: '/contact',
      iconKey: 'phone',
      order: 5,
      showInHeader: false,
      showInDrawer: true,
    ),
  ],
  footerTagline:
      'Leading provider of construction, agribusiness, oil & gas services, and IT solutions across East Africa.',
  copyrightText: '© 2026 Copyright JV ALMA C.I.S Kenya.',
  logoImageUrl: '',
);
