import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key, required this.level});
  final LevelModel level;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, layout) {
      return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Container(
              width: layout.maxWidth * level.progress,
              height: layout.maxHeight,
              color: level.color,
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: level.active
                      ? AppColors.hintTextBlack
                      : AppColors.notSelectedColor,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (level.isLocked)
                      SvgPicture.asset(
                        AppImages.closedLock,
                        colorFilter: const ColorFilter.mode(
                            AppColors.hintTextBlack, BlendMode.srcIn),
                        height: d.pSH(10),
                      ),
                    if (level.isLocked) SizedBox(width: d.pSW(5)),
                    CustomText(
                      label: level.name,
                      fontSize: getFontSize(12, size),
                      fontWeight: FontWeight.w400,
                      color: level.active
                          ? AppColors.hintTextBlack
                          : AppColors.notSelectedColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
