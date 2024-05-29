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
  const LevelCard(
      {super.key,
      required this.level,
      required this.totalPoints,
      this.animationDuration = 2500, 
      this.pointsScored = 0});
  final LevelModel level;
  final num totalPoints;
  final num pointsScored;

  final int animationDuration;
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

          final colorWidthMinusIncrease = totalPoints > level.upperboundary
              ? layout.maxWidth
              : totalPoints < level.lowerboundary
                  ? 0
                  : ((totalPoints -
                              (pointsScored > 0 ? pointsScored : 0) -
                              level.lowerboundary) /
                          level.upperboundary) *
                      layout.maxWidth;

          return Stack(
            children: [
              if (pointsScored > 0)
                AnimatedContainer(
                  duration:  Duration(milliseconds: animationDuration),
                  width: colorWidth.toDouble(),
                  height: layout.maxHeight,
                  color: Colors.yellow[700],
                ),
              AnimatedContainer(
                duration:  Duration(milliseconds: animationDuration),
                width: colorWidthMinusIncrease.toDouble(),
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
