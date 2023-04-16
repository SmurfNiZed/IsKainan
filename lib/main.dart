import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:iskainan/controllers/auth_controller.dart';
import 'package:iskainan/controllers/vendor_controller.dart';
import 'package:iskainan/firebase_options.dart';
import 'package:iskainan/pages/splash/splash_page.dart';

import 'package:iskainan/routes/route_helper.dart';
import 'package:iskainan/utils/colors.dart';
import 'data/repository/authentication_repo.dart';
import 'helper/dependencies.dart' as dep;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDisplayMode.setHighRefreshRate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(/*AuthenticationRepository()*/AuthController()));
  await Future.delayed(Duration(milliseconds: 1000));
  await dep.init();

  runApp(Home());
}


class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          primaryColor: AppColors.mainColor,
          accentColor: AppColors.mainColor,

          fontFamily: 'Roboto'
      ),
      debugShowCheckedModeBanner: false,
      title: 'IsKainan: Campus Food App',

      home: SplashScreen(),
      // initialRoute: FirebaseAuth.instance.currentUser == null
      //               ? RouteHelper.getInitial()
      //               : RouteHelper.getAccountPage(),
      // initialRoute: RouteHelper.getInitial(),
      getPages: RouteHelper.routes,
    );
  }
}
