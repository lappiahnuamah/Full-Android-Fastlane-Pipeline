import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
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
      this.textInputAction = TextInputAction.done,
      this.textCapitalization = TextCapitalization.sentences,
      this.suffix,
      this.focusNode,
      this.darkfillColor,
      this.autovalidateMode,
      this.counterText,
      this.maxLength,
      this.onTap,
      this.enabled,
      this.autofocus = false,
      this.minLines,
      this.lightThemeBorderColor,
      this.darkThemeBorderColor,
      this.fillColor,
      this.borderRadius})
      : super(key: key);

  final TextEditingController controller;
  final String? labelText;
  final String? initialValue;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;
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
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final Color? lightThemeBorderColor;
  final Color? darkThemeBorderColor;
  final Color? fillColor;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    d.init(context);
    return TextFormField(
      autofocus: autofocus,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onSaved: onSaved,
      onChanged: onChanged,
      enabled: enabled ?? true,
      onTap: onTap,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      style: TextStyle(
          fontSize: d.pSH(17),
          color:
              bright == Brightness.dark ? Colors.white : AppColors.kTextColor),
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      maxLength: maxLength,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
            color: bright == Brightness.dark
                ? AppColors.kTrendEmojiColor
                : AppColors.kFormLabelColor),
        floatingLabelStyle: TextStyle(fontSize: d.pSH(20)),
        suffixIcon: suffixIcon,
        counterText: counterText,
        suffixIconConstraints: BoxConstraints(minWidth: d.pSW(50)), //todo:50
        hintText: hintText,
        contentPadding:
            EdgeInsets.symmetric(horizontal: d.pSW(10), vertical: d.pSH(10)),
        prefixIcon: noPrefix != null
            ? noPrefix!
                ? null
                : Icon(prefixIcon,
                    size: 20,
                    color: bright == Brightness.dark
                        ? AppColors.kTrendEmojiColor
                        : AppColors.kIconColor)
            : Icon(prefixIcon,
                size: 20,
                color: bright == Brightness.dark
                    ? darkfillColor ?? AppColors.kTrendEmojiColor
                    : AppColors.kIconColor),
        fillColor: fillColor ??
            (bright == Brightness.dark
                ? AppColors.kDarkCardColor
                : Colors.white),
        filled: true,

        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(d.pSW(borderRadius ?? 0.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: bright == Brightness.dark
                  ? darkThemeBorderColor ?? Colors.white
                  : lightThemeBorderColor ?? Colors.black,
              width: bright == Brightness.dark ? d.pSH(1) : d.pSH(0.5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: darkThemeBorderColor ?? Colors.red, width: d.pSH(0.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: darkThemeBorderColor ?? Colors.red, width: d.pSH(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: bright == Brightness.dark
                    ? darkThemeBorderColor ?? Colors.grey
                    : lightThemeBorderColor ?? Colors.grey,
                width: d.pSH(0.5))),
      ),
    );
  }
}
