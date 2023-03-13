import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../utils/colors.dart';

class VendorSignInPage extends StatelessWidget {
  const VendorSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var vendorNameController = TextEditingController();
    var phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Center(
        child:
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight*0.1),
              // App Logo
              Container(
                  child: Center(child: Image.asset('assets/images/logo.png', width: Dimensions.splashImg,))
              ),
              SizedBox(height: Dimensions.height45*2,),

              // Email
              AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded),
              SizedBox(height: Dimensions.height20),

              // Password
              AppTextField(textController: passwordController, hintText: "Password", icon: Icons.key_rounded),
              SizedBox(height: Dimensions.height20),

              Container(
                width: Dimensions.screenWidth/2,
                height: Dimensions.screenHeight/13,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor
                ),
                child: Center(
                  child: BigText(
                    text: "Sign in",
                    size: Dimensions.font26,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10,),
              SizedBox(height: Dimensions.screenHeight*0.1),
              RichText(text: TextSpan(
                  recognizer: TapGestureRecognizer()..onTap=()=>Get.toNamed(RouteHelper.vendorSignUpPage),
                  text: "Don't have an account?",
                  style:
                  TextStyle(
                      color: Colors.grey[500],
                      fontSize: Dimensions.font16
                  )
              )
                ,),
            ],
          ),
        ),
      ),
    );
  }
}
// vendor page **************************************