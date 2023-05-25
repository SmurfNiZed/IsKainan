import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/models/vendor_data_model.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppNumField.dart';
import '../../widgets/app_phone_field.dart';
import '../../widgets/big_text.dart';
import '../../utils/colors.dart';

class VendorSignUpPage extends StatelessWidget {
  const VendorSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var vendorNameController = TextEditingController();
    var phoneController = TextEditingController();

    void _registration() {
      String vendorName = vendorNameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isEmpty) {
        showCustomerSnackBar("Type in your email address.", title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomerSnackBar("Type in a valid email address.", title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomerSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomerSnackBar("Password can not be less than 6 characters.", title: "Password");
      } else if (vendorName.isEmpty) {
        showCustomerSnackBar("Type in the name of your establishment.", title: "Name");
      } else if (phone.isEmpty) {
        showCustomerSnackBar("Type in your phone number.", title: "Phone Number");
      } else {
        List<String> newTag = [];

        (vendorName).split(" ").forEach((word) {
          newTag.add(word.toLowerCase());
        });

        final user = VendorData(
          email: email,
          phone: phone,
          vendor_name: vendorName,
          password: password,
          latitude: 14.654941990186154,
          longitude: 121.0648511552033, // Oble
          vendor_img: "",
          is_gcash: "false",
          operating_hours: [480, 1200], // 8:00 AM - 8:00 PM default
          operating_days: [false, false, false, false, false, false, false],
          is_open: "false",
          account_created: Timestamp.now(),
          approved: "false",
          vendor_description: "",
        );
        AuthController.instance.register(user);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Dimensions.screenHeight * 0.1),
                Container(
                  width: Dimensions.screenWidth * .8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: "Create", size: Dimensions.font20 * 2 + Dimensions.font26),
                      BigText(text: "Account", size: Dimensions.font20 * 2 + Dimensions.font26),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Container(
                  width: Dimensions.screenWidth * .9,
                  child: AppTextField(
                    textController: emailController,
                    hintText: "Email",
                    icon: Icons.email_rounded,
                    backgroundColor: AppColors.mainColor,
                  ),
                ),

                SizedBox(height: Dimensions.height20),
                Container(
                  width: Dimensions.screenWidth * .9,
                  child: AppTextField(
                    textController: passwordController,
                    hintText: "Password",
                    icon: Icons.key_rounded,
                    backgroundColor: AppColors.mainColor,
                    isPassword: true,
                  ),
                ),

                SizedBox(height: Dimensions.height20),
                Container(
                  width: Dimensions.screenWidth * .9,
                  child: AppTextField(
                    textController: vendorNameController,
                    hintText: "Name of Establishment",
                    icon: Icons.food_bank_rounded,
                    backgroundColor: AppColors.mainColor,
                  ),
                ),

                SizedBox(height: Dimensions.height20),
                Container(
                  width: Dimensions.screenWidth * .9,
                  child: AppPhoneField(
                    textController: phoneController,
                    hintText: "Contact Number",
                    icon: Icons.phone,
                    backgroundColor: AppColors.mainColor,
                  ),
                ),

                SizedBox(height: Dimensions.height20),
                Padding(
                  padding: EdgeInsets.only(right: Dimensions.screenWidth * .1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _registration();
                      },
                      child: Container(
                        width: Dimensions.screenWidth / 3,
                        height: Dimensions.screenHeight / 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                          color: AppColors.mainColor,
                        ),
                        child: Center(
                          child: BigText(
                            text: "Sign up",
                            size: Dimensions.font26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.screenHeight * 0.05),
                SizedBox(height: Dimensions.height10),
                RichText(
                  text: TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                      fontSize: Dimensions.font16,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign in instead",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: AppColors.mainColor,
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
