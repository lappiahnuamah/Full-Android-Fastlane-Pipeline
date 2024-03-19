import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/resources/app_images.dart';

class GameBackground extends StatelessWidget {
  const GameBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final bright = Theme.of(context).brightness;
    return Stack(
      children: [
        SvgPicture.asset(
          AppImages.gameBackgroundSvg,
          colorFilter: bright == Brightness.dark
              ? const ColorFilter.mode(
                  Color.fromARGB(70, 24, 22, 22), BlendMode.srcIn)
              : null,
        ),
        Opacity(
          opacity: 0.65,
          child: Container(
            width: double.infinity,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bright == Brightness.dark
                    ? [
                        const Color(0xFF2E2E2E).withOpacity(0),
                        const Color(0xFF2E2E2E),
                      ]
                    : [
                        // 313.54% 70.71% at 50% 50%,
                        const Color(0xFFEEDCFF), //100%)
                        const Color(0xFFD9FFFD), //0%,
                        const Color(0xFFDEF9FB), //41.15%,
                        const Color(0xFFEEDCFF) //100%)

                        ////
                        ///linear-gradient
                        ///(0deg, var(--dark_overlay, #2E2E2E) 0%, var(--dark_overlay, #2E2E2E) 100%),
                        ///radial-gradient(313.54% 70.71% at 50% 50%, #D9FFFD 0%, #DEF9FB 41.15%, #FFDCED 100%)
                      ],
              ),
            ),
          ),
        ),
        // if (bright == Brightness.dark)
        //   Opacity(
        //     opacity: .1,
        //     child: Container(
        //       width: double.infinity,
        //       height: double.maxFinite,
        //       decoration: BoxDecoration(
        //         gradient: RadialGradient(
        //           colors: [
        //             // 313.54% 70.71% at 50% 50%,3
        //             const Color(0xFFD9FFFD).withOpacity(0), //100%)
        //             const Color(0xFFDEF9FB).withOpacity(0.41), //0%,
        //             const Color(0xFFFFDCED),
        //             const Color(0xFF2E2E2E).withOpacity(0),
        //             //41.15%,

        //             ///radial-gradient(313.54% 70.71% at 50% 50%, #D9FFFD 0%, #DEF9FB 41.15%, #FFDCED 100%)
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
