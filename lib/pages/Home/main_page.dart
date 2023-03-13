import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/widgets/app_icon.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

import 'food_page_body.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

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
                            child: Image.asset('assets/images/logo.png', scale: 13,))
                      ],
                    ),
                    Center(
                      child: Row(
                        children: [
                          SizedBox(width: Dimensions.height45, height: Dimensions.height45,
                            child:FittedBox(
                                child:FloatingActionButton(
                                  onPressed: (){
                                    Get.toNamed(RouteHelper.choicePage);
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
                                Get.toNamed(RouteHelper.vendorSignInPage);
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
            child: FoodPageBody(),
          )),
        ],
      ),
    );
  }
}
