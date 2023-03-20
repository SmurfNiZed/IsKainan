import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class CircleImage extends StatefulWidget {
  final String imgUrl;
  final Color backgroundColor;
  final double size;

  CircleImage({Key? key,
    required this.imgUrl,
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.size = 40}) : super(key: key);

  @override
  State<CircleImage> createState() => _CircleImageState();
}

class _CircleImageState extends State<CircleImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size/2),
          color: widget.backgroundColor,
        ),
        child: CachedNetworkImage(
          imageUrl: widget.imgUrl,
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            size: widget.size/2,
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size/2),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
        // CachedNetworkImage(
        //   imageUrl: widget.imgUrl,
        //   placeholder: (context, url) => Container(
        //     width: widget.size/2,
        //     height: widget.size/2,
        //     child: const CircularProgressIndicator(
        //       color: Colors.white,
        //     ),
        //   ),
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        // ),
        // child:  Image.network(
        //  widget.imgUrl,
        //   fit: BoxFit.cover,
        //   loadingBuilder: (BuildContext context, Widget child,
        //       ImageChunkEvent? loadingProgress) {
        //     if (loadingProgress == null) return child;
        //     return const Center(
        //       child: CircularProgressIndicator(
        //         color: Colors.white,
        //       ),
        //     );
        //   },
        // ),
    );
  }
}

// image: DecorationImage(
// fit: BoxFit.cover,
// image: NetworkImage(imgUrl)),
// ),