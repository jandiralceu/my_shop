import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/Helpers/url.dart';

import '../Domain/Models/product.dart';
import '../Domain/Models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    try {
      await http.post(
        UrlHelper.getProductUrl(),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite
          },
        ),
      );

      _items.add(product);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      await http.patch(UrlHelper.getProductUrl(id: id), body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }));

      final index = _items.indexWhere((product) => product.id == id);

      if (index >= 0) {
        _items[index] = newProduct;
      }

      notifyListeners();
    } catch(error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final result = await http.delete(UrlHelper.getProductUrl(id: id));

      if (result.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      } else {
        _items.removeWhere((product) => product.id == id);
        notifyListeners();
      }
    } catch(error) {
      rethrow;
    }
  }

  Future<void> getAllProducts() async {
    try {
      final result = await http.get(UrlHelper.getProductUrl());
      final extractedProducts = json.decode(result.body);

      if (extractedProducts == null) {
        _items = [];
      } else {
        final List<Product> products = [];

        extractedProducts.forEach((id, product) {
          products.add(
            Product(
              id: id,
              price: product['price'],
              title: product['title'],
              imageUrl: product['imageUrl'],
              isFavorite: product['isFavorite'],
              description: product['description'],
            ),
          );
        });

        _items = products;
      }


      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
