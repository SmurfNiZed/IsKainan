import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/data/repository/authentication_repo.dart';

import '../data/repository/user_repo.dart';
import '../models/user_model.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final vendorName = TextEditingController();
  final phone = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> registerUser(String email, String password) async {
    String? error = AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
    if (error != null) {
      showCustomerSnackBar(error.toString());
    }
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }
}