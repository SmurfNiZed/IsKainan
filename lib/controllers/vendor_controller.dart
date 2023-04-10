import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../models/vendor_data_model.dart';

class VendorController extends GetxController{
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  @override
  void onInit() {
    super.onInit();
    getVendors();
  }
  final CollectionReference vendorsCollection = FirebaseFirestore.instance.collection('vendors');
  List<VendorData> vendors = [];

  Future<void> getVendors() async {
    QuerySnapshot querySnapshot = await vendorsCollection.get();
    vendors = await querySnapshot.docs.map((doc) => VendorData.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
  }

  Future<VendorData> getVendorData(String vendorId) async {
    DocumentSnapshot vendor = await vendorsCollection.doc(vendorId).get();
    return await VendorData.fromSnapshot(vendor as DocumentSnapshot<Map<String, dynamic>>);
  }

}
