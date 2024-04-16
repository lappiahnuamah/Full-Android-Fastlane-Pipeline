import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/categories/select_categoiries.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class TrainingMode extends StatefulWidget {
  const TrainingMode({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<TrainingMode> createState() => _TrainingModeState();
}

class _TrainingModeState extends State<TrainingMode> {
  late CategoryProvider categoryProvider;
  CategoryModel? selectedCategory;
  List levelList = [];

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
                  InkWell(
                    onTap: () {
                      for (var level in levelList) {
                        level.totalPoints = 0;
                      }
                      setState(() {
                        levelList[i].totalPoints = 1;
                      });
                    },
                    child: LevelCard(
                      level: levelList[i],
                    ),
                  )
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
                            style: TextStyle(color: AppColors.kGameDarkRed)),

                      if (selectedCategory == null)
                        const TextSpan(
                            text:
                                ' You progress through in the levels by playing games in a particular category'),

                      //Category selected
                      if (selectedCategory != null)
                        const TextSpan(
                            text:
                                'These questions has been selected at random from a pool of questions.\n'),
                      if (selectedCategory != null)
                        const TextSpan(
                          text: 'Once started you cannot pause the game.',
                          style: TextStyle(color: AppColors.kGameDarkRed),
                        ),
                    ])),
            SizedBox(
              height: d.pSH(30),
            ),
            if (selectedCategory != null) const AvailalableKeysWidget(),
            SizedBox(
              height: d.pSH(30),
            ),
            if (selectedCategory != null)
              SizedBox(
                width: d.pSH(240),
                child: TransformedButton(
                  onTap: () {},
                  buttonColor: AppColors.kGameGreen,
                  buttonText: ' START ',
                  textColor: Colors.white,
                  textWeight: FontWeight.bold,
                  height: d.pSH(66),
                ),
              ),
            SizedBox(height: d.pSH(16)),
          ]),
        ),
      ),
    );
  }
}
