import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/database/game_db_function.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/providers/dark_theme_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/cache/save_secure.dart';
import 'package:savyminds/utils/enums/auth_eums.dart';
import 'package:savyminds/utils/shared_pref_utils.dart';

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
    startTimer();
  }

  startTimer() async {
    navigatorPage(context);
  }

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    SharedPreferenceUtils.init();
    d.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: bright == Brightness.dark
              ? AppColors.kDarkTopBarColor
              : AppColors.kScaffoldBackground,
        ),
        child: Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
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
                    Image.asset(
                      "assets/images/hc_logo.png",
                      height: d.pSH(150),
                      width: d.pSH(150),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: d.pSH(15),
                    ),
                    Text(
                      kAppName,
                      style: TextStyle(
                          fontSize: d.pSH(25), fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: d.pSH(50),
                    )
                  ],
                ),
              ),
            ],
          )),
        ));
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const UnathorisedNavigator()),
        // );
      }
    } catch (e) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const UnathorisedNavigator()),
      // );
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => BottomNavigation(
    //           uri: initialGlobalDeepLinkURI ??
    //               HalloaDeepLinkHandler().initialUri ??
    //               HalloaDeepLinkHandler().latestUri)),
    // );
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BottomNavigation(
          //           uri: initialGlobalDeepLinkURI ??
          //               HalloaDeepLinkHandler().initialUri ??
          //               HalloaDeepLinkHandler().latestUri)),
          // );
        }
      } else {
        clearStorageData();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const UnathorisedNavigator()),
        // );
        Fluttertoast.showToast(msg: 'Session expired');
      }
    } catch (e) {
      clearStorageData();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const UnathorisedNavigator()),
      // );
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
            : '1011318011254-pmvib2hippl2rvpla1b8i10uhcn6jvru.apps.googleusercontent.com',
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BottomNavigation(
          //           uri: initialGlobalDeepLinkURI ??
          //               HalloaDeepLinkHandler().initialUri ??
          //               HalloaDeepLinkHandler().latestUri)),
          // );
        } else {
          clearStorageData();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => const UnathorisedNavigator()),
          // );
          Fluttertoast.showToast(msg: 'Session expired');
        }
      } else {
        clearStorageData();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const UnathorisedNavigator()),
        // );
        Fluttertoast.showToast(msg: 'Session expired');
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
