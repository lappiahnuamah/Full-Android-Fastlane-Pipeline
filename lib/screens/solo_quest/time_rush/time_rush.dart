import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/category_details_page.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';

class TimeRush extends StatefulWidget {
  const TimeRush({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<TimeRush> createState() => _TimeRushState();
}

class _TimeRushState extends State<TimeRush> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
        pageTitle: widget.quest.name,
        child: Padding(
          padding: EdgeInsets.all(d.pSH(16)),
          child: Column(
            children: [
              Row(
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
              ),
              SizedBox(height: d.pSH(40)),
              Row(
                children: [
                  ...List.generate(
                    3,
                    (index) => const Expanded(
                      child: Center(
                        child: CategoryPlaceholder(),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: d.pSH(30)),
              CustomText(
                label: 'Select Categories',
                fontWeight: FontWeight.w700,
                color: AppColors.kPrimaryColor,
                fontSize: getFontSize(20, size),
              ),
              SizedBox(height: d.pSH(30)),
              SvgPicture.asset(
                AppImages.randomIcon,
              ),
              SizedBox(height: d.pSH(50)),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 4.5,
                    mainAxisSpacing: d.pSH(10),
                    crossAxisSpacing: d.pSW(15)),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < levelList.length; i++)
                    LevelCard(
                      level: levelList[i],
                    )
                ],
              ),
            ],
          ),
        ));
  }
}
