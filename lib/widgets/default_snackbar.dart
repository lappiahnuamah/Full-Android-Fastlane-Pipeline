import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/overlay_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';

showSnackBar(BuildContext context, msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 3.0,
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
    );
}

showGameNotification(BuildContext context, OverlayModel data) {
  showOverlayNotification((context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return Card(
      color: bright == Brightness.dark
          ? AppColors.kDarkBorderColor
          : AppColors.kGameScaffoldBackground,
      margin: EdgeInsets.fromLTRB(d.pSW(15), d.pSH(25), d.pSW(15), 0),
      child: InkWell(
          child: ListTile(
            title: Text(
              data.title,
              style: TextStyle(
                  fontSize: getFontSize(20, size),
                  fontFamily: 'Architects_Daughter',
                  color: AppColors.kGameBlue,
                  fontWeight: FontWeight.bold),
            ),
            leading: data.leadingImage == null
                ? null
                : SvgPicture.asset(
                    data.leadingImage ?? "",
                    width: 32,
                    height: 32,
                  ), //Icon(Icons.notifications),
            subtitle: data.subtitle == null
                ? null
                : Text(
                    data.subtitle ?? "",
                    style: TextStyle(
                      fontSize: getFontSize(16, size),
                      fontFamily: 'Architects_Daughter',
                      color: bright == Brightness.dark
                          ? AppColors.kGameDarkText2Color
                          : AppColors.kGameText2Color,
                    ),
                  ),
            contentPadding: EdgeInsets.all(d.pSH(10)),
            trailing: data.trailing,
          ),
          onTap: () {}),
    );
  }, duration: const Duration(seconds: 2));
}
