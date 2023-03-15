import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/big_text.dart';

void showCustomerSnackBar(String message, {bool isError=true, String title="Error"}){
  Get.snackbar(title, message,
    colorText: Colors.red,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red.withOpacity(0.1),
  );
}
