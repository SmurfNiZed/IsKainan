import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double getDistance(LatLng origin, LatLng dest){
  return sqrt(pow(origin.latitude - dest.latitude, 2) + pow(origin.longitude - dest.longitude, 2));
}