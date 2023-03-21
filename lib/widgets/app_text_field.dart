import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final Color backgroundColor;
  AppTextField({Key? key,

  required this.textController,
  required this.hintText,
  required this.icon,
  required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
        decoration: BoxDecoration(
            color: Colors.white,
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
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, color: backgroundColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.white
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.white
                  )
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              )
          ),
        )
    );
  }
}

class AppTextFieldTime extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final Color backgroundColor;

  AppTextFieldTime({Key? key,
    required this.textController,
    required this.hintText,
    required this.icon,
    required this.backgroundColor}) : super(key: key);

  @override
  State<AppTextFieldTime> createState() => _AppTextFieldTimeState();
}

class _AppTextFieldTimeState extends State<AppTextFieldTime> {
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
        decoration: BoxDecoration(
            color: Colors.white,
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
        child: TextField(
          controller: widget.textController,
          decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Icon(widget.icon, color: widget.backgroundColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.white
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.white
                  )
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  // Start Time
                   await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      helpText: "Set Opening Time",
                  ).then((value) => {
                    setState(() {
                      startTime = value!;
                    })
                  });

                  // End Time
                  await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      helpText: "Set Closing Time",
                  ).then((value) => {
                    setState(() {
                      endTime = value!;
                    })
                  });

                  widget.textController.text = "${startTime.format(context).toString()} to ${endTime.format(context).toString()}";
                },
                icon: Icon(Icons.update, color:widget.backgroundColor),
              ),
          ),
        )
    );
  }
}