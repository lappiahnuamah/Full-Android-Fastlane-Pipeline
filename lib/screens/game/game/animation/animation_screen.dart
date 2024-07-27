import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  late GameProvider gameProvider;
  late AnimationController controller;
  late AnimationController totalController;
  late Animation<double> sizeAnimation;

  ///late Animation<double> animation;
  late Animation<Offset> positionAnimation;
  late Animation<double> _fontSizeAnimation;

  late Animation<double> totalAnimation;

  String currentNumber = '+3';
  String targetNumber = '';
  double fontSize = 40.0;

  bool showAnimation = false;
  bool shakeBadge = false;
  bool shakeFiftyFifty = false;

  int gamePoints = 1;
  int totalPoints = 0;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    setAnimations();
    starttTimer();
    super.initState();
  }

  void setAnimations() {
    positionAnimation = Tween<Offset>(
      begin: Offset((d.getPhoneScreenWidth() / 2) - 50,
          (d.getPhoneScreenHeight() / 2) - 50),
      end: const Offset(10.0, 0.0),
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

  void setTotalAnimation() {
    totalAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(totalController)
      ..addListener(() {
        setState(() {
          totalPoints = (lerpDouble(totalPoints, totalPoints + gamePoints,
                      totalAnimation.value) ??
                  0)
              .toInt();
        });
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

    if (timer != null) {
      timer!.cancel();
      super.dispose();
    }
    seconds.dispose();
    fiftyfityList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return Consumer<GameProvider>(builder: (context, game, child) {
      return Scaffold(
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.only(
            top: d.pSH(20),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  ///
                  ///Return Home
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: d.pSW(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            ' Return Home ',
                            style: TextStyle(
                              fontFamily: 'Architects_Daughter',
                              color: bright == Brightness.dark
                                  ? AppColors.kGameDarkTextColor
                                  : AppColors.kGameTextColor,
                              fontSize: getFontSize(22, size),
                            ),
                          ),
                        ),

                        ///total points
                        Text(
                          '$totalPoints',
                          style: TextStyle(
                              fontFamily: 'Architects_Daughter',
                              color: AppColors.kGameBlue,
                              fontSize: getFontSize(22, size),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  ////
                  /// Timer
                  ValueListenableBuilder<int>(
                      valueListenable: seconds,
                      builder: (context, time, child) {
                        return Text(
                          formatTime(time),
                          style: TextStyle(
                              fontFamily: 'Architects_Daughter',
                              fontSize: getFontSize(28, size),
                              color: time < 6
                                  ? AppColors.kGameRed
                                  : AppColors.kGameGreen,
                              fontWeight: FontWeight.w700),
                        );
                      }),
                  Expanded(child: Container()),

                  TransformedButton(
                    onTap: () {
                      _addPoints();
                      startScoreAnimation();
                    },
                    buttonColor: AppColors.kGameGreen,
                    buttonText: ' Animate ',
                    textColor: Colors.white,
                    textWeight: FontWeight.bold,
                    height: d.pSH(65),
                    width: d.getPhoneScreenWidth() * 0.6,
                  ),

                  const SizedBox(
                    height: 150,
                  )
                ],
              ),

             
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
                                Shadow(
                                    color: Colors.black, offset: Offset(1, 1))
                              ]),
                        ),
                      );
                    }),
             
              //////////////
              //////50/50
              Positioned(
                bottom: d.pSH(10),
                left: d.pSH(10),
                child: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                              radius: d.pSH(3),
                              backgroundColor: game.answerStreaks > 4
                                  ? AppColors.kGameGreen
                                  : AppColors.kUnselectedCircleColor),
                          SizedBox(height: d.pSH(5)),
                          CircleAvatar(
                              radius: d.pSH(3),
                              backgroundColor: game.answerStreaks > 3
                                  ? AppColors.kGameGreen
                                  : AppColors.kUnselectedCircleColor),
                          SizedBox(height: d.pSH(5)),
                          CircleAvatar(
                              radius: d.pSH(3),
                              backgroundColor: game.answerStreaks > 2
                                  ? AppColors.kGameGreen
                                  : AppColors.kUnselectedCircleColor),
                          SizedBox(height: d.pSH(5)),
                          CircleAvatar(
                              radius: d.pSH(3),
                              backgroundColor: game.answerStreaks > 1
                                  ? AppColors.kGameGreen
                                  : AppColors.kUnselectedCircleColor),
                          SizedBox(height: d.pSH(5)),
                          CircleAvatar(
                              radius: d.pSH(3),
                              backgroundColor: game.answerStreaks > 0
                                  ? AppColors.kGameGreen
                                  : AppColors.kUnselectedCircleColor),
                          SizedBox(height: d.pSH(5)),
                          InkWell(
                              onTap: game.fiftyFifty < 1
                                  ? null
                                  : () {
                                      shakeFiftyFiftyIcon();
                                    },
                              splashColor: AppColors.kGameGreen,
                              child: SvgPicture.asset(
                                game.fiftyFifty < 1
                                    ? 'assets/images/blur_50505.svg'
                                    : 'assets/images/5050.svg',
                                height: d.pSH(37),
                              ).animate().shakeX(
                                  duration: Duration(
                                      seconds: shakeFiftyFifty ? 2 : 0))),
                        ],
                      ),
                      SizedBox(width: d.pSW(5)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          "${game.fiftyFifty}",
                          style: TextStyle(
                              fontFamily: 'Architects_Daughter',
                              color: AppColors.kGameLightBlue,
                              fontSize: getFontSize(28, size),
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /////////////////
              //////Golden chance
              Positioned(
                bottom: d.pSH(10),
                right: d.pSH(10),
                child: SizedBox(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "${game.goldenChances}",
                    style: TextStyle(
                        fontFamily: 'Architects_Daughter',
                        color: AppColors.kGameLightBlue,
                        fontSize: getFontSize(28, size),
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(width: d.pSW(5)),
                  InkWell(
                    onTap: game.goldenChances < 1
                        ? null
                        : () {
                            shakeGoldenBadge();
                          },
                    child: SvgPicture.asset(
                      game.goldenChances < 1
                          ? 'assets/images/silver_badge.svg'
                          : 'assets/images/gold_badge.svg',
                      height: d.pSH(37),
                    ).animate().shakeY(
                        duration: Duration(
                            seconds: (shakeBadge && game.goldenChances > 0)
                                ? 2
                                : 0)),
                  ),
                ])),
              )
            ],
          ),
        )),
      );
    });
  }

  void shakeGoldenBadge() {
    setState(() {
      shakeBadge = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        shakeBadge = false;
      });
    });
  }

  void shakeFiftyFiftyIcon() {
    setState(() {
      shakeFiftyFifty = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        shakeFiftyFifty = false;
      });
    });
  }

  ValueNotifier<int> seconds = ValueNotifier<int>(10);
  ValueNotifier<List<int>> fiftyfityList = ValueNotifier<List<int>>([]);
  Timer? timer;

  starttTimer() {
    seconds.value = 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        timer.cancel();
        starttTimer();
      }
      if (seconds.value == 5) {
        shakeFiftyFiftyIcon();
      }
      if (seconds.value == 3) {
        shakeGoldenBadge();
      }
    });
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    if (minutes < 1) {
      minutes = 0;
    }
    String minuteStr = minutes.toString().padLeft(2, '0');
    String secondStr = seconds.toString().padLeft(2, '0');
    return '$minuteStr:$secondStr';
  }

  _addPoints() {
    if (seconds.value <= 3) {
      gamePoints = 1;
    } else if (seconds.value <= 6) {
      gamePoints = 2;
    } else {
      gamePoints = 3;
    }
    setState(() {});
  }
}
