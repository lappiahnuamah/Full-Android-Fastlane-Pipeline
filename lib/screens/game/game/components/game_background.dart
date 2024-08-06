import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/resources/app_images.dart';

class GameBackground extends StatelessWidget {
  const GameBackground(
      {super.key,
      this.leftPosition,
      this.rightPosition,
      this.backgroundGradient});
  final double? leftPosition;
  final double? rightPosition;
  final Gradient? backgroundGradient;

  @override
  Widget build(BuildContext context) {
    final bright = Theme.of(context).brightness;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          left: leftPosition,
          right: rightPosition,
          child: SafeArea(
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                AppImages.gameBackgroundSvg,
                height: size.height * 0.87,
                fit: BoxFit.fitHeight,
                colorFilter: bright == Brightness.dark
                    ? const ColorFilter.mode(
                        Color.fromARGB(70, 24, 22, 22), BlendMode.srcIn)
                    : null,
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.8,
          child: Container(
            width: double.infinity,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: backgroundGradient ??
                  LinearGradient(
                    begin: Alignment(-1.0, -0.5),
                    end: Alignment(1.0, 0.5),
                    colors: [
                      Color(0xFFDEFEFC),
                      Color(0xFFF2E5FF),
                    ],
                    stops: [-0.0884, 1.0],
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
