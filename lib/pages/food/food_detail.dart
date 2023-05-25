import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/vendor_controller.dart';
import 'package:iskainan/widgets/app_icon.dart';

import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/is_new.dart';
import '../../utils/shimmer.dart';
import '../../widgets/big_text.dart';
import '../../widgets/rectangle_icon_widget.dart';
import '../../widgets/small_text.dart';



class RecommendedFoodDetail extends StatefulWidget {
  final String foodId;
  final String vendorId;
  RecommendedFoodDetail({Key? key, required this.vendorId, required this.foodId}) : super(key: key);

  @override
  State<RecommendedFoodDetail> createState() => _RecommendedFoodDetailState();
}

class _RecommendedFoodDetailState extends State<RecommendedFoodDetail> {
  void _showCircularProgressIndicator() {
    AwesomeDialog(
      context: context,
      titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
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
    return FutureBuilder(
        future: controller.getVendorMenuData(widget.vendorId, widget.foodId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            VendorMenu food = snapshot.data as VendorMenu;
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  heroTag: "vendor_detail_page",            // always ake heroTag unique per floating action button please thanks
                  onPressed: () async {
                    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
                    print(locationEnabled);
                    if (!locationEnabled) {
                      print('Please enable location services');
                    } else {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied) {
                          print('Location permission is denied');
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
                          GestureDetector(
                              onTap: (){
                                Get.toNamed(RouteHelper.getVendorDetail(widget.vendorId));
                              },
                              child: AppIcon(icon: Icons.store)),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(20),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: SizedBox(child: BigText(size: Dimensions.font26, text: food.foodName!))),
                                  BigText(size: Dimensions.font26, text: "₱${food.foodPrice.toStringAsFixed(2)}")
                                ],
                              ),
                              SizedBox(height: Dimensions.height10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(text: "${food.vendorName}, ${food.vendorLoc}"),
                                  Row(
                                    children: [
                                      RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: isNew(food.food_created!)),
                                      isNew(food.food_created!)?SizedBox(width: Dimensions.width10/2,):SizedBox(),
                                      food.isSpicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: food.isSpicy=="true"?true:false):Text(""),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          width: double.maxFinite,
                          padding: EdgeInsets.only(top: Dimensions.width20, left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius20),
                              topRight: Radius.circular(Dimensions.radius20),
                            ),
                          ),
                        ),
                      ),
                      pinned: true,
                      backgroundColor: AppColors.mainColor,
                      expandedHeight: Dimensions.screenHeight/1.4,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                            food.foodImg!,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: food.food_description==""?SizedBox():Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                              child: Text(
                                food.food_description!,
                                textAlign: TextAlign.start,
                                maxLines: 4,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                )
            );
          } else {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  heroTag: "vendor_detail_page",            // always ake heroTag unique per floating action button please thanks
                  onPressed: () async {
                    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
                    print(locationEnabled);
                    if (!locationEnabled) {
                      print('Please enable location services');
                    } else {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied) {
                          print('Location permission is denied');
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
                          GestureDetector(
                              onTap: (){
                                Get.toNamed(RouteHelper.getVendorDetail(widget.vendorId));
                              },
                              child: AppIcon(icon: Icons.store)),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(20),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: shimmer(height: Dimensions.font26)),
                                  SizedBox(width: Dimensions.width30,),
                                  Expanded(
                                    flex: 2,
                                    child: shimmer(height: Dimensions.font26)),
                                ],
                              ),
                              SizedBox(height: Dimensions.height10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: shimmer(height: Dimensions.font16)),
                                  SizedBox(width: Dimensions.width30*6,),
                                  Expanded(
                                    flex: 1,
                                    child: shimmer(height: Dimensions.font16)),
                                ],
                              ),
                            ],
                          ),
                          width: double.maxFinite,
                          padding: EdgeInsets.only(top: Dimensions.width20, left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius20),
                              topRight: Radius.circular(Dimensions.radius20),
                            ),
                          ),
                        ),
                      ),
                      pinned: true,
                      backgroundColor: Colors.white,
                      expandedHeight: Dimensions.screenHeight/1.4,
                      flexibleSpace: FlexibleSpaceBar(
                        background: shimmer()
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                          child: shimmer(
                            height: Dimensions.height30*3,
                          ))
                    ),
                  ],
                )
            );
          }
    });

  }
}
