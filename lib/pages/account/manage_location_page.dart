import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/controllers/address_name_controller.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../../base/show_custom_snackbar.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';

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
  late Future<String?> chosenAddress;

  @override
  void initState(){
    super.initState();
    chosenLocation = widget.startSpot;
    chosenAddress = getAddressFromLatLng(chosenLocation.latitude, chosenLocation.longitude);
  }



  Widget build(BuildContext context) {
    Future<void> _updateVendorLocation(GeoPoint vendor_location, String? id) async {
      try{
        await FirebaseFirestore.instance.collection('vendors').doc(id).update({'vendor_location': vendor_location});
        showCustomerSnackBar("Vendor Location updated.", title: "Success", color: Colors.green);
      }catch(e){
        showCustomerSnackBar(e.toString());
      }
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.startSpot.latitude, widget.startSpot.longitude),
                zoom: 18),
            // markers: _markers.toSet(),
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
              chosenAddress = getAddressFromLatLng(chosenLocation.latitude, chosenLocation.longitude);
              // address = getAddressFromLatLng(chosenLocation) as String?;
              setState(() {
                _markers.first =
                    _markers.first.copyWith(positionParam: position.target);
              });
            },
            // onCameraIdle: () {
            //   chosenAddress = getAddressFromLatLng(chosenLocation.latitude, chosenLocation.longitude);
            // },
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
              child: FutureBuilder(
                  future: chosenAddress,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.hasData){
                        String? add = snapshot.data!;
                        return Builder(
                          builder: (context) {
                            return Row(
                              children: [
                                Icon(Icons.storefront, size: 25, color: AppColors.iconColor1),
                                SizedBox(width: Dimensions.width10,),
                                Expanded(child: Text(
                                    add,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    )/*, size: Dimensions.font20,*/)),
                              ],
                            );
                          }
                        );
                      } else {
                        return Center(
                          child: Text(
                              "Can't find a street, move pin to a better spot!",
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              )/*, size: Dimensions.font20,*/)
                        );
                      }
                    } else {
                      return Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.storefront, size: 25, color: AppColors.iconColor1),
                            ],
                          ),
                          Center(
                            child: JumpingDotsProgressIndicator(
                              color: AppColors.iconColor1,
                              fontSize: Dimensions.font26,
                            ),
                          ),
                        ],
                      );
                    }
                  })
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 42),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.mainColor,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}