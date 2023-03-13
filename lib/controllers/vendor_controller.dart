
import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/hardcoded_data.dart';
import '../data/repository/vendors_repo.dart';
import '../models/vendors_model.dart';

class VendorController extends GetxController{
  final VendorRepo vendorRepo;
  VendorController({required this.vendorRepo});
  List<VendorModel> _vendorList = [];
  // List<FoodModel> _foodList = [];
  // List<int> _foodListIds = [];

  List<VendorModel> get vendorList =>_vendorList;
  // List<FoodModel> get foodList =>_foodList;
  // List<int> get foodListIds =>_foodListIds;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getVendorList()async {
    Response response = await vendorRepo.getVendorList();
    // successful

    if(/*response.statusCode == 200*/true){
      _vendorList = [];
      // _foodList = [];
      // _foodListIds = [];
      _vendorList.addAll(Vendors.fromJson(data).contents);

      // for (var i = 0; i < vendorList.length; i++)
      //   {
      //     _foodList.addAll(vendorList[i].food_model);
      //     for (var j = 0; j < vendorList[i].food_model.length; j++)
      //     {
      //       _foodListIds.add(vendorList[i].vendorId!);
      //     }
      //   }

      _isLoaded = true;
      update(); // refresh app
    }else{

    }
  }
}