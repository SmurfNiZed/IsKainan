import 'package:geocoding/geocoding.dart';

Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  Placemark placemark = placemarks.first;
  String? street = placemark.street;
  return street;
}
