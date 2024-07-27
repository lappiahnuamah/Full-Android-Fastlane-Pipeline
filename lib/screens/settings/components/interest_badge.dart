import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.isSelected,
      this.isFavorites = false})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isFavorites;

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;

    d.init(context);
    return Container(
      height: d.pSH(26),
      decoration: BoxDecoration(
        color: isFavorites
            ? AppColors.everGreen
            : isSelected
                ? AppColors.borderPrimary
                : null,
        borderRadius: BorderRadius.circular(23),
      ),
      child: TextButton(
        onPressed: onTap,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: d.pSW(9)),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
                side: isSelected
                    ? BorderSide.none
                    : BorderSide(
                        color: bright == Brightness.dark
                            ? Colors.white
                            : AppColors.hintTextBlack))),
        child: Text(
          text,
          style: TextStyle(
              fontSize: d.pSH(12.5),
              color: isSelected ? Colors.white : AppColors.hintTextBlack),
        ),
      ),
    );
  }
}
