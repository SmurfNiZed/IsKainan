import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocode/geocode.dart';

import '../controllers/address_name_controller.dart';

class VendorData {
  String? vendor_id;
  String? email;
  String? vendor_name;
  String? password;
  String? phone;
  GeoPoint? vendor_location;
  String? vendor_img;
  String? is_gcash;
  String? operating_hours;
  String? is_open;
  String? account_created;
  String? approved;
  // VendorMenu? vendorMenu;

  VendorData(
      {this.vendor_id,
        this.email,
        this.vendor_name,
        this.password,
        this.phone,
        double? latitude,
        double? longitude,
        this.vendor_img,
        this.is_gcash,
        this.operating_hours,
        this.is_open,
        this.account_created,
        this.approved,
        /*this.vendorMenu*/}) {
    vendor_location = latitude != null && longitude != null ? GeoPoint(latitude, longitude) : null;
  }

  toJson(){
    return {
      'email': email,
      'vendor_name': vendor_name,
      'password': password,
      'phone': phone,
      'vendor_location': vendor_location,
      // 'vendor_menu': vendorMenu?.toJson(),
      'account_created': account_created,
      'is_open': is_open,
      'operating_hours': operating_hours,
      'is_gcash': is_gcash,
      'vendor_img': vendor_img,
      'approved': approved,
    };
  }

  factory VendorData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    print("VendorDataModel");
    final data = document.data()!;
    GeoPoint geoPoint = data['vendor_location'];

    // print("vendorId:"+document.id);
    // print("email:" + data['email']);
    // print("vendor_name:" +data['vendor_name']);
    // print("password:" +data['password']);
    // print("phone:" +data['phone']);
    // print("vendorImg:" +data['vendor_img']);
    // print("operatingHours:" +data['operating_hours']);
    // print("accountCreated:" +data['account_created']);
    // print("isOpen:" +data['is_open']);
    // print("isGcash:" +data['is_gcash']);

    return VendorData(
      vendor_id: document.id,
      email: data['email'],
      password: data['password'],
      vendor_name: data['vendor_name'],
      phone: data['phone'],
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      vendor_img: data['vendor_img'],
      is_gcash: data['is_gcash'].toString(),
      operating_hours: data['operating_hours'],
      is_open: data['is_open'].toString(),
      account_created: data['account_created'].toString(),
      approved: data['approved'] ?? "false",
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

class VendorMenu {
  String? foodName;
  String? foodPrice;
  String? foodImg;
  String? isAvailable;
  String? isSpicy;
  String? food_created;
  // String? isShellfish;
  // String? isPeanut;
  // String? isMilk;
  // String? isFish;
  // String? isSoy;

  VendorMenu({
    this.foodName,
    this.foodPrice,
    this.foodImg,
    this.isAvailable,
    this.isSpicy,
    this.food_created,
    /*this.isShellfish,
    this.isPeanut,
    this.isMilk,
    this.isFish,
    this.isSoy*/});

  factory VendorMenu.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return VendorMenu(
        foodName: data["foodName"],
        foodPrice: data["foodPrice"],
        foodImg: data["foodImg"],
        isAvailable: data["isAvailable"],
        isSpicy: data["isSpicy"],
        food_created: data["food_created"],
        // isShellfish: data["isShellfish"],
        // isPeanut: data["isPeanut"],
        // isMilk: data["isMilk"],
        // isFish: data["isFish"],
        // isSoy: data["isSoy"]
    );
  }

  toJson() {
    return {
      'food_name': foodName,
      'food_price': foodPrice,
      'food_img': foodImg,
      'is_available': isAvailable,
      'is_spicy': isSpicy,
      'food_created': food_created,
      // 'is_shellfish': isShellfish,
      // 'is_peanut': isPeanut,
      // 'is_milk': isMilk,
      // 'is_fish': isFish,
      // 'is_soy': isSoy,
    };
  }
}