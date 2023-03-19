import 'package:flutter/cupertino.dart';

import '../utils/dimensions.dart';

class CircleImage extends StatelessWidget {
  final String imgUrl;
  final Color backgroundColor;
  final double size;

  CircleImage({Key? key,
    required this.imgUrl,
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size/2),
            color: backgroundColor,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imgUrl)),
        ),
    );
  }
}
