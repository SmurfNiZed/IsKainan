
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/hardcoded_data.dart';
import '../data/repository/vendors_repo.dart';
import '../models/vendors_model.dart';

class VendorController extends GetxController{
  final VendorRepo vendorRepo;
  VendorController({required this.vendorRepo});
  List<VendorModel> _vendorList = [];

  List<VendorModel> get vendorList =>_vendorList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getVendorList()async {
    Response response = await vendorRepo.getVendorList();

    // successful

    if(response.statusCode == 200){
      _vendorList = [];
      _vendorList.addAll(Vendors.fromJson(response.body).contents);
      _isLoaded = true;
      update(); // refresh app
    }else{

    }
  }
}