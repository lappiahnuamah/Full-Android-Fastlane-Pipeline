import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class GameResults extends StatefulWidget {
  const GameResults(
      {super.key, required this.scores, required this.questionList});
  final String scores;
  final List<QuestionModel> questionList;

  @override
  State<GameResults> createState() => _GameResultsState();
}

class _GameResultsState extends State<GameResults> {
  late GameProvider gameProvider;
  List<QuestionModel> questionList = [];
  int selectedIndex = 0;
  ValueNotifier<int> seconds = ValueNotifier<int>(10);

  Map<int, dynamic> resultList = {};

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    questionList = widget.questionList;
    resultList = gameProvider.resultList;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bright = Theme.of(context).brightness;

    // Media query to make it responsive
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Results',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: bright == Brightness.dark
          ? AppColors.kDarkScaffoldBackground
          : AppColors.kGameScaffoldBackground,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child:
              // Questions
              ListView.builder(
            itemCount: questionList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final question = questionList[index];
              Map<String, dynamic> selectedAnswer =
                  resultList[question.id] ?? {};
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kBorderColor),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Question ${index + 1}",
                            style: const TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Builder(builder: (context) {
                          bool? choseWrongAnswer =
                              selectedAnswer['option'] == null
                                  ? null
                                  : (selectedAnswer['marks'] == 0);
                          return Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: choseWrongAnswer == null
                                    ? AppColors.kBorderColor
                                    : choseWrongAnswer
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              choseWrongAnswer == null
                                  ? Icons.question_mark
                                  : choseWrongAnswer
                                      ? Icons.close
                                      : Icons.done,
                              color: choseWrongAnswer == null
                                  ? AppColors.kBorderColor
                                  : choseWrongAnswer
                                      ? Colors.red
                                      : Colors.green,
                              size: 20,
                            ),
                          );
                        })
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        question.text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        ...List.generate(question.option.length, (index) {
                          final option = question.option[index];

                          return _answerButton(
                              answer: option,
                              choseWrongAnswer: selectedAnswer['option'] == null
                                  ? null
                                  : (selectedAnswer['option'] == option.id) &&
                                      !option.isCorrect,
                              isCorrect: option.isCorrect);
                        })
                      ]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _answerButton({
    required OptionModel answer,
    required bool? choseWrongAnswer,
    required bool isCorrect,
  }) {
    return Container(
      //width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      //height: 60,
      child: TransformedButton(
        onTap: null,
        buttonColor: choseWrongAnswer != null
            ? choseWrongAnswer
                ? AppColors.kGameRed
                : isCorrect
                    ? AppColors.kGameGreen
                    : null
            : isCorrect
                ? AppColors.kGameGreen
                : null,
        buttonText: answer.text,
        textColor: Colors.black,
        fontSize: 20,
      ),
    );
  }
}
