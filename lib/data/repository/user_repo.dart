import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../base/show_custom_snackbar.dart';
import '../../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("vendors").add(user.toJson()).whenComplete(
            () => Get.snackbar("Success", "Your account has been created.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
        showCustomerSnackBar("Error", title: error.toString());
    });
  }

  // Get specific vendor account
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("vendors").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // Get ALL vendor accounts
  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("vendors").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
}