

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/categories/category_level_model.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/category_game_page.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class CategoryDetailsPage extends StatefulWidget {
  const CategoryDetailsPage({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  bool isLoading = false;
  bool fectchingGames = false;
  List<QuestionModel> questionList = [];
  List<QuestionModel> swapQuestionList = [];
  String level = '';
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getCategoryLevel();
    });
    super.initState();
  }

  getCategoryLevel() async {
    setState(() {
      isLoading = true;
    });
    final result =
        await CategoryFunctions().getCategoryLevel(context, widget.category.id);
    if (result is CategoryLevelModel) {
      

    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bright = Theme.of(context).brightness;
    Size size = MediaQuery.of(context).size;

    return PageTemplate(
      pageTitle: 'Start Game',
      child: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: d.pSH(16), horizontal: d.pSW(30)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: d.pSH(150.5),
                      width: d.pSH(160.2),
                      child: CategoryCard(
                        category: widget.category,
                        hidePlay: true,
                      )),
                  SizedBox(height: d.pSH(40)),
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
                              catProv.getCategoryLevel(widget.category.id);
                          return catLevel != null
                              ? Wrap(
                                  runSpacing: d.pSH(10),
                                  spacing: d.pSW(15),
                                  alignment: WrapAlignment.center,
                                  children: [
          
                                    ...List.generate(catLevel.levels.length, (index) {
                                      final _level = catLevel.levels[index];
                                      if(_level.isCurrentLevel){
                                        level = _level.name;
                                      }
                                    return  LevelCard(
                                        level:_level,
                                      );
                                      },)
                                  ],
                                )
                              : const SizedBox();
                        }),
                  SizedBox(height: d.pSH(20)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                            color: bright == Brightness.dark
                                ? AppColors.kGameDarkText2Color
                                : AppColors.kGameText2Color,
                            fontSize: getFontSize(20, size),
                            fontFamily: 'Architects_Daughter',
                            height: 1.7),
                        children: [
                          const TextSpan(
                            text:
                                'These questions have been selected at random from a pool of questions.\n',
                          ),
                          TextSpan(
                            style: TextStyle(
                              color: bright == Brightness.dark
                                  ? AppColors.kGameDarkRed
                                  : AppColors.kGameRed,
                            ),
                            text: 'Once started you cannot pause the game.\n',
                          ),
                          const TextSpan(
                            text: 'Take a deep breath and let us go!',
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: d.pSH(40),
                  ),
                  const AvailalableKeysWidget(),
                  SizedBox(
                    height: d.pSH(30),
                  ),
                  TransformedButton(
                    onTap: () async{
                      getQuestions();
                    },
                    buttonColor: AppColors.kGameGreen,
                    buttonText: ' START ',
                    textColor: Colors.white,
                    textWeight: FontWeight.bold,
                    height: d.pSH(66),
                    width: d.pSH(240),
                  ),
                ],
              ),
            ),
          ),

            /////////////////////////////////////////////////////////
          /////////// CIRCULAR PROGRESS INDICATOR///////////////////
        fectchingGames
                ? LoadIndicator(
                    child: appDialog(
                        context: context, loadingMessage: "Fetching game..."))
                : const SizedBox()
        ],
      ),
    );
  }

  getQuestions() async {
    if (fectchingGames) return;
    setState(() {
      fectchingGames = true;
    });
    final result = await CategoryFunctions().fetchCategoryQuestions(
        context: context,
        categories: [widget.category.id],
        level: level,
        nextUrl: '');
    if (result.isNotEmpty && mounted) {
      spiltresultTotwoList(result).then((value) {

      });
    }else{
      Fluttertoast.showToast(msg: 'Sorry, no questions found for this category. Please try again later.');
    }
    fectchingGames =false;
    setState(() {
      
    });
  }
  

  spiltresultTotwoList(List<QuestionModel> result) {
    for (int i = 0; i < result.length; i++) {
      if (i % 2 == 0) {
        questionList.add(result[i]);
      } else {
        swapQuestionList.add(result[i]);
      }
    }
           nextScreen(context, CategoryGamePage(category: widget.category,questionList: questionList,swapQuestionList: swapQuestionList,),);

  }
}

List levelList = [];
