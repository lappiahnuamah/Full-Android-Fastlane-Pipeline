import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/database/game_db_function.dart';
import 'package:savyminds/database/new_game_db_functions.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/providers/dark_theme_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/authentication/login_options_screen.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/utils/cache/save_secure.dart';
import 'package:savyminds/utils/enums/auth_eums.dart';
import 'package:savyminds/utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Create storage
  final storage = const FlutterSecureStorage();
  Uri? uri;
  @override
  void initState() {
    super.initState();
    ///////////// Set Theme ////////////////////////////
    Provider.of<DarkThemeProvider>(context, listen: false)
        .getThemeFromPreference();
    NewGameLocalDatabase.db();

    startTimer();
  }

  startTimer() async {
    navigatorPage(context);
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Scaffold(
      body: Stack(
        children: [
          const GameBackground(),
          /////////////////////////////////////////
          /////////////// TERATECK SOLUTIONS ////////////////
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(d.pSH(10.0)),
              child: Text(
                "®Terateck Solutions",
                style: TextStyle(fontSize: d.pSH(17)),
              ),
            ),
          ),
          /////////////////////////////////////////®Terateck Solutions
          /////////////// APP LOGO ////////////////
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImages.gameLogoSvg),
                SvgPicture.asset(
                  AppImages.quizWhizSvg,
                  height: d.pSH(50),
                ),
                const Text(
                  'Think you are smart?',
                  style: TextStyle(
                      fontFamily: 'Architects_Daughter',
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.8,
                      height: 1.5),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

/////////////
/////////////
//// Checking navigating function
  Future<void> navigatorPage(context) async {
    try {
      await GameLocalDatabase.db();
      // read all values
      Map<String, String> allValues = await allSecureStorage();

      //Have saved credentials
      if (allValues['credentials'] != null &&
          allValues['keepMeLoggedIn'] == "true") {
        bool tokenHasExpired = true;

        tokenHasExpired = allValues['tokenExpireDate'] != null &&
                allValues['tokenExpireDate']!.isNotEmpty
            ? DateTime.parse((allValues['tokenExpireDate']!))
                .isBefore(DateTime.now())
            : true;

        // Check is token has expired
        if (tokenHasExpired) {
          getNewApiAccessToken(allValues);
        }

        /// active token
        else {
          loadAndSendUserHome(context, allValues);
        }
      } else {
        nextScreen(context, const LoginOptionsScreen());
      }
    } catch (e) {
      nextScreen(context, const LoginOptionsScreen());
    }
  }

  void loadAndSendUserHome(context, Map<String, String> allValues) {
    Provider.of<UserDetailsProvider>(context, listen: false)
        .setAccessToken(allValues['accessToken']!);
    AppUser user =
        AppUser.fromUserDetails(json.decode(allValues['credentials']!));
    Provider.of<UserDetailsProvider>(context, listen: false)
        .setUserDetails(user);
    if (context.mounted) {
      GameFunction().getGameStreaks(context: context);
    }

    /////////////////// Navigate to HomePage////////////
    if (context.mounted) {
      nextScreen(context, const CustomBottomNav());
    }
  }

  getNewApiAccessToken(Map<String, String> allValues) async {
    try {
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      final refresh = allValues['refreshToken'] ?? '';
      final response = await Authentications()
          .apiTokenRefresh(context: context, refreshToken: refresh);

      //got response
      if (response != null) {
        final access = jsonDecode(response)['access'];

        //access token isn't null
        if (access != null) {
          AppUser user =
              AppUser.fromUserDetails(json.decode(allValues['credentials']!));

          //Token exxpire in 28 days
          user.aTokenExpireDate =
              DateTime.now().add(const Duration(days: 28)).toString();
          user.accessToken = access;
          user.refreshToken = refresh;

          //

          userDetailsProvider.setUserDetails(user);
          userDetailsProvider.setAccessToken(access);

          userSecureStorage(user, true, null);
          if (context.mounted) {
            GameFunction().getGameStreaks(context: context);
          }

          /////////////////// Navigate to HomePage////////////
          if (context.mounted) {
            nextScreen(context, const CustomBottomNav());
          }
        }
      } else {
        clearStorageData();
        if (context.mounted) {
          nextScreen(context, const LoginOptionsScreen());
        }
        Fluttertoast.showToast(msg: 'Session expired');
      }
    } catch (e) {
      clearStorageData();
      if (context.mounted) {
        nextScreen(context, const LoginOptionsScreen());
      }
      Fluttertoast.showToast(msg: 'Session expired');
    }
  }

/////////
/////////
//////////////  Auth 2.0
  checkAuth2Credetials(Map<String, String> allValues) async {
    if (allValues['authType'] != AuthType.google.name) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
          'profile',
          'https://www.googleapis.com/auth/user.phonenumbers.read',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
        clientId: Platform.isAndroid
            ? null
            : '642728101123-8j74rq7lvbm20ok30f7j1us977sdo93n.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signInSilently();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      if (googleSignInAuthentication?.accessToken != null && context.mounted) {
        final result = await Authentications().oauthGoogle(
          context: context,
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken,
          code: googleSignInAccount?.serverAuthCode,
        );

        if (result) {
          if (context.mounted) {
            GameFunction().getGameStreaks(context: context);
          }

          /////////////////// Navigate to HomePage////////////
          if (context.mounted) {
            nextScreen(context, const CustomBottomNav());
          }
        } else {
          clearStorageData();
          if (context.mounted) {
            nextScreen(context, const LoginOptionsScreen());
            Fluttertoast.showToast(msg: 'Session expired');
          }
          Fluttertoast.showToast(msg: 'Session expired');
        }
      } else {
        clearStorageData();
        if (context.mounted) {
          nextScreen(context, const LoginOptionsScreen());
          Fluttertoast.showToast(msg: 'Session expired');
        }
      }
    }

    //// Apple
    else {}
  }

  //google
  getNewGoogleToken() {}

//apple
  getewAppleToken() {}
}
