import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({super.key, required this.quest, this.isMultiCard = false});
  final QuestModel quest;
  final bool isMultiCard;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateX(0.4)
              ..rotateY(0.05),
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: EdgeInsets.fromLTRB(
                  d.pSW(5), d.pSH(10), d.pSH(10), d.pSH(10)),
              margin: EdgeInsets.only(left: d.pSH(5), right: d.pSW(8)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(d.pSH(5)),
                border: Border.all(
                  color: quest.isLocked
                      ? const Color(0xFF717582)
                      : isMultiCard
                          ? AppColors.borderAccent
                          : AppColors.borderPrimary,
                ),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Opacity(
                  opacity: quest.isLocked ? 1 : 0,
                  child: SvgPicture.asset(
                    AppImages.closedLock,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF717582), BlendMode.srcIn),
                  ),
                ),
                SizedBox(
                  width: d.pSW(7),
                ),
                //card
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        height: d.pSH(55),
                        width: d.pSH(55),
                      ),
                      SizedBox(
                        width: d.pSW(25),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              label: quest.name,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: d.pSH(5)),
                            CustomText(
                              label: quest.description,
                              fontWeight: FontWeight.w300,
                              fontSize: getFontSize(12, size),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            )),

        //
        Positioned(
          top: d.pSH(10),
          left: d.pSW(26),
          child: SizedBox(
            height: d.pSH(51),
            width: d.pSH(59),
            child: Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/quest_icon_container.svg",
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    quest.isLocked
                        ? const Color(0xFF717582)
                        : isMultiCard
                            ? AppColors.borderAccent
                            : AppColors.borderPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                Align(
                  child: SvgPicture.asset(quest.icon),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
