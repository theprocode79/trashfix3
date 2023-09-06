class ScheduleModel {
  String type;
  String date;
  String time;
  String uid;
  String phoneNumber;
  String createdAt;
  String status;

  ScheduleModel({
    required this.type,
    required this.date,
    required this.time,
    required this.uid,
    required this.phoneNumber,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "date": date,
      "time": time,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "status": status,
    };
  }
}
