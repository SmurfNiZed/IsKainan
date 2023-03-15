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
          text: "Dashboard",
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
            AccountWidget(
              appIcon: AppIcon(
                icon: Icons.storefront,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height10*5/2,
                size: Dimensions.height10*5,
              ),
              bigText: BigText(text: "Mang Larry's Isawan"),
            ),
            SizedBox(height: Dimensions.height20,),
            AccountWidget(
              appIcon: AppIcon(
                icon: Icons.storefront,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height10*5/2,
                size: Dimensions.height10*5,
              ),
              bigText: BigText(text: "Mang Larry's Isawan"),
            ),
            SizedBox(height: Dimensions.height20,),
            AccountWidget(
              appIcon: AppIcon(
                icon: Icons.storefront,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height10*5/2,
                size: Dimensions.height10*5,
              ),
              bigText: BigText(text: "Mang Larry's Isawan"),
            ),
            SizedBox(height: Dimensions.height20,),
            AccountWidget(
              appIcon: AppIcon(
                icon: Icons.storefront,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height10*5/2,
                size: Dimensions.height10*5,
              ),
              bigText: BigText(text: "Mang Larry's Isawan"),
            ),
            SizedBox(height: Dimensions.height20,),
            AccountWidget(
              appIcon: AppIcon(
                icon: Icons.storefront,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height10*5/2,
                size: Dimensions.height10*5,
              ),
              bigText: BigText(text: "Mang Larry's Isawan"),
            ),
            SizedBox(height: Dimensions.height20,),
          ],
        ),
      )
    );
  }
}
