import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/dummy_questions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/category_details_page.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/categories/select_categoiries.dart';
import 'package:savyminds/screens/solo_quest/survival_quest/survival_quest_game_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class SurvivalQuest extends StatefulWidget {
  const SurvivalQuest({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<SurvivalQuest> createState() => _SurvivalQuestState();
}

class _SurvivalQuestState extends State<SurvivalQuest> {
  late CategoryProvider categoryProvider;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: widget.quest.name,
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  QuestIconDescCard(quest: widget.quest),
                  SizedBox(height: d.pSH(40)),
                  selectedCategory != null
                      ? SizedBox(
                          height: 159.6,
                          width: 187,
                          child: CategoryCard(
                            category: selectedCategory!,
                            hidePlay: true,
                          ),
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: d.pSH(5)),
                              child: CategoryPlaceholder(
                                height: 159,
                                width: 187,
                                label: 'Click here to select a category ',
                                onTap: () async {
                                  final result = await nextScreen(
                                      context, const SelectCategory());
                                  if (result is CategoryModel) {
                                    setState(() {
                                      selectedCategory = result;
                                    });
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedCategory =
                                        categoryProvider.getRandomCategory();
                                  });
                                },
                                child: SvgPicture.asset(
                                  AppImages.randomIcon,
                                ),
                              ),
                            )
                          ],
                        ),
                  SizedBox(height: d.pSH(30)),
                  Wrap(
                    runSpacing: d.pSH(10),
                    spacing: d.pSW(15),
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < levelList.length; i++)
                        LevelCard(
                          level: levelList[i],
                        ),
                    ],
                  ),
                  SizedBox(height: d.pSH(20)),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: getFontSize(24, size),
                            fontFamily: AppFonts.caveat,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                          children: [
                            //Category not selected
                            if (selectedCategory == null)
                              const TextSpan(
                                  text: 'Hint:',
                                  style:
                                      TextStyle(color: AppColors.kGameDarkRed)),

                            if (selectedCategory == null)
                              const TextSpan(
                                  text:
                                      ' Having a recharge mystery box can be really useful if you are about to lose all your lives.'),

                            //Category selected
                            if (selectedCategory != null)
                              const TextSpan(
                                  text:
                                      'The goal is to not lose all your lives. However, each remaining live Fetches points.\n'),
                            if (selectedCategory != null)
                              const TextSpan(
                                text: 'Once started you cannot pause the game.',
                                style: TextStyle(color: AppColors.kGameDarkRed),
                              ),
                          ])),
                  SizedBox(height: d.pSH(20)),
                  if (selectedCategory != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          4,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: d.pSW(5)),
                            child: SvgPicture.asset(
                              AppImages.lifeSvg,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: d.pSH(25)),
                  if (selectedCategory != null) const AvailalableKeysWidget(),
                ]),
              ),
            ),
            SizedBox(
              height: d.pSH(30),
            ),
            if (selectedCategory != null)
              SizedBox(
                width: d.pSH(240),
                child: TransformedButton(
                  onTap: () {
                    nextScreen(context, SurvivalQuestGamePlay(quest: widget.quest, questionList: questionList));
                  },
                  buttonColor: AppColors.kGameGreen,
                  buttonText: ' START ',
                  textColor: Colors.white,
                  textWeight: FontWeight.bold,
                  height: d.pSH(66),
                ),
              ),
            if (Platform.isIOS) SizedBox(height: d.pSH(16)),
          ],
        ),
      ),
    );
  }
}
