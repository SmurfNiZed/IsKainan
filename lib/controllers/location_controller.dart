
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/models/vendor_data_model.dart';

import '../data/repository/location_repo.dart';

class LocationController extends GetxController implements GetxService{
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;
  late Position _position;
  late Position _pickPosition;


  List<VendorData> _addressList=[];
  List<VendorData> get addressList=>_addressList;
  late List<VendorData> _allAddressList;
  late Map<String, dynamic> _getAddress;
  Map get getAddress=>_getAddress;

  late GoogleMapController _mapController;

  bool _updateAddressData = true;

  void setMapController(GoogleMapController mapController){
    _mapController = mapController;
  }

  // void updatePosition(CameraPosition cameraPosition, bool fromAddress) {
  //   if(_updateAddressData){
  //     _loading = true;
  //     update();
  //     try{
  //       if(fromAddress){
  //         _position=Position(
  //
  //         )
  //       }
  //     }catch(e){
  //       print(e);
  //     }
  //   }
  // }
}