import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class FindVendor extends StatefulWidget {
  final GeoPoint startSpot;
  final GeoPoint endSpot;
  final String vendorName;
  final String vendorAddress;
  const FindVendor({Key? key, required this.startSpot, required this.endSpot, required this.vendorName, required this.vendorAddress}) : super(key: key);

  @override
  State<FindVendor> createState() => _FindVendorState();
}

class _FindVendorState extends State<FindVendor> {
  final Set<Polyline> polyline = {};

  late GoogleMapController _controller;
  late List<LatLng> routeCoords;
  late GoogleMapPolyline _googleMapPolyline;

  final List<Marker> _markers = [];


  @override
  void initState() {
    super.initState();
    _googleMapPolyline = GoogleMapPolyline(apiKey: "AIzaSyDyzXKEdYIxAUJDsnn27y4OzCIMBOrIlME");
  }

  @override
  void dispose() {
    polyline.clear();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            polylines: polyline,
            initialCameraPosition: CameraPosition(target: LatLng(widget.startSpot.latitude, widget.startSpot.longitude),
                zoom: 18.0
            ),
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            markers: _markers.toSet(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: Dimensions.height45 + Dimensions.height10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
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
                    child: Builder(
                        builder: (context) {
                          return Row(
                            children: [
                              Icon(Icons.directions_walk, size: 25, color: AppColors.iconColor1),
                              SizedBox(width: Dimensions.width10,),
                              Expanded(child: Text(
                                  widget.vendorName + ", " + widget.vendorAddress,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                  )/*, size: Dimensions.font20,*/)),
                            ],
                          );
                        }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }

  void onMapCreated(GoogleMapController controller) {

    final markerStart = Marker(
      markerId: MarkerId('0'),
      position: LatLng(
          widget.startSpot.latitude, widget.startSpot.longitude),
    );

    final markerEnd = Marker(
      markerId: MarkerId('1'),
      position: LatLng(
          widget.endSpot.latitude, widget.endSpot.longitude),
    );

    _markers.add(markerStart);
    _markers.add(markerEnd);

    _googleMapPolyline.getCoordinatesWithLocation(
      // origin: LatLng(14.654941990186154, 121.0648511552033),
        origin: LatLng(widget.startSpot.latitude, widget.startSpot.longitude),
        destination: LatLng(widget.endSpot.latitude, widget.endSpot.longitude),
        mode: RouteMode.walking).then((value) {
      setState(() {
        routeCoords = value!;
        polyline.add(Polyline(
            polylineId: PolylineId('route1'),
            visible: true,
            points: routeCoords,
            width: 4,
            color: AppColors.mainColor,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap
        ));
      });
    });

    setState(() {
      _controller = controller;
    });
  }
}