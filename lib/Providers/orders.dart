import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Helpers/url.dart';
import '../Domain/Models/order_item.dart';
import '../Domain/Models/cart_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final timestamp = DateTime.now();

      final result = await http.post(
        UrlHelper.getOrderUrl(),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cartProduct) => {
                  'id': cartProduct.id,
                  'price': cartProduct.price,
                  'title': cartProduct.title,
                  'quantity': cartProduct.quantity,
                },
              )
              .toList(),
        }),
      );

      _orders.insert(
          0,
          OrderItem(
            id: json.decode(result.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp,
          ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getOrders() async {
    try {
      final response = await http.get(UrlHelper.getOrderUrl());
      final extractedOrders = json.decode(response.body);

      if (extractedOrders == null) {
        _orders = [];
      } else {
        final List<OrderItem> loadedOrders = [];

        extractedOrders.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ));
        });

        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
