import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class RetakeKeyDisplay extends StatefulWidget {
  const RetakeKeyDisplay({super.key, required this.onRetakeTapped});
  final Function() onRetakeTapped;

  @override
  State<RetakeKeyDisplay> createState() => _RetakeKeyDisplayState();
}

class _RetakeKeyDisplayState extends State<RetakeKeyDisplay> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GameItemsProvider>(
        builder: (context, gameItemsProvider, chikd) {
      return Container(
        padding:
            EdgeInsets.symmetric(horizontal: d.pSH(16), vertical: d.pSH(40)),
        child: Column(
          children: [
            CustomText(
              label: 'You answered incorrectly!',
              fontSize: getFontSize(38, size),
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.caveat,
              color: AppColors.kGameRed,
            ),
            SizedBox(height: d.pSH(10)),
            CustomText(
              label: 'You have a chance to retake the question',
              fontSize: getFontSize(30, size),
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.caveat,
              textAlign: TextAlign.center,
              color: Colors.white,
            ),
            SizedBox(height: d.pSH(40)),
            Stack(
              children: [
                SvgPicture.asset(
                  AppImages.retakeKey,
                  height: d.pSH(100),
                ).animate()
                  ..shimmer(duration: 1000.ms)
                  ..shakeX(duration: 1000.ms),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: d.pSH(20),
                    child: CustomText(
                      label: (gameItemsProvider
                                  .userKeys[GameKeyType.retakeKey]?.amount ??
                              0)
                          .toString(),
                      color: AppColors.kPrimaryColor,
                      fontSize: getFontSize(24, size),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: d.pSH(50)),
            InkWell(
              onTap: widget.onRetakeTapped,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: d.pSH(5), horizontal: d.pSW(12)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(d.pSH(22)),
                  border: Border.all(color: AppColors.everGreen, width: 1),
                ),
                child: CustomText(
                  label: 'Retake Question',
                  fontSize: getFontSize(24, size),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.caveat,
                  color: AppColors.everGreen,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
