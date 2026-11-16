import 'package:flutter/material.dart';

import 'it_products.dart';
import 'product_page.dart';

/// The CoffeeCore product page; its content is in `it_products.dart`.
class CoffeeCorePage extends StatelessWidget {
  const CoffeeCorePage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: coffeeCorePage);
}
