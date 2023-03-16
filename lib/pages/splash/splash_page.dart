import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/vendor_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../Home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    await Get.find<VendorController>().getVendorList();
  }

  @override
  void initState(){
    super.initState();

    _loadResource();
    // controller = AnimationController(
    //     vsync: this,
    //     duration: const Duration(seconds: 2))..forward();
  //   animation = CurvedAnimation(
  //       parent: controller,
  //       curve: Curves.linear);

    // Timer(
    //   const Duration(seconds: 3),
    //     ()=>Get.offNamed(RouteHelper.getInitial())
    // );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Scaffold(
        backgroundColor: Colors.white,
        body:
        Center(
            child: Center(child: Image.asset(
              'assets/images/logo.png',
              width: Dimensions.splashImg,
            )
          ),
        ),
      ),
      duration: 1000,
      nextScreen: HomePage(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

// Scaffold(
// backgroundColor: Colors.white,
// body: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// FadeTransition(
// opacity: animation,
// child: Center(child: Image.asset('assets/images/logo.png', width: Dimensions.splashImg,)))
// ],
// ),
// );