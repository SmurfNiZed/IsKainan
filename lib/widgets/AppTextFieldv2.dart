import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppTextFieldv2 extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final Color backgroundColor;
  AppTextFieldv2({Key? key,

    required this.textController,
    required this.hintText,
    required this.icon,
    required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height10, right: Dimensions.height10),
        decoration: BoxDecoration(
            color: Colors.grey[100]!,
            borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: TextField(
          cursorColor: AppColors.mainColor,
          controller: textController,
          decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, color: backgroundColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: AppColors.iconColor1
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.grey[100]!
                  )
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              )
          ),
        )
    );
  }
}