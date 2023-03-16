import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/base/show_custom_snackbar.dart';
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
import 'general_information_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: BigText(
          text: "Dashboard",
          size: Dimensions.font26,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              UserModel userData = snapshot.data as UserModel;
              return Container(
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
                                  Get.to(() => GeneralInformationPage(user: userData));
                                },
                                child: AccountWidget(
                                  appIcon: AppIcon(
                                    icon: Icons.email,
                                    backgroundColor: AppColors.mainColor,
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
                              AccountWidget(
                                appIcon: AppIcon(
                                  icon: Icons.location_on,
                                  backgroundColor: AppColors.iconColor1,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10 * 5 / 2,
                                  size: Dimensions.height10 * 5,
                                ),
                                bigText: BigText(text: "Manage Location"),
                              ),
                              SizedBox(height: Dimensions.height20,),

                              // Manage Account Details
                              AccountWidget(
                                appIcon: AppIcon(
                                  icon: Icons.settings,
                                  backgroundColor: AppColors.paraColor,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10 * 5 / 2,
                                  size: Dimensions.height10 * 5,
                                ),
                                bigText: BigText(
                                    text: "Manage Account Details"),
                              ),
                              SizedBox(height: Dimensions.height45,),
                              GestureDetector(
                                onTap: (){
                                  showCustomerSnackBar("See you next time!", color: Colors.green, colorText: Colors.green, title: "Logged Out");
                                  AuthController.instance.logout();
                                },
                                child: Container(
                                  width: Dimensions.screenWidth/3,
                                  height: Dimensions.screenHeight/13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      color: AppColors.mainColor
                                  ),
                                  child: Center(
                                    child: BigText(
                                      text: "Logout",
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
              );
            } else if (snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: Text('Something went wrong'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
