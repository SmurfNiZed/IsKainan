import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/controllers/vendor_controller.dart';
import 'package:iskainan/models/vendors_model.dart';
import 'package:iskainan/widgets/big_text.dart';
import 'package:iskainan/widgets/icon_and_text_widget.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';
import 'package:iskainan/widgets/small_text.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../controllers/address_name_controller.dart';
import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/distance.dart';
import '../../utils/shimmer.dart';
import '../../widgets/app_column.dart';
import 'package:get/get.dart';

// Eto yung featured portion sa baba ny search button

class FoodPageBody extends StatefulWidget {
  String searchString;
  num budget;
  LatLng position;

  FoodPageBody({Key? key,

  required this.searchString,
  required this.budget,
  required this.position}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  Future<void> _loadResource() async {
    Get.find<VendorController>().getVendors();
    Get.find<VendorController>().getVendorMenu();
  }

  PageController pageController = PageController(viewportFraction: 0.85);
  VendorController _vendorController = Get.put(VendorController());
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  final CollectionReference vendorCollection =
  FirebaseFirestore.instance.collection('vendors');

  Future<QuerySnapshot> getData() {
    return vendorCollection.get();
  }



  Future<String?> _getUserLocation() async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();
      return getAddressFromLatLng(position.latitude, position.longitude);
    } else {
      Position position = await Geolocator.getCurrentPosition();
      return getAddressFromLatLng(position.latitude, position.longitude);
    }
  }

  String? _userLocation;

  @override
  void initState(){
    super.initState();
    _loadResource;
    _getUserLocation().then((value) {
      setState(() {
        _userLocation = value;
      });
    });

    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();          // dispose include child pages that gets loaded in this page
  }

  @override
  Widget build(BuildContext context) {

    var queryVendorNames = [];
    List<VendorWithDistance> queryVendors = [];
    List<VendorMenuWithDistance> queryVendorMenu = [];

    for(var i = 0; i < _vendorController.vendorMenu.length; i++){
      if(!queryVendorNames.contains(_vendorController.vendorMenu[i].vendorName) &&
          widget.budget >= _vendorController.vendorMenu[i].foodPrice &&
          (_vendorController.vendorMenu[i].foodName.toString().toLowerCase().isCaseInsensitiveContainsAny(widget.searchString.toLowerCase()) || _vendorController.vendorMenu[i].vendorName.toString().toLowerCase().isCaseInsensitiveContainsAny(widget.searchString.toLowerCase()))
      ) {
        queryVendorNames.add(_vendorController.vendorMenu[i].vendorName);
        for(var j = 0; j < _vendorController.vendors.length; j++){
          if(_vendorController.vendors[j].is_open=="true" &&
            _vendorController.vendors[j].vendor_id == _vendorController.vendorMenu[i].vendorId){
            queryVendors.add(VendorWithDistance(vendorData: _vendorController.vendors[j], distance: getDistance(LatLng(_vendorController.vendors[j].latitude!, _vendorController.vendors[j].longitude!), widget.position)));
            break;
          }
        }
      }
    }

    queryVendors.sort((a, b) => a.distance.compareTo(b.distance));

    return Column(
      children: [
        GetBuilder<VendorController>(builder: (_){
          if (_vendorController.vendorMenu.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Container(
                    height: Dimensions.pageView,
                    // Press Transition
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: queryVendors.length,                                                 // Ilang ididisplay sa relevant food
                        itemBuilder: (context, position){
                          return _buildPageItem(position,  queryVendors[position].vendorData);
                        })
                ),
              ],
            );
          }
        },
        ),
        GetBuilder<VendorController>(builder: (_){
          return DotsIndicator(// Page Dots animation
            dotsCount: queryVendors.isEmpty?1:queryVendors.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.iconColor1,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        SizedBox(height: Dimensions.height30,),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width20),
          child: Row(
            crossAxisAlignment:CrossAxisAlignment.end ,
            children: [
              BigText(text: widget.searchString==""?"What's nearby?":"Searching"),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(text: ".", color: Colors.black26),
              ),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: _userLocation!=null?SmallText(text: widget.searchString==""?_userLocation!:"${widget.searchString}/₱${widget.budget.toStringAsFixed(2)}/${_userLocation??"..."}", isOneLine: true,):shimmer(width: Dimensions.width30*4, height: Dimensions.height15,),

              )
            ],
          ),
        ),
        // Recommended Food scroll
        GetBuilder<VendorController>(builder: (_){
          if (_vendorController.vendorMenu.isEmpty) {
            return Center(
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      ],
                    )));
          } else {
            for(var i = 0; i < _vendorController.vendorMenu.length; i++){
              for(var j = 0; j < queryVendors.length; j++){
                if(_vendorController.vendorMenu[i].vendorId == queryVendors[j].vendorData.vendor_id){
                  queryVendorMenu.add(VendorMenuWithDistance(menuData: _vendorController.vendorMenu[i], distance: queryVendors[j].distance));
                }
              }
            }

            queryVendorMenu.sort((a, b) => a.distance.compareTo(b.distance));
            return Column(
              children: [
                Container(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: queryVendorMenu.length,
                        itemBuilder: (context, index) {
                          if(widget.budget >= queryVendorMenu[index].menuData.foodPrice &&
                            (queryVendorMenu[index].menuData.foodName.toString().toLowerCase().isCaseInsensitiveContainsAny(widget.searchString.toLowerCase()) || queryVendorMenu[index].menuData.foodName.toString().toLowerCase().isCaseInsensitiveContainsAny(widget.searchString.toLowerCase()))
                              && queryVendorMenu[index].menuData.isAvailable=="true"
                          ){
                            return GestureDetector(
                                  onTap: () async {
                                    Get.toNamed(RouteHelper.getFoodDetail(queryVendorMenu[index].menuData.vendorId!, queryVendorMenu[index].menuData.foodId!));
                                  },
                                  child: Opacity(
                                    opacity: (queryVendorMenu[index].menuData.isAvailable=="true")?1:0.4,
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
                                                  image: NetworkImage(queryVendorMenu[index].menuData.foodImg!),
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
                                                        BigText(text: queryVendorMenu[index].menuData.foodName!, size: Dimensions.font20,),
                                                        SizedBox(height: Dimensions.height10/2,),
                                                        SmallText(text: queryVendorMenu[index].menuData.vendorName! + ", " + queryVendorMenu[index].menuData.vendorLoc!, size: Dimensions.font16*0.8, isOneLine: true,)
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        BigText(text: "₱"+queryVendorMenu[index].menuData.foodPrice.toStringAsFixed(2), size: Dimensions.font16*.9),
                                                        SizedBox(height: Dimensions.height10/2,),
                                                        Row(
                                                          children: [
                                                            RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true),
                                                            SizedBox(width: Dimensions.width10/2,),
                                                            queryVendorMenu[index].menuData.isSpicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: queryVendorMenu[index].menuData.isSpicy=="true"?true:false):Text(""),
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
                        })
                ),
              ],
            );
          }
        }),
      ],
    );
  }

  Widget _buildPageItem(int index, VendorData vendor){                                     // Use stack para mapatong patong ang pics
    Matrix4 matrix = new Matrix4.identity();                            // Math for sliding animation, DO NOT TOUCH PLS
    if(index == _currPageValue.floor()){
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }
    else if(index == _currPageValue.floor()+1){
      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }
    else if(index == _currPageValue.floor()-1){
      var currScale = 1-(_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else{
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){
              Get.toNamed(RouteHelper.getVendorDetail(vendor.vendor_id!));
            },
            child: Opacity(
              opacity: vendor.is_open=="true"?1:0.4,
              child: Container(                                                      // Food pics
                  height: Dimensions.pageViewContainer,
                  margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: Colors.grey.withOpacity(0.04),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(vendor.vendor_img!)
                      )
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(                                             // Food details
                height: Dimensions.pageViewTextContainer+5,
                margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, bottom: Dimensions.height30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white,
                    boxShadow: [                                                              // Drop Shadow
                      BoxShadow(
                          color: Color(0xFFe8e8e8),
                          blurRadius: 5.0,
                          offset: Offset(0, 5)
                      ),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, 0)
                      ),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(5, 0)
                      )
                    ]
                ),
                child: Opacity(
                  opacity: vendor.is_open=="true"?1:0.2,
                  child: Container(
                    padding: EdgeInsets.only(top: Dimensions.height10, left: Dimensions.width15, right: Dimensions.width15, bottom: Dimensions.height10),
                    child: AppColumn(vendorId: vendor.vendor_id!,),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
