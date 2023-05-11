import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/pages/Home/survey.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

import '../splash/splash_page.dart';
import 'food_page_body.dart';

class MainPage extends StatefulWidget {
  String searchString;
  num budget;
  LatLng position;

  MainPage({Key? key,
    required this.searchString,
    required this.budget,
    required this.position
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Portion + search button (showing the head)
          Container(
            child: Container(
                margin: EdgeInsets.only(top: Dimensions.height45, bottom : Dimensions.height15),
                padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width20),
                child: Row(                                                                                                       // Top Portion
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: Dimensions.width10),
                            child: GestureDetector(
                              onTap: (){
                                Get.offAll(() => SplashScreen(searchString: "", budget: 10000, position: widget.position,));
                              },
                              child: Image.asset('assets/images/logo.png', scale: 13,)))
                      ],
                    ),
                    Center(
                      child: Row(
                        children: [
                          SizedBox(width: Dimensions.height45, height: Dimensions.height45,
                            child:FittedBox(
                                child:FloatingActionButton(
                                  onPressed: (){
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      dismissOnTouchOutside: false,
                                      animType: AnimType.topSlide,
                                      body: ChoicePage(),
                                    ).show();
                                  },
                                  backgroundColor: AppColors.mainColor,
                                  elevation: 0,
                                  child: Icon(Icons.search, color: Colors.white, size: Dimensions.iconSize24*1.5,),
                                )
                            ),
                          ),
                          SizedBox(width: Dimensions.width10,),
                          Container(
                            width: Dimensions.height45,
                            height: Dimensions.height45,
                            child: ElevatedButton(
                              onPressed: () {
                                // Get.toNamed(RouteHelper.getVendorSignInPage());
                                FirebaseAuth.instance.authStateChanges().listen((User? user) {
                                  if (user == null) {
                                    Get.toNamed(RouteHelper.getVendorSignInPage());
                                  } else {
                                    Get.toNamed(RouteHelper.getAccountPage());
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainColor,
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(Dimensions.radius15)),
                                padding: EdgeInsets.zero,
                                elevation: 0,
                              ),
                              child: Icon(Icons.food_bank_outlined, color: Colors.white, size: Dimensions.iconSize24*1.3,),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
          // Showing the Body
          Expanded(child: SingleChildScrollView(
            child: FoodPageBody(searchString: widget.searchString, budget: widget.budget, position: widget.position,),
          )),
        ],
      ),
    );
  }
}
