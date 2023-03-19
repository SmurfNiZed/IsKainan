import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/data/repository/user_repo.dart';
import 'package:iskainan/pages/account/general_information_page.dart';
// import 'package:iskainan/controllers/profile_controller.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/circle_image.dart';
import '../splash/splash_page.dart';
import 'account_details_page.dart';
import 'manage_location_page.dart';
import 'menu_management_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  String imageUrl = '';

  @override

  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return FutureBuilder(
      future: controller.getUserData(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done) {
          VendorData user = snapshot.data as VendorData;
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('vendors').doc(user.vendor_id).snapshots(),
            builder: (context, vendorImgSnapshot) {
              if (vendorImgSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                  )
                );
              } else if (vendorImgSnapshot.hasData) {
                var imgUrl = vendorImgSnapshot.data?.data() as Map<String, dynamic>;
                return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: GestureDetector(
                          onTap: () {
                            Get.offAll(() => SplashScreen(time: 50,));
                          },
                          child: AppIcon(icon: Icons.arrow_back,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,)),
                    ),
                    body: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: Dimensions.height45),
                          Stack(
                              children: [
                                imgUrl['vendor_img']==AppConstants.DEFAULT_VENDOR_PIC?AppIcon(
                                    icon: Icons.storefront,
                                    backgroundColor: AppColors.mainColor,
                                    iconColor: Colors.white,
                                    iconSize: Dimensions.height30 + Dimensions.height45,
                                    size: Dimensions.height15 * 10)
                                : GestureDetector(
                                    onTap: (){

                                    },
                                    child: CircleImage(
                                    imgUrl: imgUrl['vendor_img'],
                                    backgroundColor: AppColors.mainColor,
                                    size: Dimensions.height15 * 10),
                                  ),
                                Positioned(
                                  top: 95,
                                  left: 95,
                                  child: GestureDetector(
                                    onTap: (){
                                      AwesomeDialog(
                                        context: context,
                                        title: "Upload Shop Photo",
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
                                          ImagePicker imagePicker = ImagePicker();
                                          XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

                                          if(file==null) return;
                                          String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                                          Reference referenceRoot = FirebaseStorage.instance.ref();
                                          Reference referenceDirImages = referenceRoot.child("vendors/${user.vendor_name} (${user.vendor_id})");

                                          Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                                          try{
                                            await referenceImageToUpload.putFile(File(file!.path));
                                            imageUrl = await referenceImageToUpload.getDownloadURL();
                                            FirebaseFirestore.instance.collection('vendors').doc(user.vendor_id).update({'vendor_img': imageUrl}).whenComplete(() => AwesomeDialog(
                                              context: context,
                                              title: "All Set!",
                                              titleTextStyle: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: Dimensions.font26,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              desc: "Shop Photo Uploaded",
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

                                          }catch(error){

                                          }
                                        },
                                        btnCancelColor: AppColors.mainColor,
                                        btnOkOnPress: () async {
                                          ImagePicker imagePicker = ImagePicker();
                                          XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                                          String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                                          Reference referenceRoot = FirebaseStorage.instance.ref();
                                          Reference referenceDirImages = referenceRoot.child("vendors/${user.vendor_name} (${user.vendor_id})");

                                          Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                                          try{
                                            await referenceImageToUpload.putFile(File(file!.path));
                                            imageUrl = await referenceImageToUpload.getDownloadURL();
                                            FirebaseFirestore.instance.collection('vendors').doc(user.vendor_id).update({'vendor_img': imageUrl}).whenComplete(() => AwesomeDialog(
                                              context: context,
                                              title: "All Set!",
                                              titleTextStyle: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: Dimensions.font26,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              desc: "Shop Photo Uploaded",
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
                                          }catch(error){

                                          }
                                        },
                                        btnOkIcon: Icons.upload,
                                        btnOkColor: AppColors.mainColor,
                                        btnOkText: 'Gallery',
                                      ).show();
                                    },
                                    child: AppIcon(
                                      icon: Icons.add,
                                      backgroundColor: AppColors.iconColor1,
                                      iconSize: 20,
                                      iconColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(height: Dimensions.height45),

                          // Can be scrolled if we add more options
                          Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Manage General Information
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => GeneralInformationPage());
                                      },
                                      child: AccountWidget(
                                        appIcon: AppIcon(
                                          icon: Icons.settings,
                                          backgroundColor: AppColors.iconColor1,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(
                                            text: "Manage General Information"),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20,),

                                    // Manage Menu
                                    GestureDetector(
                                      onTap: (){
                                        Get.to(() => MenuManagementPage(email: user.email, vendor_id: user.vendor_id,));
                                      },
                                      child: AccountWidget(
                                        appIcon: AppIcon(
                                          icon: Icons.restaurant_menu,
                                          backgroundColor: AppColors.iconColor1,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(text: "Manage Menu"),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20,),

                                    // Manage Location
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => ManageLocationPage(startSpot: user.vendor_location!, Id: user.vendor_id!,));
                                      },
                                      child: AccountWidget(
                                        appIcon: AppIcon(
                                          icon: Icons.location_on,
                                          backgroundColor: AppColors.iconColor1,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(text: "Manage Location"),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20,),

                                    // Manage Account Details
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => AccountDetailsPage());
                                      },
                                      child: AccountWidget(
                                        appIcon: AppIcon(
                                          icon: Icons.email,
                                          backgroundColor: AppColors.paraColor,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(
                                            text: "Manage Account Details"),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20,),
                                    GestureDetector(
                                      onTap: () {
                                        showCustomerSnackBar(
                                            "See you next time!", color: Colors.green,
                                            title: "Logged Out");
                                        AuthController.instance.logout();
                                      },
                                      child: AccountWidget(
                                        appIcon: AppIcon(
                                          icon: Icons.logout,
                                          backgroundColor: Colors.red[900]!,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(
                                            text: "Logout"),
                                      ),
                                    ),
                                  ],
                                ),
                              ))

                        ],
                      ),
                    )
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                );
              }
            }
          );
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator(color: AppColors.mainColor,)));
        }
      }
    );
  }
}
