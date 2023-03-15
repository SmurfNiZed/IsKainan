import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/pages/Home/sign_up_page.dart';
import 'package:iskainan/widgets/app_text_field.dart';
// import '../../controllers/signin_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_hidden_text_field.dart';
import '../../widgets/big_text.dart';
import '../../utils/colors.dart';
import '../account/account_page.dart';

class VendorSignInPage extends StatelessWidget {
  const VendorSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

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
              SizedBox(height: Dimensions.height45*3/2,),

              Row(
                children: [
                  SizedBox(width: Dimensions.width20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: "Hello", size: Dimensions.font20*3+Dimensions.font16,),
                      RichText(text: TextSpan(
                          text: "Sign into your account",
                          style:
                          TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.font20
                          )
                      )
                        ,),
                    ],
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height45,),

              // Email
              AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded),
              SizedBox(height: Dimensions.height20),

              // Password
              AppHiddenTextField(textController: passwordController, hintText: "Password", icon: Icons.key_rounded),
              SizedBox(height: Dimensions.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(text: TextSpan(
                      text: "Sign into your account",
                      style:
                      TextStyle(
                          color: Colors.grey[500],
                          fontSize: Dimensions.font20
                      )
                  )
                    ,),
                  SizedBox(width:Dimensions.width20)
                ],
              ),
              SizedBox(height: Dimensions.height20*3,),
              GestureDetector(
                onTap: (){
                  AuthController.instance.login(emailController.text.trim(), passwordController.text.trim());
                },
                child: Container(
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
              ),
              SizedBox(height: Dimensions.screenHeight*0.08),
              RichText(text: TextSpan(
                  text: "Don't have an account? ",
                  style:
                  TextStyle(
                      color: Colors.grey,
                      fontSize: Dimensions.font16,
                  ),
                  children: [
                    TextSpan(
                      text: "Create",
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>VendorSignUpPage(), transition: Transition.fade),
                    )
                  ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// vendor page **************************************