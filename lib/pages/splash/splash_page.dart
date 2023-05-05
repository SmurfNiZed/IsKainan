import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/vendor_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../Home/home_page.dart';

class SplashScreen extends StatefulWidget {
  String searchString;
  double budget;
  LatLng position;

  SplashScreen({Key? key,
    required this.searchString,
    required this.budget,
    required this.position}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    await Get.find<VendorController>().getVendors();
    await Get.find<VendorController>().getVendorMenu();
  }


  @override
  void initState(){
    super.initState();
    _loadResource();
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
      duration: 3,
      nextScreen: HomePage(searchString: widget.searchString, budget: widget.budget, position: widget.position,),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

