import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_text.dart';

class QuestIconDescCard extends StatefulWidget {
  const QuestIconDescCard({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<QuestIconDescCard> createState() => _QuestIconDescCardState();
}

class _QuestIconDescCardState extends State<QuestIconDescCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: d.pSH(51),
          width: d.pSH(59),
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/icons/quest_icon_container.svg",
                fit: BoxFit.fill,
                colorFilter: const ColorFilter.mode(
                  AppColors.borderPrimary,
                  BlendMode.srcIn,
                ),
              ),
              Align(
                child: SvgPicture.network(
                  widget.quest.icon,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: d.pSW(16)),
        Expanded(
            child: CustomText(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          label: widget.quest.description,
        ))
      ],
    );
  }
}
