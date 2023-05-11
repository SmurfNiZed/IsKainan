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
import '../../utils/is_new.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';

class VendorList extends StatefulWidget {
  const VendorList({Key? key}) : super(key: key);

  @override
  State<VendorList> createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  var _controller = TextEditingController();
  void clearField(){ //resets the search
    _controller.clear();
    setState(() {
      name = "";
    });
  }
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BigText(text: "  Vendor List", size: Dimensions.font26, color: Colors.white ),
          backgroundColor: AppColors.mainColor
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: Dimensions.height15),
        child: Column(
          children: [
            SizedBox(
              width: 380,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppColors.mainColor,),
                    hintText: 'Search for a vendor...',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: AppColors.mainColor),
                        onPressed: clearField),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:  BorderSide(color: AppColors.mainColor, width: 5)
                    )

                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            SizedBox(height: Dimensions.height10,),
            GetBuilder<VendorController>(builder: (vendor){
              return Container(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: vendor.vendors.length,
                    itemBuilder: (context, index) {
                      var data = vendor.vendors[index];

                      Future<List<double>> getFoodPrices() async {
                        QuerySnapshot foodSnapshot = await FirebaseFirestore.instance
                            .collection('vendors')
                            .doc(vendor.vendors[index].vendor_id)
                            .collection('foodList')
                            .orderBy("food_created", descending: true)
                            .get();
                        List<double> prices = foodSnapshot.docs.map((doc) {
                          return (doc['food_price'] as num).toDouble();
                        }).toList();
                        return prices;
                      }

                      late String startTime = '${(vendor.vendors[index].operating_hours![0]~/60)%12}:${((vendor.vendors[index].operating_hours![0]%60)).toString().padLeft(2, '0')} ${(vendor.vendors[index].operating_hours![0]~/60) < 12 ? 'AM' : 'PM'}';
                      late String endTime = '${(vendor.vendors[index].operating_hours![1]~/60)%12}:${((vendor.vendors[index].operating_hours![1]%60)).toString().padLeft(2, '0')} ${(vendor.vendors[index].operating_hours![1]~/60) < 12 ? 'AM' : 'PM'}';

                      if (name.isEmpty){
                        return GestureDetector(
                          onTap: (){
                            Get.toNamed(RouteHelper.getVendorDetail(vendor.vendors[index].vendor_id!));
                          },
                          child: Opacity(
                            opacity: vendor.vendors[index].is_open=="true"?1:0.2,
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
                                          image: CachedNetworkImageProvider(vendor.vendors[index].vendor_img!),
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
                                                BigText(text: vendor.vendors[index].vendor_name!, size: Dimensions.font20,),
                                                SizedBox(height: Dimensions.height10/2,),
                                                SmallText(text: startTime + " - " + endTime+ "   " + vendor.vendors[index].vendor_location!, size: Dimensions.font16*0.8, isOneLine: true,),
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
                                                      return BigText(text: prices.length > 1?"₱"+((prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) + " - ₱" + (prices).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)):"₱"+(prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2), size: Dimensions.font16*.9);
                                                    } else if (snapshot.hasError) {
                                                      return Center(
                                                        child: Text('Error fetching prices: ${snapshot.error}'),
                                                      );
                                                    } else {
                                                      return Center(
                                                        child: JumpingDotsProgressIndicator(),
                                                      );
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: Dimensions.height10/2,),
                                                Row(
                                                  children: [
                                                    RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: isNew(vendor.vendors[index].account_created!)?true:false),
                                                    isNew(vendor.vendors[index].account_created!)? SizedBox(width: Dimensions.width10/2,) : SizedBox(),
                                                    RectangleIconWidget(text: "GCASH", iconColor: Colors.blueAccent, isActivated: vendor.vendors[index].is_gcash=="true"?true:false)
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
                      } else if (data.vendor_name.toString().isCaseInsensitiveContainsAny(name)){
                        return GestureDetector(
                          onTap: (){
                            Get.toNamed(RouteHelper.getVendorDetail(vendor.vendors[index].vendor_id!));
                          },
                          child: Opacity(
                            opacity: vendor.vendors[index].is_open=="true"?1:0.2,
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
                                          image: CachedNetworkImageProvider(vendor.vendors[index].vendor_img!),
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
                                                BigText(text: vendor.vendors[index].vendor_name!, size: Dimensions.font20,),
                                                SizedBox(height: Dimensions.height10/2,),
                                                SmallText(text: startTime + " - " + endTime+ "   " + vendor.vendors[index].vendor_location!, size: Dimensions.font16*0.8, isOneLine: true,),
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
                                                      return BigText(text: prices.length > 1?"₱"+((prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) + " - ₱" + (prices).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)):"₱"+(prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2), size: Dimensions.font16*.9);
                                                    } else if (snapshot.hasError) {
                                                      return Center(
                                                        child: Text('Error fetching prices: ${snapshot.error}'),
                                                      );
                                                    } else {
                                                      return Center(
                                                        child: JumpingDotsProgressIndicator(),
                                                      );
                                                    }
                                                  },
                                                ),
                                                SizedBox(height: Dimensions.height10/2,),
                                                Row(
                                                  children: [
                                                    RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: isNew(vendor.vendors[index].account_created!)?true:false),
                                                    isNew(vendor.vendors[index].account_created!)? SizedBox(width: Dimensions.width10/2,) : SizedBox(),
                                                    RectangleIconWidget(text: "GCASH", iconColor: Colors.blueAccent, isActivated: vendor.vendors[index].is_gcash=="true"?true:false)
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


                    }
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

