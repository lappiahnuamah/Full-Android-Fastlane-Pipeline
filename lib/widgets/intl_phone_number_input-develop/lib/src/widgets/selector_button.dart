import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';


import '../../intl_phone_number_input.dart';
import '../../intl_phone_number_input_test.dart';
import '../models/country_model.dart';
import 'countries_search_list_widget.dart';
import 'item.dart';

/// [SelectorButton]
class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bright = Theme.of(context).brightness;
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: const Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                    country: country,
                    showFlag: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    leadingPadding: selectorConfig.leadingPadding,
                    trailingSpace: selectorConfig.trailingSpace,
                    textStyle: selectorTextStyle,
                  ),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                ),
              )
            : Item(
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                leadingPadding: selectorConfig.leadingPadding,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorTextStyle,
              )
        : Padding(
            padding: EdgeInsets.only(right: d.pSW(5)),
            child: MaterialButton(
              key: const Key(TestHelper.DropdownButtonKeyValue),
              padding: EdgeInsets.zero,
              minWidth: 0,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: bright == Brightness.dark
                          ? AppColors.kDarkBorderColor
                          : AppColors.kBorderColor,
                      width: d.pSH(0.5),),
                  borderRadius: BorderRadius.circular(d.pSH(4))),
              color: bright == Brightness.dark
                  ? AppColors.kDarkCardColor
                  : Colors.white,
              onPressed: countries.isNotEmpty &&
                      countries.length > 1 &&
                      isEnabled
                  ? () async {
                      Country? selected;
                      if (selectorConfig.selectorType ==
                          PhoneInputSelectorType.BOTTOM_SHEET) {
                        selected = await showCountrySelectorBottomSheet(
                            context, countries, context);
                        // lg('selected country: $selected');
                      } else {
                        selected =
                            await showCountrySelectorDialog(context, countries);
                      }

                      if (selected != null) {
                        onCountryChanged(selected);
                      }
                    }
                  : null,
              child: Padding(
                padding: EdgeInsets.only(
                    left: d.pSW(9),
                    right: d.pSW(0),
                    top: d.pSH(12.4),
                    bottom: d.pSH(12.4)),
                child: Item(
                  country: country,
                  showFlag: selectorConfig.showFlags,
                  useEmoji: selectorConfig.useEmoji,
                  leadingPadding: selectorConfig.leadingPadding,
                  trailingSpace: selectorConfig.trailingSpace,
                  textStyle: selectorTextStyle,
                ),
              ),
            )
          );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          withCountryNames: false,
          trailingSpace: selectorConfig.trailingSpace,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(
      BuildContext inheritedContext, List<Country> countries) {
    return showDialog(
      context: inheritedContext,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: Directionality(
          textDirection: Directionality.of(inheritedContext),
          child: SizedBox(
            width: double.maxFinite,
            child: CountrySearchListWidget(
              countries,
              locale,
              searchBoxDecoration: searchBoxDecoration,
              showFlags: selectorConfig.showFlags,
              useEmoji: selectorConfig.useEmoji,
              autoFocus: autoFocusSearchField,
            ),
          ),
        ),
      ),
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(BuildContext inheritedContext,
      List<Country> countries, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return showModalBottomSheet(
      context: inheritedContext,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor:
          bright == Brightness.dark ? null : AppColors.kScaffoldBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      useSafeArea: selectorConfig.useBottomSheetSafeArea,
      constraints: BoxConstraints(maxHeight: size.height * 0.7),
      builder: (BuildContext context) {
        return Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: ShapeDecoration(
                color: Theme.of(context).canvasColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              child: CountrySearchListWidget(
                countries,
                locale,
                searchBoxDecoration: searchBoxDecoration,
                showFlags: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                autoFocus: autoFocusSearchField,
              ),
            ),
          ),
        ]);
      },
    );
  }
}
