import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/solo_quest/components/quest_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Contest extends StatefulWidget {
  const Contest({super.key});

  @override
  State<Contest> createState() => _ContestState();
}

class _ContestState extends State<Contest> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(d.pSH(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(
          label: 'Multi Player',
          fontWeight: FontWeight.w700,
          fontSize: getFontSize(24, size),
        ),
        SizedBox(height: d.pSH(16)),
        const CustomText(
          label: 'All Contests',
          fontWeight: FontWeight.w500,
          color: AppColors.hintTextBlack,
        ),
        SizedBox(height: d.pSH(16)),
        ...List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: d.pSH(10)),
            child: QuestCard(
              isMultiCard: true,
              quest: QuestModel(
                  id: 1,
                  name: 'Contest Mode',
                  description: 'Play with friends and flex your muscles',
                  icon: "assets/icons/learner.svg",
                  isLocked: index.isEven),
            ),
          ),
        ),
      ]),
    );
  }
}
