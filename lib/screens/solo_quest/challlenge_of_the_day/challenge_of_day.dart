import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/solo_quest/challlenge_of_the_day/start_challenge_of_day.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class ChallengeOfTheDay extends StatefulWidget {
  const ChallengeOfTheDay({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<ChallengeOfTheDay> createState() => _ChallengeOfTheDayState();
}

class _ChallengeOfTheDayState extends State<ChallengeOfTheDay> {
  late CategoryProvider categoryProvider;
  List<CategoryModel> selectedCategories = [];

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    selectedCategories = categoryProvider.getTwoRandomCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: widget.quest.name,
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(
          children: [
            QuestIconDescCard(quest: widget.quest),
            SizedBox(height: d.pSH(40)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    2,
                    (index) => selectedCategories.length > index
                        ? Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: AspectRatio(
                                  aspectRatio: 1.08,
                                  child: CategoryCard(
                                    category: selectedCategories[index],
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
            Flexible(child: Container()),
            SizedBox(
              width: d.pSH(240),
              child: TransformedButton(
                onTap: () {
                  nextScreen(
                      context,
                      StartChallengeOfTheDay(
                          quest: widget.quest,
                          selectedCategories: selectedCategories));
                },
                buttonColor: AppColors.kGameGreen,
                buttonText: ' GO! ',
                textColor: Colors.white,
                textWeight: FontWeight.bold,
                height: d.pSH(66),
              ),
            ),
            SizedBox(height: d.pSH(16)),
          ],
        ),
      ),
    );
  }
}
