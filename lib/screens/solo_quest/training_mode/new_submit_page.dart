import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/categories/category_level_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/game_page_background.dart';
import 'package:savyminds/widgets/submit_page_background.dart';

class NewSubmitPage extends StatefulWidget {
  const NewSubmitPage(
      {super.key,
      required this.questionList,
      required this.categoryModel,
      required this.totalPoints,
      required this.correctAnswers});
  final List<NewQuestionModel> questionList;
  final CategoryModel? categoryModel;
  final int totalPoints;
  final int correctAnswers;

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

    return Scaffold(
      body: Stack(
        children: [
          SubmitPageBackground(icon: widget.categoryModel!.icon),
          SafeArea(
            child: Container(
              alignment: const Alignment(0.5,-0.5),
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
                      widget.totalPoints.toString(),
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
                      height: d.pSH(100),
                      child: CategoryCard(
                        category: widget.categoryModel!,
                        borderRadius: d.pSH(10),
                        fontSize: d.pSH(16),
                        hidePlay: true,
                        iconSize: 24,
                      ),
                    ),
                    SizedBox(height: d.pSH(15)),
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
                                                      color:
                                                          AppColors.textBlack,
                                                      fontSize:
                                                          getFontSize(13, size),
                                                      fontFamily:
                                                          AppFonts.inter,
                                                      height: 1.5,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "${(levelUpperBound - (catLevel.totalPoints + widget.totalPoints)).toInt()}",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .kGameDarkLightBlue,
                                                            fontSize:
                                                                getFontSize(
                                                                    16, size),
                                                            fontFamily:
                                                                AppFonts.inter,
                                                            height: 1.5,
                                                            fontStyle: FontStyle
                                                                .normal,
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
                                                "${(catLevel.totalPoints + widget.totalPoints).toInt()}",
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
                    const AvailalableKeysWidget(showShop: false,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCategoryRankMessage({required int rank}) {
    return '';
  }
}
