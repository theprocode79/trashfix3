import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/models/orders_model.dart';
import 'package:trashfix2/models/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../providers/details_provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedIndex = 0; // 0 for 'All', 1 for 'Orders', 2 for 'Schedules'
  Future<List<ScheduleModel>> getSchedules() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(ap.uid)
        .collection('schedules')
        .get();

    List<ScheduleModel> schedules = [];
    querySnapshot.docs.forEach((doc) {
      schedules.add(ScheduleModel(
        date: doc['date'],
        createdAt: doc['createdAt'],
        phoneNumber: doc['phoneNumber'],
        time: doc['time'],
        type: doc['type'],
        uid: doc['uid'],
        status: doc['status'],
      ));
    });

    return schedules;
  }

  Future<List<OrdersModel>> getOrders() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(ap.uid)
        .collection('orders')
        .get();

    List<OrdersModel> orders = [];
    querySnapshot.docs.forEach((doc) {
      orders.add(OrdersModel(
        itemId: doc['itemId'],
        amount: doc['amount'],
        createdAt: doc['createdAt'],
        itemName: doc['itemName'],
        phoneNumber: doc['phoneNumber'],
        type: doc['type'],
        uid: doc['uid'],
        status: doc['status'],
      ));
    });

    return orders;
  }

  Future<List<dynamic>> combineData() async {
    List<ScheduleModel> schedules = await getSchedules();
    List<OrdersModel> orders = await getOrders();

    List<dynamic> combinedData = [];
    combinedData.addAll(schedules);
    combinedData.addAll(orders);

    return combinedData;
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: combineData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('History'),
                  backgroundColor: Colors.purple,
                ),
                body: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('History'),
                  backgroundColor: Colors.purple,
                ),
                body: Center(
                    child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                )));
          } else {
            List<dynamic> combinedData = (snapshot.data as List<dynamic>);
            List<dynamic> filteredData = [];
            if (selectedIndex == 0) {
              filteredData = combinedData;
            } else if (selectedIndex == 1) {
              filteredData =
                  combinedData.where((item) => item is OrdersModel).toList();
            } else if (selectedIndex == 2) {
              filteredData =
                  combinedData.where((item) => item is ScheduleModel).toList();
            }
            // Display the transactions in your UI
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.purple,
                title: const Text('History'),
              ),
              body: Column(
                children: [
                  Text(
                    'Available Balance: ${ap.userModel.points}TF Points',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ToggleButtons(
                    fillColor: Colors.green.shade900,
                    selectedColor: Colors.white,
                    borderColor: Colors.grey,
                    borderWidth: 2,
                    borderRadius: BorderRadius.circular(12),
                    isSelected: [
                      selectedIndex == 0,
                      selectedIndex == 1,
                      selectedIndex == 2
                    ],
                    onPressed: (int index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    children: const [
                      Expanded(
                        child: Center(child: Text("All")),
                      ),
                      Expanded(
                        child: Center(child: Text("Orders")),
                      ),
                      Expanded(
                        child: Center(child: Text("Pickups")),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        var item = filteredData[index];
                        if (item is OrdersModel) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.remove)),
                              title: Text('Purchase of ${item.itemName}'),
                              subtitle: Text(DateFormat('dd-MM-yyyy - kk:mm')
                                  .format(DateTime.parse(item.createdAt))),
                              trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '-${item.amount}TF',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                          color: item.status == 'Pending'
                                              ? Colors.yellow.shade700
                                              : Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          );
                        } else {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                                leading: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Icon(
                                      Icons.add_outlined,
                                    )),
                                title: const Text('Pickup'),
                                subtitle: Text(DateFormat('dd-MM-yyyy - kk:mm')
                                    .format(DateTime.parse(item.createdAt))),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      '+10TF',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                          color: item.status == 'Pending'
                                              ? Colors.yellow.shade700
                                              : Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
