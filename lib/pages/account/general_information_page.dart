import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/profile_controller.dart';
// import 'package:iskainan/controllers/profile_controller.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_hidden_text_field.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';


class GeneralInformationPage extends StatelessWidget {
  UserModel user;
  GeneralInformationPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var emailController = TextEditingController(text: user.email.toString());
    var passwordController = TextEditingController(text: user.password.toString());
    var vendorNameController = TextEditingController(text: user.vendorName.toString());
    var phoneController = TextEditingController(text: user.phone.toString());

    Future<void> _updateGeneralInformation() async {
      final controller = Get.put(ProfileController());
      String vendorName = vendorNameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(email.isEmpty){
        showCustomerSnackBar("Type in your email address.", title: "Email address");
      }else if(!GetUtils.isEmail(email)){
        showCustomerSnackBar("Type in a valid email address.", title: "Valid email address");
      }else if(password.isEmpty){
        showCustomerSnackBar("Type in your password", title: "Password");
      }else if(password.length < 6){
        showCustomerSnackBar("Password can not be less than 6 characters.", title: "Password");
      }else if(vendorName.isEmpty){
        showCustomerSnackBar("Type in the name of your establishment.", title: "Name");
      }else if(phone.isEmpty){
        showCustomerSnackBar("Type in your phone number.", title: "Phone Number");
      }else{
        final userData = UserModel(
            id: user.id,
            email: email,
            phone: phone,
            vendorName: vendorName,
            password: password
        );
        print("Gen Info Page: " + userData.id.toString());
        await controller.updateRecord(userData);
      }
    }

    return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            title: BigText(
              text: "General Information Page",
              size: Dimensions.font26,
              color: Colors.white,
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(height: Dimensions.height45),
                AppIcon(icon: Icons.email,
                    backgroundColor: AppColors.mainColor,
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
                          AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded),
                          SizedBox(height: Dimensions.height20),

                          // Password
                          AppHiddenTextField(textController: passwordController, hintText: "Password", icon: Icons.key_rounded),
                          SizedBox(height: Dimensions.height20),

                          // Vendor Name
                          AppTextField(textController: vendorNameController, hintText: "Name of Establishment", icon: Icons.food_bank_rounded),
                          SizedBox(height: Dimensions.height20),

                          // Contact Number
                          AppTextField(textController: phoneController, hintText: "Contact Number", icon: Icons.phone),
                          SizedBox(height: Dimensions.height20*2),
                          GestureDetector(
                            onTap: (){
                              _updateGeneralInformation();
                            },
                            child: Container(
                              width: Dimensions.screenWidth/3,
                              height: Dimensions.screenHeight/13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  color: AppColors.mainColor
                              ),
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
          )
    );
  }
}
