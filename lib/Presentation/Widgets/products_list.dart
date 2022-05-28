import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../../Providers/products.dart';

class ProductsList extends StatelessWidget {
  const ProductsList(this.showFavoritesProducts, {Key? key}) : super(key: key);

  final bool showFavoritesProducts;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavoritesProducts
        ? productsData.favoritesProducts
        : productsData.items;

    return products.isEmpty
        ? const Center(
            child: Text('No Product '
                'available'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: const ProductItem(),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
          );
  }
}
