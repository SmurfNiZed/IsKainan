import 'package:geocoding/geocoding.dart';

Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
  if(14.65910932070817 < latitude && latitude < 14.660944555603638 && 121.06675129383801 < longitude && longitude < 121.06887694448234){
    return "Area 2";
  } else if (14.657473995747297 < latitude && latitude < 14.656195962035602 && 121.07060829428076 < longitude && longitude < 121.06859822127993){
    return "Melchor Bldg.";
  } else {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks.first;
    String? street = placemark.street;
    return street;
  }
}



