import 'package:flutter/material.dart';

import 'it_products.dart';
import 'product_page.dart';

/// The Kilimo Mkononi Education page; its content is in `it_products.dart`.
class KilimoMkononiEducationPage extends StatelessWidget {
  const KilimoMkononiEducationPage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: kilimoEducationPage);
}
