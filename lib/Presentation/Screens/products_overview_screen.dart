import 'package:flutter/material.dart';
import 'package:my_shop/Providers/products.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../Widgets/badge.dart';
import '../../Providers/cart.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/products_list.dart';

enum FiltersOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavoritesProducts = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      Provider.of<Products>(context, listen: false).getAllProducts();
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Show Favorites'),
                value: FiltersOptions.favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All Products'),
                value: FiltersOptions.all,
              ),
            ],
            onSelected: (FiltersOptions selectedOption) {
              setState(() {
                if (selectedOption == FiltersOptions.favorites) {
                  showFavoritesProducts = true;
                } else {
                  showFavoritesProducts = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsList(showFavoritesProducts),
    );
  }
}
