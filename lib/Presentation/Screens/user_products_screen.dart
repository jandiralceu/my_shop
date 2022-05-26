import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import './edit_product_screen.dart';
import '../../Providers/products.dart';
import '../Widgets/user_product_item_details.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (ctx, index) => Column(
            children: [
              UserProductItemDetails(
                id: productsData.items[index].id,
                key: Key(productsData.items[index].id),
                title: productsData.items[index].title,
                imageUrl: productsData.items[index].imageUrl,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
