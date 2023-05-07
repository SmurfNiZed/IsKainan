import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppPhoneField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final Color backgroundColor;
  bool? isPassword;
  AppPhoneField({Key? key,

    required this.textController,
    required this.hintText,
    required this.icon,
    required this.backgroundColor,
    this.isPassword = false}) : super(key: key);

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  bool _obscureText = true;

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
          keyboardType: TextInputType.phone,
          controller: widget.textController,
          obscureText: (widget.isPassword! && _obscureText),
          decoration: InputDecoration(
            suffixIcon: widget.isPassword!?IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off:Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: (){
                setState((){
                  _obscureText = !_obscureText;
                });
              },
            ):SizedBox(),
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
          ),
        )
    );
  }
}