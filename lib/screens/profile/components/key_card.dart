import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/game_key_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/widgets/custom_text.dart';

class KeyCard extends StatelessWidget {
  const KeyCard({super.key, required this.gameKey, this.height = 40});
  final GameKeyModel gameKey;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          gameKey.icon,
          width: d.pSH(height),
          height: d.pSH(height),
        ),
        SizedBox(width: d.pSW(5)),
        gameKey.isLocked
            ? SvgPicture.asset(
                AppImages.closedLock,
                colorFilter: const ColorFilter.mode(
                    AppColors.hintTextBlack, BlendMode.srcIn),
                width: d.pSH(15),
                height: d.pSH(15),
              )
            : CustomText(
                label: gameKey.amount.toString(),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
      ],
    );
  }
}
