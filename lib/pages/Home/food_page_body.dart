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
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

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
          // Slider section
          GetBuilder<VendorController>(builder:(vendor){
            return vendor.isLoaded?Container(
              height: Dimensions.pageView,
              // Press Transition
              child: PageView.builder(
                  controller: pageController,
                  itemCount: vendor.vendorList.length,                                                 // Ilang ididisplay sa relevant food
                  itemBuilder: (context, position){
                    return _buildPageItem(position,  vendor.vendorList[position]);
                  })
            ):Container(
              height: Dimensions.pageView,
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
          }),
          GetBuilder<VendorController>(builder: (vendor){
            return DotsIndicator(// Page Dots animation
              dotsCount: vendor.vendorList.isEmpty?1:vendor.vendorList.length,
              position: _currPageValue,
              decorator: DotsDecorator(
                activeColor: AppColors.iconColor1,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
            );
          }),
          // Popular Text
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
          GetBuilder<VendorController>(builder: (vendor){
            return vendor.isLoaded?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vendor.vendorList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteHelper.getFoodDetail(index, vendor.vendorList[index].food_model.length-1));
                    },
                    child: Opacity(
                      opacity: (vendor.vendorList[index].food_model[vendor.vendorList[index].food_model.length-1].isAvailable!&&vendor.vendorList[index].isOpen!)?1:0.4,
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
                                    image: AssetImage(vendor.vendorList[index].food_model[vendor.vendorList[index].food_model.length-1].foodImg!),
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
                                          BigText(text: vendor.vendorList[index].food_model[vendor.vendorList[index].food_model.length-1].foodName!, size: Dimensions.font20,),
                                          SizedBox(height: Dimensions.height10/2,),
                                          SmallText(text: vendor.vendorList[index].vendorName! + ", " + vendor.vendorList[index].vendorLocation!, size: Dimensions.font16*0.8, isOneLine: true,),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BigText(text: "₱"+(vendor.vendorList[index].food_model[vendor.vendorList[index].food_model.length-1].foodPrice!), size: Dimensions.font16*.9),
                                          SizedBox(height: Dimensions.height10/2,),
                                          Row(
                                            children: [
                                              RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true),
                                              SizedBox(width: Dimensions.width10/2,),
                                              vendor.vendorList[index].food_model[vendor.vendorList[index].food_model.length-1].isSpicy!?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: vendor.vendorList[index].food_model[vendor.vendorList[index].food_model.length-1].isSpicy!):Text(""),
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
  Widget _buildPageItem(int index, VendorModel vendor){                                     // Use stack para mapatong patong ang pics
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
              Get.toNamed(RouteHelper.getVendorDetail(index));
            },
            child: Opacity(
              opacity: vendor.isOpen!?1:0.4,
              child: Container(                                                      // Food pics
                  height: Dimensions.pageViewContainer,
                  margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            vendor.vendorImg!
                        ),
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
                opacity: vendor.isOpen!?1:0.2,
                child: Container(
                  padding: EdgeInsets.only(top: Dimensions.height10, left: Dimensions.width15, right: Dimensions.width15, bottom: Dimensions.height10),
                  child: AppColumn(pageId: index,),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
