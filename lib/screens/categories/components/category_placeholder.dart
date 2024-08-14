import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_text.dart';

class CategoryPlaceholder extends StatelessWidget {
  const CategoryPlaceholder(
      {super.key,
      this.height = 87,
      this.width = 103,
      this.label,
      required this.onTap});
  final double height;
  final double width;
  final String? label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: d.pSH(height),
        width: d.pSH(width),
        child: Stack(children: [
          SvgPicture.asset(
            'assets/icons/category_placeholder.svg',
            height: d.pSH(height),
            width: d.pSH(width),
            fit: BoxFit.fill,
          ),

          //
          Align(
            child: Padding(
              padding: EdgeInsets.all(d.pSH(width * 0.1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    label: '?',
                    color: AppColors.notSelectedColor,
                    fontSize: d.isTablet ? width * 0.16 : width * 0.2,
                  ),
                  CustomText(
                    label: label ?? 'Select Category',
                    fontSize: d.isTablet ? width * 0.06 : width * 0.1,
                    color: AppColors.notSelectedColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
