// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geocode/geocode.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:iskainan/controllers/auth_controller.dart';
// import '../../base/show_custom_snackbar.dart';
// import '../../controllers/location_controller.dart';
// import '../../controllers/profile_controller.dart';
// import '../../models/vendor_data_model.dart';
// import '../../utils/colors.dart';
// import '../../utils/dimensions.dart';
// import '../../widgets/big_text.dart';
// import 'account_page.dart';
//
// class ManageLocationPage extends StatefulWidget {
//   const ManageLocationPage({Key? key}) : super(key: key);
//
//   @override
//   State<ManageLocationPage> createState() => _ManageLocationPage();
// }
//
// class _ManageLocationPage extends State<ManageLocationPage> {
//
//   // late GoogleMapController myController;
//   late CameraPosition _pickPosition;
//   late String? _locationName;
//   // void initMarker(specify, specifyId) async{
//   //   var markerIdVal = specifyId;
//   //   final MarkerId markerId = MarkerId(markerIdVal);
//   //   final Marker marker = Marker(
//   //     markerId: markerId,
//   //     position: LatLng(specify['vendorLocation'])
//   //   );
//   // }
//
//   // getMarkerData() async {
//   //   Firestore.instance.collection("vendors").getDocuments().then((myMockData){
//   //     if(myMockData.documents.isNotEmpty){
//   //       for(int i = 0; i < myMockData.documents.length; i++){
//   //
//   //       }
//   //     }
//   //   });
//   // }
//
//   // Future<void> updateVendorLocation(Position latitude, Position longitude, String? id)async ){
//   //   FirebaseFirestore.instance.collection('vendors').doc(id).update({
//   //   'vendor_location': GeoPoint(latitude, longitude),
//   //   });
//   //   showCustomerSnackBar("Account details updated.", title: "Success", color: Colors.green);
//   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());
//     final List<Marker> _markers = [];
//     // Set<Marker> getMarker(){
//     //   return <Marker>[
//     //     Marker(
//     //       markerId: MarkerId("Mang Larry's Isawan"),
//     //       position: LatLng(14.651215654673477, 121.06247133178275),
//     //       icon: BitmapDescriptor.defaultMarker,
//     //       infoWindow: InfoWindow(title: 'Shop')
//     //     )
//     //   ].toSet();
//     // }
//     return FutureBuilder(
//       future: controller.getUserData(),
//       builder: (context, snapshot){
//         if(snapshot.connectionState == ConnectionState.done) {
//           VendorData user= snapshot.data as VendorData;
//           return Scaffold(
//             body: SafeArea(
//               child: Center(
//                 child: SizedBox(
//                   width: double.maxFinite,
//                   child: Stack(
//                     children: [
//                       GoogleMap(
//                         initialCameraPosition: CameraPosition(
//                           target: LatLng(user.vendor_location!.latitude, user.vendor_location!.longitude),
//                           zoom: 18.0,
//                         ),
//                         markers: _markers.toSet(),
//                         zoomControlsEnabled: false,
//                         compassEnabled: false,
//                         indoorViewEnabled: true,
//                         mapToolbarEnabled: false,
//                         onMapCreated: (GoogleMapController controller){
//                           final marker = Marker(
//                             markerId:  MarkerId('0'),
//                             position: LatLng(user.vendor_location!.latitude, user.vendor_location!.longitude)
//                           );
//                           // myController = controller;
//                           _markers.add(marker);
//                         },
//                         onCameraMove: (position) {
//                           setState(() {
//                             _markers.first = _markers.first.copyWith(positionParam: position.target);
//                           });
//                         },
//                       ),
//                       Center(
//                         child: Icon(
//                           Icons.location_on,
//                           color: AppColors.mainColor,
//                           size: 50,
//                         ),
//                       ),
//                       Positioned(
//                         top: Dimensions.height45,
//                         left: Dimensions.width20,
//                         right: Dimensions.width20,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
//                           height: 50,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(Dimensions.radius20/2),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.storefront, size: 25, color: AppColors.iconColor1),
//                               // Expanded(child: Text(
//                               //
//                               // ))
//                             ],
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           // List<Placemark> placemarks = await GeoCode.local.findAddressesFromCoordinates(
//                           //     Coordinates(_pickPosition.target.latitude, _pickPosition.target.longitude));
//                           // if (placemarks != null && placemarks.isNotEmpty) {
//                           //   setState(() {
//                           //     _locationName = placemarks[0].locality;
//                           //   });
//                           // }
//                         },
//                         child: Text('Get Location Name'),
//                       ),
//                     ],
//                   )
//                 ),
//               ),
//             )
//             // body: Column(
//             //   children: [
//             //     Container(
//             //       height: 500,
//             //       width: MediaQuery.of(context).size.width,
//             //       margin: const EdgeInsets.only(left: 5, top: 5, right:5),
//             //       decoration: BoxDecoration(
//             //           borderRadius: BorderRadius.circular(5),
//             //           border: Border.all(
//             //               width: 2,
//             //               color: AppColors.iconColor1
//             //           )
//             //       ),
//             //       child: Stack(
//             //         children: [
//             //           GoogleMap(
//             //             // markers: getMarker(),
//             //             initialCameraPosition: CameraPosition(
//             //               target: LatLng(user.vendor_location!.latitude, user.vendor_location!.longitude),
//             //               zoom: 18.0,
//             //             ),
//             //             zoomControlsEnabled: false,
//             //             compassEnabled: false,
//             //             indoorViewEnabled: true,
//             //             mapToolbarEnabled: false,
//             //             onCameraIdle: (){
//             //
//             //             },
//             //             onMapCreated: (GoogleMapController controller){
//             //               myController = controller;
//             //             },
//             //           ),
//             //         ],
//             //       ),
//             //     ),
//             //     SizedBox(height: Dimensions.height45,),
//             //     GestureDetector(
//             //       onTap: () {
//             //         // _updateGeneralInformation(
//             //         //     vendorNameController,
//             //         //     phoneController,
//             //         //     _checkBoxGCash!,
//             //         //     _checkBoxOpen!,
//             //         //     operatingHoursController,
//             //         //     user.vendor_id);
//             //       },
//             //       child: Container(
//             //         margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
//             //         height: 50,
//             //         width: Dimensions.screenWidth,
//             //         decoration: BoxDecoration(
//             //             color: AppColors.iconColor1,
//             //             borderRadius: BorderRadius.circular(Dimensions.radius30),
//             //             boxShadow: [
//             //               BoxShadow(
//             //                   blurRadius: 10,
//             //                   spreadRadius: 7,
//             //                   offset: Offset(1, 10),
//             //                   color: Colors.grey.withOpacity(0.2)
//             //               )
//             //             ]
//             //         ),
//             //         child: Row(
//             //           mainAxisAlignment: MainAxisAlignment.center,
//             //           crossAxisAlignment: CrossAxisAlignment.center,
//             //           children: [
//             //             BigText(text: "Save Changes", color: Colors.white,),
//             //           ],
//             //         ),
//             //       ),
//             //     )
//             //   ],
//             // )
//           );
//         } else {
//           return Scaffold(
//             body: Center(
//               child: Icon(Icons.location_on,
//               size: Dimensions.screenWidth/2,
//               color: AppColors.iconColor1,),
//             ),
//           );
//           // return Scaffold(
//           //   backgroundColor: Colors.white,
//           //   body: Center(child: CircularProgressIndicator(color: AppColors.mainColor,))
//           // );
//         }
//       }
//     );
//   }
// }
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../base/show_custom_snackbar.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import 'account_page.dart';

