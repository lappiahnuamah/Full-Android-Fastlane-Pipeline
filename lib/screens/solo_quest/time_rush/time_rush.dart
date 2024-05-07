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
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/solo_quest/time_rush/select_three_categories.dart';
import 'package:savyminds/screens/solo_quest/time_rush/time_rush_game_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class TimeRush extends StatefulWidget {
  const TimeRush({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<TimeRush> createState() => _TimeRushState();
}

class _TimeRushState extends State<TimeRush> {
  late CategoryProvider categoryProvider;
  List<CategoryModel> selectedCategories = [];

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
              QuestIconDescCard(quest: widget.quest),
              SizedBox(height: d.pSH(40)),
              Row(
                children: [
                  ...List.generate(
                    3,
                    (index) => selectedCategories.length > index
                        ? Expanded(
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: AspectRatio(
                                  aspectRatio: 1.08,
                                  child: CategoryCard(
                                    category: selectedCategories[index],
                                    hidePlay: true,
                                    fontSize: 12,
                                    iconSize: d.pSH(26),
                                    borderRadius: d.pSH(18),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Center(
                              child: CategoryPlaceholder(
                                onTap: () {},
                              ),
                            ),
                          ),
                  )
                ],
              ),
              SizedBox(height: d.pSH(30)),
              if (selectedCategories.isEmpty)
                InkWell(
                  onTap: () async {
                    final result = await nextScreen(
                        context, const SelectedThreeCategories());
                    if (result is List<CategoryModel>) {
                      selectedCategories = result;
                      setState(() {});
                    }
                  },
                  child: CustomText(
                    label: 'Select Categories',
                    fontWeight: FontWeight.w700,
                    color: AppColors.kPrimaryColor,
                    fontSize: getFontSize(20, size),
                  ),
                ),
              if (selectedCategories.isEmpty) SizedBox(height: d.pSH(30)),
              if (selectedCategories.isEmpty)
                InkWell(
                  onTap: () {
                    selectedCategories =
                        categoryProvider.getThreeRandomCategories();
                    setState(() {});
                  },
                  child: SvgPicture.asset(
                    AppImages.randomIcon,
                  ),
                ),
              if (selectedCategories.isEmpty) SizedBox(height: d.pSH(50)),
              // Wrap(
              //   runSpacing: d.pSH(10),
              //   spacing: d.pSW(15),
              //   alignment: WrapAlignment.center,
              //   children: [
              //     for (int i = 0; i < levelList.length; i++)
              //       LevelCard(
              //         level: levelList[i],
              //         totalPoints: 50,
              //       )
              //   ],
              // ),
              if (selectedCategories.isNotEmpty) SizedBox(height: d.pSH(40)),
              if (selectedCategories.isNotEmpty)
                Column(
                  children: [
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
                          children: const [
                            TextSpan(
                                text: 'Hint:',
                                style:
                                    TextStyle(color: AppColors.kGameDarkRed)),
                            TextSpan(
                                text:
                                    ' Hint: Don’t waste time on a single question. Use the to jump a question.\n'),
                            TextSpan(
                                text: 'Once started you cannot pause the game.',
                                style: TextStyle(
                                  color: AppColors.kGameDarkRed,
                                )),
                          ]),
                    ),
                    SizedBox(height: d.pSH(40)),
                    const AvailalableKeysWidget(),
                    SizedBox(height: d.pSH(40)),
                    SizedBox(
                      width: d.pSH(240),
                      child: TransformedButton(
                        onTap: () {
           nextScreen(context, TimeRushGamePage(questModel: widget.quest,questionList: questionList,swapQuestionList: swapQuestionList,),);
                        },
                        buttonColor: AppColors.kGameGreen,
                        buttonText: ' START ',
                        textColor: Colors.white,
                        textWeight: FontWeight.bold,
                        height: d.pSH(66),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: d.pSH(16)),
            ],
          ),
        ));
  }
}
