import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
//import 'package:savyminds/screens/categories/category_details_page.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class StartChallengeOfTheDay extends StatefulWidget {
  const StartChallengeOfTheDay(
      {super.key, required this.quest, required this.selectedCategories});
  final QuestModel quest;
  final List<CategoryModel> selectedCategories;

  @override
  State<StartChallengeOfTheDay> createState() => _StartChallengeOfTheDayState();
}

class _StartChallengeOfTheDayState extends State<StartChallengeOfTheDay> {
  late CategoryProvider categoryProvider;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: 'Start Game',
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(
          children: [
            QuestIconDescCard(
              quest: widget.quest,
              description:
                  "You are playing challenge of the day. Put your thinking caps on and answer two of the most tough questions. You can’t afford to lose this one. ",
            ),
            SizedBox(height: d.pSH(40)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    2,
                    (index) => widget.selectedCategories.length > index
                        ? Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: AspectRatio(
                                  aspectRatio: 1.08,
                                  child: CategoryCard(
                                    category: widget.selectedCategories[index],
                                    hidePlay: true,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CategoryPlaceholder(
                              onTap: () {},
                            ),
                          ),
                  )
                ],
              ),
            ),
            SizedBox(height: d.pSH(30)),
            // Wrap(
            //   runSpacing: d.pSH(10),
            //   spacing: d.pSW(15),
            //   alignment: WrapAlignment.center,
            //   children: [
            //     for (int i = 0; i < levelList.length; i++)
            //       LevelCard(
            //         level: levelList[i],
            //         totalPoints: 50,
            //       ),
            //   ],
            // ),
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
                  children: const [
                    TextSpan(
                        text:
                            'These are some of the hardest trivial out there. You need more than memory to work these out.\n'),
                    //Category not selected
                    TextSpan(
                        text: 'Once started you cannot pause the game.',
                        style: TextStyle(color: AppColors.kGameDarkRed)),
                  ]),
            ),
            Flexible(child: Container()),
            TransformedButton(
              onTap: () {},
              buttonColor: AppColors.kGameGreen,
              buttonText: 'START',
              textColor: Colors.white,
              textWeight: FontWeight.bold,
              height: d.pSH(66),
            ),
            SizedBox(height: d.pSH(16)),
          ],
        ),
      ),
    );
  }
}
