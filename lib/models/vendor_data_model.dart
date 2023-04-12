import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocode/geocode.dart';

import '../controllers/address_name_controller.dart';

class VendorData {
  String? vendor_id;
  String? email;
  String? vendor_name;
  String? password;
  String? phone;
  String? vendor_location;
  double? latitude;
  double? longitude;
  String? vendor_img;
  String? is_gcash;
  List<int>? operating_hours;
  List<bool>? operating_days;
  String? is_open;
  Timestamp? account_created;
  String? approved;

  VendorData(
      {this.vendor_id,
        this.email,
        this.vendor_name,
        this.password,
        this.phone,
        this.latitude,
        this.longitude,
        this.vendor_location,
        this.vendor_img,
        this.is_gcash,
        this.operating_hours,
        this.operating_days,
        this.is_open,
        this.account_created,
        this.approved}) {
    late Future<String?> getLocation;
    getLocation = getAddressFromLatLng(latitude!, longitude!);

    getLocation.then((String? data) {
      data != null?vendor_location = data:"";
    });
  }

  toJson(){
    return {
      'email': email,
      'vendor_name': vendor_name,
      'password': password,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'vendor_location': vendor_location,
      'account_created': account_created,
      'is_open': is_open,
      'operating_hours': operating_hours,
      'operating_days': operating_days,
      'is_gcash': is_gcash,
      'vendor_img': vendor_img,
      'approved': approved,
    };
  }

  factory VendorData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return VendorData(
      vendor_id: document.id,
      email: data['email'],
      password: data['password'],
      vendor_name: data['vendor_name'],
      phone: data['phone'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      vendor_location: data['vendor_location'],
      vendor_img: data['vendor_img'],
      is_gcash: data['is_gcash'].toString(),
      operating_hours: List<int>.from(data['operating_hours'] ?? []),
      operating_days: List<bool>.from(data['operating_days'] ?? []),
      is_open: data['is_open'].toString(),
      account_created: data['account_created'],
      approved: data['approved'] ?? "false",
    );
  }
}

class VendorMenu {
  String? foodId;
  String? vendorId;
  String? vendorName;
  String? foodName;
  String? foodPrice;
  String? foodImg;
  String? isAvailable;
  String? isSpicy;
  Timestamp? food_created;

  VendorMenu({
    this.foodId,
    this.vendorId,
    this.vendorName,
    this.foodName,
    this.foodPrice,
    this.foodImg,
    this.isAvailable,
    this.isSpicy,
    this.food_created});

  factory VendorMenu.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return VendorMenu(
      foodId: document.id,
      vendorName: data!["vendor_name"],
      vendorId: data["vendor_id"],
      foodName: data["food_name"],
      foodPrice: data["food_price"],
      foodImg: data["food_img"],
      isAvailable: data["is_available"],
      isSpicy: data["is_spicy"],
      food_created: data["food_created"],
    );
  }

  toJson() {
    return {
      'food_name': foodName,
      'vendor_id': vendorId,
      'vendor_name': vendorName,
      'food_price': foodPrice,
      'food_img': foodImg,
      'is_available': isAvailable,
      'is_spicy': isSpicy,
      'food_created': food_created,
    };
  }
}