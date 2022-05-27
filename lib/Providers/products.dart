import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Domain/Models/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [];
  static final baseUrl = Uri.parse('https://jandir-my-shop-default-rtdb'
      '.firebaseio.com/products.json');

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    try {
      await http.post(
        baseUrl,
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

  void updateProduct(String id, Product newProduct) {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  Future<void> getAllProducts() async {
    try {
      final result = await http.get(baseUrl);
      final products = json.decode(result.body) as Map<String, dynamic>;

      products.forEach((id, product) {
        _items.add(
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

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
