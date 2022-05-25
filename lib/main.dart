import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Providers/cart.dart';
import './Providers/orders.dart';
import './Providers/products.dart';
import './Presentation/Screens/cart_screen.dart';
import './Presentation/Screens/orders_screen.dart';
import './Presentation/Screens/product_detail_screen.dart';
import './Presentation/Screens/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          CartScreen.routeName: (_) => const CartScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
          ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
        },
      ),
    );
  }
}
