import 'package:flutter/material.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.label,
    this.color,
    this.maxLines,
    this.fontSize = 16,
    this.overflow = TextOverflow.visible,
    this.textAlign,
    this.shadows,
    this.fontStyle,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  final String label;
  final Color? color;
  final double fontSize;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? height;
  final List<Shadow>? shadows;
  final TextDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(
      label,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
          fontSize: getFontSize(fontSize, size),
          fontWeight: fontWeight,
          color: color ?? AppColors.hintTextBlack,
          fontStyle: fontStyle,
          height: height,
          shadows: shadows,
          letterSpacing: letterSpacing,
          decoration: decoration),
    );
  }
}
