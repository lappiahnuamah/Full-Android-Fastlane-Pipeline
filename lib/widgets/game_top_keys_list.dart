import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';

import '../resources/app_images.dart';

class GameTopKeysList extends StatelessWidget {
  const GameTopKeysList(
      {super.key,
      required this.showHint,
      required this.showMysteryBox,
      required this.showTimesTwo,
      required this.onHintPressed,
      required this.onMysteryBoxPressed,
      required this.onTimesTwoPressed});
  final bool showHint;
  final bool showMysteryBox;
  final bool showTimesTwo;
  final VoidCallback onHintPressed;
  final VoidCallback onMysteryBoxPressed;
  final VoidCallback onTimesTwoPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Consumer<GameItemsProvider>(
          builder: (context, gameItemsProvider, chikd) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showHint)
              InkWell(
                  onTap: onHintPressed,
                  child: SvgPicture.asset(
                    AppImages.hintKey,
                    height: d.pSH(d.isTablet ? 43 : 33),
                  )).animate()
                ..shimmer(duration: 700.ms)
                ..scale(duration: 700.ms),
            SizedBox(height: d.pSH(10)),
            if ((showMysteryBox || showTimesTwo) && showHint)
              SizedBox(width: d.pSH(d.isTablet ? 40 : 34)),
            if (showMysteryBox)
              InkWell(
                  onTap: onMysteryBoxPressed,
                  child: SvgPicture.asset(
                    AppImages.mysteryBox,
                    height: d.pSH(d.isTablet ? 53 : 43),
                  )).animate()
                ..shimmer(duration: 1000.ms)
                ..moveY(duration: 1000.ms),
            SizedBox(height: d.pSH(10)),
            if (showMysteryBox && showTimesTwo)
              SizedBox(width: d.pSH(d.isTablet ? 35 : 30)),
            if (showTimesTwo)
              InkWell(
                  onTap: onTimesTwoPressed,
                  child: SvgPicture.asset(
                    AppImages.doublePoints,
                    height: d.pSH(d.isTablet ? 43 : 33),
                  )).animate()
                ..shimmer(duration: 1000.ms)
                ..shakeY(duration: 1000.ms),
            SizedBox(height: d.pSH(10))
          ],
        );
      }),
    );
  }
}
