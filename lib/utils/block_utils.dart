import 'package:flutter/material.dart';
import 'package:savyminds/screens/authentication/blocked_profile_view.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth/app_user.dart';

class BlockUtils {
  static blockcUser(
      {required BuildContext context, required AppUser user}) async {
    SharedPreferencesHelper.clearCache();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlockedProfileView(
                    currentUser: user,
                    isMyAccount: true,
                  )));
    }
  }
}
