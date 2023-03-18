import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:iskainan/controllers/auth_controller.dart';

import '../data/repository/user_repo.dart';
import '../models/user_model.dart';
import '../models/vendor_data_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _authRepo = Get.put(AuthController());
  final _userRepo = Get.put(UserRepository());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    }
  }

  // getMenuData() {
  //   final email = _authRepo.firebaseUser.value?.email;
  //   if(email != null){
  //     return _userRepo.getMenuDetails(email);
  //   }
  // }

  // Future<List<VendorData>> getAllUsers() async => await _userRepo.allUser();

  // updateRecord(VendorData user) async {
  //   await _userRepo.updateGeneralInformation(user);
  // }

}