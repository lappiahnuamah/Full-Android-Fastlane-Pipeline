import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/animations/lightening_animation.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/categories/category_level_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/categories/select_categoiries.dart';
import 'package:savyminds/screens/solo_quest/training_mode/training_mode_game_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/questions/questions_manager.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class TrainingMode extends StatefulWidget {
  const TrainingMode({super.key, required this.quest, this.category});
  final QuestModel quest;
  final CategoryModel? category;

  @override
  State<TrainingMode> createState() => _TrainingModeState();
}

class _TrainingModeState extends State<TrainingMode> {
  late CategoryProvider categoryProvider;
  late GameProvider gameProvider;
  bool isLoading = false;
  bool questionsLoading = false;

  CategoryModel? selectedCategory;
  List levelList = [];
  LevelName level = LevelName.beginner;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    gameProvider = context.read<GameProvider>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedCategory = widget.category;
      if (widget.category != null) {
        getCategoryLevel();
      }
    });
    super.initState();
  }

  getCategoryLevel() async {
    setState(() {
      isLoading = true;
    });
    await CategoryFunctions()
        .getCategoryLevel(context, selectedCategory?.id ?? 0);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: widget.quest.name,
      child: StageLightingDemo(
        child: Stack(
          children: [
            Padding(
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
                                      getCategoryLevel();
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
                                    getCategoryLevel();
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
                  isLoading
                      ? SizedBox(
                          height: d.pSH(60),
                          width: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        )
                      : Consumer<CategoryProvider>(
                          builder: (context, catProv, chils) {
                          final CategoryLevelModel? catLevel = catProv
                              .getCategoryLevel(selectedCategory?.id ?? 0);
                          return catLevel != null
                              ? Wrap(
                                  runSpacing: d.pSH(10),
                                  spacing: d.pSW(15),
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ...List.generate(
                                      catLevel.levels.length,
                                      (index) {
                                        final _level = catLevel.levels[index];
                                        if (_level.isCurrentLevel) {
                                          level = _level.name;
                                        }
                                        return LevelCard(
                                          level: _level,
                                          totalPoints: catLevel.totalPoints,
                                        );
                                      },
                                    )
                                  ],
                                )
                              : const SizedBox();
                        }),
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
                  if (selectedCategory != null) const AvailableKeysWidget(),
                  SizedBox(
                    height: d.pSH(30),
                  ),
                  if (selectedCategory != null)
                    SizedBox(
                      width: d.pSH(240),
                      child: TransformedButton(
                        onTap: () {
                          getQuestions();
                        },
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

            /////////////////////////////////////////////////////////
            /////////// CIRCULAR PROGRESS INDICATOR///////////////////
            questionsLoading
                ? LoadIndicator(
                    child: appDialog(
                        context: context, loadingMessage: "Fetching questions"))
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  getQuestions() async {
    if (!context.mounted) return;

    if (questionsLoading) return;

    setState(() {
      questionsLoading = true;
    });

    final result = await QuestionsManager.getTrainingModeQuestions(
      context: context,
      questId: widget.quest.id,
      level: level,
      categoryId: selectedCategory?.id ?? 0,
    );

    setState(() {
      questionsLoading = false;
    });

    if (result.questions.isNotEmpty) {
      if (mounted) {
        nextScreen(
            context,
            TrainingModeGamePage(
                category: selectedCategory!,
                questionList: result.questions,
                swapQuestions: result.swapQuestions,
                quest: widget.quest,
                level: level));
      }
    } else {
      Fluttertoast.showToast(
          msg:
              'No questions available for this category. Please select another category.');
    }
  }
}
