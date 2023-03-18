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
                      // Can be scrolled if we add more options
                      Expanded(
                          child: SingleChildScrollView(
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

                            AppTextField(
                              textController: vendorNameController,
                              hintText: "Name of Establishment",
                              icon: Icons.food_bank_rounded,
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
                                      value: _checkBoxGCash,
                                      title: Transform.translate(
                                        offset: const Offset(-15,0),
                                        child: SmallText(text: "Gcash Available", size: Dimensions.font16,),
                                      ),
                                      onChanged: (val) {
                                        _setState(() => _checkBoxGCash = val!);
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
                                  value: _checkBoxOpen,
                                  title: Transform.translate(
                                    offset: Offset(0, -4),
                                    child: Transform.translate(
                                      offset: const Offset(-15,15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SmallText(text: "Store is Open", size: Dimensions.font16,),
                                          SmallText(text: "only uncheck this when temporarily unavailable", color: AppColors.paraColor, size: Dimensions.font16-5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    _setState(() => _checkBoxOpen = val!);
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                  checkColor: Colors.white,
                                  activeColor: AppColors.iconColor1,
                                  contentPadding: EdgeInsets.only(left: Dimensions.width10*2/3),
                                  ),
                              ),
                            ),

                            SizedBox(height: Dimensions.height20,),
                            AppTextField(
                              textController: operatingHoursController,
                              hintText: "Operating Hours",
                              icon: Icons.timer,
                              backgroundColor: AppColors.iconColor1,
                            ),
                            SizedBox(height: Dimensions.height20),
                            user.approved == "true"?SmallText(text: "This vendor is approved."):SmallText(text: "This vendor is not yet approved."),
                            SizedBox(height: Dimensions.height30),
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
                                margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                height: 50,
                                width: Dimensions.screenWidth,
                                decoration: BoxDecoration(
                                    color: AppColors.iconColor1,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BigText(text: "Save Changes", color: Colors.white,),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height45),
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
