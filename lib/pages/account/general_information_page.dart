import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iskainan/controllers/profile_controller.dart';
import 'package:iskainan/widgets/AppNumField.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../../base/show_custom_snackbar.dart';
import '../../models/vendor_data_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/AppTextFieldLong.dart';
import '../../widgets/AppTextFieldv2.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class GeneralInformationPage extends StatefulWidget {
  const GeneralInformationPage({Key? key}) : super(key: key);

  @override
  State<GeneralInformationPage> createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage> {
  late bool? _checkBoxGCash = false;
  late bool? _checkBoxOpen = false;
  late bool? _isApproved;

  late StreamController<String> _streamController;
  late String startTime;
  late String endTime;

  late List<bool> values;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    Future<void> _updateGeneralInformation(
        TextEditingController vendorNameController,
        TextEditingController phoneController,
        TextEditingController vendorDescriptionController,
        bool isGcash,
        bool isOpen,
        List<int> operatingHours,
        List<bool> operatingDays,
        String? id) async {

      String vendorName = vendorNameController.text.trim();
      String phone = phoneController.text.trim();
      String vendorDescription = vendorDescriptionController.text.trim();

      if (vendorName.isEmpty) {
        showCustomerSnackBar("Type in the name of your establishment.",
            title: "Name");
      } else if (phone.isEmpty) {
        showCustomerSnackBar("Type in your phone number.",
            title: "Phone Number");
      } else {
        try {
          FirebaseFirestore.instance.collection('vendors').doc(id).update({
            'vendor_name': vendorName,
            'phone': phone,
            'is_gcash': (isGcash ? "true" : "false"),
            'is_open': (isOpen ? "true" : "false"),
            'operating_hours': operatingHours,
            'operating_days': operatingDays,
            'vendor_description': vendorDescription,
          }).whenComplete(() => AwesomeDialog(
            context: context,
            title: "All Set!",
            titleTextStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.bold
            ),
            desc: "Information updated.",
            descTextStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.normal
            ),
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            autoDismiss: true,
            autoHide: Duration(seconds: 3),
          ).show());
        } catch (e) {
          showCustomerSnackBar(e.toString());
        }
      }
    }

    return FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            VendorData user = snapshot.data as VendorData;
            _streamController = StreamController<String>.broadcast();
            startTime = '${(user.operating_hours![0]~/60)%12}:${((user.operating_hours![0]%60)).toString().padLeft(2, '0')} ${(user.operating_hours![0]~/60) < 12 ? 'AM' : 'PM'}';
            endTime = '${(user.operating_hours![1]~/60)%12}:${((user.operating_hours![1]%60)).toString().padLeft(2, '0')} ${(user.operating_hours![1]~/60) < 12 ? 'AM' : 'PM'}';
            String op_hours = startTime + " - " + endTime;
            values = user.operating_days!;

            _checkBoxGCash = user.is_gcash == "true" ? true : false;
            _checkBoxOpen = user.is_open == "true" ? true : false;
            _isApproved = user.approved == "true"? true: false;
            late TextEditingController vendorNameController =
            TextEditingController(text: user.vendor_name.toString());
            late TextEditingController phoneController =
            TextEditingController(text: user.phone.toString());
            late TextEditingController vendorDescriptionController =
            TextEditingController(text: user.vendor_description.toString());
            return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.mainColor,
                  title: Text('Manage General Information',),
                  titleTextStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: Dimensions.font26*1,
                      fontWeight: FontWeight.bold
                  ),
                ),
                body: Stack(
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          // Can be scrolled if we add more options
                          Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: Dimensions.height30*3),
                                    AppIcon(
                                        icon: Icons.settings,
                                        backgroundColor: AppColors.iconColor1,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height30 + Dimensions.height45,
                                        size: Dimensions.height15 * 10),
                                    SizedBox(height: Dimensions.height45),

                                    Container(

                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  spreadRadius: 7,
                                                  offset: Offset(1, 10),
                                                  color: Colors.grey.withOpacity(0.2)
                                              )
                                            ]
                                        ),
                                        child: AppTextFieldv2(
                                          textController: vendorNameController,
                                          hintText: "Name of Establishment",
                                          icon: Icons.food_bank_rounded,
                                          backgroundColor: AppColors.iconColor1,
                                        )
                                    ),

                                    SizedBox(height: Dimensions.height20),

                                    // Contact Number
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 7,
                                                offset: Offset(1, 10),
                                                color: Colors.grey.withOpacity(0.2)
                                            )
                                          ]
                                      ),
                                      child: AppNumField(
                                        textController: phoneController,
                                        hintText: "Contact Number",
                                        icon: Icons.phone,
                                        backgroundColor: AppColors.iconColor1,
                                      ),
                                    ),

                                    SizedBox(height: Dimensions.height20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: StatefulBuilder(
                                            builder: (context, _setState) => GestureDetector(
                                              onTap: () {
                                                _setState(() {
                                                  _checkBoxGCash = !_checkBoxGCash!;
                                                });
                                              },
                                              child: Container(
                                                height: Dimensions.height45,
                                                margin: EdgeInsets.only(left: Dimensions.height10, right: Dimensions.height10/2),
                                                decoration: BoxDecoration(
                                                  color: _checkBoxGCash!? Colors.blueAccent : Colors.grey[100],
                                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                                ),
                                                child: Center(child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SmallText(text: "Gcash", size: Dimensions.font16, color: _checkBoxGCash!? Colors.white:Colors.black,),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: StatefulBuilder(
                                            builder: (context, _setState) => GestureDetector(
                                              onTap: () {
                                                _setState(() {
                                                  _checkBoxOpen =  !_checkBoxOpen!;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                                height: Dimensions.height45,
                                                margin: EdgeInsets.only(left: Dimensions.height10/2, right: Dimensions.height10),
                                                decoration: BoxDecoration(
                                                  color: _checkBoxOpen!? AppColors.iconColor1 : Colors.grey[100],
                                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                                ),
                                                child: Center(child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: Dimensions.height10,),
                                                    SmallText(text: "Open", size: Dimensions.font16, color: _checkBoxOpen!? Colors.white:Colors.black,),
                                                    GestureDetector(
                                                      onTap: (){
                                                        AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType.question,
                                                          animType: AnimType.topSlide,
                                                          showCloseIcon: true,
                                                          dismissOnTouchOutside: true,
                                                          dismissOnBackKeyPress: true,
                                                          body: Container(
                                                            padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Your shop will close automatically once it's past your selected operating hours. Only use this option if you plan to stop operating for some time.",
                                                                  textAlign: TextAlign.justify,
                                                                  style: TextStyle(
                                                                      height: 1.5,
                                                                      fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey
                                                                  ),
                                                                ),
                                                                SizedBox(height: Dimensions.height10,),
                                                                Text(
                                                                  "- Maintenance\n- Day-offs\n- Holidays",
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                      height: 1.5,
                                                                      fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ).show();
                                                      },
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                          Icons.question_mark,
                                                          size: 15,
                                                          color: _checkBoxOpen!?AppColors.iconColor1:Colors.grey[100],
                                                        ),
                                                        radius: Dimensions.width10,
                                                        backgroundColor: _checkBoxOpen!?Colors.grey[100]:AppColors.iconColor1,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ),)
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height20),

                                    GestureDetector(
                                      onTap: () async {
                                        TimeRange result = await showTimeRangePicker(
                                            context: context,
                                            start: TimeOfDay(hour: user.operating_hours![0]~/60, minute: user.operating_hours![0]%60),
                                            clockRotation: 180,
                                            end: TimeOfDay(hour: user.operating_hours![1]~/60, minute: user.operating_hours![1]%60),
                                            fromText: "Open",
                                            toText: "Closed",
                                            strokeColor: AppColors.mainColor,
                                            handlerColor: AppColors.mainColor,
                                            use24HourFormat: false,
                                            selectedColor: AppColors.mainColor,
                                            ticks: 24,
                                            snap: true,
                                            interval: Duration(minutes: 30),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                    textButtonTheme: TextButtonThemeData(
                                                        style: TextButton.styleFrom(
                                                            foregroundColor: AppColors.mainColor
                                                        )
                                                    )
                                                ),
                                                child: child!,
                                              );
                                            });

                                        user.operating_hours![0] = (result.startTime.hour * 60) + result.startTime.minute;
                                        user.operating_hours![1] = (result.endTime.hour * 60) + result.endTime.minute;

                                        startTime = '${result.startTime.hour%12==0?12:result.startTime.hour%12}:${(result.startTime.minute).toString().padLeft(2, '0')} ${result.startTime.hour < 12 ? 'AM' : 'PM'}';
                                        endTime = '${result.endTime.hour%12==0?12:result.endTime.hour%12}:${(result.endTime.minute).toString().padLeft(2, '0')} ${result.endTime.hour < 12 ? 'AM' : 'PM'}';
                                        op_hours = startTime + " - " + endTime;
                                        _streamController.sink.add(op_hours);
                                        // });

                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                        margin: EdgeInsets.only(left: Dimensions.height10, right: Dimensions.height10),
                                        height: 50,
                                        width: Dimensions.screenWidth,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  spreadRadius: 7,
                                                  offset: Offset(1, 10),
                                                  color: Colors.grey.withOpacity(0.2)
                                              )
                                            ]
                                        ),
                                        child: StreamBuilder<String>(
                                          stream: _streamController.stream,
                                          initialData: op_hours,
                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.timer, color: AppColors.iconColor1,),
                                                    SizedBox(width: Dimensions.width10,),
                                                    Text("Operating Hours: ${snapshot.data}", maxLines: 1, overflow: TextOverflow.ellipsis),
                                                  ],
                                                ),
                                                Icon(Icons.edit, color: AppColors.iconColor1,),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20),
                                    StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.width10),
                                          height: Dimensions.height20*5,
                                          margin: EdgeInsets.only(left: Dimensions.height10/2, right: Dimensions.height10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(Dimensions.radius30),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 7,
                                                    offset: Offset(1, 10),
                                                    color: Colors.grey.withOpacity(0.2)
                                                )
                                              ]
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today, size: Dimensions.height20, color: AppColors.iconColor1,),
                                                  SizedBox(width: Dimensions.width10,),
                                                  SmallText(text: "Operating Days", size: Dimensions.font16,),
                                                ],
                                              ),
                                              WeekdaySelector(
                                                firstDayOfWeek: 7,
                                                selectedFillColor: AppColors.iconColor1,
                                                onChanged: (v) {
                                                  setState(() {
                                                    values[v % 7] = !values[v % 7]!;
                                                  });
                                                },
                                                values: values,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: Dimensions.height20),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  spreadRadius: 7,
                                                  offset: Offset(1, 10),
                                                  color: Colors.grey.withOpacity(0.2)
                                              )
                                            ]
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: Dimensions.height10),
                                        child: AppTextFieldLong(vendorDescriptionController: vendorDescriptionController)),
                                    SizedBox(height: Dimensions.height20),
                                    RichText(text: TextSpan(
                                      text: "This vendor is ",
                                      style:
                                      TextStyle(
                                        color: Colors.grey,
                                        fontSize: Dimensions.font16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _isApproved!?"verified":"unverified",
                                          style: TextStyle(
                                            color: _isApproved!?AppColors.iconColor1:AppColors.mainColor,
                                            fontSize: Dimensions.font16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap=()=>AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.question,
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            dismissOnTouchOutside: true,
                                            dismissOnBackKeyPress: true,
                                            body: Container(
                                              padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "At IsKainan, we prioritize authenticity and safety for our customers. To ensure this, we carefully verify all vendor accounts, which may take some time. Only verified accounts can be seen publicly. To speed up the process, start setting up your menu, location, and general information!",
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        height: 1.5,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                  SizedBox(height: Dimensions.height10,),
                                                  Text(
                                                    "During the verification process, we review the accuracy of the information you've provided and confirm that you are a legitimate vendor around the campus community. This helps us maintain a trusted marketplace for everyone involved. Thank you for your patience and understanding.",
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        height: 1.5,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ).show(),
                                        ),
                                      ],
                                    ),
                                    ),
                                    SizedBox(height: Dimensions.height30),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                                      child: Divider(
                                        height: 1, // Set the height of the divider
                                        color: Colors.grey, // Set the color of the divider
                                        thickness: 1, // Set the thickness of the divider
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height30),
                                    GestureDetector(
                                      onTap: () {
                                        _updateGeneralInformation(
                                            vendorNameController,
                                            phoneController,
                                            vendorDescriptionController,
                                            _checkBoxGCash!,
                                            _checkBoxOpen!,
                                            user.operating_hours!,
                                            user.operating_days!,
                                            user.vendor_id);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                                        height: 50,
                                        width: Dimensions.screenWidth,
                                        decoration: BoxDecoration(
                                            color: Colors.lightGreen[400],
                                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  spreadRadius: 7,
                                                  offset: Offset(1, 10),
                                                  color: Colors.grey.withOpacity(0.2)
                                              )
                                            ]
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            BigText(text: "Save Changes", color: Colors.white,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height45),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),

                  ],
                ));
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    )));
          }
        });
  }
}