import 'package:flutter/material.dart';

import 'it_products.dart';
import 'product_page.dart';

/// The AlmaWorks product page; its content is in `it_products.dart`.
class AlmaWorksPage extends StatelessWidget {
  const AlmaWorksPage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: almaWorksPage);
}
