import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/animations/bouncing_animation.dart';
import 'package:savyminds/constants.dart';

class SubmitPageBackground extends StatelessWidget {
  const SubmitPageBackground(
      {super.key, required this.icon, required this.gameIcon});
  final String icon;
  final String gameIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -d.pSH(5),
          bottom: -d.pSH(60),
          left: 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (index) => SvgPicture.network(
                  gameIcon,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF525252), BlendMode.srcIn),
                  height: d.pSH(70),
                ),
              ).toList()),
        ),

//Bouncing
        Positioned(
          top: d.pSH(190),
          right: -40,
          child: Opacity(
            opacity: 0.8,
            child: BouncingAnimation(
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(135 / 360),
                child: SvgPicture.network(
                  icon,
                  height: d.pSH(150),
                  colorFilter:
                      const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),

        //Background Design
        Opacity(
          opacity: 0.9,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, 0.0), // Equivalent to 50% 50%
                radius: 1.3, // 313.54% ,
                colors: [
                  Color(0xFFD9FFFD),
                  Color(0xFFDEF9FB),
                  Color(0xFFEEDCFF),
                ],
                stops: [
                  0.0, // 0%
                  0.275, // 27.5%
                  1, // 100%
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
