import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/solo_quest/components/quest_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class SoloQuest extends StatefulWidget {
  const SoloQuest({super.key});

  @override
  State<SoloQuest> createState() => _SoloQuestState();
}

class _SoloQuestState extends State<SoloQuest> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(d.pSH(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(
          label: 'Single Player',
          fontWeight: FontWeight.w700,
          fontSize: getFontSize(24, size),
        ),
        SizedBox(height: d.pSH(16)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      label: 'Daily',
                      fontWeight: FontWeight.w500,
                      color: AppColors.hintTextBlack,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomText(
                          label: '100',
                          fontWeight: FontWeight.w500,
                          color: AppColors.hintTextBlack,
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset("assets/icons/flame.svg")
                      ],
                    )
                  ],
                ),
                SizedBox(height: d.pSH(16)),
                const QuestCard(
                  quest: QuestModel(
                      id: 1,
                      name: 'Learner Mode',
                      description:
                          'Feel free to not know but give yourself a chance',
                      icon: "assets/icons/learner.svg",
                      isLocked: false),
                ),
                SizedBox(height: d.pSH(16)),
                const CustomText(
                  label: 'All Solo Quests',
                  fontWeight: FontWeight.w500,
                  color: AppColors.hintTextBlack,
                ),
                SizedBox(height: d.pSH(16)),
                ...List.generate(
                  6,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: d.pSH(10)),
                    child: QuestCard(
                      quest: QuestModel(
                          id: 1,
                          name: 'Learner Mode',
                          description:
                              'Feel free to not know but give yourself a chance',
                          icon: "assets/icons/learner.svg",
                          isLocked: index.isEven),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
