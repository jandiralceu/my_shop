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
  var _loading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _loading = true;
      });
      await Provider.of<Orders>(context, listen: false).getOrders();
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order resume'),
      ),
      drawer: const AppDrawer(),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (ctx, index) =>
                  OrderItemDetails(ordersData.orders[index]),
            ),
    );
  }
}
