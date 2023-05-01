import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppNumField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final Color backgroundColor;
  bool? isPassword;
  AppNumField({Key? key,

    required this.textController,
    required this.hintText,
    required this.icon,
    required this.backgroundColor,
    this.isPassword = false}) : super(key: key);

  @override
  State<AppNumField> createState() => _AppNumFieldState();
}

class _AppNumFieldState extends State<AppNumField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height10, right: Dimensions.height10),
        decoration: BoxDecoration(
          color: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: (widget.isPassword! && _obscureText),
          cursorColor: AppColors.mainColor,
          controller: widget.textController,
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
                      color: AppColors.iconColor1
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.grey[100]!
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