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
import 'package:sizer/sizer.dart';

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
      body: Sizer(
        builder: (context, orientation, deviceType) {
          return Container(
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
                    SizedBox(height: 15.h),
                    Container(
                      width: 80.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(text: "Create", size: 35.sp),
                          BigText(text: "Account", size: 35.sp),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: 90.w,
                      child: AppTextField(
                        textController: emailController,
                        hintText: "Email",
                        icon: Icons.email_rounded,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),

                    SizedBox(height: 2.h),
                    Container(
                      width: 90.w,
                      child: AppTextField(
                        textController: passwordController,
                        hintText: "Password",
                        icon: Icons.key_rounded,
                        backgroundColor: AppColors.mainColor,
                        isPassword: true,
                      ),
                    ),

                    SizedBox(height: 2.h),
                    Container(
                      width: 90.w,
                      child: AppTextField(
                        textController: vendorNameController,
                        hintText: "Name of Establishment",
                        icon: Icons.food_bank_rounded,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),

                    SizedBox(height: 2.h),
                    Container(
                      width: 90.w,
                      child: AppPhoneField(
                        textController: phoneController,
                        hintText: "Contact Number",
                        icon: Icons.phone,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),

                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            _registration();
                          },
                          child: Container(
                            width: 30.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.sp),
                              color: AppColors.mainColor,
                            ),
                            child: Center(
                              child: BigText(
                                text: "Sign up",
                                size: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 20.sp,
                        child: RichText(
                          text: TextSpan(
                            text: "Have an account? ",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey,
                              fontSize: 10.sp,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign in instead",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: AppColors.mainColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                              ),
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
        },
      ),
    );
  }
}
