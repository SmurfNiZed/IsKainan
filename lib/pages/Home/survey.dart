import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/utils/shimmer.dart';
import 'package:iskainan/widgets/AppNumField.dart';
import 'package:iskainan/widgets/small_text.dart';
import '../../controllers/vendor_controller.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppTextFieldv2.dart';
import '../splash/splash_page.dart';

class ChoicePage extends StatefulWidget {
  ChoicePage({Key? key}) : super(key: key);

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  late StreamSubscription<Position> _locationSubscription;

  late Stream<Position> _locationStream;
  late List<Marker> vendorsLocation = [];

  void _getUserLocation() async {
    _locationStream = Geolocator.getPositionStream();
    _locationSubscription = _locationStream.listen((position) {
      // handle location updates here
    });
  }

  List<Marker> createMarkers() {
    List<Marker> vendorMarkers = [];
    VendorController _vendorController = Get.put(VendorController());
    for (var vendor in _vendorController.vendors) {
      vendorMarkers.add(
        Marker(
          markerId: MarkerId('${vendor.latitude}-${vendor.longitude}'),
          position: LatLng(vendor.latitude!, vendor.longitude!),
        ),
      );
    }
    return vendorMarkers;
  }

  @override
  void initState(){
    super.initState();
    _getUserLocation();
    vendorsLocation = createMarkers();
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final TextEditingController _budgetController = TextEditingController();

    final List<Marker> _markers = [];

    var chosenLocation = LatLng(0,0);

    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height20, left: 5, right: 5),
        width: Dimensions.width30*10,
        child: Column(
          children: [
            AppTextFieldv2(textController: _searchController, hintText: "Food/Shop", icon: Icons.fastfood_rounded, backgroundColor: AppColors.mainColor),
            SizedBox(height: Dimensions.height10,),
            AppNumField(textController: _budgetController, hintText: "Budget", icon: Icons.money, backgroundColor: AppColors.mainColor),
            SizedBox(height: Dimensions.height10,),
            Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 2,
                  color: AppColors.mainColor
                )
              ),
              child: Stack(
                children: [
                  StreamBuilder<Position>(
                    stream: _locationStream,
                    builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
                      if (snapshot.hasData) {
                        Position position = snapshot.data!;

                        chosenLocation = LatLng(position.latitude, position.longitude);

                        final marker = Marker(
                          markerId: MarkerId('0'),
                          position: chosenLocation,
                        );

                        _markers.add(marker);
                        for (var vendor in vendorsLocation) {
                          _markers.add(vendor);
                        }
                        return GoogleMap(
                          tiltGesturesEnabled: false,
                          rotateGesturesEnabled: false,
                          markers: _markers.toSet(),
                          mapToolbarEnabled: false,
                          compassEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: chosenLocation,
                              zoom: 17
                          ),
                        );
                      } else {
                        return Center(
                          child: shimmer(width: MediaQuery.of(context).size.width, height: 140, radius: 5,),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height30,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            SmallText(text: 'Cancel', color: Colors.white, size: Dimensions.font16,)
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        if (chosenLocation != LatLng(0,0) && !_searchController.text.isEmpty && !_budgetController.text.isEmpty){
                          Get.offAll(() => SplashScreen(searchString: _searchController.text.trim(), budget: double.parse(_budgetController.text.trim()), position: chosenLocation,));
                        } else {
                          print("Fields are incomplete");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.width10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            SmallText(text: 'Search', color: Colors.white, size: Dimensions.font16,)
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.iconColor1,
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
      // Get.toNamed(RouteHelper.getInitial());
          ],
        )
    );
  }
}
// choice page **************************************






