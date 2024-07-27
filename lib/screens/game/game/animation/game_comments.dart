import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';


class GameComments {
  List<String> goodComment = [
    'Nice 💥',
    'Great job!',
    'Impressive!',
    'Well done!'
  ];
  List<String> betterComment = [
    'You\'re on a roll!',
    'You\'re nailing it!',
    'You\'re in the zone.',
    'Keep up the great work.',
    'Keep the streak going!'
  ];
  List<String> bestComment = [
    'You\'re setting a high bar for excellence!',
    'Keep the momentum!',
    'You\'re demonstrating exceptional knowledge',
    'You\'re proving to be a real pro at this.',
    'Your knowledge is shining brightly today.',
    'Wow, you\'re a true expert in this field'
  ];

  List<String> badComment = [
    'Better luck on next 😨',
    'Nice try!',
    'Close but not quite!',
  ];
  List<String> worstComment = [
    'Not quite, but your positivity is a win!',
    'Wrong answers are just opportunities to improve',
    'Keep going',
    'Keep your spirits high and stay focused.',
    'You\'ve got plenty of chances to make a comeback!',
    'Incorrect, but don\'t be discouraged.',
  ];

  List<String> useChancesComment = ['You can use your 50/50'];

  showGameCommentToast(
      {required BuildContext context,
      required bool isCorrectAswer,
      required int streaks,
      required int lostStreaks,
      required int fifty,
      required int goldenBadge}) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    final String comment = getWhatToSay(
        isCorrectAswer: isCorrectAswer,
        streaks: streaks,
        lostStreaks: lostStreaks,
        fifty: fifty,
        goldenBadge: goldenBadge);

    if (comment.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/game_logo 1.svg",
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: d.pSW(20)),
                Expanded(
                  child: Text(
                    comment,
                    style: TextStyle(
                        color: bright == Brightness.light
                            ? AppColors.kGameDarkText2Color
                            : AppColors.kGameText2Color,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Architects_Daughter',
                        fontSize: getFontSize(23, size)),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            elevation: 3.0,
            backgroundColor: bright == Brightness.light
                ? AppColors.kDarkBorderColor.withOpacity(0.8)
                : AppColors.kGameScaffoldBackground.withOpacity(0.8),
          ),
        );
    }
  }

  String getWhatToSay(
      {required bool isCorrectAswer,
      required int streaks,
      required int lostStreaks,
      required int fifty,
      required int goldenBadge}) {
    /// Chose correct  answer
    if (isCorrectAswer) {
      //// if user has 10+ streaks use
      if (streaks > 9) {
        return bestComment[Random().nextInt(bestComment.length)];
      } else if (streaks > 3) {
        return betterComment[Random().nextInt(betterComment.length)];
      } else if (streaks > 2) {
        return goodComment[Random().nextInt(goodComment.length)];
      }
      return '';
    }

    /// Chose wronng  answer
    else {
      if (lostStreaks <= 2) {
        return badComment[Random().nextInt(badComment.length)];
      }

      //Person has chances
      if (lostStreaks > 2) {
        if (fifty > 0) {
          return useChancesComment[Random().nextInt(useChancesComment.length)];
        } else if (goldenBadge > 0) {
          return 'You can use your golden badge';
        } else {
          return worstComment[Random().nextInt(worstComment.length)];
        }
      }
      return '';
    }
  }
}
