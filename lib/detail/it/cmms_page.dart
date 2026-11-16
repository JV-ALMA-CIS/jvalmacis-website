import 'package:flutter/material.dart';

import 'it_products.dart';
import 'product_page.dart';

/// The NyumbaSmart product page; its content is in `it_products.dart`.
class CmmsPage extends StatelessWidget {
  const CmmsPage({super.key});

  @override
  Widget build(BuildContext context) => const ProductPage(content: nyumbaSmartPage);
}
