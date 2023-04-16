import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'big_text.dart';

class RectangleIconWidget extends StatelessWidget {
  final String text;
  final Color iconColor;
  final bool isActivated;

  RectangleIconWidget({Key? key,
    required this.text,
    required this.iconColor,
    required this.isActivated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isActivated?Container(
      padding: EdgeInsets.only(top: Dimensions.height10/2, bottom: Dimensions.height10/2, left: Dimensions.width10/2, right: Dimensions.width10/2),
      child: BigText(text: text, color: Colors.white, size: Dimensions.font20/2,),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15/4),
          color: isActivated?iconColor:Colors.grey
      ),
    ):SizedBox();
  }
}
