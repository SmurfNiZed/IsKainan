import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String vendorName;
  final String email;
  final String phone;
  final String password;

  const UserModel({
   this.id,
   required this.email,
   required this.password,
   required this.vendorName,
   required this.phone
});

  toJson(){
    return {
      "vendor_name": vendorName,
      "email": email,
      "phone": phone,
      "password": password,
    };
  }

  // Build Json object for fetching
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["email"],
      password: data["password"],
      vendorName: data["vendor_name"],
      phone: data["phone"],
    );
  }

}