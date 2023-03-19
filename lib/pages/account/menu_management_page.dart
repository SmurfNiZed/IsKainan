import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/auth_controller.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../controllers/profile_controller.dart';
import '../../data/repository/user_repo.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text_field.dart';
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

  // Future MenuEditor() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Menu Editor'),
  //       content: TextField(
  //         decoration: InputDecoration(
  //           hintText: "Enter your name",
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           child: Text('Save Changes',
  //             style:
  //               TextStyle(
  //                 color: Colors.white
  //               ),
  //             ),
  //           style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(AppColors.iconColor1),
  //           ),
  //           onPressed: (){
  //
  //           },
  //         ),
  //       ],
  //     ),
  // );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    Future<void> _addMenu(String vendorId, VendorMenu entry) async {
      final userRepo = Get.put(UserRepository());

      final menuInitial = VendorMenu(
        foodName: entry.foodName,
        foodPrice: entry.foodPrice,
        foodImg: entry.foodImg,
        isAvailable: entry.isAvailable,
        isSpicy: entry.isSpicy,
        food_created: Timestamp.now().toDate(),
      );

      await userRepo.addVendorMenu(menuInitial, vendorId);
    }

    Future<void> _updateMenu(String vendorId, VendorMenu entry) async {
      final userRepo = Get.put(UserRepository());

      final newMenu = VendorMenu(
        foodName: entry.foodName,
        foodPrice: entry.foodPrice,
        foodImg: entry.foodImg,
        isAvailable: entry.isAvailable,
        isSpicy: entry.isSpicy,
      );

      await userRepo.updateVendorMenu(vendorId, entry.foodId!, newMenu);
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
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
                          return Center(child: JumpingDotsProgressIndicator(
                            color: AppColors.iconColor1,
                            )
                          );
                        } else if (snapshot.hasData) {
                          final Stream<QuerySnapshot> postStream = FirebaseFirestore.instance.collection('vendors').doc(widget.vendor_id).collection('foodList').orderBy("food_created", descending: false).snapshots();
                          return StreamBuilder<QuerySnapshot>(
                            stream: postStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: JumpingDotsProgressIndicator(
                                  color: AppColors.iconColor1,
                                )
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
                                      itemCount: food.size,
                                      itemBuilder: (BuildContext context, int index) {
                                        final foodItem = food!.docs[index];
                                        final foodId = foodItem.id;
                                        final foodName = foodItem['food_name'];
                                        final foodPrice = foodItem['food_price'];
                                        final foodImg = foodItem['food_img'];
                                        var is_available = foodItem['is_available'];
                                        var is_spicy = foodItem['is_spicy'];
                                        final food_created = foodItem['food_created'];

                                        late TextEditingController foodNameController =
                                        TextEditingController(text: foodName.toString());
                                        late TextEditingController foodPriceController =
                                        TextEditingController(text: foodPrice.toString());

                                        late String vendorId;

                                        return GestureDetector(
                                          onTap: (){
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.noHeader,
                                              animType: AnimType.topSlide,
                                              title: "Test",
                                              // desc: "Test Description",
                                              dismissOnTouchOutside: true,
                                              dismissOnBackKeyPress: true,
                                              btnCancelOnPress: (){

                                              },
                                              btnCancelColor: AppColors.mainColor,
                                              btnOkOnPress: (){
                                                final updatedEntry = VendorMenu(
                                                  foodId: foodId,
                                                  foodName: foodNameController.text.trim(),
                                                  foodPrice: foodPriceController.text.trim(),
                                                  foodImg: " ",
                                                  isAvailable: is_available,
                                                  isSpicy: is_spicy,
                                                );
                                                _updateMenu(vendorId, updatedEntry);

                                              },
                                              btnOkColor: AppColors.iconColor1,
                                              btnOkText: 'Save',
                                              body: FutureBuilder(
                                                  future: controller.getUserData(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.done) {
                                                      VendorData user = snapshot.data as VendorData;
                                                      vendorId = user.vendor_id!;
                                                      return Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: [
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
                                                                AppTextField(
                                                                  textController: foodNameController,
                                                                  hintText: "Product Name",
                                                                  icon: Icons.restaurant_menu,
                                                                  backgroundColor: AppColors.iconColor1,
                                                                ),
                                                                SizedBox(height: Dimensions.height20),

// Contact Number
                                                                AppTextField(
                                                                  textController: foodPriceController,
                                                                  hintText: "Price",
                                                                  icon: Icons.attach_money_rounded,
                                                                  backgroundColor: AppColors.iconColor1,
                                                                ),
                                                                SizedBox(height: Dimensions.height20),

                                                                Container(
                                                                  margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            blurRadius: 10,
                                                                            spreadRadius: 7,
                                                                            offset: Offset(1, 10),
                                                                            color: Colors.grey.withOpacity(0.2)
                                                                        )
                                                                      ]
                                                                  ),
                                                                  child: StatefulBuilder(
                                                                    builder: (context, _setState) => CheckboxListTile(
                                                                      value: is_available=="true"?true:false,
                                                                      title: Transform.translate(
                                                                        offset: const Offset(-15,0),
                                                                        child: SmallText(text: "Available", size: Dimensions.font16,),
                                                                      ),
                                                                      onChanged: (val) {
                                                                        _setState(() => val!?is_available="true":is_available="false");
                                                                      },
                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                      checkColor: Colors.white,
                                                                      activeColor: AppColors.iconColor1,
                                                                      contentPadding: EdgeInsets.only(left: Dimensions.width10*2/3),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: Dimensions.height20,),
                                                                Container(
                                                                  margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            blurRadius: 10,
                                                                            spreadRadius: 7,
                                                                            offset: Offset(1, 10),
                                                                            color: Colors.grey.withOpacity(0.2)
                                                                        )
                                                                      ]
                                                                  ),
                                                                  child: StatefulBuilder(
                                                                    builder: (context, _setState) => CheckboxListTile(
                                                                      value: is_spicy=="true"?true:false,
                                                                      title: Transform.translate(
                                                                        offset: const Offset(-15,0),
                                                                        child: SmallText(text: "Spicy", size: Dimensions.font16,),
                                                                      ),
                                                                      onChanged: (val) {
                                                                        _setState(() => val!?is_spicy="true":is_spicy="false");
                                                                      },
                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                      checkColor: Colors.white,
                                                                      activeColor: AppColors.iconColor1,
                                                                      contentPadding: EdgeInsets.only(left: Dimensions.width10*2/3),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        color: Colors.white,
                                                        child: Center(
                                                            child: CircularProgressIndicator(
                                                              color: AppColors.mainColor,
                                                            )),
                                                      );
                                                    }
                                                  })
                                            ).show();
                                          },
                                          child: Opacity(
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
                      late TextEditingController foodNameController = TextEditingController();
                      late TextEditingController foodPriceController = TextEditingController();
                      late String food_img;
                      late String is_available = "false";
                      late String is_spicy = "false";

                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.topSlide,
                          title: "Add a Product",

                          dismissOnTouchOutside: true,
                          dismissOnBackKeyPress: true,
                          btnCancelOnPress: (){
                          },
                          btnCancelColor: AppColors.mainColor,
                          btnOkOnPress: (){
                            final entry = VendorMenu(
                              foodName: foodNameController.text.trim(),
                              foodPrice: foodPriceController.text.trim(),
                              foodImg: " ",
                              isAvailable: is_available,
                              isSpicy: is_spicy,
                              food_created: Timestamp.now().toDate(),
                            );
                            _addMenu(widget.vendor_id!, entry);
                          },
                          btnOkColor: AppColors.iconColor1,
                          btnOkText: 'Save',
                          body: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Column(
                                  children: [
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
                                    AppTextField(
                                      textController: foodNameController,
                                      hintText: "Product Name",
                                      icon: Icons.restaurant_menu,
                                      backgroundColor: AppColors.iconColor1,
                                    ),
                                    SizedBox(height: Dimensions.height20),

                                    AppTextField(
                                      textController: foodPriceController,
                                      hintText: "Price",
                                      icon: Icons.attach_money_rounded,
                                      backgroundColor: AppColors.iconColor1,
                                    ),
                                    SizedBox(height: Dimensions.height20),

                                    Container(
                                      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 7,
                                                offset: Offset(1, 10),
                                                color: Colors.grey.withOpacity(0.2)
                                            )
                                          ]
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, _setState) => CheckboxListTile(
                                          value: is_available=="true"?true:false,
                                          title: Transform.translate(
                                            offset: const Offset(-15,0),
                                            child: SmallText(text: "Available", size: Dimensions.font16,),
                                          ),
                                          onChanged: (val) {
                                            _setState(() => val!?is_available="true":is_available="false");
                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                          checkColor: Colors.white,
                                          activeColor: AppColors.iconColor1,
                                          contentPadding: EdgeInsets.only(left: Dimensions.width10*2/3),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: Dimensions.height20,),

                                    Container(
                                      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 7,
                                                offset: Offset(1, 10),
                                                color: Colors.grey.withOpacity(0.2)
                                            )
                                          ]
                                      ),
                                      child: StatefulBuilder(
                                        builder: (context, _setState) => CheckboxListTile(
                                          value: is_spicy=="true"?true:false,
                                          title: Transform.translate(
                                            offset: const Offset(-15,0),
                                            child: SmallText(text: "Spicy", size: Dimensions.font16,),
                                          ),
                                          onChanged: (val) {
                                            _setState(() => val!?is_spicy="true":is_spicy="false");
                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                          checkColor: Colors.white,
                                          activeColor: AppColors.iconColor1,
                                          contentPadding: EdgeInsets.only(left: Dimensions.width10*2/3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                      ).show();
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



