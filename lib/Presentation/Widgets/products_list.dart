import 'package:flutter/material.dart';

import './product_card.dart';
import '../../Domain/Models/product.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key, required this.products}) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ProductCard(products[index]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
    );
  }
}