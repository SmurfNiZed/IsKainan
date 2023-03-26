import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/models/user_model.dart';
import 'package:iskainan/pages/Home/sign_in_page.dart';

import '../data/repository/user_repo.dart';
import '../models/vendor_data_model.dart';
import '../pages/Home/home_page.dart';
import '../pages/account/account_page.dart';
import '../pages/splash/splash_page.dart';
import '../routes/route_helper.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  final userRepo = Get.put(UserRepository());

  @override
  void onReady(){
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);

    // notify changes
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user){
    Get.offAll(() => SplashScreen());
  }

  void register(VendorData user) async {
    try{
      await auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
      await userRepo.createUser(user);
    }catch(e){
      showCustomerSnackBar(e.toString());
    }
  }




  void login(String email, String password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      showCustomerSnackBar(e.toString());
    }
  }

  void logout() async {
    await auth.signOut();
  }
}