import 'package:flutter/cupertino.dart';
import 'package:iskainan/widgets/small_text.dart';

import '../utils/dimensions.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  IconAndTextWidget({Key? key,
    required this.icon,
    required this.text,
    required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: Dimensions.iconSize16),
        SizedBox(width: Dimensions.width10/2,),
        SmallText(text: text),
      ],
    );
  }
}
