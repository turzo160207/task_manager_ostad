import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsPath.backgroundSvg,
          fit: BoxFit.cover,
          height: screenSize.height,
          width: screenSize.width,
        ),
        SafeArea(child: child),
      ],
    );
  }
}