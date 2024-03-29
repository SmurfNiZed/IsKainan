import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/data/repository/user_repo.dart';
import 'package:iskainan/pages/account/general_information_page.dart';
import 'package:progress_indicators/progress_indicators.dart';
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
import 'package:sizer/sizer.dart';

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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            VendorData user = snapshot.data as VendorData;
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.mainColor, size: 40),
                  onPressed: () {
                    Get.offAll(() => SplashScreen(
                      searchString: "",
                      budget: 10000,
                      position: LatLng(0, 0),
                    ));
                  },
                ),
              ),
              body: Sizer(
                builder: (context, orientation, deviceType){
                  return Container(

                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.sp),
                                    child: Text(
                                      "Hello,\nVendor!",
                                      style: TextStyle(
                                        fontSize: 15.w,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('vendors')
                                      .doc(user.vendor_id)
                                      .snapshots(),
                                  builder: (context, vendorImgSnapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (vendorImgSnapshot.hasData) {
                                        var imgUrl = vendorImgSnapshot.data?.data()
                                        as Map<String, dynamic>;
                                        return imgUrl['vendor_img'] == ""
                                            ? AppIcon(
                                          icon: Icons.storefront,
                                          backgroundColor:
                                          AppColors.mainColor,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height30 +
                                              Dimensions.height45,
                                          size: Dimensions.height15 * 10,
                                        )
                                            : GestureDetector(
                                          onTap: () {
                                            AwesomeDialog(
                                                context: context,
                                                dialogType:
                                                DialogType.noHeader,
                                                animType: AnimType.topSlide,
                                                showCloseIcon: true,
                                                dismissOnTouchOutside: true,
                                                dismissOnBackKeyPress: true,
                                                btnCancelIcon: Icons.delete,
                                                btnCancelText: "Delete",
                                                btnCancelOnPress: () async {
                                                  try {
                                                    await FirebaseStorage
                                                        .instance
                                                        .ref(
                                                        'vendors/${user.vendor_id}/vendorImage')
                                                        .listAll()
                                                        .then((value) {
                                                      FirebaseStorage.instance
                                                          .ref(value.items
                                                          .first.fullPath)
                                                          .delete()
                                                          .whenComplete(() =>
                                                          AwesomeDialog(
                                                            context:
                                                            context,
                                                            title:
                                                            "All Set!",
                                                            titleTextStyle: TextStyle(
                                                                fontFamily:
                                                                'Montserrat',
                                                                fontSize:
                                                                Dimensions
                                                                    .font26,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                            desc:
                                                            "Photo updated.",
                                                            descTextStyle: TextStyle(
                                                                fontFamily:
                                                                'Montserrat',
                                                                fontSize:
                                                                Dimensions
                                                                    .font20,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                            dialogType:
                                                            DialogType
                                                                .success,
                                                            animType: AnimType
                                                                .topSlide,
                                                            autoDismiss:
                                                            true,
                                                            autoHide:
                                                            Duration(
                                                                seconds:
                                                                3),
                                                          ).show());
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection('vendors')
                                                        .doc(user.vendor_id)
                                                        .update({
                                                      'vendor_img': ""
                                                    });
                                                  } catch (e) {}
                                                },
                                                btnCancelColor:
                                                AppColors.mainColor,
                                                body: Container(
                                                    padding: EdgeInsets.only(
                                                        left: Dimensions
                                                            .width20,
                                                        right: Dimensions
                                                            .width20,
                                                        top: Dimensions
                                                            .height30),
                                                    height:
                                                    Dimensions.height45 *
                                                        5,
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radius15),
                                                      color: Colors.white,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: imgUrl[
                                                      'vendor_img'],
                                                      errorWidget: (context,
                                                          url, error) =>
                                                          Icon(
                                                            Icons.error,
                                                            size: Dimensions
                                                                .iconSize24 /
                                                                2,
                                                            color: Colors.white,
                                                          ),
                                                      imageBuilder: (context,
                                                          imageProvider) =>
                                                          Container(
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  Dimensions
                                                                      .radius15),
                                                              image:
                                                              DecorationImage(
                                                                image:
                                                                imageProvider,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                    ))).show();
                                          },
                                          child: CircleImage(
                                            imgUrl: imgUrl['vendor_img'],
                                            backgroundColor:
                                            AppColors.mainColor,
                                            size: 100.sp,
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width: 100.sp,
                                          height: 100.sp,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                75.sp),
                                            color: AppColors.mainColor,
                                          ),
                                        );
                                      }
                                    } else {
                                      return Container(
                                        width: 100.sp,
                                        height: 100.sp,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            75.sp,),
                                          color: AppColors.mainColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(width: 10.sp)
                              ],
                            ),
                            Positioned(
                              top: 15.h,
                              left: 85.w,
                              child: GestureDetector(
                                onTap: () {
                                  AwesomeDialog(
                                    context: context,
                                    title: "Upload Shop Photo",
                                    titleTextStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Dimensions.font20,
                                        fontWeight: FontWeight.bold),
                                    dialogType: DialogType.noHeader,
                                    animType: AnimType.topSlide,
                                    showCloseIcon: true,
                                    dismissOnTouchOutside: true,
                                    dismissOnBackKeyPress: true,
                                    btnCancelIcon: Icons.photo_camera,
                                    btnCancelText: "Camera",
                                    btnCancelOnPress: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(
                                          source: ImageSource.camera);

                                      if (file == null) return;
                                      String uniqueFileName = "VendorProfilePic";

                                      Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                      Reference referenceDirImages =
                                      referenceRoot.child(
                                          "vendors/${user.vendor_id}/vendorImage");

                                      Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);

                                      try {
                                        await referenceImageToUpload
                                            .putFile(File(file!.path));
                                        imageUrl = await referenceImageToUpload
                                            .getDownloadURL();
                                        FirebaseFirestore.instance
                                            .collection('vendors')
                                            .doc(user.vendor_id)
                                            .update({
                                          'vendor_img': imageUrl
                                        }).whenComplete(() => AwesomeDialog(
                                          context: context,
                                          title: "All Set!",
                                          titleTextStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Dimensions.font26,
                                              fontWeight: FontWeight.bold),
                                          desc: "Photo updated.",
                                          descTextStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Dimensions.font20,
                                              fontWeight:
                                              FontWeight.normal),
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          autoDismiss: true,
                                          autoHide: Duration(seconds: 3),
                                        ).show());
                                      } catch (error) {}
                                    },
                                    btnCancelColor: AppColors.mainColor,
                                    btnOkOnPress: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(
                                          source: ImageSource.gallery);

                                      String uniqueFileName = "VendorProfilePic";

                                      Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                      Reference referenceDirImages =
                                      referenceRoot.child(
                                          "vendors/${user.vendor_id}/vendorImage");

                                      Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);

                                      try {
                                        await referenceImageToUpload
                                            .putFile(File(file!.path));
                                        imageUrl = await referenceImageToUpload
                                            .getDownloadURL();
                                        FirebaseFirestore.instance
                                            .collection('vendors')
                                            .doc(user.vendor_id)
                                            .update({
                                          'vendor_img': imageUrl
                                        }).whenComplete(() => AwesomeDialog(
                                          context: context,
                                          title: "All Set!",
                                          titleTextStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Dimensions.font26,
                                              fontWeight: FontWeight.bold),
                                          desc: "Photo updated.",
                                          descTextStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Dimensions.font20,
                                              fontWeight:
                                              FontWeight.normal),
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          autoDismiss: true,
                                          autoHide: Duration(seconds: 3),
                                        ).show());
                                      } catch (error) {}
                                    },
                                    btnOkIcon: Icons.upload,
                                    btnOkColor: AppColors.mainColor,
                                    btnOkText: 'Gallery',
                                  ).show();
                                },
                                child: AppIcon(
                                  icon: Icons.edit,
                                  backgroundColor: AppColors.iconColor1,
                                  iconSize: 15.sp,
                                  size: 30.sp,
                                  iconColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
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
                                        iconSize: 3.5.h,
                                        size: 7.h,
                                      ),
                                      bigText:
                                      BigText(text: "Manage General Information",
                                      size:12.sp)
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h
                                  ),

                                  // Manage Menu
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => MenuManagementPage(
                                        user: user,
                                      ));
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.restaurant_menu,
                                        backgroundColor: AppColors.iconColor1,
                                        iconColor: Colors.white,
                                        iconSize: 3.5.h,
                                        size: 7.h,
                                      ),
                                      bigText: BigText(text: "Manage Menu",
                                          size:12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),

                                  // Manage Location
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('vendors')
                                          .doc(user.vendor_id)
                                          .snapshots(),
                                      builder: (context, vendorLocSnapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (vendorLocSnapshot.hasData) {
                                            var loc = vendorLocSnapshot.data?.data()
                                            as Map<String, dynamic>;
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => ManageLocationPage(
                                                  startSpot: GeoPoint(
                                                      loc['latitude']!,
                                                      loc['longitude']!),
                                                  Id: user.vendor_id!,
                                                ));
                                              },
                                              child: AccountWidget(
                                                appIcon: AppIcon(
                                                  icon: Icons.location_on,
                                                  backgroundColor: AppColors.iconColor1,
                                                  iconColor: Colors.white,
                                                  iconSize: 3.5.h,
                                                  size: 7.h,
                                                ),
                                                bigText:
                                                BigText(text: "Manage Location",
                                                    size:12.sp),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                              child: JumpingDotsProgressIndicator(),
                                            );
                                          }
                                        } else {
                                          return Center(
                                            child: JumpingDotsProgressIndicator(),
                                          );
                                        }

                                        // print(loc['vendor_location']!.toString().split(","));
                                      }),
                                  SizedBox(
                                    height: 1.h,
                                  ),

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
                                        iconSize: 3.5.h,
                                        size: 7.h,
                                      ),
                                      bigText: BigText(text: "Manage Account Details",
                                          size:12.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showCustomerSnackBar("See you next time!",
                                          color: Colors.green, title: "Logged Out");
                                      AuthController.instance.logout();
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.logout,
                                        backgroundColor: Colors.red[900]!,
                                        iconColor: Colors.white,
                                        iconSize: 3.5.h,
                                        size: 7.h,
                                      ),
                                      bigText: BigText(text: "Logout",
                                          size:12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                }
              )
            );
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    )));
          }
        }
        );
  }
}
