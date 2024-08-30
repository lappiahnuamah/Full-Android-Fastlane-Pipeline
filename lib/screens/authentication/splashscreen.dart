import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/database/new_game_db_functions.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/providers/audio_provider.dart';
import 'package:savyminds/providers/dark_theme_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_gradients.dart';
import 'package:savyminds/resources/app_hero_tags.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/authentication/login_options_screen.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/enums/auth_eums.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Create storage
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
    Future.delayed(const Duration(seconds: 2), () {
      navigatorPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GameBackground(
            backgroundGradient: AppGradients.landingGradient,
          ),
          /////////////////////////////////////////
          /////////////// TERATECK SOLUTIONS ////////////////
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(d.pSH(10.0)),
              child: Text(
                "®Terateck Solutions",
                style: TextStyle(fontSize: getFontSize(17, size)),
              ),
            ),
          ),
          /////////////////////////////////////////
          /////////////// APP LOGO ////////////////
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: AppHeroTags.savvyMindsLogo,
                  child: SvgPicture.asset(AppImages.gameLogoSvg,
                      height: d.isTablet ? d.pSH(120) : null),
                ),
                Hero(
                  tag: AppHeroTags.savvyMindsText,
                  child: SvgPicture.asset(
                    AppImages.savvyMinds,
                    height: d.isTablet ? d.pSH(60) : d.pSH(50),
                  ),
                ),
                Text(
                  'Think you are smart?',
                  style: TextStyle(
                      fontFamily: 'Architects_Daughter',
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.8,
                      height: 1.5,
                      fontSize: d.isTablet ? getFontSize(18, size) : null),
                ),
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
      // read all values
      final credentials =
          SharedPreferencesHelper.getString(SharedPreferenceValues.credentials);
      final keepMeLoggedIn = SharedPreferencesHelper.getString(
          SharedPreferenceValues.keepMeLoggedIn);
      final tokenExpireDate = SharedPreferencesHelper.getString(
          SharedPreferenceValues.tokenExpireDate);
      final accessToken =
          SharedPreferencesHelper.getString(SharedPreferenceValues.accessToken);

      //Have saved credentials
      if (credentials.isNotEmpty && keepMeLoggedIn == "true") {
        bool tokenHasExpired = true;

        tokenHasExpired = tokenExpireDate.isNotEmpty
            ? DateTime.parse((tokenExpireDate)).isBefore(DateTime.now())
            : true;

        log('token has expired: ${tokenHasExpired}');
        // Check is token has expired
        if (tokenHasExpired) {
          getNewApiAccessToken(credentials: credentials);
        }

        /// active token
        else {
          loadAndSendUserHome(context,
              credentials: credentials, accessToken: accessToken);
        }
      } else {
        nextScreen(context, const LoginOptionsScreen());
      }
    } catch (e) {
      log('error: $e');
      nextScreen(context, const LoginOptionsScreen());
    }
  }

  Future<void> loadAndSendUserHome(BuildContext context,
      {required String credentials, required String accessToken}) async {
    log('access token: ${accessToken}');
    log('credentials: ${credentials}');
    AudioProvider audioProvider = context.read<AudioProvider>();
    Provider.of<UserDetailsProvider>(context, listen: false)
        .setAccessToken(accessToken);
    AppUser user = AppUser.fromSecureJson(json.decode(credentials));
    Provider.of<UserDetailsProvider>(context, listen: false)
        .setUserDetails(user);
    await audioProvider.loadCachedAudioSettings();
    if (context.mounted) {
      GameFunction().getGameStreaks(context: context);
    }

    /////////////////// Navigate to HomePage////////////
    if (context.mounted) {
      nextScreen(context, const CustomBottomNav());
    }
  }

  getNewApiAccessToken({required String credentials}) async {
    try {
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      final refresh = SharedPreferencesHelper.getString(
          SharedPreferenceValues.refreshToken);
      final response = await Authentications()
          .apiTokenRefresh(context: context, refreshToken: refresh);

      //got response
      if (response != null) {
        final access = jsonDecode(response)['access'];

        //access token isn't null
        if (access != null) {
          AppUser user = AppUser.fromUserDetails(json.decode(credentials));

          //Token exxpire in 28 days
          user.aTokenExpireDate =
              DateTime.now().add(const Duration(days: 28)).toString();
          user.accessToken = access;
          user.refreshToken = refresh;

          //

          userDetailsProvider.setUserDetails(user);
          userDetailsProvider.setAccessToken(access);

          SharedPreferencesHelper.userSecureStorage(user, true, null);
          if (context.mounted) {
            GameFunction().getGameStreaks(context: context);
          }

          /////////////////// Navigate to HomePage////////////
          if (context.mounted) {
            nextScreen(context, const CustomBottomNav());
          }
        }
      } else {
        SharedPreferencesHelper.clearCache();
        if (context.mounted) {
          nextScreen(context, const LoginOptionsScreen());
        }
        Fluttertoast.showToast(msg: 'Session expired');
      }
    } catch (e) {
      SharedPreferencesHelper.clearCache();
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
          SharedPreferencesHelper.clearCache();
          if (context.mounted) {
            nextScreen(context, const LoginOptionsScreen());
            Fluttertoast.showToast(msg: 'Session expired');
          }
          Fluttertoast.showToast(msg: 'Session expired');
        }
      } else {
        SharedPreferencesHelper.clearCache();
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
