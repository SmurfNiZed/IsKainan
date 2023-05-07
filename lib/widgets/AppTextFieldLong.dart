import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppTextFieldLong extends StatelessWidget {
  TextEditingController vendorDescriptionController;
  AppTextFieldLong({Key? key, required this.vendorDescriptionController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: vendorDescriptionController,
      cursorColor: AppColors.mainColor,
      minLines: 1,
      maxLines: 5,
      maxLength: 100,
      decoration: InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,
          hintText:"Description",
          prefixIcon: Icon(Icons.description_outlined, color: AppColors.iconColor1),
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
    );
  }
}
