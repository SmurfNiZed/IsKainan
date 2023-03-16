import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/big_text.dart';

void showCustomerSnackBar(String message, {bool isError=true, String title="Error", Color color= Colors.red}){
  Get.snackbar(title, message,
    colorText: color,
    snackPosition: SnackPosition.TOP,
    backgroundColor: color.withOpacity(0.3),
  );
}

