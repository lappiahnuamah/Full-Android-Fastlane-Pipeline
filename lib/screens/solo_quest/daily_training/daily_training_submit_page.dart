import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/animations/increasing_number.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/categories/category_level_model.dart';
import 'package:savyminds/models/categories/category_rank_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/solo_quest/daily_training/daily_training.dart';
import 'package:savyminds/screens/solo_quest/training_mode/training_mode.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/submit_page_background.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class DailyTrainingSubmitPage extends StatefulWidget {
  const DailyTrainingSubmitPage(
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
  State<DailyTrainingSubmitPage> createState() =>
      _DailyTrainingSubmitPageState();
}

class _DailyTrainingSubmitPageState extends State<DailyTrainingSubmitPage> {
  LevelName levelName = LevelName.beginner;
  int levelUpperBound = 1999;
  int levelLowerBound = 0;
  bool isLoading = false;
  CategoryLevelModel? categoryLevelModel;
  late GameItemsProvider gameItemsProvider;

  CategoryRankModel? categoryRankModel;

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    gameItemsProvider.setDailyCategoryToPlayed(id: widget.categoryModel!.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSomeData();
    });
    super.initState();
  }

  Future<void> getSomeData() async {
    if (widget.categoryModel != null) {
      if (widget.categoryModel != null) {
        await CategoryFunctions().submitCategoryPoints(
            context: context,
            category: widget.categoryModel!.id,
            gameTypeId: widget.quest.id,
            totalPoints: widget.pointsScored);
      }
      getCategoryLevel();
    }
    GameFunction().postGameStreaks(
      context: context,
    );

    getCategoryRank();
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
                      Consumer<GameItemsProvider>(
                          builder: (context, itemProvider, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: d.pSW(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Categories

                              ...itemProvider.dailyTrainingCategories.entries
                                  .map((e) {
                                final category = e.value['category'];
                                return Expanded(
                                    child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: AspectRatio(
                                      aspectRatio: 0.99,
                                      child: CategoryCard(
                                        category: category,
                                        hidePlay: true,
                                        greyedOut: e.value['isPlayed'],
                                        fontSize: 12,
                                        iconSize: d.pSH(26),
                                        borderRadius: d.pSH(18),
                                      ),
                                    ),
                                  ),
                                ));
                              }),
                            ],
                          ),
                        );
                      }),
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
                      IncreasingNumberAnimation(
                        from: 0,
                        to: widget.pointsScored,
                        style: TextStyle(
                          color: AppColors.kGameLightBlue,
                          fontSize: getFontSize(24, size),
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.inter,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: d.pSH(5)),
                      Text(
                        widget.categoryModel?.name ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: getFontSize(24, size),
                          fontFamily: AppFonts.inter,
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: d.pSH(25)),
                      Consumer<CategoryProvider>(
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
                                              totalPoints: catLevel.totalPoints,
                                              pointsScored: widget.pointsScored,
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
                                            fontSize: getFontSize(13, size),
                                            fontFamily: AppFonts.inter,
                                            height: 1.5,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: "\nYou need ",
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
                                                      text:
                                                          "${(levelUpperBound - (catLevel.totalPoints + widget.pointsScored)).toInt()}",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .kGameDarkLightBlue,
                                                        fontSize: getFontSize(
                                                            16, size),
                                                        fontFamily:
                                                            AppFonts.inter,
                                                        height: 1.5,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              " more points to move to the \nnext level.",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .textBlack,
                                                            fontSize:
                                                                getFontSize(
                                                                    13, size),
                                                            fontFamily:
                                                                AppFonts.inter,
                                                            height: 1.5,
                                                            fontStyle: FontStyle
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
                                              fontSize: getFontSize(22, size),
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
                                              color:
                                                  AppColors.kGameDarkLightBlue,
                                              fontSize: getFontSize(20, size),
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
                                              fontSize: getFontSize(22, size),
                                              fontFamily: AppFonts.caveat,
                                              height: 1.5,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          SizedBox(
                                            height: d.pSH(7),
                                          ),
                                          IncreasingNumberAnimation(
                                            from: catLevel.totalPoints.toInt(),
                                            to: (catLevel.totalPoints +
                                                    widget.pointsScored)
                                                .toInt(),
                                            style: TextStyle(
                                              color:
                                                  AppColors.kGameDarkLightBlue,
                                              fontSize: getFontSize(20, size),
                                              fontFamily: AppFonts.inter,
                                              fontWeight: FontWeight.w700,
                                              height: 1.5,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          )
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
                                        color:
                                            AppColors.kWhite.withOpacity(0.9)),
                                    child: Text(
                                      "You are ranked in top ${categoryRankModel?.rank ?? 1}",
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
                      Consumer<GameItemsProvider>(
                          builder: (context, itemProvider, child) {
                        return (itemProvider.dailyTrainingCategories.entries
                                .any((element) =>
                                    element.value['isPlayed'] == false))
                            ? TransformedButton(
                                onTap: () {
                                  playNextCategory(context);
                                },
                                buttonText: 'PLAY NEXT',
                                fontSize: getFontSize(22, size),
                                isReversed: true,
                                height: d.pSH(70),
                                width: d.getPhoneScreenWidth() * 0.55,
                                buttonColor: AppColors.kGameGreen,
                              )
                            : const SizedBox();
                      }),
                      SizedBox(
                        height: d.pSH(30),
                      ),
                      TransformedButton(
                        onTap: () {
                          nextScreen(context, const CustomBottomNav(),
                              TransitionType.rotation);
                          nextScreen(context, const DailyTraining());
                        },
                        buttonText: 'RETURN TO TRAINING',
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

  void playNextCategory(BuildContext context) {
    final gameItemsProvider = context.read<GameItemsProvider>();

    final nextCategory = gameItemsProvider.dailyTrainingCategories.entries
        .firstWhere((element) => element.value['isPlayed'] == false)
        .value['category'];

    nextScreen(context, const CustomBottomNav());
    nextScreen(
        context,
        TrainingMode(
          quest: widget.quest,
          category: nextCategory,
          isDailyTraining: true,
        ));
  }

  Future<void> getCategoryRank() async {
    final result = await CategoryFunctions().getRankForACategory(
        context: context, categoryId: widget.categoryModel?.id ?? 0);

    if (result is CategoryRankModel) {
      setState(() {
        categoryRankModel = result;
      });
    }
  }

  String getCategoryRankMessage({required int rank}) {
    return '';
  }
}
