import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iskainan/exceptions/signup_email_password_failure.dart';
import 'package:iskainan/pages/Home/sign_in_page.dart';
import 'package:iskainan/pages/splash/splash_page.dart';

import '../../pages/Home/home_page.dart';
import '../../pages/Home/survey.dart';
import '../../pages/account/account_page.dart';
import '../../routes/route_helper.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  // Will be loaded when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    // ever(firebaseUser, _setInitialScreen);
  }

  // _setInitialScreen(User? user) {
  //   Get.to(() => SplashScreen());
  //   // user == null ? Get.to(() => HomePage()) : Get.to(() => VendorSignInPage());
  // }

  Future<void> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null? Get.offAll(() => RouteHelper.getChoicePage()) : Get.offAll(() => RouteHelper.getInitial());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {

    } catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}