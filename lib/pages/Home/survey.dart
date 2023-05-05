import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskainan/widgets/AppNumField.dart';
import 'package:iskainan/widgets/app_text_field.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppTextFieldv2.dart';
import '../../widgets/small_text.dart';

// choice page **************************************
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
                        final marker = Marker(
                          markerId: MarkerId('0'),
                          position: snapshot.data!,
                        );

                        _markers.add(marker);

                        return GoogleMap(
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
            )
          ],
        )
    );
  }
}
// choice page **************************************






