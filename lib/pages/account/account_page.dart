import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
import 'package:iskainan/pages/account/general_information_page.dart';
// import 'package:iskainan/controllers/profile_controller.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../splash/splash_page.dart';
import 'account_details_page.dart';
import 'manage_location_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
            onTap: (){
              Get.offAll(() => SplashScreen(time: 50,));
            },
            child: AppIcon(icon: Icons.arrow_back, backgroundColor: AppColors.mainColor, iconColor: Colors.white,)),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: Dimensions.height45),
            AppIcon(icon: Icons.storefront,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height30 + Dimensions.height45,
                size: Dimensions.height15 * 10),
            SizedBox(height: Dimensions.height45),

            // Can be scrolled if we add more options
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Manage General Information
                      GestureDetector(
                        onTap: (){
                          Get.to(() => GeneralInformationPage());
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.settings,
                            backgroundColor: AppColors.iconColor1,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(
                              text: "Manage General Information"),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20,),

                      // Manage Menu
                      AccountWidget(
                        appIcon: AppIcon(
                          icon: Icons.restaurant_menu,
                          backgroundColor: AppColors.iconColor1,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10 * 5 / 2,
                          size: Dimensions.height10 * 5,
                        ),
                        bigText: BigText(text: "Manage Menu"),
                      ),
                      SizedBox(height: Dimensions.height20,),

                      // Manage Location
                      GestureDetector(
                        onTap: (){
                          Get.to(() => ManageLocationPage());
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.location_on,
                            backgroundColor: AppColors.iconColor1,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(text: "Manage Location"),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20,),

                      // Manage Account Details
                      GestureDetector(
                        onTap: (){
                          Get.to(() => AccountDetailsPage());
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.email,
                            backgroundColor: AppColors.paraColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(
                              text: "Manage Account Details"),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20,),
                      GestureDetector(
                        onTap: (){
                          showCustomerSnackBar("See you next time!", color: Colors.green, title: "Logged Out");
                          AuthController.instance.logout();
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.logout,
                            backgroundColor: Colors.red[900]!,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(
                              text: "Logout"),
                        ),
                      ),
                    ],
                  ),
                ))

          ],
        ),
      )
    );
  }
}
