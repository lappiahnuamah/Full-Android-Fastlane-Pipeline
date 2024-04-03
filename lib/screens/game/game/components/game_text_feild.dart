import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';

class GameTextFeild extends StatelessWidget {
  const GameTextFeild(
      {Key? key,
      required this.controller,
      this.labelText,
      this.initialValue,
      this.suffixIcon,
      this.validator,
      this.onChanged,
      this.hintText,
      this.onSaved,
      this.keyboardType,
      this.obscureText,
      this.prefixIcon,
      this.maxLines,
      this.noPrefix,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.readOnly,
      this.suffix,
      this.darkfillColor,
      this.counterText,
      this.maxLength,
      this.onTap,
      this.enabled,
      this.hintStyle,
      this.suffixString,
      this.suffixStyle})
      : super(key: key);

  final TextEditingController controller;
  final String? labelText;
  final String? initialValue;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Color? darkfillColor;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData? prefixIcon;
  final int? maxLines;

  final bool? noPrefix;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final bool? readOnly;
  final String? hintText;
  final int? maxLength;
  final String? counterText;
  final void Function()? onTap;
  final bool? enabled;
  final TextStyle? hintStyle;
  final TextStyle? suffixStyle;
  final String? suffixString;
  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    d.init(context);
    return TextFormField(
      minLines: 1,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      enabled: enabled ?? true,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      style: TextStyle(
        fontSize: d.pSH(25),
        color: bright == Brightness.dark ? Colors.white : AppColors.kTextColor,
        fontFamily: AppFonts.caveat,
      ),
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      textAlign: TextAlign.center,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        counterText: counterText,
        suffixIconConstraints: BoxConstraints(minWidth: d.pSW(50)),
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
              color: bright == Brightness.dark
                  ? AppColors.kTrendEmojiColor
                  : AppColors.hintTextBlack,
              fontFamily: AppFonts.caveat,
            ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: d.pSW(15), vertical: d.pSH(10)),
        fillColor:
            bright == Brightness.dark ? AppColors.kDarkCardColor : Colors.white,
        filled: true,
        suffix: suffix,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.kGameGreen, width: 3),
            borderRadius: BorderRadius.circular(d.pSH(10))),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: d.pSH(0.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: d.pSH(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: bright == Brightness.dark
                    ? AppColors.kDarkBorderColor
                    : AppColors.kBorderColor,
                width: d.pSH(0.5))),
      ),
    );
  }
}
