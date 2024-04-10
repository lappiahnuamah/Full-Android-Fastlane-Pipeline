import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(
      {super.key,
      required this.answer,
      required this.onTap,
      required this.isSelected,
      required this.isReversed});

  final OptionModel answer;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: d.getPhoneScreenWidth() * 0.7,
      constraints: BoxConstraints(minHeight: d.pSH(58)),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TransformedButton(
        onTap: onTap,
        buttonColor: isSelected
            ? answer.isCorrect
                ? AppColors.everGreen
                : AppColors.kGameRed
            : null,
        buttonText: answer.text,
        fontSize: 24,
        textWeight: FontWeight.w700,
        isReversed: !isReversed,
      ),
    );
  }
}
