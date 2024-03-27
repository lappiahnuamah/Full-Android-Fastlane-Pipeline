import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';

class TransformedButton extends StatelessWidget {
  const TransformedButton(
      {required this.onTap,
      this.buttonColor,
      required this.buttonText,
      this.textColor,
      this.fontSize,
      this.textWeight,
      this.isReversed,
      this.height,
      this.keepBlue,
      this.width,
      super.key});

  final Function()? onTap;
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final FontWeight? textWeight;
  final double? fontSize;
  final bool? isReversed;
  final double? height;
  final double? width;
  final bool? keepBlue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return SizedBox(
        height: height,
        width: width,
        child: InkWell(
            onTap: onTap,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                (buttonColor == AppColors.kGameGreen )
                    ? SvgPicture.asset(
                        "assets/icons/buttons/green_button.svg",
                        height: height,
                        width: width,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        buttonColor == AppColors.kGameRed ||
                                buttonColor == AppColors.kGameDarkRed
                            ? "assets/images/red_button.png"
                            : bright == Brightness.dark
                                ? keepBlue ?? false
                                    ? "assets/images/blue_button.png"
                                    : "assets/images/grey_button.png"
                                : "assets/images/blue_button.png",
                        height: height,
                        width: width,
                        fit: BoxFit.fill,
                      ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: d.pSH(3), vertical: d.pSH(5)),
                    child: Text(
                      buttonText,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Architects_Daughter',
                        color: textColor ?? Colors.white,
                        fontSize: fontSize ?? getFontSize(22, size),
                        fontWeight: textWeight,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
