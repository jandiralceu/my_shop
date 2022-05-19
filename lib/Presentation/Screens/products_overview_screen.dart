import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/products.dart';
import '../Widgets/products_list.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: ProductsList(products: products),
    );
  }
}
