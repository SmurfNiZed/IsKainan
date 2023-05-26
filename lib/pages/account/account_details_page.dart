import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/profile_controller.dart';
import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../data/repository/user_repo.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppTextFieldv2.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

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
          await FirebaseFirestore.instance.collection('vendors').doc(id).update({'email': email, 'password': password});// Updates Email and Password in Firebase Firestore
          await FirebaseAuth.instance.currentUser!.updateEmail(email);                                                    // Updates email in Firebase Authentication
          await FirebaseAuth.instance.currentUser!.updatePassword(password);                                              // Updates password in Firebase Authentication
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
              extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.mainColor,
                  title: Text('Manage Account Details',),
                  titleTextStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: Dimensions.font26*1,
                      fontWeight: FontWeight.bold
                  ),
                ),
                body: Container(

                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 20*3.5),
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
                                Container(
                                  width: Dimensions.screenWidth * .9,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
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
                                  child:AppTextFieldv2(textController: emailController, hintText: "Email", icon: Icons.email_rounded, backgroundColor: AppColors.paraColor)
                                ),

                                SizedBox(height: Dimensions.height20),

                                // Password
                                Container(
                                  width: Dimensions.screenWidth * .9,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
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
                                  child: AppTextFieldv2(textController: passwordController, hintText: "Password", icon: Icons.key_rounded, backgroundColor: AppColors.paraColor, isPassword: true)
                                ),

                                SizedBox(height: Dimensions.height20*3),
                                GestureDetector(
                                  onTap: (){
                                    _updateAccountDetails(emailController, passwordController, user.vendor_id);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                    height: 50,
                                    width: Dimensions.screenWidth * .7,
                                    decoration: BoxDecoration(
                                        color: Colors.lightGreen[400],
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
                                // SizedBox(height: Dimensions.height30),
                                // Align(
                                //   alignment: Alignment.center,
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       AwesomeDialog(
                                //         context: context,
                                //         dialogType: DialogType.noHeader,
                                //         btnOkColor: AppColors.mainColor,
                                //         btnOkText: "Proceed",
                                //         btnOkIcon: Icons.delete,
                                //         btnOkOnPress: () async {
                                //           final userRepo = Get.put(UserRepository());
                                //           final FirebaseAuth _auth = FirebaseAuth.instance;
                                //
                                //           try {
                                //             await userRepo.deleteVendor(user.vendor_id!);
                                //             User acc = _auth.currentUser!;
                                //             await acc.delete();
                                //           } catch (e) {}
                                //         },
                                //         btnCancelColor: AppColors.paraColor,
                                //         btnCancelIcon: Icons.arrow_back,
                                //         btnCancelOnPress: () {},
                                //         body: Container(
                                //           padding: EdgeInsets.only(
                                //             left: Dimensions.width10,
                                //             right: Dimensions.width10,
                                //             bottom: Dimensions.width10,
                                //           ),
                                //           child: Column(
                                //             children: [
                                //               BigText(text: "Delete Account"),
                                //               SizedBox(height: Dimensions.height10),
                                //               SmallText(
                                //                 text:
                                //                 "You are about to delete this account. This action cannot be undone once you proceed.",
                                //                 size: Dimensions.font16,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ).show();
                                //     },
                                //     child: Container(
                                //       width: Dimensions.screenWidth * .7,
                                //       height: 50,
                                //       decoration: BoxDecoration(
                                //         color: AppColors.mainColor,
                                //         borderRadius: BorderRadius.circular(Dimensions.radius30),
                                //         boxShadow: [
                                //           BoxShadow(
                                //             blurRadius: 10,
                                //             spreadRadius: 7,
                                //             offset: Offset(1, 10),
                                //             color: Colors.grey.withOpacity(0.2),
                                //           ),
                                //         ],
                                //       ),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         crossAxisAlignment: CrossAxisAlignment.center,
                                //         children: [
                                //           BigText(text: "Delete Account", color: Colors.white),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
