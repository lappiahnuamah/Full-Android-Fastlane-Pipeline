import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/intl_phone_number_input-develop/lib/intl_phone_number_input.dart';

class CustomIntlTextFeild extends StatefulWidget {
  const CustomIntlTextFeild(
      {super.key,
      required this.onChanged,
      this.hintText,
      this.labelStyle,
      this.labelText,
      this.controller,
      this.enabled,
      required this.onSaved,
      this.initialValue,
      this.readOnly,
      this.counterText,
      this.textfeildLabelText,
      this.ignoreBlanks = false});

  final TextEditingController? controller;
  final Function(String) onChanged;
  final Function(PhoneNumber?) onSaved;
  final TextStyle? labelStyle;
  final String? labelText;
  final String? hintText;
  final String? textfeildLabelText;
  final bool? enabled;
  final bool? readOnly;
  final String? initialValue;
  final String? counterText;
  final bool ignoreBlanks;

  @override
  State<CustomIntlTextFeild> createState() => _CustomIntlTextFeildState();
}

class _CustomIntlTextFeildState extends State<CustomIntlTextFeild> {
  PhoneNumber? initialValue;

  @override
  void initState() {
    getIInitialValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    d.init(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.labelText == null
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(bottom: 4, left: d.pSW(4)),
                  child: Text(
                    widget.labelText!,
                    style: widget.labelStyle ??
                        TextStyle(
                            color: bright == Brightness.dark
                                ? AppColors.kTrendEmojiColor
                                : AppColors.kFormLabelColor),
                  ),
                ),
          InternationalPhoneNumberInput(
            textFieldController: widget.controller,
            initialValue: initialValue,
            ignoreBlank: widget.ignoreBlanks,
            onInputChanged: (phone) =>
                widget.onChanged(phone.phoneNumber ?? ''),
            onSaved: (phone) => widget.onSaved(phone),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            selectorTextStyle: const TextStyle(
              fontSize: 14,
            ),
            spaceBetweenSelectorAndTextField: 0,
            inputDecoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: d.pSW(10), vertical: d.pSH(10)),
              fillColor: bright == Brightness.dark
                  ? AppColors.kDarkCardColor
                  : Colors.white,
              filled: true,
              counterText: widget.counterText,
              enabled: widget.enabled ?? true,
              labelText: widget.textfeildLabelText,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              hintStyle: TextStyle(
                  color: bright == Brightness.dark
                      ? AppColors.kTrendEmojiColor
                      : AppColors.kHintColor),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: bright == Brightness.dark
                        ? Colors.white54
                        : Colors.black54,
                    width: bright == Brightness.dark ? d.pSH(1) : d.pSH(0.5)),
              ),
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
            searchBoxDecoration: InputDecoration(
              labelStyle: TextStyle(
                  color: bright == Brightness.dark
                      ? AppColors.kTrendEmojiColor
                      : AppColors.kFormLabelColor),
              floatingLabelStyle: TextStyle(fontSize: d.pSH(20)),
              fillColor: bright == Brightness.dark
                  ? AppColors.kDarkCardColor
                  : Colors.white,
              filled: true,
              suffixIconConstraints: BoxConstraints(minWidth: d.pSW(50)),
              hintText: 'Search by country name or dial code',
              hintStyle: TextStyle(
                  color: bright == Brightness.dark
                      ? AppColors.kTrendEmojiColor
                      : AppColors.kHintColor),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: d.pSW(10), vertical: d.pSH(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: bright == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    width: bright == Brightness.dark ? d.pSH(1) : d.pSH(0.5)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: d.pSH(0.5)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: d.pSH(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: bright == Brightness.dark
                          ? Colors.grey
                          : Colors.grey,
                      width: d.pSH(0.5))),
            ),
          )
        ]);
  }

  getIInitialValue() async {
    if (widget.initialValue != null) {
      initialValue = await PhoneNumber.getRegionInfoFromPhoneNumber(
          widget.initialValue ?? '');
      setState(() {});
    }
  }
}
