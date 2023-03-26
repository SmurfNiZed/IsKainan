import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/profile_controller.dart';
import 'package:iskainan/widgets/small_text.dart';
// import 'package:iskainan/controllers/profile_controller.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppTextFieldv2.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import 'account_page.dart';


class AccountDetailsPage extends StatelessWidget {

  AccountDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    Future<void> _updateAccountDetails(TextEditingController emailController,
        TextEditingController passwordController, String? id) async {
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
      }else{

        try{

          await FirebaseAuth.instance.currentUser!.updateEmail(email);                                                    // Updates email in Firebase Authentication
          await FirebaseAuth.instance.currentUser!.updatePassword(password);                                              // Updates password in Firebase Authentication
          await FirebaseFirestore.instance.collection('vendors').doc(id).update({'email': email, 'password': password});// Updates Email and Password in Firebase Firestore
          showCustomerSnackBar("Account details updated", title: "Success", color: Colors.green);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
          // Get.offAll(() => AccountPage());
        }catch(e){
          showCustomerSnackBar(e.toString());
        }
        
      }
    }

    return FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            VendorData user = snapshot.data as VendorData;
            late TextEditingController emailController = TextEditingController(text: user.email.toString());
            late TextEditingController passwordController = TextEditingController(text: user.password.toString());
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: AppIcon(icon: Icons.clear, backgroundColor: AppColors.paraColor, iconColor: Colors.white,)),
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
                                AppIcon(icon: Icons.email,
                                    backgroundColor: AppColors.paraColor,
                                    iconColor: Colors.white,
                                    iconSize: Dimensions.height30 + Dimensions.height45,
                                    size: Dimensions.height15 * 10),
                                SizedBox(height: Dimensions.height45),

                                // Email
                                AppTextFieldv2(textController: emailController, hintText: "Email", icon: Icons.email_rounded, backgroundColor: AppColors.paraColor,),
                                SizedBox(height: Dimensions.height20),

                                // Password
                                AppTextFieldv2(textController: passwordController, hintText: "Password", icon: Icons.key_rounded, backgroundColor: AppColors.paraColor, isPassword: true),
                                SizedBox(height: Dimensions.height30),

                                GestureDetector(
                                  onTap: (){
                                    _updateAccountDetails(emailController, passwordController, user.vendor_id);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                    height: 50,
                                    width: Dimensions.screenWidth,
                                    decoration: BoxDecoration(
                                        color: AppColors.paraColor,
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
                              ],
                            ),
                          ))

                    ],
                  ),
                )
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
