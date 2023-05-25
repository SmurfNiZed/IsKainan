import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iskainan/pages/Home/sign_up_page.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/dimensions.dart';
import '../../utils/colors.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/big_text.dart';

class VendorSignInPage extends StatelessWidget {
  const VendorSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    Container(
                      width: 80.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            text: "Hello",
                            size: 50.sp,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Please sign in to continue.",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // Email
                    Container(
                      width: 90.w,
                      child: AppTextField(
                        textController: emailController,
                        hintText: "Email",
                        icon: Icons.email_rounded,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Password
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 2.w),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            AuthController.instance.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
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
                                text: "Sign in",
                                size: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 15.h),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: AppColors.mainColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => VendorSignUpPage(), transition: Transition.fade),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
