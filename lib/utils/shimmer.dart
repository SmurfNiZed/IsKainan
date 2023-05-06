import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class shimmer extends StatelessWidget {
  shimmer({Key? key, this.height, this.width, this.radius = 16}) : super(key: key);

  final double? height, width;
  double radius;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black.withOpacity(0.02),
        highlightColor: Colors.black.withOpacity(0.08),
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
        )
    );
  }
}