import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';
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
    Size size = MediaQuery.of(context).size;
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
                  tag: 'Logo-${widget.quest.name}', //TODO:Fix later
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
            child: widget.quest.name == 'Training Mode'
                ? RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: getFontSize(13, size)),
                      children: [
                        TextSpan(
                          text:
                              "Click in the box below to select a category you will like to train. Use the ",
                          style: TextStyle(color: Colors.black),
                        ),
                        WidgetSpan(
                          child: SvgPicture.asset(
                            'assets/icons/random.svg',
                            height: d.pSH(14),
                          ),
                        ),
                        TextSpan(
                          text: " to select a category at random.",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                : CustomText(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    label: widget.description ?? widget.quest.description,
                  ))
      ],
    );
  }
}
