import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/pages/Home/survey.dart';
import 'package:iskainan/pages/account/account_page.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/signup_controller.dart';
import '../../models/signup_body_model.dart';
import '../../models/user_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_hidden_text_field.dart';
import '../../widgets/big_text.dart';
import '../../utils/colors.dart';

class VendorSignUpPage extends StatelessWidget {
  const VendorSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(SignUpController());
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var vendorNameController = TextEditingController();
    var phoneController = TextEditingController();

    var signUpImages = ["f.png", "g.png"];

    void _registration(){

      String vendorName = vendorNameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(email.isEmpty){
        showCustomerSnackBar("Type in your email address.", title: "Email address");
      }else if(!GetUtils.isEmail(email)){
        showCustomerSnackBar("Type in a valid email address.", title: "Valid email address");
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
        final user = UserModel(
          email: email,
          phone: phone,
          vendorName: vendorName,
          password: password
        );

        AuthController.instance.register(user);
      }
    }

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
                  SizedBox(height:Dimensions.height45*3/2),

                  // Email
                  AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded, backgroundColor: AppColors.mainColor,),
                  SizedBox(height: Dimensions.height20),

                  // Password
                  AppHiddenTextField(textController: passwordController, hintText: "Password", icon: Icons.key_rounded, backgroundColor: AppColors.mainColor,),
                  SizedBox(height: Dimensions.height20),

                  // Vendor Name
                  AppTextField(textController: vendorNameController, hintText: "Name of Establishment", icon: Icons.food_bank_rounded, backgroundColor: AppColors.mainColor,),
                  SizedBox(height: Dimensions.height20),

                  // Contact Number
                  AppTextField(textController: phoneController, hintText: "Contact Number", icon: Icons.phone, backgroundColor: AppColors.mainColor),
                  SizedBox(height: Dimensions.height20*2),


                  GestureDetector(
                    onTap: (){
                      _registration();
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
                          text: "Sign up as Vendor",
                          size: Dimensions.font20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10,),
                  RichText(text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                    text: "Have an account already?",
                      style:
                      TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font16
                      ),
                    )
                  ,),
                  SizedBox(height: Dimensions.screenHeight*0.05),
                  RichText(text: TextSpan(

                      text: "Sign up another way",
                      style:
                      TextStyle(
                          color: Colors.grey[500],
                          fontSize: Dimensions.font16
                      )
                    )
                  ,),
                  Wrap(
                    children: List.generate(2, (index) => Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: Dimensions.radius30*2/3,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          "assets/images/"+signUpImages[index]
                        )
                      ),
                    ))
                  )

                ],
              ),
            ),
        ),
    );
  }
}
