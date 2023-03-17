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



  createUser(VendorData user) async {
    await _db.collection('vendors').add(user.toJson()).whenComplete(
                () => Get.snackbar("Success", "Your account has been created.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green),
          );
    // await _db.collection('vendors').doc(vendorId.id).collection('foodList').add({'initialization': true});
  }

  Future<VendorData> getUserDetails(String email) async {
    final snapshot = await _db.collection("vendors").where("email", isEqualTo: email).get();

    final userData = snapshot.docs.map((e) => VendorData.fromSnapshot(e)).single;


    return userData;
  }

  // Future<List<VendorData>> allUser() async {
  //   final snapshot = await _db.collection("vendors").get();
  //   final userData = snapshot.docs.map((e) => VendorData.fromSnapshot(e)).toList();
  //   return userData;
  // }

  Future<void> updateGeneralInformation(VendorData user) async{
    await _db.collection("vendors").doc(user.vendor_id).update(user.toJson());
  }

}
