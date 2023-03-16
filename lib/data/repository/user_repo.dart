import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:iskainan/models/vendor_data_model.dart';

import '../../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // createVendorMenu(VendorData user) async {
  //   final collection = _db.collection('vendors');
  //   final document = collection.doc();
  //
  //   await document.collection('vendorMenu').add(menu.toJson()).whenComplete(
  //         () => Get.snackbar("Success", "Your account has been created.",
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.green.withOpacity(0.1),
  //         colorText: Colors.green),
  //   );
  // }

  createUser(/*UserModel*/VendorData user) async {
    DocumentReference vendorId = await _db.collection('vendors').add(user.toJson());
    await _db.collection('vendors').doc(vendorId.id).collection('foodList').add({'initialization': true});
  }

  Future<UserModel> getUserDetails(String email) async {
    print(email);
    final snapshot = await _db.collection("vendors").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("vendors").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateGeneralInformation(UserModel user) async{
    await _db.collection("vendors").doc(user.id).update(user.toJson());
  }

}
