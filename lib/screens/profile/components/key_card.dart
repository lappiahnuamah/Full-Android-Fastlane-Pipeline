import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/game_key_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class KeyCard extends StatelessWidget {
  const KeyCard({super.key, required this.gameKey});
  final GameKeyModel gameKey;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          gameKey.icon,
          width: d.pSH(45),
          height: d.pSH(45),
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
                fontSize: getFontSize(20, size),
                fontWeight: FontWeight.w500,
              ),
      ],
    );
  }
}
