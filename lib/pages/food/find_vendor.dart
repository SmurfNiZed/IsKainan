import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/colors.dart';

class FindVendor extends StatefulWidget {
  final GeoPoint startSpot;
  final GeoPoint endSpot;
  const FindVendor({Key? key, required this.startSpot, required this.endSpot}) : super(key: key);

  @override
  State<FindVendor> createState() => _FindVendorState();
}

class _FindVendorState extends State<FindVendor> {
  final Set<Polyline> polyline = {};

  late GoogleMapController _controller;
  late List<LatLng> routeCoords;
  late GoogleMapPolyline _googleMapPolyline;

  final List<Marker> _markers = [];


  getSomePoints() async {
    routeCoords = (await _googleMapPolyline.getCoordinatesWithLocation(
      // origin: LatLng(14.654941990186154, 121.0648511552033),
        origin: LatLng(widget.startSpot.latitude, widget.startSpot.longitude),
        destination: LatLng(widget.endSpot.latitude, widget.endSpot.longitude),
        mode: RouteMode.walking))!;
  }

  @override
  void initState() {
    super.initState();
    _googleMapPolyline = GoogleMapPolyline(apiKey: "AIzaSyDyzXKEdYIxAUJDsnn27y4OzCIMBOrIlME");
    getSomePoints();
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
      body: GoogleMap(
        onMapCreated: onMapCreated,
        polylines: polyline,
        initialCameraPosition: CameraPosition(target: LatLng(widget.startSpot.latitude, widget.startSpot.longitude),
        zoom: 18.0
        ),
        mapType: MapType.normal,
        mapToolbarEnabled: false,
        markers: _markers.toSet(),
      ),
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

    setState(() {
      _controller = controller;

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
  }
}
