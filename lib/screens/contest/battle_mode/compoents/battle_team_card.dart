import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/widgets/custom_text.dart';

class BattleTeamCard extends StatelessWidget {
  const BattleTeamCard(
      {super.key, required this.teamName, required this.teamImage});
  final String teamName;
  final String teamImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: d.pSH(6), vertical: d.pSH(4)),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textBlack),
          borderRadius: BorderRadius.circular(30),
        ),
        constraints: BoxConstraints(
          minWidth: (size.width / 2) - d.pSH(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: d.pSH(25),
              width: d.pSH(25),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: EdgeInsets.all(d.pSH(0.5)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.textBlack),
                  shape: BoxShape.circle,
                  image: teamImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(teamImage), fit: BoxFit.cover)
                      : null),
              child: teamImage.isEmpty
                  ? Image.asset(AppImages.groupPicBackground, fit: BoxFit.cover)
                  : null,
            ),
            SizedBox(width: d.pSW(15)),
            CustomText(
              label: teamName,
              fontSize: 20,
              fontFamily: AppFonts.caveat,
            ),
          ],
        ));
  }
}
