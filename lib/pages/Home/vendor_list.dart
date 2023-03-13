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

class VendorList extends StatelessWidget {
  const VendorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: Dimensions.height20),
      child: Column(
        children: [
          GetBuilder<VendorController>(builder: (vendor){
            return vendor.isLoaded?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vendor.vendorList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteHelper.getVendorDetail(index));
                    },
                    child: Opacity(
                      opacity: vendor.vendorList[index].isOpen!?1:0.2,
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
                                    image: AssetImage(vendor.vendorList[index].vendorImg!),
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
                                          BigText(text: vendor.vendorList[index].vendorName!, size: Dimensions.font20,),
                                          SizedBox(height: Dimensions.height10/2,),
                                          Row(
                                            children: [
                                              Icon(Icons.star, color: AppColors.mainColor, size: 15,),
                                              SizedBox(width: Dimensions.width10/2,),
                                              SmallText(text: vendor.vendorList[index].vendorRating!, size: Dimensions.font16*0.8,),
                                              SizedBox(width: Dimensions.width10,),
                                              SmallText(text: vendor.vendorList[index].vendorLocation!, size: Dimensions.font16*0.8, isOneLine: true,),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BigText(text: vendor.vendorList[index].price_range.length > 1?"₱"+((vendor.vendorList[index].price_range).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) + " - ₱" + (vendor.vendorList[index].price_range).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)):"₱"+(vendor.vendorList[index].price_range).reduce((a, b) => a < b ? a : b).toStringAsFixed(2), size: Dimensions.font16*.9),
                                          SizedBox(height: Dimensions.height10/2,),
                                          RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true),
                                          SizedBox(height: Dimensions.height10/2,)
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
                  );
                }):Container(
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
