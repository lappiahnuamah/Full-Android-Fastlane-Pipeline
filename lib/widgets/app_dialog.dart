import 'package:flutter/material.dart';
import 'package:savyminds/resources/app_colors.dart';

class AppDialog {
  AppDialog._();

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          // set up the buttons

          Widget continueButton = TextButton(
            child: Text(
              "Yes",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color ??
                      AppColors.kSecondaryColor),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          );
          Widget cancelButton = TextButton(
            child: const Text(
              "No",
              style: TextStyle(color: AppColors.kPrimaryColor),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              continueButton,
              cancelButton,
            ],
          );

          // show the dialog

          return alert;
        });

    return result ?? false;
  }
}
