import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/widgets/custom_text.dart';

class GameHintDialog extends StatelessWidget {
  const GameHintDialog({super.key, required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.hintKey,
            height: d.pSH(33),
          ).animate()
            ..shimmer(duration: 1000.ms)
            ..scale(duration: 1000.ms),
          SizedBox(width: d.pSH(20)),
          const CustomText(
            label: 'Hint To Question',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.caveat,
          ),
        ],
      ),
      SizedBox(height: d.pSH(20)),
      CustomText(
        label: hint,
        fontSize: 22,
        color: AppColors.textBlack,
        fontWeight: FontWeight.w700,
        fontFamily: AppFonts.caveat,
        letterSpacing: 1.2,
      ),
      SizedBox(height: d.pSH(20)),
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.everGreen,
              foregroundColor: Colors.white),
          child: const CustomText(
              label: 'Okay',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.caveat,
              color: Colors.white))
    ]);
  }
}
