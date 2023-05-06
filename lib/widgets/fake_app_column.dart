import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';
import 'package:iskainan/widgets/small_text.dart';
import '../controllers/vendor_controller.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/is_new.dart';
import '../utils/shimmer.dart';
import 'big_text.dart';


class FakeAppColumn extends StatefulWidget {
  FakeAppColumn({Key? key}) : super(key: key);

  @override
  State<FakeAppColumn> createState() => _FakeAppColumnState();
}

class _FakeAppColumnState extends State<FakeAppColumn> {

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        shimmer(height: Dimensions.font26, width: Dimensions.width30*9),
        SizedBox(height: Dimensions.height10,),
        shimmer(height: Dimensions.font16, width: Dimensions.width30*3),
        SizedBox(height: Dimensions.height10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            shimmer(height: Dimensions.font16, width: Dimensions.screenWidth*1.5/5),
            shimmer(height: Dimensions.font16, width: Dimensions.screenWidth*1/5),
          ],
        ),
      ],
    );
  }
}

