import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iskainan/widgets/rectangle_icon_widget.dart';
import 'package:iskainan/widgets/small_text.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../controllers/vendor_controller.dart';
import '../utils/colors.dart';
import '../utils/days_open.dart';
import '../utils/dimensions.dart';
import '../utils/is_new.dart';
import '../utils/shimmer.dart';
import 'app_icon.dart';
import 'big_text.dart';


class AppColumnDetailed extends StatefulWidget {
  final String vendorId;
  AppColumnDetailed({Key? key, required this.vendorId}) : super(key: key);

  @override
  State<AppColumnDetailed> createState() => _AppColumnDetailedState();
}

class _AppColumnDetailedState extends State<AppColumnDetailed> {
  late StreamController<String> _streamController;
  late String startTime;
  late String endTime;

  late List<bool> values;

  Future<String> _getPriceRange() async {
    QuerySnapshot foodSnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.vendorId)
        .collection('foodList')
        .orderBy("food_created", descending: true)
        .get();

    List<double> prices = foodSnapshot.docs.map((doc) {
      return (doc['food_price'] as num).toDouble();
    }).toList();
    return prices.length > 1?"₱"+((prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) + " - ₱" + (prices).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)):"₱"+(prices).reduce((a, b) => a < b ? a : b).toStringAsFixed(2);
  }

  String? _priceRange;

  @override
  void initState(){
    super.initState();

    _getPriceRange().then((value) {
      setState(() {
        _priceRange = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var vendorProfile;
    for(int i = 0; i < Get.find<VendorController>().vendors.length; i++){
      if(Get.find<VendorController>().vendors[i].vendor_id == widget.vendorId){
        vendorProfile = Get.find<VendorController>().vendors[i];
        break;
      }
    }

    late String startTime = '${(vendorProfile.operating_hours![0]~/60)%12}:${((vendorProfile.operating_hours![0]%60)).toString().padLeft(2, '0')} ${(vendorProfile.operating_hours![0]~/60) < 12 ? 'AM' : 'PM'}';
    late String endTime = '${(vendorProfile.operating_hours![1]~/60)%12}:${((vendorProfile.operating_hours![1]%60)).toString().padLeft(2, '0')} ${(vendorProfile.operating_hours![1]~/60) < 12 ? 'AM' : 'PM'}';



    return _priceRange!=null?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigText(text: vendorProfile.vendor_name!, size: Dimensions.font26,),
        SizedBox(height: Dimensions.height10,),
        Row(
          children: [
            SmallText(text: startTime + " - " + endTime, size: Dimensions.font16*0.8, isOneLine: true,),
            SizedBox(width: Dimensions.width10,),
            SmallText(text: vendorProfile.vendor_location!, size: Dimensions.font16*0.8, isOneLine: true,),
          ],
        ),
        SizedBox(height: Dimensions.height10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BigText(text: _priceRange!, size: Dimensions.font16,),
            Row(
              children: [
                RectangleIconWidget(text: "NEW", iconColor: AppColors.isNew, isActivated: isNew(vendorProfile.account_created)?true:false),
                vendorProfile.is_gcash=="true"?SizedBox(width: Dimensions.width10/2,):SizedBox(),
                RectangleIconWidget(text: "GCASH", iconColor: Colors.blueAccent, isActivated: vendorProfile.is_gcash=="true"?true:false)
              ],
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SmallText(text: "Contact Number: ${vendorProfile.phone}"),
            GestureDetector(
              onTap: (){
                AwesomeDialog(
                  dialogType: DialogType.noHeader,
                  body:
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20, bottom: Dimensions.width20, right: Dimensions.width20),
                    child: WeekdaySelector(
                      firstDayOfWeek: 7,
                      selectedFillColor: AppColors.iconColor1,
                      onChanged: (v) {
                      },
                      elevation: 0,
                      selectedElevation: 0,
                      enableFeedback: false,
                      splashColor: Colors.white,
                      selectedSplashColor: AppColors.iconColor1,
                      values: vendorProfile.operating_days,
                    ),
                  ),
                  context: context
                ).show();
              },
              child: SmallText(text: getDayRange(vendorProfile.operating_days)))
          ],
        ),
        vendorProfile.vendor_description==""?SizedBox():
        Column(
          children: [
            SizedBox(height: Dimensions.height10,),
            Text(
              vendorProfile.vendor_description,
              maxLines: 4,
              style: TextStyle(

              ),
            )
          ],
        )
      ],
    ):
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        shimmer(height: Dimensions.font26, width: Dimensions.width30*9,),
        SizedBox(height: Dimensions.height10,),
        Row(
          children: [
            shimmer(height: Dimensions.font16, width: Dimensions.width30*3,),
            SizedBox(width: Dimensions.width10,),
            shimmer(height: Dimensions.font16, width: Dimensions.width30*4,),
          ],
        ),
        SizedBox(height: Dimensions.height10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            shimmer(height: Dimensions.font16, width: Dimensions.width30*4,),
            shimmer(height: Dimensions.font16, width: Dimensions.width30*3,),
          ],
        ),
        SizedBox(height: Dimensions.height10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            shimmer(height: Dimensions.font16, width: Dimensions.width30*6,),
            shimmer(height: Dimensions.font16, width: Dimensions.width30*2,),
          ],
        ),
        SizedBox(height: Dimensions.height10,),
        shimmer(height: Dimensions.font16,),
      ],
    );
  }
}

