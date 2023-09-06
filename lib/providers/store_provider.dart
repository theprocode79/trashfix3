import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreProvider extends ChangeNotifier {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('store_items');
  late Stream<QuerySnapshot> _stream;

  StoreProvider() {
    _stream = _collection.snapshots();
  }

  Stream<QuerySnapshot> get dataStream => _stream;
}
