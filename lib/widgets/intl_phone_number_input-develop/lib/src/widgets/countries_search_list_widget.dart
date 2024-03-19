import 'package:flutter/material.dart';
import '../../intl_phone_number_input_test.dart';
import '../models/country_model.dart';
import '../utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;

  const CountrySearchListWidget(
    this.countries,
    this.locale, {
    super.key,
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
  });

  @override
  CountrySearchListWidgetState createState() => CountrySearchListWidgetState();
}

class CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        const InputDecoration(labelText: 'Search by country name or dial code');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: const Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) {
              final String value = searchController.text.trim();
              return setState(
                () => filteredCountries = Utils.filterCountries(
                  countries: widget.countries,
                  locale: widget.locale,
                  value: value,
                ),
              );
            },
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];

              return DirectionalCountryListTile(
                country: country,
                locale: widget.locale,
                showFlags: widget.showFlags!,
                useEmoji: widget.useEmoji!,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      Navigator.of(context).pop(country);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final VoidCallback onTap;

  const DirectionalCountryListTile(
      {Key? key,
      required this.country,
      required this.locale,
      required this.showFlags,
      required this.useEmoji,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
        leading:
            (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
        title: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            '${Utils.getCountryName(country, locale)}',
            textDirection: Directionality.of(context),
            textAlign: TextAlign.start,
          ),
        ),
        subtitle: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            country.dialCode ?? '',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
          ),
        ),
        onTap: onTap);
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : country?.flagUri != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(
                          country?.flagUri ?? "",
                        ),
                      )
                    : const SizedBox.shrink(),
          )
        : const SizedBox.shrink();
  }
}
