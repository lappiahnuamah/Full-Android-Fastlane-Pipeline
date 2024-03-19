import 'package:flutter/material.dart';
import 'package:savyminds/utils/dimensions.dart';
import 'package:savyminds/utils/func.dart';

class DialogButton extends StatelessWidget {
  const DialogButton(
      {Key? key,
      required this.onTap,
      this.label = 'Button',
      this.labelColor = Colors.white,
      required this.mainColor,
      this.strokeColor = Colors.transparent,
      required this.width,
      this.labelStyle})
      : super(key: key);

  // final Size size;
  final String label;
  final Color mainColor;
  final Color labelColor;
  final Color strokeColor;
  final double width;
  final Function() onTap;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(size.width * 0.02 /*8*/)),
            color: mainColor,
            border: strokeColor != Colors.transparent
                ? Border.all(
                    color: strokeColor, width: size.height * 0.0025 /*2.0*/
                    )
                : Border.all(width: 0, color: Colors.transparent)),
        width: width > 0 ? width : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.02 /*16.0*/,
              horizontal: width == 0
                  ? getScaledDimension(
                      16, Dimensions.kStandardWidth, size.width)
                  : 0),
          child: Center(
            child: Text(
              label,
              style: labelStyle ??
                  TextStyle(
                      fontSize: size.height * 0.017 /*14*/,
                      color: labelColor /*Colors.white*/,
                      letterSpacing: 0.004,
                      fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
