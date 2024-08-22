import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_text.dart';

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    super.key,
    required this.title,
    required this.onTapped,
  });
  final String title;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: d.pSW(10), vertical: d.pSH(4)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.borderPrimary,
          ),
        ),
        child: Center(
          child: CustomText(
            label: title,
            fontSize: 13,
            color: AppColors.borderPrimary,
          ),
        ),
      ),
    );
  }
}
