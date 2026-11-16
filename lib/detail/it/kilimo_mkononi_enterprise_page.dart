import 'package:flutter/material.dart';

import 'it_products.dart';
import 'product_page.dart';

/// The Kilimo Mkononi Enterprise page; its content is in `it_products.dart`.
class KilimoMkononiEnterprisePage extends StatelessWidget {
  const KilimoMkononiEnterprisePage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: kilimoEnterprisePage);
}
