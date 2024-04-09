import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';

class GamePageBackground extends StatelessWidget {
  const GamePageBackground({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Icons
        Positioned(
          top: -d.pSH(90),
          left: -d.pSH(90),
          child: Opacity(
            opacity: 0.5,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(135 / 360),
              child: SvgPicture.network(
                icon,
                height: d.pSH(400),
                colorFilter:
                    const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
            ),
          ),
        ),

        Positioned(
          top: d.pSH(379),
          left: d.pSH(198),
          child: Opacity(
            opacity: 0.5,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(315 / 360),
              child: SvgPicture.network(
                icon,
                height: d.pSH(180),
                colorFilter:
                    const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: d.pSH(0),
          left: -d.pSH(30),
          child: Opacity(
            opacity: 0.5,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(25 / 360),
              child: SvgPicture.network(
                icon,
                height: d.pSH(210),
                colorFilter:
                    const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        //Background Design
        Opacity(
          opacity: 0.85,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFDEFEFC),
                Color(0xFFF2E5FF),
              ], transform: GradientRotation(-168)),
            ),
          ),
        ),
      ],
    );
  }
}
