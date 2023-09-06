class UserModel {
  String name;
  String email;
  String address;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  String points;

  UserModel(
      {required this.name,
      required this.email,
      required this.address,
      required this.profilePic,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid,
      required this.points});

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        address: map['address'] ?? '',
        profilePic: map['profilePic'] ?? '',
        createdAt: map['createdAt'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        uid: map['uid'] ?? '',
        points: map['points']);
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "address": address,
      "profilePic": profilePic,
      "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "points": points,
    };
  }
}


/* 
Data points:
Phone - at the time of otp verification - done
name - done
society name
flat number
[] is another number registered with you address
referral code - have to find the logic of this 
*/