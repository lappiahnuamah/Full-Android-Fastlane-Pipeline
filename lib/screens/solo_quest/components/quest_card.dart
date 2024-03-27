import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/solo_quest/daily_training/daily_raininng.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';

class QuestCard extends StatelessWidget {
  const QuestCard(
      {super.key,
      required this.quest,
      this.isMultiCard = false,
      this.isDailyTraining = false});
  final QuestModel quest;
  final bool isMultiCard;
  final bool isDailyTraining;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SvgPicture.asset(
          quest.isLocked
              ? AppImages.darkQuestCardSvg
              : isMultiCard
                  ? AppImages.redQuestCardSvg
                  : AppImages.blueQuestCardSvg,
          fit: BoxFit.fill,
          width: double.infinity,
          height: d.pSH(74),
        ),
        Container(
          width: double.infinity,
          padding:
              EdgeInsets.fromLTRB(d.pSW(5), d.pSH(10), d.pSH(10), d.pSH(10)),
          margin: EdgeInsets.only(left: d.pSH(5), right: d.pSW(8)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Opacity(
              opacity: quest.isLocked ? 1 : 0,
              child: SvgPicture.asset(
                AppImages.closedLock,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Color(0xFF717582), BlendMode.srcIn),
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
                  SizedBox(
                    width: d.pSW(25),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                label: quest.name,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isDailyTraining)
                              InkWell(
                                onTap: () {
                                  nextScreen(context, const DailyTraining());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: d.pSH(2), horizontal: d.pSW(4)),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(d.pSH(3)),
                                    border: Border.all(
                                        color: AppColors.borderPrimary,
                                        width: 0.5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.playCategoryIcon,
                                        fit: BoxFit.cover,
                                        height: d.pSH(9),
                                        colorFilter: const ColorFilter.mode(
                                            AppColors.borderPrimary,
                                            BlendMode.srcIn),
                                      ),
                                      SizedBox(width: d.pSW(5)),
                                      const CustomText(
                                        label: 'Start',
                                        color: AppColors.borderPrimary,
                                        fontSize: 10.5,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
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
        ),
      ],
    );
  }
}
