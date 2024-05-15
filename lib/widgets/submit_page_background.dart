import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_images.dart';

class SubmitPageBackground extends StatelessWidget {
  const SubmitPageBackground({super.key, required this.icon});
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
                Color(0xFFF2E5FF),
                Color(0xFFDEFEFC),
                Color(0xFFF2E5FF),
              ], transform: GradientRotation(-168)),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(6, (index) => Container(
              margin: EdgeInsets.symmetric(vertical: d.pSH(30)),
              child: SvgPicture.asset(AppImages.brainSvg,)) ).toList() 
              
            
          ),
        ),
      ],
    );
  }
}
