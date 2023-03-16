import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/profile_controller.dart';

import '../../base/show_custom_snackbar.dart';
import '../../models/user_model.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_hidden_text_field.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import 'account_page.dart';

class GeneralInformationPage extends StatefulWidget {
  const GeneralInformationPage({Key? key}) : super(key: key);

  @override
  State<GeneralInformationPage> createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage> {
  late bool? _checkBoxGCash = false;
  late bool? _checkBoxOpen = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    Future<void> _updateGeneralInformation(
        TextEditingController vendorNameController,
        TextEditingController phoneController,
        bool isGcash,
        bool isOpen,
        TextEditingController operatingHoursController,
        String? id) async {
      // final controller = Get.put(ProfileController());
      String vendorName = vendorNameController.text.trim();
      String phone = phoneController.text.trim();
      String operatingHours = operatingHoursController.text.trim();

      if (vendorName.isEmpty) {
        showCustomerSnackBar("Type in the name of your establishment.",
            title: "Name");
      } else if (phone.isEmpty) {
        showCustomerSnackBar("Type in your phone number.",
            title: "Phone Number");
      } else {
        try {
          FirebaseFirestore.instance.collection('vendors').doc(id).update({
            'vendor_name': vendorName,
            'phone': phone,
            'is_gcash': (isGcash ? "true" : "false"),
            'is_open': (isOpen ? "true" : "false"),
            'operating_hours': operatingHours,
          });
          showCustomerSnackBar("Account details updated.",
              title: "Success", color: Colors.green);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AccountPage()));
        } catch (e) {
          showCustomerSnackBar(e.toString());
        }
      }
    }

    return FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            VendorData user = snapshot.data as VendorData;
            _checkBoxGCash = user.is_gcash == "true" ? true : false;
            _checkBoxOpen = user.is_open == "true" ? true : false;
            late TextEditingController vendorNameController =
                TextEditingController(text: user.vendor_name.toString());
            late TextEditingController phoneController =
                TextEditingController(text: user.phone.toString());
            late TextEditingController operatingHoursController = TextEditingController(text: user.operating_hours.toString());
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: AppIcon(
                        icon: Icons.clear,
                        backgroundColor: AppColors.iconColor1,
                        iconColor: Colors.white,
                      )),
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: Dimensions.height45),
                      AppIcon(
                          icon: Icons.settings,
                          backgroundColor: AppColors.iconColor1,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height30 + Dimensions.height45,
                          size: Dimensions.height15 * 10),
                      SizedBox(height: Dimensions.height45),

                      // Can be scrolled if we add more options
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Email
                            AppTextField(
                              textController: vendorNameController,
                              hintText: "Email",
                              icon: Icons.email_rounded,
                              backgroundColor: AppColors.iconColor1,
                            ),
                            SizedBox(height: Dimensions.height20),

                            // Contact Number
                            AppTextField(
                              textController: phoneController,
                              hintText: "Contact Number",
                              icon: Icons.phone,
                              backgroundColor: AppColors.iconColor1,
                            ),
                            SizedBox(height: Dimensions.height20),

                            // Checkbox(value: _checkBox, onChanged: (val){
                            //   setState(() { _checkBox = val;
                            //   });
                            // }),

                            StatefulBuilder(
                              builder: (context, _setState) => CheckboxListTile(
                                  value: _checkBoxGCash,
                                  title: SmallText(text: "GCash Available", size: Dimensions.font16),
                                  onChanged: (val) {
                                    _setState(() => _checkBoxGCash = val!);
                                  },
                              controlAffinity: ListTileControlAffinity.leading,
                              checkColor: Colors.white,
                              activeColor: AppColors.iconColor1
                                ,),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            StatefulBuilder(
                              builder: (context, _setState) => CheckboxListTile(
                                value: _checkBoxOpen,
                                title: SmallText(text: "Store is Open", size: Dimensions.font16,),
                                onChanged: (val) {
                                  _setState(() => _checkBoxOpen = val!);
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                checkColor: Colors.white,
                                activeColor: AppColors.iconColor1
                                ,),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            AppTextField(
                              textController: operatingHoursController,
                              hintText: "Operating Hours",
                              icon: Icons.email_rounded,
                              backgroundColor: AppColors.iconColor1,
                            ),
                            SizedBox(height: Dimensions.height45),
                            GestureDetector(
                              onTap: () {
                                _updateGeneralInformation(
                                    vendorNameController,
                                    phoneController,
                                    _checkBoxGCash!,
                                    _checkBoxOpen!,
                                    operatingHoursController,
                                    user.vendor_id);
                              },
                              child: Container(
                                width: Dimensions.screenWidth / 3,
                                height: Dimensions.screenHeight / 13,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius30),
                                    color: AppColors.iconColor1),
                                child: Center(
                                  child: BigText(
                                    text: "Save",
                                    size: Dimensions.font26,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ));
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                )));
          }
        });
  }
}
