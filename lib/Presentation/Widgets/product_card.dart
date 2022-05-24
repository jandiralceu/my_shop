import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/cart.dart';
import '../../Domain/Models/product.dart';
import '../../Presentation/Screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: product.id,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () => product.toggleFavoriteStatus(),
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            onPressed: () =>
                cart.addItem(product.imageUrl, product.price, product.title),
            color: Theme.of(context).accentColor,
            icon: const Icon(Icons.shopping_cart),
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
