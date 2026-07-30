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
import 'detail/agribusiness/agribusiness_detail.dart';
import 'detail/oil/oil_gas_services_detail.dart';
import 'detail/it/it_division_detail.dart';
import 'detail/it/cmms_page.dart';
import 'detail/it/alma_works_page.dart';
import 'detail/it/coffee_core_page.dart';
import 'detail/it/kilimo_mkononi_landing_page.dart';
import 'detail/it/kilimo_mkononi_enterprise_page.dart';
import 'detail/it/kilimo_mkononi_education_page.dart';
import 'admin/auth/admin_gate.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase with platform-specific options
  );
  usePathUrlStrategy(); // Keep your URL strategy for clean URLs
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JV ALMA C.I.S',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      onGenerateRoute: (settings) {
        developer.log('MyApp: Generating route for ${settings.name}', name: 'MyApp');
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          case '/business-units':
            return MaterialPageRoute(builder: (_) => const BusinessUnitsPage());
          case '/contact':
            return MaterialPageRoute(builder: (_) => const ContactPage());
          case '/news':
            return MaterialPageRoute(builder: (_) => const NewsPage());
          /*case '/projects':
            return MaterialPageRoute(builder: (_) => const ProjectsPage());*/
          case '/careers':
            return MaterialPageRoute(builder: (_) => const CareersPage());
          case '/certificates':
            return MaterialPageRoute(builder: (_) => const CertificatesPage());
          case '/privacy-policy':
            return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
          case '/cookies':
            return MaterialPageRoute(builder: (_) => const CookiesPage());
            case '/terms':
            return MaterialPageRoute(builder: (_) => const TermsPage());
          case '/delete-account':
            return MaterialPageRoute( builder: (_) => const DeleteAccountPage());
          case '/map':
            return MaterialPageRoute(builder: (_) => const MapPage(address: ''));
          case '/construction-detail':
            return MaterialPageRoute(builder: (_) => const ConstructionDetail());
          case '/agribusiness':
            return MaterialPageRoute(builder: (_) => const AgribusinessDetail());
          case '/oil-gas':
            return MaterialPageRoute(builder: (_) => const OilAndGasServicesDetail());
          case '/it-division':
            return MaterialPageRoute(builder: (_) => const ITDivisionDetail());
          case '/cmms':
            return MaterialPageRoute(builder: (_) => const CmmsPage());
          case '/alma-works':
            return MaterialPageRoute(builder: (_) => const AlmaWorksPage());
          case '/coffee-core':
            return MaterialPageRoute(builder: (_) => const CoffeeCorePage());
          case '/kilimo-mkononi':
            return MaterialPageRoute(builder: (_) => const KilimoMkononiLandingPage());
          case '/kilimo-mkononi-enterprise':
            return MaterialPageRoute(builder: (_) => const KilimoMkononiEnterprisePage());
          case '/kilimo-mkononi-education':
            return MaterialPageRoute(builder: (_) => const KilimoMkononiEducationPage());
          // Intentionally not linked from any nav/footer/sitemap. Real access
          // control is the Firebase Auth + firestore.rules admin check inside
          // AdminGate, not this route's obscurity.
          case '/portal-mgmt':
            return MaterialPageRoute(builder: (_) => const AdminGate());
          default:
            developer.log('Unknown route: ${settings.name}', name: 'MyApp');
            return MaterialPageRoute(
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