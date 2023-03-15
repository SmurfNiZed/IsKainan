import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  createUser(UserModel user) async {
  await FirebaseFirestore.instance.collection("vendors").add(user.toJson()).whenComplete(
            () => Get.snackbar("Success", "Your account has been created.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green),
    );
  }
}