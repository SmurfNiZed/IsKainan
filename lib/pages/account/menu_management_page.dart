import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
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
  VendorData user;
  MenuManagementPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {


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
        food_created: Timestamp.now(),
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
        food_created: entry.food_created
      );

      await userRepo.updateVendorMenu(vendorId, entry.foodId!, newMenu);
    }

    Future<void> _deleteMenu(String vendorId, String foodId, String vendorName, String foodName) async {
      final userRepo = Get.put(UserRepository());
      await userRepo.deleteVendorMenu(vendorId, foodId);
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference reference = storage.ref().child('vendors/${vendorName}(${vendorId})/FoodList/${foodName}');
      reference.delete().whenComplete(() => AwesomeDialog(
        context: context,
        title: "Okay!",
        titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: Dimensions.font26,
            fontWeight: FontWeight.bold
        ),
        desc: "Food Deleted",
        descTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.normal
        ),
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        autoDismiss: true,
        autoHide: Duration(seconds: 3),
      ).show());
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                  GestureDetector(
                    onTap: (){
                      late TextEditingController foodNameController = TextEditingController();
                      late TextEditingController foodPriceController = TextEditingController();
                      late String food_img;
                      late String is_available = "false";
                      late String is_spicy = "false";
                      XFile? _imageFile;
                      StreamController<File> _imageController = StreamController<File>();

                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.topSlide,
                          dismissOnTouchOutside: true,
                          dismissOnBackKeyPress: true,
                          showCloseIcon: true,
                          btnOkOnPress: () async {
                            String uniqueFileName = foodNameController.text.trim();

                            Reference referenceRoot = FirebaseStorage.instance.ref();
                            Reference referenceDirImages = referenceRoot.child("vendors/${widget.user.vendor_name}(${widget.user.vendor_id})/FoodList");

                            Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                            try{
                              await referenceImageToUpload.putFile(File(_imageFile!.path));
                              String imageUrl = await referenceImageToUpload.getDownloadURL();
                              final entry = VendorMenu(
                                foodName: foodNameController.text.trim(),
                                foodPrice: foodPriceController.text.trim(),
                                foodImg: imageUrl,
                                isAvailable: is_available,
                                isSpicy: is_spicy,
                                food_created: Timestamp.now(),
                              );
                              _addMenu(widget.user.vendor_id!, entry);
                            }catch(error){

                            }
                          },
                          btnOkColor: AppColors.iconColor1,
                          btnOkText: 'Create',
                          body: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: Dimensions.width10),
                                  child: BigText(text: "Add a Product"),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: Dimensions.height10,),
                                    GestureDetector(
                                      onTap: (){
                                        AwesomeDialog(
                                          context: context,
                                          title: "Upload Food Photo",
                                          titleTextStyle: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: Dimensions.font20,
                                              fontWeight: FontWeight.bold
                                          ),
                                          dialogType: DialogType.noHeader,
                                          animType: AnimType.topSlide,
                                          showCloseIcon: true,
                                          dismissOnTouchOutside: true,
                                          dismissOnBackKeyPress: true,
                                          btnCancelIcon: Icons.photo_camera,
                                          btnCancelText: "Camera",
                                          btnCancelOnPress: () async {
                                            final imagePicker = ImagePicker();
                                            _imageFile = await imagePicker.pickImage(source: ImageSource.camera);
                                            if(_imageFile != null){
                                              _imageController.add(File(_imageFile!.path));
                                            }
                                          },
                                          btnCancelColor: AppColors.iconColor1,
                                          btnOkOnPress: () async {
                                            final imagePicker = ImagePicker();
                                            _imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
                                            if(_imageFile != null){
                                              _imageController.add(File(_imageFile!.path));
                                            }
                                          },
                                          btnOkIcon: Icons.upload,
                                          btnOkColor: AppColors.iconColor1,
                                          btnOkText: 'Gallery',
                                        ).show();
                                      },
                                      child: StreamBuilder(
                                        stream: _imageController.stream,
                                        builder: (BuildContext context, AsyncSnapshot<File> snapshot){
                                          if(!snapshot.hasData){
                                            return Container(
                                                margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                                height: Dimensions.listViewImgSize,
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                                    color: Colors.grey[100],
                                                ),
                                                child: Icon(Icons.camera_alt),
                                            );
                                          }
                                          else{
                                            return Container(
                                              margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                              height: Dimensions.listViewImgSize,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                                  color: Colors.grey[100],
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(File(_imageFile!.path)),
                                                  )
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20,),
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
                      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                      child: Icon(Icons.add, size: 50, color: Colors.grey,),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance.collection('vendors').where("email", isEqualTo: widget.user.email).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: JumpingDotsProgressIndicator(
                            color: AppColors.iconColor1,
                            )
                          );
                        } else if (snapshot.hasData) {
                          final Stream<QuerySnapshot> postStream = FirebaseFirestore.instance.collection('vendors').doc(widget.user.vendor_id).collection('foodList').orderBy("food_created", descending: true).snapshots();
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
                                        late String vendorName;

                                        return GestureDetector(
                                          onTap: (){

                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.noHeader,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              dismissOnTouchOutside: true,
                                              dismissOnBackKeyPress: true,
                                              btnCancelText: "Delete",
                                              btnCancelOnPress: (){
                                                _deleteMenu(vendorId, foodId, vendorName, foodName);
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
                                                  food_created: food_created,
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
                                                      vendorName = user.vendor_name!;
                                                      return Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: Dimensions.width10),
                                                              child: BigText(text: "Edit Product"),
                                                            ),
                                                            Column(
                                                              children: [

                                                                SizedBox(height: Dimensions.height10,),
                                                                Container(
                                                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                                                  height: Dimensions.listViewImgSize,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                                                      color: Colors.white38,
                                                                      image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: AssetImage('assets/images/food2.jpg'),
                                                                      )
                                                                  ),
                                                                ),
                                                                SizedBox(height: Dimensions.height20,),

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
                                                  StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection('vendors').doc(widget.user.vendor_id).collection('foodList').doc(foodId).snapshots(),
                                                      builder: (context, foodImgSnapshot) {
                                                        if (foodImgSnapshot.hasData) {
                                                          var imgUrl = foodImgSnapshot.data?.data() as Map<String, dynamic>;
                                                          return imgUrl['food_img'] == ""?AppIcon(
                                                              icon: Icons.fastfood_rounded,
                                                              backgroundColor: AppColors.mainColor,
                                                              iconColor: Colors.white,
                                                              iconSize: Dimensions.height30 + Dimensions.height45,
                                                              size: Dimensions.height15 * 10)
                                                              :  CachedNetworkImage(
                                                            width: Dimensions.listViewImgSize,
                                                            height: Dimensions.listViewImgSize,
                                                            imageUrl: imgUrl['food_img'],
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Container(
                                                            width: Dimensions.listViewImgSize,
                                                            height: Dimensions.listViewImgSize,
                                                            child: Center(child: CircularProgressIndicator(
                                                              color: Colors.white,
                                                            ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                              color: AppColors.iconColor1,
                                                            ),
                                                          );
                                                        }
                                                      }
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



