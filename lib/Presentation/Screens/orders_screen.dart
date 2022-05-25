import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/orders.dart';
import '../../Presentation/Widgets/app_drawer.dart';
import '../../Presentation/Widgets/order_item_details.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order resume'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, index) => OrderItemDetails(ordersData.orders[index]),
      ),
    );
  }
}
