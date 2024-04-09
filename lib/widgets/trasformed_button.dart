import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/utils/func.dart';

class TransformedButton extends StatelessWidget {
  const TransformedButton(
      {required this.onTap,
      this.buttonColor,
      required this.buttonText,
      this.textColor,
      this.fontSize,
      this.textWeight,
      this.isReversed = false,
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
  final bool isReversed;
  final double? height;
  final double? width;
  final bool? keepBlue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: height,
        width: width,
        child: InkWell(
            onTap: onTap,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset(
                    !isReversed
                        ? "assets/icons/option1.svg"
                        : "assets/icons/option2.svg",
                    height: height,
                    width: width,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        buttonColor ?? AppColors.kGameBlue, BlendMode.srcIn)),
                Align(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: d.pSH(3), vertical: d.pSH(5)),
                    child: Text(
                      buttonText,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFonts.caveat,
                          color: textColor ?? Colors.white,
                          fontSize: getFontSize(fontSize ?? 22, size),
                          fontWeight: textWeight,
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
              ],
            )));
  }
}
