import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iskainan/controllers/vendor_controller.dart';
import 'package:iskainan/models/vendors_model.dart';
import 'package:iskainan/widgets/big_text.dart';
import 'package:iskainan/widgets/icon_and_text_widget.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';
import 'package:iskainan/widgets/small_text.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_column.dart';
import 'package:get/get.dart';

// Eto yung featured portion sa baba ny search button

class FoodPageBody extends StatefulWidget {
  FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  final VendorController _vendorController = Get.put(VendorController());
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  final CollectionReference vendorCollection =
  FirebaseFirestore.instance.collection('vendors');

  Future<QuerySnapshot> getData() {
    return vendorCollection.get();
  }

  @override
  void initState(){
    super.initState();
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
    return Container(
      child: Column(
        children: [
          GetBuilder<VendorController>(builder: (_){
              if (_vendorController.vendors.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Container(
                        height: Dimensions.pageView,
                        // Press Transition
                        child: PageView.builder(
                            controller: pageController,
                            itemCount: _vendorController.vendors.length,                                                 // Ilang ididisplay sa relevant food
                            itemBuilder: (context, position){
                              // print(position);
                              return _buildPageItem(position,  _vendorController.vendors[position]);
                            })
                    ),
                  ],
                );
              }
            },
          ),
          GetBuilder<VendorController>(builder: (_){
            return DotsIndicator(// Page Dots animation
                        dotsCount: _vendorController.vendors.isEmpty?1:_vendorController.vendors.length,
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
                BigText(text: "Recommended"),
                SizedBox(width: Dimensions.width10,),
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  child: BigText(text: ".", color: Colors.black26),
                ),
                SizedBox(width: Dimensions.width10,),
                Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: SmallText(text: "Street Food", color: Colors.black26),
                )
              ],
            ),
          ),
          // Recommended Food scroll
          GetBuilder<VendorController>(builder: (_){
            if (_vendorController.vendorMenu.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _vendorController.vendorMenu.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('foodList').get();
                                Get.toNamed(RouteHelper.getFoodDetail(querySnapshot.docs[index].reference.parent.parent!.id, _vendorController.vendorMenu[index].foodId!));
                              },
                              child: Opacity(
                                opacity: (_vendorController.vendorMenu[index].isAvailable=="true")?1:0.4,
                                child: Container(
                                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
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
                                              image: NetworkImage(_vendorController.vendorMenu[index].foodImg!),
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
                                                    BigText(text: _vendorController.vendorMenu[index].foodName!, size: Dimensions.font20,),
                                                    SizedBox(height: Dimensions.height10/2,),
                                                    SmallText(text: _vendorController.vendorMenu[index].vendorName!, size: Dimensions.font16*0.8, isOneLine: true,)
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    BigText(text: "₱"+_vendorController.vendorMenu[index].foodPrice!, size: Dimensions.font16*.9),
                                                    SizedBox(height: Dimensions.height10/2,),
                                                    Row(
                                                      children: [
                                                        RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true),
                                                        SizedBox(width: Dimensions.width10/2,),
                                                        _vendorController.vendorMenu[index].isSpicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: _vendorController.vendorMenu[index].isSpicy=="true"?true:false):Text(""),
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
                          })
                  ),
                ],
              );
            }
          }),
        ],
      ),
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
                      color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
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
                  child: AppColumn(vendorId: _vendorController.vendors[index].vendor_id!,),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
