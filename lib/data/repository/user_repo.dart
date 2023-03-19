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

  addVendorMenu(VendorMenu menu, String vendorId) async {
    await _db.collection('vendors').doc(vendorId).collection('foodList').add(menu.toJson());
  }

  getVendorMenu(String email, String vendorId) async {
    final vendorSnapshot = await _db.collection('vendors').doc(vendorId).collection("foodList")
        .orderBy("food_created", descending: true).get();
    final foodList = vendorSnapshot.docs.map((e) => VendorMenu.fromSnapshot(e)).toList();
    return foodList;
  }

  Future<void> updateVendorMenu(String vendorId, String foodId, VendorMenu vendorMenu) async{
    await _db.collection('vendors').doc(vendorId).collection('foodList').doc(foodId).update(vendorMenu.toJson());
  }

  deleteVendorMenu(String vendorId, String foodId) async {
    await _db.collection('vendors').doc(vendorId).collection('foodList').doc(foodId).delete();
  }

  createUser(VendorData user) async {
    await _db.collection('vendors').add(user.toJson()).whenComplete(
                () => Get.snackbar("Success", "Your account has been created.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green),
          );
  }

  Future<VendorData> getUserDetails(String email) async {
    final snapshot = await _db.collection("vendors").where("email", isEqualTo: email).get();

    final userData = snapshot.docs.map((e) => VendorData.fromSnapshot(e)).single;
    return userData;
  }

  // Future<VendorMenu> getMenuDetails(String email) async {
  //   final vendorSnapshot = await _db.collection("vendors").where("email", isEqualTo: email).get();
  //
  //   final vendorItems = vendorSnapshot.docs.first;
  //   final vendorDocRef = vendorItems.reference;
  //   final menuSnapshot = vendorDocRef.collection('menu').get();
  //
  //   final menuData = menuSnapshot.docs.map((e) => VendorMenu.fromSnapshot(e)).toList());
  //   return menuData;
  // }



  Future<List<VendorData>> allUser() async {
    final snapshot = await _db.collection("vendors").get();
    final userData = snapshot.docs.map((e) => VendorData.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateGeneralInformation(VendorData user) async{
    await _db.collection("vendors").doc(user.vendor_id).update(user.toJson());
  }


}
