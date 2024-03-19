import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';

class TwinText extends StatelessWidget {
  const TwinText(
      {Key? key,
      this.title,
      required this.content,
      this.titleStyle,
      this.contentStyle,
      this.space,
      this.crossAxisAlignment,
      this.textAlign,
      this.width})
      : super(key: key);

  final String? title;
  final String content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final double? space;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextAlign? textAlign;
  final double? width;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Brightness bright = Theme.of(context).brightness;
    return SizedBox(
      width: width ?? size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          title != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      textAlign: textAlign ?? TextAlign.start,
                      style: titleStyle ??
                          TextStyle(
                            fontSize: d.pSW(14),
                            color: bright == Brightness.dark
                                ? Colors.white
                                : AppColors.kPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(
                      height: d.pSH(space ?? 2),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          Text(
            content,
            textAlign: textAlign ?? TextAlign.start,
            style: contentStyle ??
                TextStyle(
                  fontSize: d.pSW(14),
                  color: bright == Brightness.dark
                      ? Colors.white
                      : AppColors.kPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
          )
        ],
      ),
    );
  }
}
