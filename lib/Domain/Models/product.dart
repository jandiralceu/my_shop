import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/Domain/Models/http_exception.dart';
import 'package:my_shop/Helpers/url.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final newIsFavoriteValue = !isFavorite;

    try {
      final response = await http.patch(
        UrlHelper.getProductUrl(id: id),
        body: json.encode({
          'isFavorite': newIsFavoriteValue,
        }),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Sorry, error on favorite product');
      } else {
        isFavorite = newIsFavoriteValue;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