class ManageLocationPage extends StatefulWidget {
  final GeoPoint startSpot;
  final String Id;
  ManageLocationPage({Key? key, required this.startSpot, required this.Id})
      : super(key: key);

  @override
  _ManageLocationPage createState() => _ManageLocationPage();
}

class _ManageLocationPage extends State<ManageLocationPage> {
  final List<Marker> _markers = [];
  late GeoPoint chosenLocation;
  late Address address;


  getAddress(GeoPoint currentLocation) {
    GeoCode geoCode = GeoCode();

    return geoCode.reverseGeocoding(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
  }

  Future<void> _updateVendorLocation(GeoPoint vendor_location, String? id) async {
    try{
      await FirebaseFirestore.instance.collection('vendors').doc(id).update({'vendor_location': vendor_location}); 
      showCustomerSnackBar("Vendor Location updated.", title: "Success", color: Colors.green);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
    }catch(e){
      showCustomerSnackBar(e.toString());
    }
  }



  @override
  void initState(){
    super.initState();
    chosenLocation = widget.startSpot;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.startSpot.latitude, widget.startSpot.longitude),
              zoom: 18),
          markers: _markers.toSet(),
          zoomControlsEnabled: false,
          compassEnabled: false,
          indoorViewEnabled: true,
          mapToolbarEnabled: false,
          onMapCreated: (controller) {
            final marker = Marker(
              markerId: MarkerId('0'),
              position: LatLng(
                  widget.startSpot.latitude, widget.startSpot.longitude),

            );

            _markers.add(marker);
          },
          onCameraMove: (position) {
            chosenLocation = GeoPoint(position.target.latitude, position.target.longitude);
            // address = getAddress(chosenLocation);
            setState(() {
              _markers.first =
                  _markers.first.copyWith(positionParam: position.target);
            });
          },
        ),
        Positioned(
            top: Dimensions.height45 + Dimensions.height10,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2)
                    )
                  ]
              ),
              child: Row(
                children: [
                  Icon(Icons.storefront, size: 25, color: AppColors.iconColor1),
                  SizedBox(width: Dimensions.width10,),
                  Expanded(child: SmallText(text: chosenLocation.latitude.toString(),)),
                ],
              ),
            ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                _updateVendorLocation(chosenLocation, widget.Id);
              },
              child: Container(
                margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                height: 50,
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                    color: AppColors.iconColor1,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: Offset(1, 10),
                          color: Colors.grey.withOpacity(0.2)
                      )
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BigText(text: "Save Changes", color: Colors.white,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}