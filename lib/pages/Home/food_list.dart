import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iskainan/widgets/app_column.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';

import '../../controllers/vendor_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';

class FoodList extends StatelessWidget {
  const FoodList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: Dimensions.height20),
      child: Column(
        children: [
          GetBuilder<VendorController>(builder: (vendor){
            return vendor.isLoaded?Expanded(
              child: ListView.builder(
                itemCount: vendor.vendorList.length,
                itemBuilder: (BuildContext context, int vendorId) {
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: vendor.vendorList[vendorId].food_model.length,
                        itemBuilder: (BuildContext context, int foodId) {
                          return GestureDetector(
                            onTap: (){
                              Get.toNamed(RouteHelper.getFoodDetail(vendorId, foodId));
                            },
                            child: Opacity(
                              opacity: (vendor.vendorList[vendorId].isOpen!&&vendor.vendorList[vendorId].food_model[foodId].isAvailable!)?1:0.2,
                              child: Container(
                                margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                                child: Row(
                                  children: [
                                    // image section
                                    Container(
                                      width: Dimensions.listViewImgSize,
                                      height: Dimensions.listViewImgSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                                          color: Colors.white38,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(vendor.vendorList[vendorId].food_model[foodId].foodImg!),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: Dimensions.listViewImgSize,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(Dimensions.radius20),
                                              bottomRight: Radius.circular(Dimensions.radius20)
                                          ),
                                          color: Colors.white,
                                        ),
                                        child:
                                        Padding(padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.height10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BigText(text: vendor.vendorList[vendorId].food_model[foodId].foodName!, size: Dimensions.font20,),
                                                  SizedBox(height: Dimensions.height10/2,),
                                                  SmallText(text: vendor.vendorList[vendorId].vendorName! + ", " + vendor.vendorList[vendorId].vendorLocation!, size: Dimensions.font16*0.8, isOneLine: true,),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BigText(text: "₱"+(vendor.vendorList[vendorId].food_model[foodId].foodPrice!), size: Dimensions.font16*.9),
                                                  SizedBox(height: Dimensions.height10/2,),
                                                  Row(
                                                    children: [
                                                      RectangleIconWidget(text: "NEW", iconColor: Colors.yellow[700]!, isActivated: true),
                                                      SizedBox(width: Dimensions.width10/2,),
                                                      vendor.vendorList[vendorId].food_model[foodId].isSpicy!?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: vendor.vendorList[vendorId].food_model[foodId].isSpicy!):Text(""),
                                                    ],
                                                  ),
                                                  SizedBox(height: Dimensions.height20,)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );/*Text(vendor.vendorList[index].food_model[subIndex].foodName!)*/;
                        },
                      ),
                    ],
                  );
                },
              ),
            ):Container(
              width: Dimensions.screenWidth,
              height: Dimensions.screenWidth/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
