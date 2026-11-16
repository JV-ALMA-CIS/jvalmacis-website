import 'package:flutter/material.dart';

import 'it_products.dart';
import 'product_page.dart';

/// The Kilimo Mkononi product page; its content is in `it_products.dart`.
class KilimoMkononiLandingPage extends StatelessWidget {
  const KilimoMkononiLandingPage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: kilimoMkononiPage);
}
