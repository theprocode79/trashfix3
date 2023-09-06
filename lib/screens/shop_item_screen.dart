import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/models/orders_model.dart';
import 'package:trashfix2/widgets/custom_button.dart';

import '../providers/details_provider.dart';
import '../utils/utils.dart';

class ShopItemScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ShopItemScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ShopItemScreen> createState() => _ShopItemScreenState();
}

class _ShopItemScreenState extends State<ShopItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.data['image_url']),
            const SizedBox(height: 20),
            Text(
              widget.data['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.data['amount'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            CustomButton(text: "Place Order", onPressed: () => storeData())
          ],
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    OrdersModel ordersModel = OrdersModel(
      type: "Order",
      itemId: widget.data['itemId'],
      createdAt: DateTime.now().toString(),
      phoneNumber: ap.userModel.phoneNumber,
      uid: ap.userModel.uid,
      amount: widget.data['amount'],
      itemName: widget.data['name'],
      status: "Pending",
    );
    ap.saveOrdersDataToFirebase(
        context: context,
        ordersModel: ordersModel,
        onSuccess: () {
          showSnackBar(context, "Placed the order, see you soon!");
        });
  }
}
