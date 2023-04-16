import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../models/vendor_data_model.dart';

class VendorController extends GetxController{
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  @override
  void onInit() {
    super.onInit();
    getVendors();
    getVendorMenu();
    getCheapVendorMenu();
  }

  final CollectionReference vendorsCollection = FirebaseFirestore.instance.collection('vendors');
  final Query<Map<String, dynamic>> vendorMenuCollection = FirebaseFirestore.instance.collectionGroup('foodList');


  List<VendorData> vendors = [];
  List<VendorMenu> vendorMenu = [];
  List<VendorMenu> cheapVendorMenu = [];

  Future<void> getVendors() async {
    QuerySnapshot querySnapshot = await vendorsCollection.get();
    vendors = await querySnapshot.docs.map((doc) => VendorData.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
  }

  Future<VendorData> getVendorData(String vendorId) async {
    DocumentSnapshot vendor = await vendorsCollection.doc(vendorId).get();
    return await VendorData.fromSnapshot(vendor as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<void> getCheapVendorMenu() async {
    await vendorMenuCollection.get().then((snapshot) {
      cheapVendorMenu = snapshot.docs.map((DocumentSnapshot document) {
        return VendorMenu.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  Future<void> getVendorMenu() async {
    final QuerySnapshot snapshot = await vendorMenuCollection.get();

    vendorMenu = snapshot.docs.map((DocumentSnapshot document) {
      return VendorMenu.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }

  Future<VendorMenu> getVendorMenuData(String vendorId, String foodId) async {
    DocumentSnapshot menuSnapshot = await vendorsCollection.doc(vendorId).collection('foodList').doc(foodId).get();
    return await VendorMenu.fromSnapshot(menuSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }
}
