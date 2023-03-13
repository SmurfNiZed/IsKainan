import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';

import '../../controllers/vendor_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_column.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';

class VendorDetail extends StatelessWidget {
  final int pageId;
  const VendorDetail({Key? key, required this.pageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vendorProfile = Get.find<VendorController>().vendorList[pageId];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "vendor_detail_page",            // always ake heroTag unique per floating action button please thanks
        onPressed: (){},
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
                AppIcon(icon: Icons.hotel_class_rounded)
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: Container(
                child: AppColumn(pageId: pageId!,),
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
            expandedHeight: Dimensions.screenHeight*2/5,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                  vendorProfile.vendorImg!,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child:
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: vendorProfile.food_model.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Get.toNamed(RouteHelper.getFoodDetail(pageId, index));
                      },
                      child: Opacity(
                        opacity: vendorProfile.food_model[index].isAvailable!?1:0.2,
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
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(vendorProfile.food_model[index].foodImg!),
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SmallText(text: vendorProfile.food_model[index].foodName!, size: Dimensions.font20,),
                                        SizedBox(height: Dimensions.height10),
                                        BigText(text: "₱" + vendorProfile.food_model[index].foodPrice.toString(), size: Dimensions.font16,),
                                        SizedBox(height: Dimensions.height10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            RectangleIconWidget(text: "NEW", iconColor: Colors.yellow[600]!, isActivated: true),
                                            SizedBox(width: Dimensions.width10/2,),
                                            vendorProfile.food_model[index].isSpicy!?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: vendorProfile.food_model[index].isSpicy!):SmallText(text: ""),
                                            vendorProfile.food_model[index].isSpicy!?SizedBox(width: Dimensions.width10,):SmallText(text: ""),
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
            )
        ],
      ),
    );
  }
}
