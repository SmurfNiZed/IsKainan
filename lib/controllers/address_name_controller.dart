import 'package:geocoding/geocoding.dart';

Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
  if (14.659279223 < latitude && latitude < 14.660592238 && 121.067001996 < longitude && longitude < 121.068541584){
    return "Area 2";
  } else if (14.656188692 < latitude && latitude < 14.657506914 && 121.068630105 < longitude && longitude < 121.070636397){
    return "Melchor Hall";
  } else if (14.648427758 < latitude && latitude < 14.653026096 && 121.074410969 < longitude && longitude < 121.076363617){
    return "UP Town Center";
  } else if (14.653848695 < latitude && latitude < 14.654680383 && 121.073336749 < longitude && longitude < 121.074000597){
    return "Vinzons Hall & Student Union Building";
  } else if (14.651336751 < latitude && latitude < 14.652431834 && 121.07277483 < longitude && longitude < 121.074019375){
    return "UP College of Home Economics";
  } else if (14.650617924 < latitude && latitude < 14.651149906 && 121.072629994 < longitude && longitude < 121.073783344){
    return "Institute of Chemistry";
  } else if (14.648554898 < latitude && latitude < 14.649629236 && 121.07247441 < longitude && longitude < 121.073732366){
    return "National Institute of Physics";
  }else if (14.647740076 < latitude && latitude < 14.648927742 && 121.070802434 < longitude && longitude < 121.072213362){
    return "Institute of Mathematics";
  } else if (14.650571222 < latitude && latitude < 14.650996801 && 121.071271429 < longitude && longitude < 121.072017083){
    return "UP NIMBB";
  } else if (14.650409034 < latitude && latitude < 14.651317283 && 121.070201228 < longitude && longitude < 121.071236561){
    return "Institute of Biology";
  } else if (14.647483157 < latitude && latitude < 14.6485056 && 121.069065299 < longitude && longitude < 121.069982614){
    return "National Institute of Geological Sciences";
  } else if (14.648980477 < latitude && latitude < 14.649585116 && 121.069129675 < longitude && longitude < 121.06975463){
    return "College of Science Library";
  } else if (14.651325731 < latitude && latitude < 14.651930363 && 121.067203181 < longitude && longitude < 121.068504053){
    return "UP NISMED";
  } else if (14.65251683 < latitude && latitude < 14.653829885 && 121.068667657 < longitude && longitude < 121.070652491){
    return "Palma Hall";
  } else if (14.65686596 < latitude && latitude < 14.657519881 && 121.062490522 < longitude && longitude < 121.063292502){
    return "School of Urban and Regional Planning";
  } else if (14.652121083 < latitude && latitude < 14.652493463 && 121.062389931 < longitude && longitude < 121.062761417){
    return "Gyud Food Market at UP Food Hub";
  } else if (14.650510213 < latitude && latitude < 14.652063437 && 121.064421648 < longitude && longitude < 121.065800303){
    return "College of Architecture";
  } else if (14.650038595 < latitude && latitude < 14.650806715 && 121.062278627 < longitude && longitude < 121.064295648){
    return "Village A and Village B";
  } else if (14.64831811 < latitude && latitude < 14.649049906 && 121.065962653 < longitude && longitude < 121.066713672){
    return "Institute of Civil Engineering";
  } else if (14.646659879 < latitude && latitude < 14.647692705 && 121.06300013 < longitude && longitude < 121.064545082){
    return "Krus na Ligas (near Arko)";
  } else {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks.first;
    String? street = placemark.street;
    return street;
  }
}



