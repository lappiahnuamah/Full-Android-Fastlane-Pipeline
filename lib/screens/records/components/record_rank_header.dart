import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_text.dart';

class RecordRankHeader extends StatelessWidget {
  const RecordRankHeader(
      {super.key,
      required this.title,
      required this.onTapped,
      required this.isSelected});
  final String title;
  final VoidCallback onTapped;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTapped,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: d.pSW(10), vertical: d.pSH(4)),
        decoration: BoxDecoration(
          color: !isSelected ? null : AppColors.borderPrimary,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.blueBird,
                ),
        ),
        child: Center(
          child: CustomText(
            label: title,
            fontSize: 13,
            color: isSelected ? Colors.white : AppColors.blueBird,
          ),
        ),
      ),
    );
  }
}
