import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        title: BigText(
          text: "{vendorName} Dashboard",
          size: Dimensions.font26,
          color: Colors.white,
        ),
      ),
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: Dimensions.height20),
        child: Column(
          children: [
            AppIcon(icon: Icons.storefront,
            backgroundColor: AppColors.mainColor,
            iconColor: Colors.white,
            iconSize: Dimensions.height30 + Dimensions.height45,
            size: Dimensions.height15*10),
            SizedBox(height: Dimensions.height30,),

            // Can be scrolled if we add more options
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Manage General Information
                      AccountWidget(
                        appIcon: AppIcon(
                          icon: Icons.email,
                          backgroundColor: AppColors.mainColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
                        ),
                        bigText: BigText(text: "Manage General Information"),
                      ),
                      SizedBox(height: Dimensions.height20,),

                      // Manage Menu
                      AccountWidget(
                        appIcon: AppIcon(
                          icon: Icons.restaurant_menu,
                          backgroundColor: AppColors.iconColor1,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
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
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
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
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
                        ),
                        bigText: BigText(text: "Manage Account Details"),
                      ),
                      SizedBox(height: Dimensions.height20,),

                    ],
                  ),
                ))

          ],
        ),
      )
    );
  }
}
