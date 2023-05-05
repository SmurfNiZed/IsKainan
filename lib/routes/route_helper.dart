import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/pages/Home/home_page.dart';
import 'package:iskainan/pages/food/food_detail.dart';
import '../pages/Home/sign_in_page.dart';
import '../pages/Home/survey.dart';
import '../pages/Home/sign_up_page.dart';
import '../pages/account/account_page.dart';
import '../pages/food/find_vendor.dart';
import '../pages/food/vendor_detail.dart';
import '../pages/splash/splash_page.dart';

class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String initial = "/";                // homepage
  static const String choicePage = '/search-page';      // survey
  static const String vendorSignUpPage = '/vendor-signup-page'; //vendor login page
  static const String vendorSignInPage = '/vendor-signin-page'; //vendor login page
  static const String foodDetail = "/food-detail";  // food detail
  static const String vendorDetail = "/vendor-detail";  // vendor detail page
  static const String vendorList = "/vendor-list";
  static const String foodList = "/food-list";
  static const String accountPage = '/account-page';
  static const String findVendor = '/find-vendor';
  // static const String generalInformationPage = '/general-information-page';


  static String getSplashPage()=>'$splashPage';
  static String getInitial(String searchString, num budget, String position)=>'$initial?searchString=$searchString&budget=$budget&position=$position';
  static String getChoicePage()=>'$choicePage';
  static String getVendorSignUpPage()=>'$vendorSignUpPage';
  static String getVendorSignInPage()=>'$vendorSignInPage';
  static String getVendorDetail(String vendorId)=>'$vendorDetail?vendorId=$vendorId';
  static String getFoodDetail(String vendorId, String foodId)=>'$foodDetail?vendorId=$vendorId&foodId=$foodId';
  static String getVendorList()=>'$vendorList';
  static String getFoodList()=>'$foodList';
  static String getAccountPage()=>'$accountPage';
  static String getFindVendor(String startLat, String startLng, String lat, String lng, String vendorName, String vendorAddress)=>'$findVendor?startLat=$startLat&startLng=$startLng&lat=$lat&lng=$lng&vendorName=$vendorName&vendorAddress=$vendorAddress';
  // static String getGeneralInformationPage(UserModel user)=>'$generalInformationPage?user=$user';

  static List<GetPage> routes=[
    // GetPage(name: splashPage, page: ()=>SplashScreen()),

    GetPage(name: initial, page: (){
      var searchString = Get.parameters['searchString'] as String;
      var budget = Get.parameters['budget'] as String;
      var position = Get.parameters['position'] as String;

      List<String> components = position.split(",");

      double latitude = double.parse(components[0]);
      double longitude = double.parse(components[1]);

      return SplashScreen(searchString: searchString, budget: double.parse(budget), position: LatLng(latitude,longitude),);
    }),

    GetPage(name: choicePage, page: ()=> ChoicePage()),

    GetPage(name: vendorSignUpPage, page: ()=>VendorSignUpPage()),

    GetPage(name: vendorSignInPage, page: ()=>VendorSignInPage()),

    GetPage(name: findVendor, page:(){
      var startLat = Get.parameters['startLat'] as String;
      var startLng = Get.parameters['startLng'] as String;
      var lat = Get.parameters['lat'] as String;
      var lng = Get.parameters['lng'] as String;
      var vendorName = Get.parameters['vendorName'] as String;
      var vendorAddress = Get.parameters['vendorAddress'] as String;
      return FindVendor(startSpot: GeoPoint(double.parse(startLat!), double.parse(startLng!)), endSpot: GeoPoint(double.parse(lat), double.parse(lng)), vendorName: vendorName, vendorAddress: vendorAddress,);
      },
    ),

    GetPage(name: accountPage, page: ()=>AccountPage()),

    GetPage(name: vendorDetail, page:(){
      var vendorId = Get.parameters['vendorId'];
      return VendorDetail(vendorId: vendorId!);
      },
    ),

    GetPage(name: foodDetail, page:(){
      var foodId = Get.parameters['foodId'];
      var vendorId = Get.parameters['vendorId'];
      return RecommendedFoodDetail(vendorId: vendorId!, foodId: foodId!);
      },
    ),
  ];
}