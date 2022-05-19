import 'package:flutter/material.dart';
import 'package:my_shop/Presentation/Screens/product_detail_screen.dart';

import '../../Domain/Models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
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
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            onPressed: () {},
            color: Theme.of(context).accentColor,
            icon: const Icon(Icons.shopping_cart),
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
