import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class CategoryPlaceholder extends StatelessWidget {
  const CategoryPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: d.pSH(87),
      width: d.pSH(103),
      child: Stack(children: [
        SvgPicture.asset('assets/icons/category_placeholder.svg'),

        //
        Align(
          child: Padding(
            padding: EdgeInsets.all(d.pSH(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  label: '?',
                  color: AppColors.notSelectedColor,
                  fontSize: getFontSize(24, size),
                ),
                CustomText(
                  label: 'Select Category',
                  fontSize: getFontSize(12, size),
                  color: AppColors.notSelectedColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
