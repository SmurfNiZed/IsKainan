import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import '../../utils/dimensions.dart';
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

    var signUpImages = ["f.png", "g.png"];

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
                  AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded),
                  SizedBox(height: Dimensions.height20),

                  // Password
                  AppTextField(textController: passwordController, hintText: "Password", icon: Icons.key_rounded),
                  SizedBox(height: Dimensions.height20),

                  // Vendor Name
                  AppTextField(textController: vendorNameController, hintText: "Name of Establishment", icon: Icons.food_bank_rounded),
                  SizedBox(height: Dimensions.height20),

                  // Contact Number
                  AppTextField(textController: phoneController, hintText: "Contact Number", icon: Icons.phone),
                  SizedBox(height: Dimensions.height20*2),

                  Container(
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
                  SizedBox(height: Dimensions.height10,),
                  RichText(text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                    text: "Have an account already?",
                      style:
                      TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font16
                      )
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
// vendor page **************************************