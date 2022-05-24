import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_card.dart';
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

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductCard(),
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
