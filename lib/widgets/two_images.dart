import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';

class TwoImages extends StatelessWidget {
  const TwoImages({super.key, required this.back, required this.front});
  final String front;
  final String back;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -d.pSH(5),
            child: SvgPicture.asset(
              back,
              width: 32,
              height: 32,
            ),
          ),
          Positioned(
            bottom: -d.pSH(5),
            child: SvgPicture.asset(
              front,
              width: 32,
              height: 32,
            ),
          )
        ],
      ),
    );
  }
}
