import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'design/app_theme.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/business_units_page.dart';
import 'pages/contact_page.dart';
import 'pages/news_page.dart';
//import 'pages/projects_page.dart';
//import 'pages/references_page.dart';
import 'pages/careers_page.dart';
import 'pages/certificates_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/cookies_page.dart';
import 'pages/terms_page.dart';
import 'pages/delete_account_page.dart';
import 'pages/map_page.dart';
import 'detail/construction/construction_detail.dart';
import 'detail/portfolio/portfolios.dart';
import 'pages/community_impact_content.dart';
import 'pages/community_impact_page.dart';
import 'detail/portfolio/project_page.dart';
import 'detail/agribusiness/agribusiness_detail.dart';
import 'detail/oil/oil_gas_services_detail.dart';
import 'detail/it/it_division_detail.dart';
import 'detail/it/cmms_page.dart';
import 'detail/it/product_page.dart';
import 'detail/it/alma_works_page.dart';
import 'detail/it/coffee_core_page.dart';
import 'detail/it/kilimo_mkononi_landing_page.dart';
import 'detail/it/kilimo_mkononi_enterprise_page.dart';
import 'detail/it/kilimo_mkononi_education_page.dart';
import 'admin/auth/admin_gate.dart';
import 'routing/page_titles.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize Firebase with platform-specific options
  );
  usePathUrlStrategy(); // Keep your URL strategy for clean URLs
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: siteName,
      navigatorObservers: [PageTitleObserver()],
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      onGenerateRoute: (settings) {
        developer.log('MyApp: Generating route for ${settings.name}', name: 'MyApp');
        // One page per portfolio project, e.g. /construction-detail/<slug>
        // and /agribusiness/<slug>.
        if (portfolioProjectForRoute(settings.name) case final found?) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                PortfolioProjectPage(portfolio: found.portfolio, project: found.project),
          );
        }
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());
          case '/about':
            return MaterialPageRoute(settings: settings, builder: (_) => const AboutPage());
          case '/business-units':
            return MaterialPageRoute(settings: settings, builder: (_) => const BusinessUnitsPage());
          case '/contact':
            return MaterialPageRoute(settings: settings, builder: (_) => const ContactPage());
          case '/news':
            return MaterialPageRoute(settings: settings, builder: (_) => const NewsPage());
          /*case '/projects':
            return MaterialPageRoute(settings: settings, builder: (_) => const ProjectsPage());*/
          case '/careers':
            return MaterialPageRoute(settings: settings, builder: (_) => const CareersPage());
          case '/certificates':
            return MaterialPageRoute(settings: settings, builder: (_) => const CertificatesPage());
          case '/privacy-policy':
            return MaterialPageRoute(settings: settings, builder: (_) => const PrivacyPolicyPage());
          case '/cookies':
            return MaterialPageRoute(settings: settings, builder: (_) => const CookiesPage());
          case '/terms':
            return MaterialPageRoute(settings: settings, builder: (_) => const TermsPage());
          case communityImpactRoute:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const CommunityImpactPage(),
            );
          // The page's former address: old links and bookmarks open the page
          // under its new address (Firebase Hosting also redirects it, 301).
          case legacyCommunityRoute:
            return MaterialPageRoute(
              settings: RouteSettings(name: communityImpactRoute, arguments: settings.arguments),
              builder: (_) => const CommunityImpactPage(),
            );
          case '/delete-account':
            return MaterialPageRoute(settings: settings, builder: (_) => const DeleteAccountPage());
          case '/map':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const MapPage(address: ''));
          case '/construction-detail':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const ConstructionDetail());
          case '/agribusiness':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const AgribusinessDetail());
          case '/oil-gas':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const OilAndGasServicesDetail());
          case '/it-division':
            return MaterialPageRoute(settings: settings, builder: (_) => const ITDivisionDetail());
          case '/cmms':
            return MaterialPageRoute(settings: settings, builder: (_) => const CmmsPage());
          case '/alma-safety':
            return MaterialPageRoute(settings: settings, builder: (_) => const AlmaSafetyPage());
          case '/alma-hub':
            return MaterialPageRoute(settings: settings, builder: (_) => const AlmaHubPage());
          case '/alma-works':
            return MaterialPageRoute(settings: settings, builder: (_) => const AlmaWorksPage());
          case '/coffee-core':
            return MaterialPageRoute(settings: settings, builder: (_) => const CoffeeCorePage());
          case '/kilimo-mkononi':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const KilimoMkononiLandingPage());
          case '/kilimo-mkononi-enterprise':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const KilimoMkononiEnterprisePage());
          case '/kilimo-mkononi-education':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const KilimoMkononiEducationPage());
          // Intentionally not linked from any nav/footer/sitemap. Real access
          // control is the Firebase Auth + firestore.rules admin check inside
          // AdminGate, not this route's obscurity.
          case '/portal-mgmt':
            return MaterialPageRoute(settings: settings, builder: (_) => const AdminGate());
          default:
            developer.log('Unknown route: ${settings.name}', name: 'MyApp');
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Page Not Found')),
                body: const Center(
                  child: Text('404 - Page Not Found'),
                ),
              ),
            );
        }
      },
    );
  }
}
