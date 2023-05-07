import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../controllers/profile_controller.dart';
import '../../controllers/vendor_controller.dart';
import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/is_new.dart';
import '../../utils/shimmer.dart';
import '../../widgets/app_column.dart';
import '../../widgets/app_column_detailed.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/shimmer_food_list.dart';
import '../../widgets/small_text.dart';
import 'find_vendor.dart';

class VendorDetail extends StatefulWidget {
  final String vendorId;
  const VendorDetail({Key? key, required this.vendorId}) : super(key: key);

  @override
  State<VendorDetail> createState() => _VendorDetailState();
}


class _VendorDetailState extends State<VendorDetail> {
  late StreamController<String> _streamController;
  late String startTime;
  late String endTime;

  late List<bool> values;

  void _showCircularProgressIndicator() {
    AwesomeDialog(
      context: context,
      titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: Dimensions.font26,
          fontWeight: FontWeight.bold
      ),
      body: Container(
        padding: EdgeInsets.all(Dimensions.height45),
        child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
                SizedBox(height: Dimensions.height20 + Dimensions.height10/2,),
              ],
            )
        ),
      ),
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      autoDismiss: true,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      autoHide: Duration(seconds: 1),
    ).show();
  }

  Future<void> _navigateToFindVendor(Position position) async {
    final DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.collection('vendors').doc(widget.vendorId);

    documentReference.get().then((DocumentSnapshot documentSnapshot) {
      var latitude = documentSnapshot.get('latitude');
      var longitude = documentSnapshot.get('longitude');
      var vendorName = documentSnapshot.get('vendor_name');
      var vendorAddress = documentSnapshot.get('vendor_location');
      Get.toNamed(RouteHelper.getFindVendor(
          position.latitude.toString(),
          position.longitude.toString(),
          latitude.toString(),
          longitude.toString(),
          vendorName,
          vendorAddress
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "vendor_detail_page",
        onPressed: () async {
          bool locationEnabled = await Geolocator.isLocationServiceEnabled();

          if (!locationEnabled) {

          } else {
            LocationPermission permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied) {

              } else {
                // _showCircularProgressIndicator();
                Position position = await Geolocator.getCurrentPosition();
                _navigateToFindVendor(position);
              }
            } else {
              // _showCircularProgressIndicator();
              Position position = await Geolocator.getCurrentPosition();
              _navigateToFindVendor(position);
            }
          }
        },
        backgroundColor: AppColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.navigation),
            SmallText(text: "GO", color: Colors.white,)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: AppIcon(icon: Icons.clear)),
              ],
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(90),
                child: Container(
                  child: AppColumnDetailed(vendorId: widget.vendorId,),
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: Dimensions.width20, left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.width15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius20),
                          topRight: Radius.circular(Dimensions.radius20)
                      )
                  ),
                )
            ),
            pinned: true,
            backgroundColor: AppColors.mainColor,
            expandedHeight: Dimensions.screenHeight/2,
            collapsedHeight: kToolbarHeight+54,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: FutureBuilder(
                      future: controller.getVendorData(widget.vendorId),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.done){
                          VendorData user = snapshot.data as VendorData;
                          return user.vendor_img==""?Container(
                            color: AppColors.mainColor,
                            width: Dimensions.screenWidth,
                            height: Dimensions.screenHeight,
                            child: Icon(
                              Icons.storefront,
                              color: Colors.white,
                              size: Dimensions.width30*5,
                            ),
                          )
                            :CachedNetworkImage(
                            imageUrl: user.vendor_img!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return shimmer();
                        }
                      }
                  )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('vendors').doc(widget.vendorId!).collection('foodList').get(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Column(
                      children: [
                        Container(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                                    child: Row(
                                      children: [
                                        // image section
                                        Container(
                                          width: Dimensions.listViewImgSize,
                                          height: Dimensions.listViewImgSize,
                                          child: shimmer(),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: Dimensions.listViewTextContSize,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(Dimensions.radius20),
                                                  bottomRight: Radius.circular(Dimensions.radius20)
                                              ),

                                            ),
                                            child:
                                            Padding(padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      shimmer(height: Dimensions.font20, width: Dimensions.width30*5,),
                                                      SizedBox(height: Dimensions.height10/2,),
                                                      shimmer(height:Dimensions.font16, width: Dimensions.width30*2,),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      shimmer(height: Dimensions.font16, width: Dimensions.width30*1.5,),
                                                      SizedBox(height: Dimensions.height10/2,),
                                                      shimmer(height: Dimensions.font20, width: Dimensions.width30*3,),
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
                                  );
                                })
                        ),
                      ],
                    );
                  } else {
                    var data = snapshot.data!.docs.map((DocumentSnapshot document) {
                      return VendorMenu.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>);
                    }).toList();
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Get.toNamed(RouteHelper.getFoodDetail(data[index].vendorId!, data[index].foodId!));
                            },
                            child: Opacity(
                              opacity: data[index].isAvailable=="true"?1:0.2,
                              child: Container(
                                margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, top: Dimensions.height10, bottom: Dimensions.height10),
                                child: Row(
                                  children: [
                                    // image section
                                    Container(
                                      width: Dimensions.listViewImgSize,
                                      height: Dimensions.listViewImgSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(data[index].foodImg!),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: Dimensions.listViewTextContSize,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(Dimensions.radius20),
                                              bottomRight: Radius.circular(Dimensions.radius20)
                                          ),
                                          color: Colors.white,
                                        ),
                                        child:
                                        Padding(padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              BigText(text: data[index].foodName!, size: Dimensions.font20,),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      BigText(text: "₱" + data[index].foodPrice.toStringAsFixed(2), size: Dimensions.font16,),
                                                      SizedBox(width: Dimensions.width10/2),
                                                    ],
                                                  ),
                                                  SizedBox(height: Dimensions.height10,),
                                                  Row(
                                                    children: [
                                                      RectangleIconWidget(text: "NEW", iconColor: Colors.yellow[600]!, isActivated: isNew(data[index].food_created!)),
                                                      SizedBox(width: Dimensions.width10/2,),
                                                      data[index].isSpicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: data[index].isSpicy=="true"?true:false):SmallText(text: ""),
                                                      data[index].isSpicy=="true"?SizedBox(width: Dimensions.width10,):SmallText(text: ""),
                                                    ],
                                                  )
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
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
