import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key, required this.level, required this.totalPoints});
  final LevelModel level;
  final num totalPoints;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: d.pSH(23),
        width: d.pSH(90),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(builder: (context, layout) {
          final colorWidth = totalPoints > level.upperboundary
              ? layout.maxWidth
              : totalPoints < level.lowerboundary
                  ? 0
                  : ((totalPoints - level.lowerboundary) /
                          level.upperboundary) *
                      layout.maxWidth;

          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: colorWidth.toDouble(),
                height: layout.maxHeight,
                color: level.color,
              ),
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: level.isCurrentLevel
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
                        label: level.name.name.capitalize(),
                        fontSize: getFontSize(12, size),
                        fontWeight: FontWeight.w400,
                        color: level.isCurrentLevel
                            ? AppColors.hintTextBlack
                            : AppColors.notSelectedColor,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }
}
