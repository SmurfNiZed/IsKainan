import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/auth_controller.dart';

import '../../controllers/profile_controller.dart';
import '../../data/repository/user_repo.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/rectangle_icon_widget.dart';
import '../../widgets/small_text.dart';
import '../splash/splash_page.dart';

class MenuManagementPage extends StatefulWidget {
  String? email;
  String? vendor_id;
  MenuManagementPage({Key? key, required this.email, required this.vendor_id}) : super(key: key);

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    Future<void> _addMenu(String vendorId) async {
      final userRepo = Get.put(UserRepository());

      final menuInitial = VendorMenu(
        foodName: "Spicy Buttered Chicken",
        foodPrice: "89.00",
        foodImg: " ",
        isAvailable: "true",
        isSpicy: "true",
        food_created: Timestamp.now().toDate().toString(),
      );

      await userRepo.addVendorMenu(menuInitial, vendorId);
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: Dimensions.height20),
            child: Column(
              children: [
                SizedBox(height: Dimensions.height45*3),
                AppIcon(icon: Icons.restaurant_menu,
                    backgroundColor: AppColors.iconColor1,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height30 + Dimensions.height45,
                    size: Dimensions.height15 * 10),
                SizedBox(height: Dimensions.height45),
                FutureBuilder(
                    future: FirebaseFirestore.instance.collection('vendors').where("email", isEqualTo: widget.email).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        )
                        );
                      } else if (snapshot.hasData) {
                        final Stream<QuerySnapshot> postStream = FirebaseFirestore.instance.collection('vendors').doc(widget.vendor_id).collection('foodList').snapshots();
                        return StreamBuilder<QuerySnapshot>(
                          stream: postStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                color: AppColors.mainColor,
                              );
                            } else if (snapshot.hasData) {
                              var food = snapshot.data;
                              if (food!.size == 0){
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
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: food!.size,
                                    itemBuilder: (BuildContext context, int index) {
                                      final foodItem = food!.docs[index];
                                      final foodName = foodItem['food_name'];
                                      final foodPrice = foodItem['food_price'];
                                      final foodImg = foodItem['food_img'];
                                      final is_available = foodItem['is_available'];
                                      final is_spicy = foodItem['is_spicy'];
                                      final food_created = foodItem['food_created'];
                                      return Opacity(
                                        opacity: is_available=="true"?1:0.2,
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
                                                      image: AssetImage('assets/images/food2.jpg'),
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
                                                            BigText(text: foodName, size: Dimensions.font20,),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            BigText(text: foodPrice==" "?"":"₱"+ foodPrice, size: Dimensions.font16*.9),
                                                            SizedBox(height: Dimensions.height10/2,),
                                                            Row(
                                                              children: [
                                                                RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true),
                                                                SizedBox(width: Dimensions.width10/2,),
                                                                is_spicy=="true"?RectangleIconWidget(text: "SPICY", iconColor: Colors.red[900]!, isActivated: true):Text(""),
                                                                food_created=="true"?RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: true):Text(""),
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
                                      );
                                    });
                              }

                            } else {
                              return Center(
                                child: BigText(text: "Foodlist is Empty!"),
                              );
                            }
                          },
                        );

                      } else {
                        return Center(
                            child: BigText(text: "Unknown Vendor. Who are you!?",)
                        );
                      }
                    }
                ),
                GestureDetector(
                  onTap: (){
                    _addMenu(widget.vendor_id!);
                  },
                  child: Container(
                    height: Dimensions.height30*4,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                    child: Icon(Icons.add, size: 50, color: Colors.grey,),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: Dimensions.height45 + Dimensions.height10,
            left: Dimensions.width20,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AppIcon(icon: Icons.arrow_back,
                  backgroundColor: AppColors.iconColor1,
                  iconColor: Colors.white,)),
          ),
        ],
      ),
    );
  }
}


// ListView(
// children: snapshot.data!.docs.map((document) {
// return Center(
// child: Container(
// width: MediaQuery.of(context).size.width/1.2,
// height: 300,
// child: Text("Title " + document['food_name']),
// ),
// );
// }).toList(),
// );