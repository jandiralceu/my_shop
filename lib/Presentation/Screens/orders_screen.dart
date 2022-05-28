import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/orders.dart';
import '../../Presentation/Widgets/app_drawer.dart';
import '../../Presentation/Widgets/order_item_details.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order resume'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getOrders(),
        builder: (_, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                        itemCount: ordersData.orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderItemDetails(ordersData.orders[index]),
                      ));
            }
          }
        },
      ),
    );
  }
}
