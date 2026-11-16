import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../detail/portfolio/portfolios.dart';

/// Name shown in search results and browser tabs.
const siteName = 'JV ALMA C.I.S';

/// Title for the home page, which also names what the company does so that
/// a search for the company shows its services.
const homeTitle = 'JV ALMA C.I.S | Construction, Agribusiness, Oil & Gas and IT in Kenya';

/// Page names by route. Each tab reads "<page> | JV ALMA C.I.S".
const _pageNames = <String, String>{
  '/about': 'About Us',
  '/business-units': 'Business Units',
  '/contact': 'Contact Us',
  '/news': 'News & Updates',
  '/careers': 'Careers',
  '/certificates': 'Certificates & Compliance',
  '/privacy-policy': 'Privacy Policy',
  '/cookies': 'Cookies Policy',
  '/terms': 'Terms and Conditions',
  '/delete-account': 'Delete Account',
  '/community-impact': 'Community & Impact',
  // Former address of Community & Impact, which opens it.
  '/community-development': 'Community & Impact',
  '/map': 'Map',
  '/construction-detail': 'Construction',
  '/agribusiness': 'Agribusiness',
  '/oil-gas': 'Oil & Gas Services',
  '/it-division': 'IT Division',
  '/cmms': 'NyumbaSmart',
  '/alma-works': 'AlmaWorks',
  '/alma-safety': 'AlmaSafety',
  '/alma-hub': 'AlmaHub',
  '/coffee-core': 'CoffeeCore',
  '/kilimo-mkononi': 'Kilimo Mkononi',
  '/kilimo-mkononi-enterprise': 'Kilimo Mkononi Enterprise',
  '/kilimo-mkononi-education': 'Kilimo Mkononi Education',
  '/portal-mgmt': 'Admin',
};

/// The document title for [route]; unknown routes get "Page not found".
String pageTitleFor(String? route) {
  if (route == null || route == '/') return homeTitle;
  if (portfolioProjectForRoute(route) case (:final portfolio, :final project)) {
    return '${project.title.split(',').first.replaceFirst(RegExp(r'\.$'), '')} | ${portfolio.unit} | $siteName';
  }
  final name = _pageNames[route] ?? 'Page not found';
  return '$name | $siteName';
}

/// Keeps the browser tab title in step with the page on screen.
class PageTitleObserver extends NavigatorObserver {
  void _update(Route<dynamic>? route) {
    if (route is! PageRoute) return;
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(label: pageTitleFor(route.settings.name)),
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _update(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _update(previousRoute);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _update(newRoute);
}
