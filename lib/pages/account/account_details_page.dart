import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/profile_controller.dart';
// import 'package:iskainan/controllers/profile_controller.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../models/vendor_data_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_hidden_text_field.dart';
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
        // TextEditingController phoneController,
        // TextEditingController vendorNameController,
        TextEditingController passwordController, String? id) async {
      // String vendorName = vendorNameController.text.trim();
      // String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      print(email);
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
          FirebaseAuth.instance.currentUser!.updateEmail(email);
          FirebaseAuth.instance.currentUser!.updatePassword(password);
          FirebaseFirestore.instance.collection('vendors').doc(id).update({'email': email, 'password': password});
          showCustomerSnackBar("Account details updated. Logging you out.", title: "Success", color: Colors.green);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
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
            print(snapshot.data);
            VendorData user = snapshot.data as VendorData;
            print("Accoutn Details Page:" + user.email!);
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
                      SizedBox(height: Dimensions.height45),
                      AppIcon(icon: Icons.email,
                          backgroundColor: AppColors.paraColor,
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
                                AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded, backgroundColor: AppColors.paraColor,),
                                SizedBox(height: Dimensions.height20),

                                // Password
                                AppHiddenTextField(textController: passwordController, hintText: "Password", icon: Icons.key_rounded, backgroundColor: AppColors.paraColor,),
                                SizedBox(height: Dimensions.height20),

                                GestureDetector(
                                  onTap: (){
                                    _updateAccountDetails(emailController, passwordController, user.vendor_id);
                                  },
                                  child: Container(
                                    width: Dimensions.screenWidth/3,
                                    height: Dimensions.screenHeight/13,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                                        color: AppColors.paraColor
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
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator(color: AppColors.mainColor,)));
          }
        }
    );
  }
}
