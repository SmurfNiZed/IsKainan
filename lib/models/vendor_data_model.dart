import 'package:cloud_firestore/cloud_firestore.dart';

class VendorData {
  String? vendorId;
  String email;
  String vendorName;
  String password;
  String phone;
  GeoPoint? vendorLocation;
  String? vendorImg;
  bool? isGcash;
  String? operatingHours;
  bool? isOpen;
  DateTime? accountCreated;
  // VendorMenu? vendorMenu;

  VendorData(
      {this.vendorId,
        required this.email,
        required this.vendorName,
        required this.password,
        required this.phone,
        double? latitude,
        double? longitude,
        this.vendorImg,
        this.isGcash,
        this.operatingHours,
        this.isOpen,
        this.accountCreated,
        /*this.vendorMenu*/}): vendorLocation = latitude != null && longitude != null ? GeoPoint(latitude, longitude) : null;

  toJson(){
    return {
      'email': email,
      'vendor_name': vendorName,
      'password': password,
      'phone': phone,
      'vendor_location': vendorLocation,
      // 'vendor_menu': vendorMenu?.toJson(),
      'accountCreated': accountCreated,
      'isOpen': isOpen,
      'operatingHours': operatingHours,
      'isGcash': isGcash,
      'vendorImg': vendorImg
    };
  }

  factory VendorData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return VendorData(
      vendorId: document.id,
      email: data['email'],
      password: data['password'],
      vendorName: data['vendorName'],
      phone: data['phone'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      vendorImg: data['vendorImg'],
      isGcash: data['isGcash'],
      operatingHours: data['operatingHours'],
      isOpen: data['isOpen'],
      accountCreated: data['accountCreated'],
      // vendorMenu: VendorMenu.fromSnapshot(data['vendorMenu'])
    );
  }

  // Parsing Data
  // factory VendorData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document)
  // {
  //   final data = document.data()!;
  //   return VendorData(
  //     vendorId: document.id,
  //     email: data["email"],
  //     password: data["password"],
  //     vendorName: data["vendorName"],
  //     phone: data["phone"],
  //     latitude: data["latitude"],
  //     longitude: data["longitude"],
  //     vendorImg: data["vendorImg"],
  //     isGcash: data["isGcash"],
  //     operatingHours: data["operatingHours"],
  //     isOpen: data["isOpen"],
  //     accountCreated: data["accountCreated"],
  //     vendorMenu: data["vendorMenu"],
  //   );
  // }

  // Upon account creation
  // toJson(){
  //   return {
  //   'email': email,
  //   'vendor_name': vendorName,
  //   'password': password,
  //   'phone': phone,
  //   'vendor_location': vendorLocation,
  //   'vendor_menu': vendorMenu,
  //   'accountCreated': accountCreated,
  //   'isOpen': isOpen,
  //   'operatingHours': operatingHours,
  //   'isGcash': isGcash,
  //   'vendorImg': vendorImg
  //   };
  // }
}

// class VendorMenu {
//   String? foodName;
//   String? foodPrice;
//   String? foodImg;
//   bool? isAvailable;
//   bool? isSpicy;
//   bool? isShellfish;
//   bool? isPeanut;
//   bool? isMilk;
//   bool? isFish;
//   bool? isSoy;
//
//   VendorMenu({
//     this.foodName,
//     this.foodPrice,
//     this.foodImg,
//     this.isAvailable,
//     this.isSpicy,
//     this.isShellfish,
//     this.isPeanut,
//     this.isMilk,
//     this.isFish,
//     this.isSoy});
//
//   factory VendorMenu.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
//     final data = document.data()!;
//     return VendorMenu(
//         foodName: data["foodName"],
//         foodPrice: data["foodPrice"],
//         foodImg: data["foodImg"],
//         isAvailable: data["isAvailable"],
//         isSpicy: data["isSpicy"],
//         isShellfish: data["isShellfish"],
//         isPeanut: data["isPeanut"],
//         isMilk: data["isMilk"],
//         isFish: data["isFish"],
//         isSoy: data["isSoy"]
//     );
//   }
//
//   toJson() {
//     return {
//       'food_name': foodName,
//       'food_price': foodPrice,
//       'food_img': foodImg,
//       'is_available': isAvailable,
//       'is_spicy': isSpicy,
//       'is_shellfish': isShellfish,
//       'is_peanut': isPeanut,
//       'is_milk': isMilk,
//       'is_fish': isFish,
//       'is_soy': isSoy,
//     };
//   }
// }