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
import '../../widgets/big_text.dart';
import '../../widgets/expandable_text_widget.dart';
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
      autoHide: Duration(seconds: 2),
    ).show();
  }

  void _navigateToFindVendor(Position position) {
    final DocumentReference documentReference = FirebaseFirestore.instance.collection('vendors').doc(widget.vendorId);
    documentReference.get().then((DocumentSnapshot documentSnapshot) {
      var latitude = documentSnapshot.get('latitude');
      var longitude = documentSnapshot.get('longitude');
      Get.toNamed(RouteHelper.getFindVendor(
          position.latitude.toString(),
          position.longitude.toString(),
          latitude.toString(),
          longitude.toString()
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // var foodProfile = Get.find<VendorController>().getVendorMenuData(foodId);
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
                          _showCircularProgressIndicator();
                          Position position = await Geolocator.getCurrentPosition();
                          _navigateToFindVendor(position);
                        }
                      } else {
                        _showCircularProgressIndicator();
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
                          child: BigText(size: Dimensions.font26, text: food.foodName!),
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
                      expandedHeight: Dimensions.screenHeight/2,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                            food.foodImg!,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                              child: ExpandableTextWidget(text: "A delicious and sophisticated take on the classic taco. Inspired by the fresh flavors of coastal cuisine, this taco features a variety of seafood fillings, including succulent shrimp, tender crab meat, or flaky fish. Each taco is topped with bright and tangy salsas or creamy avocado crema, adding a burst of flavor that perfectly complements the seafood. The name Taco de la Costa evokes images of sun, sand, and sea, making it a perfect choice for anyone seeking a taste of the coast in a single bite. Taco de la Costa is the perfect choice for seafood lovers who crave a bit of sophistication in their tacos. The seafood fillings are cooked to perfection, ensuring that each bite is succulent and bursting with flavor. The salsas and avocado crema add a bright and fresh element to the dish, perfectly complementing the rich flavors of the seafood. Whether you're in the mood for shrimp, crab, or fish, Taco de la Costa is sure to satisfy your craving for coastal cuisine. The name itself conjures up images of white sandy beaches, crystal clear waters, and the salty breeze of the ocean, transporting you to a world of relaxation and indulgence with every bite. "),
                              margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            );
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    )
                )
            );
          }
    });

  }
}
