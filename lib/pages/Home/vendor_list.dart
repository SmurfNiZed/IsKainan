import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iskainan/models/vendor_data_model.dart';
import 'package:iskainan/widgets/app_column.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../controllers/address_name_controller.dart';
import '../../controllers/vendor_controller.dart';
import '../../data/hardcoded_data.dart';
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
    final CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
    Stream<QuerySnapshot> myStream1 = vendors.snapshots();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: Dimensions.height20),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: myStream1,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }

              if (snapshot.hasData) {
                List<VendorData> vendorDataList = snapshot.data!.docs.map((DocumentSnapshot document) {
                  return VendorData.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>);
                }).toList();


                if (vendorDataList.length == 0) {
                  return Container(
                    height: Dimensions.height30*5,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20, top: Dimensions.height20),
                    child: Center(child: Text("No vendors available!", style: TextStyle(fontSize: Dimensions.font26,color: AppColors.paraColor, fontFamily: 'Roboto', fontWeight: FontWeight.bold),)),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vendorDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final thisShop = vendorDataList[index];
                      List<double>? price_range;

                      Future<List<double>> getFoodPrices() async {
                        QuerySnapshot foodSnapshot = await FirebaseFirestore.instance
                            .collection('vendors')
                            .doc(thisShop.vendor_id)
                            .collection('foodList')
                            .orderBy("food_created", descending: true)
                            .get();

                        List<double> prices = foodSnapshot.docs.map((doc) {
                          return double.parse(doc['food_price']);
                        }).toList();

                        return prices;
                      }


                      return GestureDetector(
                        onTap: (){
                          Get.toNamed(RouteHelper.getVendorDetail(index));
                        },
                        child: Opacity(
                          opacity: thisShop.is_open=='true'?1:0.2,
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
                                        image: CachedNetworkImageProvider(thisShop.vendor_img!),
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
                                              BigText(text: thisShop.vendor_name!, size: Dimensions.font20,),
                                              SizedBox(height: Dimensions.height10/2,),
                                              Row(
                                                children: [
                                                  SmallText(text: thisShop.vendor_location!, size: Dimensions.font16*0.8, isOneLine: true,),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<List<double>>(
                                                future: getFoodPrices(),
                                                builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
                                                  if (snapshot.hasData) {
                                                    List<double> prices = snapshot.data!;

                                                    // Build your ListView.builder using prices
                                                    return BigText(text: prices.length > 1?"₱"+((prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) + " - ₱" + (prices).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)):"₱"+(prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2), size: Dimensions.font16*.9);
                                                  } else if (snapshot.hasError) {
                                                    // Handle the case where there was an error fetching prices
                                                    return Center(
                                                      child: Text('Error fetching prices: ${snapshot.error}'),
                                                    );
                                                  } else {
                                                    // Handle the case where prices haven't finished loading yet
                                                    return Center(
                                                      child: JumpingDotsProgressIndicator(),
                                                    );
                                                  }
                                                },
                                              ),
                                              // BigText(text: "₱"+price_range.toString(), size: Dimensions.font16*.9),
                                              SizedBox(height: Dimensions.height10/2,),
                                              Row(
                                                children: [
                                                  RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true),
                                                  SizedBox(width: Dimensions.width10/2,),
                                                  RectangleIconWidget(text: "GCASH", iconColor: Colors.blueAccent, isActivated: thisShop.is_gcash=="true"?true:false),
                                                ],
                                              ),
                                              SizedBox(height: Dimensions.height10/2,),
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
                    },
                  );
                }
              } else {
                return Container(
                  height: Dimensions.height30*5,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20, top: Dimensions.height20),
                  child: Center(child: Text("Nothing in here yet!", style: TextStyle(fontSize: Dimensions.font26,color: AppColors.paraColor, fontFamily: 'Roboto', fontWeight: FontWeight.bold),)),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                  ),
                );
              }
            },
          ),
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
