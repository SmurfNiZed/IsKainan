import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocode/geocode.dart';

Future<Address> getAddressFromLatLng(GeoPoint latLng) async {

  GeoCode geoCode = GeoCode();
  Address address = await geoCode.reverseGeocoding(latitude: latLng.latitude, longitude: latLng.longitude);
  return address;

}