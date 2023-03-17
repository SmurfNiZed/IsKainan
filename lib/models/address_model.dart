// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AddressModel{
//   late int? _id;
//   late String _address;
//   late String _latitude;
//   late String _longitude;
//
//   AddressModel({
//     id,
//     required address,
//     required latitude,
//     required longitude,
//   }){
//     _id = id;
//     _address = address;
//     _latitude = latitude;
//     _longitude = longitude;
//   }
//
//   String get address => _address;
//   String get latitude => _latitude;
//   String get longitude => _longitude;
//
//   factory AddressModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
//     final data = document.data()!;
//
//   }
// }