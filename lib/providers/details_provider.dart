import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashfix2/models/orders_model.dart';
import 'package:trashfix2/models/schedule_model.dart';
import 'package:trashfix2/screens/otp_screen.dart';
import 'package:trashfix2/utils/utils.dart';
import 'dart:io';

import '../models/store_model.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  StoreModel? _storeModel;
  StoreModel get storeModel => _storeModel!;
  ScheduleModel? _scheduleModel;
  ScheduleModel get scheduleModel => _scheduleModel!;
  OrdersModel? _ordersModel;
  OrdersModel get ordersModel => _ordersModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_SignedIn") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_SignedIn", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      print(phoneNumber);
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OtpScreen(verificationId: verificationId)));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  //verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
    }
  }

  // Database operations
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("User exists");
      return true;
    } else {
      print("New User");
      return false;
    }
  }

  void saveUserDataToFirebase(
      {required BuildContext context,
      required UserModel userModel,
      required File profilePic,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading the image to firebase storage
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.uid;
      });
      _userModel = userModel;

      //uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFireStore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        address: snapshot['address'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
        points: snapshot['points'],
      );
      _uid = userModel.uid;
    });
    notifyListeners();
  }

  //Storing data locally
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSp() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  Future getStoreDataFromFirestore() async {
    await _firebaseFirestore
        .collection("store_items")
        .doc('1')
        .get()
        .then((DocumentSnapshot snapshot) {
      _storeModel = StoreModel(
          name: snapshot['name'],
          amount: snapshot['amount'],
          image_url: snapshot['image_url']);
    });
    await _firebaseFirestore.collection('store_items').get();

    notifyListeners();
  }

  void saveScheduleDataToFirebase(
      {required BuildContext context,
      required ScheduleModel scheduleModel,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    // bool docExists = await checkIfDocExists(_uid!);
    try {
      // if (docExists) {
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .collection("schedules")
          .add({
        "type": scheduleModel.type,
        "date": scheduleModel.date,
        "time": scheduleModel.time,
        "uid": scheduleModel.uid,
        "phoneNumber": scheduleModel.phoneNumber,
        "createdAt": scheduleModel.createdAt,
        "status": scheduleModel.status,
      }).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
      // } else {
      //   await _firebaseFirestore.collection("schedules").doc(_uid).set({
      //     "schedules": FieldValue.arrayUnion([scheduleModel.toMap()])
      //   }).then((value) {
      //     onSuccess();
      //     _isLoading = false;
      //     notifyListeners();
      //  });
      // }
      //uploading to database
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = _firebaseFirestore
        ..collection("users").doc(_uid).collection('schedules');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  void saveOrdersDataToFirebase(
      {required BuildContext context,
      required OrdersModel ordersModel,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    // bool docExists = await checkIfDocExists(_uid!);
    try {
      // if (docExists) {
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .collection("orders")
          .add({
        "type": ordersModel.type,
        "uid": ordersModel.uid,
        "phoneNumber": ordersModel.phoneNumber,
        "createdAt": ordersModel.createdAt,
        "amount": ordersModel.amount,
        "itemId": ordersModel.itemId,
        "itemName": ordersModel.itemName,
        "status": ordersModel.status
      }).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
      // } else {
      //   await _firebaseFirestore.collection("schedules").doc(_uid).set({
      //     "schedules": FieldValue.arrayUnion([scheduleModel.toMap()])
      //   }).then((value) {
      //     onSuccess();
      //     _isLoading = false;
      //     notifyListeners();
      //  });
      // }
      //uploading to database
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> checkIfDocExists(String docId) async {
  //   try {
  //     // Get reference to Firestore collection
  //     var collectionRef = _firebaseFirestore
  //       ..collection("users").doc(_uid).collection('schedules');

  //     var doc = await collectionRef.doc(docId).get();
  //     return doc.exists;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
