import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';

class CustomTextFieldWithLabel extends StatelessWidget {
  const CustomTextFieldWithLabel(
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
      this.minLines,
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
      this.labelStyle,
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
  final int? minLines;
  final bool? noPrefix;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final bool? readOnly;
  final String? hintText;
  final int? maxLength;
  final String? counterText;
  final void Function()? onTap;
  final bool? enabled;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? suffixStyle;
  final String? suffixString;
  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    d.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText == null
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(bottom: 4, left: d.pSW(4)),
                child: Text(
                  labelText!,
                  style: labelStyle ??
                      TextStyle(
                          color: bright == Brightness.dark
                              ? AppColors.kTrendEmojiColor
                              : AppColors.kFormLabelColor),
                ),
              ),
        TextFormField(
          minLines: minLines ?? 1,
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
              fontSize: d.pSH(17),
              color: bright == Brightness.dark
                  ? Colors.white
                  : AppColors.kTextColor),
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            labelStyle: TextStyle(
                color: bright == Brightness.dark
                    ? AppColors.kTrendEmojiColor
                    : AppColors.kFormLabelColor),
            floatingLabelStyle: TextStyle(fontSize: d.pSH(20)),
            suffixIcon: suffixIcon,
            counterText: counterText,
            suffixIconConstraints: BoxConstraints(minWidth: d.pSW(50)),
            hintText: hintText,
            hintStyle: hintStyle ??
                TextStyle(
                    color: bright == Brightness.dark
                        ? AppColors.kTrendEmojiColor
                        : AppColors.hintTextBlack),
            contentPadding: EdgeInsets.symmetric(
                horizontal: d.pSW(10), vertical: d.pSH(10)),
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
            fillColor: bright == Brightness.dark
                ? AppColors.kDarkCardColor
                : Colors.white,
            filled: true,
            suffix: suffix,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                      bright == Brightness.dark ? Colors.white : Colors.black,
                  width: bright == Brightness.dark ? d.pSH(1) : d.pSH(0.5)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: d.pSH(0.5)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: d.pSH(0.5)),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        bright == Brightness.dark ? Colors.grey : Colors.grey,
                    width: d.pSH(0.5))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        bright == Brightness.dark ? Colors.grey : Colors.grey,
                    width: d.pSH(0.5))),
          ),
        ),
      ],
    );
  }
}
