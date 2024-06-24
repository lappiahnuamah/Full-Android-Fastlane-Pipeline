import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/questions/option_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class AnswerButton extends StatefulWidget {
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
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          double offset = 0;
          if (!widget.answer.isCorrect && _shakeController.isAnimating) {
            offset = _shakeAnimation.value;
          }

          return Transform.translate(
            offset: Offset(offset, 0),
            child: GestureDetector(
              onTap: () => _handleAnswer(widget.answer.isCorrect),
              child: AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: widget.answer.isCorrect &&
                                _scaleController.isAnimating
                            ? _scaleAnimation.value
                            : 1.0,
                        child: Container(
                          width: d.getPhoneScreenWidth() * 0.7,
                          constraints: BoxConstraints(minHeight: d.pSH(58)),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TransformedButton(
                            onTap: () {
                              _handleAnswer(widget.answer.isCorrect);
                              widget.onTap.call();
                            },
                            buttonColor: widget.isSelected
                                ? widget.answer.isCorrect
                                    ? AppColors.everGreen
                                    : AppColors.kGameRed
                                : null,
                            buttonText: widget.answer.text, // answer.text,
                            fontSize: widget.answer.text.length > 40
                                ? 18
                                : widget.answer.text.length > 25
                                    ? 20
                                    : 22,
                            textWeight: FontWeight.w700,
                            isReversed: !widget.isReversed,
                            padding: EdgeInsets.symmetric(
                                horizontal: d.pSH(10), vertical: d.pSH(5)),
                          ),
                        ));
                  }),
            ),
          );
        });
  }

  void _handleAnswer(bool isCorrectAnswer) {
    if (isCorrectAnswer) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }
}
