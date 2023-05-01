import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../utils/is_new.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';

class FoodList extends StatefulWidget {
  FoodList({Key? key}) : super(key: key);

  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Card(

          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.mainColor,
              ), hintText: 'Search...'
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: Dimensions.height20),
        child: Column(
          children: [
            GetBuilder<VendorController>(builder: (vendor){
              return Expanded(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: vendor.vendorMenu.length,
                    itemBuilder: (context, index) {
                      var data = vendor.vendorMenu[index];

                      if(name.isEmpty){
                        return GestureDetector(
                          onTap: () async {
                            QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('foodList').get();
                            Get.toNamed(RouteHelper.getFoodDetail(querySnapshot.docs[index].reference.parent.parent!.id, vendor.vendorMenu[index].foodId!));
                          },
                          child: Opacity(
                            opacity: (vendor.vendorMenu[index].isAvailable=="true")?1:0.4,
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
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(vendor.vendorMenu[index].foodImg!),
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.listViewImgSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(Dimensions.radius20),
                                          bottomRight: Radius.circular(Dimensions.radius20),
                                        ),
                                      ),
                                      child: Padding(padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                BigText(text: vendor.vendorMenu[index].foodName!, size: Dimensions.font20,),
                                                SizedBox(height: Dimensions.height10/2,),
                                                SmallText(text: vendor.vendorMenu[index].vendorName! + ", " + vendor.vendorMenu[index].vendorLoc!, size: Dimensions.font16*0.8, isOneLine: true,)
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                BigText(text: "₱"+vendor.vendorMenu[index].foodPrice.toStringAsFixed(2), size: Dimensions.font16*.9),
                                                SizedBox(height: Dimensions.height10/2,),
                                                Row(
                                                  children: [
                                                    RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: isNew(vendor.vendorMenu[index].food_created!)?true:false),
                                                    isNew(vendor.vendorMenu[index].food_created!)? SizedBox(width: Dimensions.width10/2,):SizedBox(),
                                                    vendor.vendorMenu[index].isSpicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: vendor.vendorMenu[index].isSpicy=="true"?true:false):Text(""),
                                                  ],
                                                ),
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
                      } else if (data.foodName.toString().isCaseInsensitiveContainsAny(name)){
                        return GestureDetector(
                          onTap: () async {
                            QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('foodList').get();
                            Get.toNamed(RouteHelper.getFoodDetail(querySnapshot.docs[index].reference.parent.parent!.id, vendor.vendorMenu[index].foodId!));
                          },
                          child: Opacity(
                            opacity: (vendor.vendorMenu[index].isAvailable=="true")?1:0.4,
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
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(vendor.vendorMenu[index].foodImg!),
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: Dimensions.listViewImgSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(Dimensions.radius20),
                                          bottomRight: Radius.circular(Dimensions.radius20),
                                        ),
                                      ),
                                      child: Padding(padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10, ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                BigText(text: vendor.vendorMenu[index].foodName!, size: Dimensions.font20,),
                                                SizedBox(height: Dimensions.height10/2,),
                                                SmallText(text: vendor.vendorMenu[index].vendorName! + ", " + vendor.vendorMenu[index].vendorLoc!, size: Dimensions.font16*0.8, isOneLine: true,)
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                BigText(text: "₱"+vendor.vendorMenu[index].foodPrice.toStringAsFixed(2), size: Dimensions.font16*.9),
                                                SizedBox(height: Dimensions.height10/2,),
                                                Row(
                                                  children: [
                                                    RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: isNew(vendor.vendorMenu[index].food_created!)?true:false),
                                                    isNew(vendor.vendorMenu[index].food_created!)? SizedBox(width: Dimensions.width10/2,):SizedBox(),
                                                    vendor.vendorMenu[index].isSpicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: vendor.vendorMenu[index].isSpicy=="true"?true:false):Text(""),
                                                  ],
                                                ),
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
                      } else {
                        return Container();
                      }
                    }),
              );
            })
          ],
        ),
      ),
    );
  }
}
