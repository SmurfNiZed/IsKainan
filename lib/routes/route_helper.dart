import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:iskainan/pages/Home/allergies_page.dart';
import 'package:iskainan/pages/Home/main_page.dart';
import 'package:iskainan/pages/food/recommended_food_detail.dart';

import '../pages/Home/address_page.dart';
import '../pages/Home/budget_page.dart';
import '../pages/Home/survey.dart';
import '../pages/Home/vendor_page.dart';
import '../pages/food/vendor_detail.dart';

class RouteHelper{
  static const String initial = "/";                // homepage
  static const String choicePage = '/search-page';      // survey
  static const String budgetPage = '/budget-page';  // budget page
  static const String addressPage = '/address-page'; // address page
  static const String allergiesPage = '/allergies-page'; // allergiespage
  static const String vendorLoginPage = '/vendor-login-page'; //vendor login page
  static const String foodDetail = "/food-detail";  // food detail
  static const String vendorDetail = "/vendor-detail";  // vendor detail page

  static String getInitial()=>'$initial';
  static String getChoicePage()=>'$choicePage';
  static String getBudgetPage()=>'$budgetPage';
  static String getAddressPage()=>'$addressPage';
  static String getAllergiesPage()=>'$allergiesPage';
  static String getVendorLoginPage()=>'$vendorLoginPage';
  static String getVendorDetail(int pageId)=>'$vendorDetail?pageId=$pageId';
  static String getFoodDetail(int pageId)=>'$foodDetail?pageId=$pageId';

  static List<GetPage> routes=[
    GetPage(name: initial, page: ()=> MainPage()),

    GetPage(name: choicePage, page: ()=> ChoicePage()),

    GetPage(name: budgetPage, page: ()=> BudgetPage()),

    GetPage(name: addressPage, page: ()=> AddressPage()),

    GetPage(name: allergiesPage, page: ()=>AllergiesPage()),

    GetPage(name: vendorLoginPage, page: ()=>VendorLoginPage()),

    GetPage(name: vendorDetail, page:(){
      var pageId = Get.parameters['pageId'];
      return VendorDetail(pageId: int.parse(pageId!));
      },
    ),

    GetPage(name: foodDetail, page:(){
      var pageId = Get.parameters['pageId'];
      return RecommendedFoodDetail(pageId: int.parse(pageId!));
    },
    ),
  ];
}