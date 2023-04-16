import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/vendor_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/location_repo.dart';
import '../data/repository/vendors_repo.dart';
import '../utils/app_constants.dart';

Future<void> init()async { // init() method
  final sharedPreferences= await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);
  // apiClient
  Get.lazyPut(()=>ApiClient(appBaseUrl:AppConstants.BASE_URL));
  // Get.lazyPut(()=> AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // repository
  Get.lazyPut(()=>VendorRepo(apiClient:Get.find()));
  Get.lazyPut(()=>LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // controllers
  Get.lazyPut(()=>VendorController());
  // Get.lazyPut(() => LocationController(locationRep: Get.find()))
  // Get.lazyPut(() => AuthController(authRepo: Get.find()));
}