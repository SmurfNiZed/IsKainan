import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/widgets/AppNumField.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import 'package:iskainan/widgets/small_text.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppTextFieldv2.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../splash/splash_page.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({Key? key}) : super(key: key);

  Future<LatLng> _getUserLocation() async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } else {
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }
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
        width: 300,
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
                  FutureBuilder(
                    future: _getUserLocation(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.mainColor,
                          )
                        );
                      } else {

                        chosenLocation = snapshot.data!;

                        final marker = Marker(
                          markerId: MarkerId('0'),
                          position: snapshot.data!,
                        );

                        _markers.add(marker);

                        return GoogleMap(
                          tiltGesturesEnabled: false,
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          markers: _markers.toSet(),
                          mapToolbarEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: snapshot.data!,
                              zoom: 17
                          ),
                        );
                      }
                    },
                  )
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






