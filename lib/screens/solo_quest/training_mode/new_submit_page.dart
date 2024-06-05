import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/categories/category_level_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/solo_quest/training_mode/training_mode.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/questions/questions_manager.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/submit_page_background.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class NewSubmitPage extends StatefulWidget {
  const NewSubmitPage(
      {super.key,
      required this.categoryModel,
      required this.pointsScored,
      required this.correctAnswers,
      required this.quest});
  final CategoryModel? categoryModel;
  final int pointsScored;
  final int correctAnswers;
  final QuestModel quest;

  @override
  State<NewSubmitPage> createState() => _NewSubmitPageState();
}

class _NewSubmitPageState extends State<NewSubmitPage> {
  LevelName levelName = LevelName.beginner;
  int levelUpperBound = 1999;
  int levelLowerBound = 0;
  bool isLoading = false;
  CategoryLevelModel? categoryLevelModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.categoryModel != null) {
        getCategoryLevel();
      }
      GameFunction().postGameStreaks(
        context: context,
      );
      // GameFunction().getGameStreaks(context: context);
    });
    super.initState();
  }

  getCategoryLevel() async {
    setState(() {
      isLoading = true;
    });
    await CategoryFunctions()
        .getCategoryLevel(context, widget.categoryModel?.id ?? 0);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            SubmitPageBackground(
              icon: widget.categoryModel?.icon ?? '',
              gameIcon: widget.quest.icon,
            ),
            SafeArea(
              child: Container(
                alignment: const Alignment(0.5, -0.5),
                padding: EdgeInsets.symmetric(vertical: d.pSH(16)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Points Scored",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontSize: getFontSize(24, size),
                          fontFamily: AppFonts.caveat,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        widget.pointsScored.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.kGameLightBlue,
                          fontSize: getFontSize(24, size),
                          fontFamily: AppFonts.inter,
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: d.pSH(15)),
                      SizedBox(
                        width: d.pSW(115),
                        height: d.pSH(120),
                        child: CategoryCard(
                          category: widget.categoryModel!,
                          borderRadius: d.pSH(10),
                          fontSize: d.pSH(16),
                          hidePlay: true,
                          iconSize: 24,
                        ),
                      ),
                      SizedBox(height: d.pSH(25)),
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
                              final CategoryLevelModel? catLevel =
                                  categoryLevelModel = catProv.getCategoryLevel(
                                      widget.categoryModel?.id ?? 0);
                              return catLevel != null
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: d.pSH(16)),
                                          child: Wrap(
                                            runSpacing: d.pSH(10),
                                            spacing: d.pSW(15),
                                            alignment: WrapAlignment.center,
                                            children: [
                                              ...List.generate(
                                                catLevel.levels.length,
                                                (index) {
                                                  final _level =
                                                      catLevel.levels[index];
                                                  if (_level.isCurrentLevel) {
                                                    levelName = _level.name;
                                                    levelUpperBound =
                                                        _level.upperboundary;
                                                    levelLowerBound =
                                                        _level.lowerboundary;
                                                  }
                                                  return LevelCard(
                                                    level: _level,
                                                    totalPoints:
                                                        catLevel.totalPoints,
                                                    pointsScored:
                                                        widget.pointsScored,
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: d.pSH(10)),
                                        RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: "Nice Job!",
                                                style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize:
                                                      getFontSize(13, size),
                                                  fontFamily: AppFonts.inter,
                                                  height: 1.5,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: "\nYou need ",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.textBlack,
                                                        fontSize: getFontSize(
                                                            13, size),
                                                        fontFamily:
                                                            AppFonts.inter,
                                                        height: 1.5,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "${(levelUpperBound - (catLevel.totalPoints + widget.pointsScored)).toInt()}",
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .kGameDarkLightBlue,
                                                              fontSize:
                                                                  getFontSize(
                                                                      16, size),
                                                              fontFamily:
                                                                  AppFonts
                                                                      .inter,
                                                              height: 1.5,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    " more points to move to the \nnext level.",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColors
                                                                      .textBlack,
                                                                  fontSize:
                                                                      getFontSize(
                                                                          13,
                                                                          size),
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .inter,
                                                                  height: 1.5,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                              )
                                                            ])
                                                      ])
                                                ])),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Correct Answers",
                                                  style: TextStyle(
                                                    color: AppColors.textBlack,
                                                    fontSize:
                                                        getFontSize(22, size),
                                                    fontFamily: AppFonts.caveat,
                                                    height: 1.5,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: d.pSH(7),
                                                ),
                                                Text(
                                                  "${widget.correctAnswers}",
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .kGameDarkLightBlue,
                                                    fontSize:
                                                        getFontSize(20, size),
                                                    fontFamily: AppFonts.inter,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.5,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Overall scores",
                                                  style: TextStyle(
                                                    color: AppColors.textBlack,
                                                    fontSize:
                                                        getFontSize(22, size),
                                                    fontFamily: AppFonts.caveat,
                                                    height: 1.5,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: d.pSH(7),
                                                ),
                                                Text(
                                                  "${(catLevel.totalPoints + widget.pointsScored).toInt()}",
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .kGameDarkLightBlue,
                                                    fontSize:
                                                        getFontSize(20, size),
                                                    fontFamily: AppFonts.inter,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.5,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: d.pSH(7),
                                        ),
                                        Container(
                                          width: d.getPhoneScreenWidth(),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(d.pSH(5)),
                                          margin: EdgeInsets.symmetric(
                                              vertical: d.pSH(10)),
                                          decoration: BoxDecoration(
                                              color: AppColors.kWhite
                                                  .withOpacity(0.9)),
                                          child: Text(
                                            "You are ranked in top 10",
                                            style: TextStyle(
                                              color: AppColors.kPrimaryColor,
                                              fontSize: getFontSize(27, size),
                                              fontFamily: AppFonts.caveat,
                                              height: 1.5,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox();
                            }),
                      SizedBox(
                        height: d.pSH(15),
                      ),
                      const AvailableKeysWidget(
                        showShop: false,
                      ),
                      SizedBox(
                        height: d.pSH(40),
                      ),
                      TransformedButton(
                        onTap: () {
                          nextScreen(context, const CustomBottomNav());
                          nextScreen(
                              context,
                              TrainingMode(
                                quest: widget.quest,
                                category: widget.categoryModel,
                              ));
                        },
                        buttonText: 'PLAY AGAIN',
                        fontSize: getFontSize(22, size),
                        isReversed: true,
                        height: d.pSH(70),
                        width: d.getPhoneScreenWidth() * 0.55,
                        buttonColor: AppColors.kGameGreen,
                      ),
                      SizedBox(
                        height: d.pSH(30),
                      ),
                      TransformedButton(
                        onTap: () {
                          nextScreen(context, const CustomBottomNav());
                        },
                        buttonText: 'Return Home',
                        fontSize: getFontSize(22, size),
                        height: d.pSH(80),
                        buttonColor: AppColors.kGameRed,
                        width: d.getPhoneScreenWidth() * 0.65,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCategoryRankMessage({required int rank}) {
    return '';
  }

  // getQuestions() async {
  //   if (!context.mounted) return;

  //   if (questionsLoading) return;

  //   setState(() {
  //     questionsLoading = true;
  //   });

  //   final result = await QuestionsManager.getTrainingModeQuestions(
  //     context: context,
  //     questId: widget.quest.id,
  //     level: widget,
  //     categoryId: selectedCategory?.id ?? 0,
  //   );

  //   setState(() {
  //     questionsLoading = false;
  //   });

  //   if (result.isNotEmpty) {
  //     if (mounted) {
  //       nextScreen(
  //           context,
  //           TrainingModeGamePage(
  //               category: selectedCategory!,
  //               questionList: result,
  //               quest: widget.quest,
  //               level: level));
  //     }
  //   } else { n
  //     Fluttertoast.showToast(
  //         msg:
  //             'No questions available for this category. Please select another category.');
  //   }
  // }
}
