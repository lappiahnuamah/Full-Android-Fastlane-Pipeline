import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/resources/app_colors.dart';

class GameImageOptions extends StatefulWidget {
  const GameImageOptions({super.key,required this.fiftyfityList,required this.options,required this.selectedAnswer,required this.onOptionSelected});
  final List<int> fiftyfityList;
  final List<OptionModel> options;
  final OptionModel ?selectedAnswer;
final Function(OptionModel option) onOptionSelected;

  @override
  State<GameImageOptions> createState() => _GameImageOptionsState();
}

class _GameImageOptionsState extends State<GameImageOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: widget.fiftyfityList.contains(widget.options[0].id)
                  ? const SizedBox()
                  : imageOptions(
                      answer: widget.options[0],
                      onTap: () {},
                      isSelected: widget.selectedAnswer?.id == widget.options[0].id,
                      isReversed: false,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2,
                            0.005) // Adjust the perspective by changing this value
                        ..rotateX(0.2)
                        ..rotateY(-0.1)),
            ),
            SizedBox(width: d.pSH(15)),
            Expanded(
              child: widget.options.length < 2
                  ? const SizedBox()
                  : widget.fiftyfityList.contains(widget.options[1].id)
                      ? const SizedBox()
                      : imageOptions(
                          answer: widget.options[1],
                          onTap: () {},
                          isSelected:
                              widget.selectedAnswer?.id == widget.options[1].id,
                          isReversed: false,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.005) // Adjust the perspective by changing this value
                            ..rotateX(0.2)
                            ..rotateY(0.1)),
            ),
          ],
        )),
        SizedBox(height: d.pSH(10)),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: widget.options.length < 3
                  ? const SizedBox()
                  : widget.fiftyfityList.contains(widget.options[2].id)
                      ? const SizedBox()
                      : imageOptions(
                          answer: widget.options[2],
                          onTap: () {},
                          isSelected:
                              widget.selectedAnswer?.id == widget.options[2].id,
                          isReversed: true,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.005) // Adjust the perspective by changing this value
                            ..rotateX(-0.2)
                            ..rotateY(-0.1)),
            ),
            SizedBox(width: d.pSH(15)),
            Expanded(
              child: widget.options.length < 4
                  ? const SizedBox()
                  : widget.fiftyfityList.contains(widget.options[3].id)
                      ? const SizedBox()
                      : imageOptions(
                          answer: widget.options[3],
                          onTap: () {},
                          isSelected:
                              widget.selectedAnswer?.id == widget.options[3].id,
                          isReversed: true,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.005) // Adjust the perspective by changing this value
                            ..rotateX(-0.2)
                            ..rotateY(0.1)),
            ),
          ],
        ))
      ],
    );
  }



  Widget imageOptions(
      {required OptionModel answer,
      required VoidCallback onTap,
      required bool isSelected,
      required bool isReversed,
      required Matrix4 transform}) {
    final bright = Theme.of(context).brightness;

    return InkWell(
      onTap: onTap,
      child: Transform(
          alignment: Alignment.center,
          transform: transform, // Adjust the rotation angle if needed
          child: Container(
              width: double.infinity,
              height: double.maxFinite,
              padding: EdgeInsets.all(d.pSH(5)),
              decoration: BoxDecoration(
                  color: isSelected
                      ? answer.isCorrect
                          ? AppColors.everGreen
                          : AppColors.kGameRed
                      : bright == Brightness.dark
                          ? AppColors.kGameDarkBlue
                          : AppColors.kGameBlue,
                  borderRadius: BorderRadius.circular(d.pSH(5))),
              child: Container(
                height: double.maxFinite,
                color: AppColors.kWhite,
                child: Image.network(
                  answer.image,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: AppColors.kGameBlue,
                        size: 40,
                      ),
                    );
                  },
                ),
              ))),
    );
  }

}