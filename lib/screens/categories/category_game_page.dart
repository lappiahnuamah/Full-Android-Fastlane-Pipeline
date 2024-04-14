import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/dummy_questions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/answer_button.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/dialogs/game_hint_dialog.dart';
import 'package:savyminds/widgets/game_image_options.dart';
import 'package:savyminds/widgets/game_page_background.dart';
import 'package:savyminds/widgets/game_page_keys_list.dart';
import 'package:savyminds/widgets/game_top_keys_list.dart';
import 'package:savyminds/widgets/mystery_box_open.dart';
import 'package:savyminds/widgets/retake_key_display.dart';

class CategoryGamePage extends StatefulWidget {
  const CategoryGamePage({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryGamePage> createState() => _CategoryGamePageState();
}

class _CategoryGamePageState extends State<CategoryGamePage>
    with TickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  ValueNotifier<int> seconds = ValueNotifier<int>(10);
  ValueNotifier<List<int>> fiftyfityList = ValueNotifier<List<int>>([]);
  OptionModel? selectedAnswer;
  Map<int, dynamic> resultList = {};


  int selectedIndex = 0;
  Timer? timer;

  bool timesTwoActivated = false;
  bool retakeActivated = false;
  bool breakTime = false;
  bool showRetake = false;

  ///////////////////////////////
  //////Animations
  late AnimationController controller;
  late AnimationController totalController;
  late Animation<double> sizeAnimation;

  ///late Animation<double> animation;
  late Animation<Offset> positionAnimation;
  late Animation<double> _fontSizeAnimation;

  late Animation<double> totalAnimation;
  bool showAnimation = false;
  String currentNumber = '+1';
  String targetNumber = '';
  double fontSize = 45.0;
  int gamePoints = 1;

int  currentGamePoints =0;
int answerStreak = 0;
int loseStreaks = 0;

  //swap
  PageController swapController = PageController(initialPage: 0);

  startTimer(int? time) {
    seconds.value = time ?? 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        if (selectedIndex < questionList.length - 1) {
          pageController.nextPage(
              duration: const Duration(
                milliseconds: 400,
              ),
              curve: Curves.easeIn);
          // gameProvider.addSelectedAnswer(
          //     option: selectedAnswer,
          //     questioinId: questionList[selectedIndex].id);
          if (selectedAnswer == null) {
            // gameProvider.resetAnswerStreak();
          }
          timer.cancel();
          FlameAudio.bgm.stop();
        } else {
          // gameProvider.addSelectedAnswer(
          //     option: selectedAnswer,
          //     questioinId: questionList[selectedIndex].id);
          // if (selectedAnswer == null) {
          //   gameProvider.resetAnswerStreak();
          //}
          timer.cancel();
          FlameAudio.bgm.stop();
          FlameAudio.play('outro_game_over.mp3');
          // nextScreen(
          //     context,
          //     SubmitPage(
          //       questionList: questionList,
          //     ));
          // pageController.jumpToPage(0);
          selectedIndex = 0;
          startTimer(15);
          setState(() {});
        }
      }
      if (seconds.value == 5) {
        // shakeFiftyFiftyIcon();
        FlameAudio.bgm.play('five_sec_more.mp3');
      }
      if (seconds.value == 3) {
        // shakeGoldenBadge();
      }
    });
  }

  late GameItemsProvider gameItemsProvider;

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    startTimer(questionList[selectedIndex].questionTime);
    FlameAudio.bgm.stop();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    setAnimations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        GamePageBackground(icon: widget.category.icon),

        //Actual Game
        SafeArea(
          child: Consumer2<GameProvider, GameItemsProvider>(
              builder: (context, gameProvider, gameItemsProvider, child) {
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(d.pSH(16), d.pSH(10), d.pSH(16), 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/icons/log-out.svg'),
                      ),

                      //Score
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (timesTwoActivated)
                            CustomText(
                              label: 'x2',
                              color: AppColors.everGreen,
                              fontSize: getFontSize(18, size),
                              fontWeight: FontWeight.bold,
                            ),
                          SizedBox(
                            width: d.pSH(10),
                          ),
                          CustomText(
                            label: '$currentGamePoints',
                            color: AppColors.kPrimaryColor,
                            fontSize: getFontSize(24, size),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: questionList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (val) {
                          selectedIndex = val;
                          if (questionList[selectedIndex].isGolden) {
                            FlameAudio.play('when_question_is_star.mp3');
                          } else {
                            FlameAudio.play('new_question.mp3');
                          }
                          startTimer(questionList[selectedIndex].questionTime);
                        },
                        itemBuilder: (context, index) {
                          //swap page builder
                          return PageView.builder(
                            controller: swapController,
                            itemCount: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            onPageChanged: (val) {
                              if (swapQuestionList[selectedIndex].isGolden) {
                                FlameAudio.play('when_question_is_star.mp3');
                              } else {
                                FlameAudio.play('new_question.mp3');
                              }
                              startTimer(
                                  swapQuestionList[selectedIndex].questionTime);
                            },
                            itemBuilder: (context, swapIndex) {
                              QuestionModel question = questionList[index];
                              if (swapIndex != 0) {
                                question = swapQuestionList[index];
                              }
                              return Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: d.pSH(16)),
                                      child: Column(
                                        children: [
                                          if (question.isGolden)
                                            SvgPicture.asset(
                                              'assets/icons/star.svg',
                                              height: d.pSH(25),
                                            ).animate()
                                              ..shimmer(duration: 1000.ms)
                                              ..scale(duration: 1000.ms),
                                          SizedBox(height: d.pSH(10)),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(question.text,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: AppFonts.caveat,
                                                    color: AppColors.textBlack,
                                                    fontSize: getFontSize(
                                                        question.image.isEmpty
                                                            ? 30
                                                            : 22,
                                                        size), //88 : 20
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                              if (question.image.isNotEmpty)
                                                SizedBox(height: d.pSH(20)),
                                              if (question.image.isNotEmpty)
                                                Expanded(
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Transform(
                                                      alignment:
                                                          Alignment.center,
                                                      transform:
                                                          Matrix4.identity()
                                                            ..setEntry(3, 2,
                                                                0.002) // Adjust the perspective by changing this value
                                                            ..rotateX(0.3)
                                                            ..rotateY(0.05),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          d.pSH(
                                                                              20))),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  d.pSH(5)),
                                                          child: Image.network(
                                                            question.image,
                                                            fit: BoxFit.fill,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              if (question.image.isNotEmpty)
                                                SizedBox(height: d.pSH(10)),
                                            ],
                                          )),

                                          //Question Number and Timer
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ///
                                              ///Question number
                                              Text(
                                                "${index + 1}/${questionList.length}",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.hintTextBlack,
                                                    fontSize:
                                                        getFontSize(20, size),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(width: d.pSH(30)),
                                              GameTopKeysList(
                                                showHint:
                                                    question.hint.isNotEmpty,
                                                showMysteryBox:
                                                    question.hasMysteryBox,
                                                showTimesTwo:
                                                    question.hasTimesTwoPoints,
                                                onMysteryBoxPressed: () {
                                                  _showMysteryBox();
                                                },
                                                onHintPressed: () {
                                                  _showHintDialog();
                                                },
                                                onTimesTwoPressed: () {
                                                  setState(() {
                                                    timesTwoActivated = true;
                                                  });
                                                },
                                              ),
                                              SizedBox(width: d.pSH(30)),
                                              ////
                                              /// Timer
                                              ValueListenableBuilder<int>(
                                                  valueListenable: seconds,
                                                  builder:
                                                      (context, time, child) {
                                                    return SizedBox(
                                                      width: d.pSH(25),
                                                      child: Text(
                                                        '$time',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            fontSize:
                                                                getFontSize(
                                                                    20, size),
                                                            color: time < 6
                                                                ? AppColors
                                                                    .kGameRed
                                                                : AppColors
                                                                    .kGameGreen,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: d.pSH(5)),
                                  const Divider(
                                      color: AppColors.blueBird, thickness: 4),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              ///// Options --- (Text)
                                              ///
                                              if (question.option.isNotEmpty &&
                                                  question.option[0].image
                                                      .isEmpty &&
                                                  question.option[0].text !=
                                                      '.')
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: d.pSW(15),
                                                    right: d.pSW(15),
                                                    top: d.pSH(5),
                                                  ),
                                                  child:
                                                      ValueListenableBuilder<
                                                              List<int>>(
                                                          valueListenable:
                                                              fiftyfityList,
                                                          builder: (context,
                                                              list, child) {
                                                            return SingleChildScrollView(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ...List.generate(
                                                                        question
                                                                            .option
                                                                            .length,
                                                                        (subIndex) {
                                                                      final option =
                                                                          question
                                                                              .option[subIndex];

                                                                      return list
                                                                              .contains(option.id)
                                                                          ? const SizedBox()
                                                                          : AnswerButton(
                                                                              answer: option,
                                                                              onTap: () {
                                                                                answerButtonPressed(option, question, context, index);
                                                                              },
                                                                              isSelected: selectedAnswer?.id == option.id,
                                                                              isReversed: subIndex % 2 == 0);
                                                                    }),
                                                                    const SizedBox(
                                                                        height:
                                                                            20)
                                                                  ]),
                                                            );
                                                          }),
                                                ),

                                              if (question.option.isNotEmpty &&
                                                      question.option[0].image
                                                          .isNotEmpty ||
                                                  question.option[0].text ==
                                                      '.')
                                                Container(
                                                    width:
                                                        d.getPhoneScreenWidth() *
                                                            0.75,
                                                    padding: EdgeInsets.only(
                                                        top: d.pSH(20),
                                                        bottom: d.pSH(10)),
                                                    child:
                                                        ValueListenableBuilder<
                                                                List<int>>(
                                                            valueListenable:
                                                                fiftyfityList,
                                                            builder: (context,
                                                                list, child) {
                                                              return GameImageOptions(
                                                                options: question.option,
                                                                selectedAnswer: selectedAnswer,
                                                                fiftyfityList: fiftyfityList.value,
                                                                onOptionSelected: (option){
                                                                  answerButtonPressed(option, question, context, index);
                                                                },
                                                                  );
                                                            })),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: d.pSH(15)),

                                        //Bottom Keys
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: d.pSH(16)),
                                            child: GamePageKeysList(
                                              answerStreaks: 3,
                                              onFiftyTapped: () {
                                                _useFiftyFiifty(
                                                    question.option);
                                              },
                                              //onRetakeTapped: () {},
                                              onFreezeTapped: () {
                                                _freezeTime(
                                                    question.questionTime);
                                              },
                                              onSwapTapped: () {
                                                _swapQuestion();
                                              },
                                              onGoldenTapped: () {
                                                _useGoldenChance(
                                                    question: question,
                                                    questionID: question.id);
                                              },
                                            ))
                                      ],
                                    ),
                                  ),
                                  if (Platform.isAndroid)
                                    SizedBox(height: d.pSH(8))
                                ],
                              );
                            },
                          );
                        }))
              ],
            );
          }),
        ),

        ////Pause cover
        if (breakTime)
          Container(
            color: Colors.black.withOpacity((showRetake ? 0.9 : 0.5)),
          ),

        //// Animation pointss
        if (showAnimation)
          AnimatedBuilder(
              animation: positionAnimation,
              builder: (context, child) {
                return Positioned(
                  right: positionAnimation.value.dx,
                  top: positionAnimation.value.dy,
                  child: Text(
                    '+$gamePoints',
                    style: TextStyle(
                        fontSize: _fontSizeAnimation.value,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Architects_Daughter',
                        color: AppColors.kGameLightBlue,
                        shadows: const [
                          Shadow(color: Colors.black, offset: Offset(1, 1))
                        ]),
                  ),
                );
              }),

        if (breakTime && showRetake && !retakeActivated)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(child: RetakeKeyDisplay(
                onRetakeTapped: () {
                  setState(() {
                    retakeActivated = true;
                  });
                },
              )))
      ],
    ));
  }

 
  void answerButtonPressed(OptionModel option, QuestionModel question,
      BuildContext context, int index) {
    selectedAnswer = option;
    breakTime = true;
    //timer?.cancel();
    FlameAudio.bgm.stop();
    setState(() {});
    if (option.isCorrect) {
      FlameAudio.play('correct_ans.mp3');
      _addPoints(questionPoints: question.points, isGolden: question.isGolden,time:question.questionTime);
      // gameProvider.increaseAnswerStreak(
      //     context: context, hasGolden: question.isGolden && seconds.value > 6);
    } else {
      FlameAudio.play('wong_ans.mp3');
      if ((gameItemsProvider.userKeys[GameKeyType.retakeKey]?.amount ?? 0) >
          0) {
        setState(() {
          showRetake = true;
        });
      }
      answerStreak=0;
       loseStreaks++;
    }

    // GameComments().showGameCommentToast(
    //     context: context,
    //     isCorrectAswer: option.isCorrect,
    //     streaks: gameProvider.answerStreaks,
    //     lostStreaks: loseStreaks,
    //     fifty: gameProvider.fiftyFifty,
    //     goldenBadge: gameProvider.goldenChances);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        breakTime = false;
        showRetake = false;
      });

      if (retakeActivated) {
        retakeActivated = false;
        setState(() {});
      }

      moveToNextScreen(index: index, questionId: question.id);
    });
  }

  _addPoints({required int questionPoints, required bool isGolden,required int time}) {
    if (seconds.value <= time * 0.4) {
      gamePoints = questionPoints;
    } else if (seconds.value <= time * 0.7) {
      gamePoints = questionPoints * 2;
    } else {
      gamePoints = questionPoints * 3;
      if (isGolden) {
        gameItemsProvider.increaseKeyAmount(GameKeyType.goldenKey);
      }
    }
    if (timesTwoActivated) {
      gamePoints = gamePoints * 2;
      setState(() {
        timesTwoActivated = false;
      });
    }
    startScoreAnimation();
    Future.delayed(const Duration(seconds: 2), () {
      // gameProvider.addGamePoints(gamePoints);
    });
  }

  void startScoreAnimation() {
    setState(() {
      showAnimation = true;
    });
    if (!controller.isAnimating) {
      controller.reset(); // Reset the animation
      controller.forward(); // Start the animation when the button is pressed
    }

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          currentNumber = targetNumber;
          showAnimation = false;
        });
      }
    });
  }

  void setAnimations() {
    positionAnimation = Tween<Offset>(
      begin: Offset((d.getPhoneScreenWidth() / 2) - 40,
          (d.getPhoneScreenHeight() / 2) - 80),
      end: const Offset(-5.0, 10.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    _fontSizeAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  ////////////////////////////####################////////////////////////
  //////////////////////////  KEY TAPPED ACTIONS   ///////////////////////
  ////////////////////////////####################////////////////////////
  _showHintDialog() async {
    timer?.cancel();
    await showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: GameHintDialog(hint: questionList[selectedIndex].hint))),);
    startTimer(seconds.value);

    setState(() {});
  }

  _showMysteryBox() async {
    timer?.cancel();
    await showDialog(
      context: context,
      builder: ((context) => const MysteryBoxOpen()),
    );
    startTimer(seconds.value);
  }

  _freezeTime(int questionTime) {
    timer?.cancel();
    setState(() {});
    Future.delayed(Duration(seconds: questionTime), () {
      startTimer(seconds.value);
    });
  }

  _useFiftyFiifty(List<OptionModel> options) {
    if (options.length > 2) {
      List<int> removeList = [];
      while ((options.length - removeList.length) > 2) {
        final rand = Random().nextInt(options.length);
        if (!(options[rand].isCorrect) &&
            !(removeList.contains(options[rand].id))) {
          removeList.add(options[rand].id);
        }
      }
      fiftyfityList.value = removeList;
      FlameAudio.play('when_50_50_clicked.mp3');
      setState(() {});
      gameItemsProvider.reduceKeyAmount(GameKeyType.fiftyFifty);
    }
  }

  _useGoldenChance(
      {required QuestionModel question, required int questionID}) {
    for (var element in question.option) {
      if (element.isCorrect) {
        FlameAudio.play('correct_ans.mp3');
        selectedAnswer = element;
        break;
      }
    }
    breakTime = true;
    timer?.cancel();
    setState(() {});
     loseStreaks = 0;
    _addPoints(
         questionPoints: question.points, isGolden: false,time: question.questionTime);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        breakTime = false;
      });
      moveToNextScreen(index: selectedIndex, questionId: questionID);
    });
  }

  _swapQuestion() {
    if (swapQuestionList.isNotEmpty) {
      timer?.cancel();

      swapController.nextPage(
          duration: const Duration(
            milliseconds: 400,
          ),
          curve: Curves.easeIn);
    }
  }

 moveToNextScreen({required int index, required int questionId}) {
    timer?.cancel();
    FlameAudio.bgm.stop();
    if (index < questionList.length - 1) {
      pageController.nextPage(
          duration: const Duration(
            milliseconds: 400,
          ),
          curve: Curves.easeIn);
      addSelectedAnswer(
          option: selectedAnswer, questioinId: questionList[index].id);
    } else {
      addSelectedAnswer(
          option: selectedAnswer, questioinId: questionList[index].id);
      // nextScreen(
      //     context,
      //     SubmitPage(
      //       questionList: questionList,
      //     ));
    }
  ///  GameLocalDatabase.deleteQuestion(questionId);
  }


  void addSelectedAnswer(
      {required int questioinId, required OptionModel? option}) {
    if (option == null) {
      resultList.addAll({
        questioinId: {
          'question': questioinId,
          'option': null,
          'marks': 0,
        }
      });
    } else {
      resultList.addAll({
        option.question: {
          'question': option.question,
          'option': option.id,
          'marks': option.isCorrect ? 1 : 0,
        }
      });
    }
  }
  @override
  void dispose() {
    controller.dispose();
    swapController.dispose();

    if (timer != null) {
      timer!.cancel();
    }
    seconds.dispose();
    fiftyfityList.dispose();
    super.dispose();
  }
}

