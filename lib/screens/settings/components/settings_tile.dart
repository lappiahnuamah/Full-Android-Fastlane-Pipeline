import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_text.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.trailing,
  });
  final String title;
  final String description;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: d.isTablet ? d.pSH(80) : d.pSH(60),

      ///  padding: EdgeInsets.symmetric(vertical: d.isTablet ? d.pSH(8) : 0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: Border(
            bottom: BorderSide(color: AppColors.hintTextBlack.withOpacity(0.6)),
            //  top: BorderSide(color: AppColors.hintTextBlack.withOpacity(0.6)),
          )),
      child: Center(
        child: ListTile(
          title: CustomText(
            label: title,
            fontSize: d.isTablet ? 14 : 16,
            fontWeight: FontWeight.w600,
          ),
          subtitle: description.isEmpty
              ? null
              : CustomText(
                  label: description,
                  fontWeight: FontWeight.w400,
                  color: AppColors.hintTextBlack,
                  fontSize: d.isTablet ? 10 : 12,
                ),
          onTap: onTap,
          trailing: trailing,
        ),
      ),
    );
  }
}
