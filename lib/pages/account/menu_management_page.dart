import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/controllers/auth_controller.dart';

import '../../controllers/profile_controller.dart';
import '../../data/repository/user_repo.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../splash/splash_page.dart';

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({Key? key}) : super(key: key);

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    Future<void> _addMenu(String vendorId) async {
      final userRepo = Get.put(UserRepository());

      final menuInitial = VendorMenu(
        foodName: " ",
        foodPrice: " ",
        foodImg: " ",
        isAvailable: "false",
      );

      await userRepo.addVendorMenu(menuInitial, vendorId);
    }

    return FutureBuilder(
      future: controller.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          VendorData user = snapshot.data as VendorData;
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: Dimensions.height45*3),
                                AppIcon(icon: Icons.restaurant_menu,
                                    backgroundColor: AppColors.iconColor1,
                                    iconColor: Colors.white,
                                    iconSize: Dimensions.height30 + Dimensions.height45,
                                    size: Dimensions.height15 * 10),
                                SizedBox(height: Dimensions.height45),

                                GestureDetector(
                                  onTap: (){
                                    _addMenu(user.vendor_id!);
                                  },
                                  child: Container(
                                    height: Dimensions.height30*4,
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                                    child: Icon(Icons.add, size: 50, color: Colors.grey,),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            ,
                          )
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: Dimensions.height45 + Dimensions.height10,
                  left: Dimensions.width20,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: AppIcon(icon: Icons.arrow_back,
                        backgroundColor: AppColors.iconColor1,
                        iconColor: Colors.white,)),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator(
            color: AppColors.mainColor,
          ),);
        }
      }
    );
  }
}
