class OrdersModel {
  String type;
  String uid;
  String phoneNumber;
  String createdAt;
  String amount;
  String itemId;
  String itemName;
  String status;

  OrdersModel({
    required this.type,
    required this.uid,
    required this.phoneNumber,
    required this.createdAt,
    required this.amount,
    required this.itemId,
    required this.itemName,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "amount": amount,
      "itemId": itemId,
      "itemName": itemName,
      "status": status,
    };
  }
}
