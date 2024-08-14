import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_text.dart';

class QuestIconDescCard extends StatefulWidget {
  const QuestIconDescCard(
      {super.key,
      required this.quest,
      this.isContest = false,
      this.description});
  final QuestModel quest;
  final bool isContest;
  final String? description;

  @override
  State<QuestIconDescCard> createState() => _QuestIconDescCardState();
}

class _QuestIconDescCardState extends State<QuestIconDescCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: d.isTablet ? d.pSW(71) : d.pSW(51),
          width: d.isTablet ? d.pSW(79) : d.pSW(59),
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/icons/quest_icon_container.svg",
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  widget.isContest
                      ? AppColors.borderAccent
                      : AppColors.borderPrimary,
                  BlendMode.srcIn,
                ),
                height: d.isTablet ? d.pSW(71) : d.pSW(51),
                width: d.isTablet ? d.pSW(79) : d.pSW(59),
              ),
              Align(
                child: Hero(
                  tag: 'Logo-${widget.quest.name}7', //TODO:Fix later
                  child: SvgPicture.network(
                    widget.quest.icon,
                    height: d.isTablet ? d.pSW(40) : null,
                  ),
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
          label: widget.description ?? widget.quest.description,
        ))
      ],
    );
  }
}
