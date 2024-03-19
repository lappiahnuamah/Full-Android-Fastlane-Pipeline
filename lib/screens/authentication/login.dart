import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/fcm_data.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/functions/auth/fcm_functions.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/providers/dark_theme_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/authentication/email_verification.dart';
import 'package:savyminds/screens/authentication/forgot_password.dart';
import 'package:savyminds/screens/authentication/signup_screens/sign_up.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import '../../widgets/load_indicator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool keepMeLoggedIn = true;
  bool hidePassword = true;
  String username = "";
  String email = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthValidate authValidate = AuthValidate();
  bool isLoading = false;

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    d.init(context);
    double statusbar = MediaQuery.of(context).viewPadding.top;
    double height = MediaQuery.of(context).size.height - statusbar;
    Brightness bright = Theme.of(context).brightness;

    return Consumer<DarkThemeProvider>(
        builder: (BuildContext consumerContext, value, child) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: bright == Brightness.dark
                ? AppColors.kDarkTopBarColor
                : AppColors.kTopBarColor,
          ),
          child: PopScope(
            canPop: true,
            onPopInvoked: (popValue) => onWillPop(popValue),
            child: Scaffold(
              key: _scaffoldKey,
              body: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: Platform.isIOS ? height - d.pSH(32) : height,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: d.pSW(25),
                                // vertical: d.pSH(25),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.1,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text('Sign In',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: d.pSH(25),
                                              color: bright == Brightness.dark
                                                  ? Colors.white
                                                  : AppColors.kPrimaryColor,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Form(
                                      key: _loginFormKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /////////////////////////////////////////////////////////
                                          //////////////(- Display sign in text -)/////////////////

                                          SizedBox(
                                            height: d.pSH(25),
                                          ),
                                          ////////////////////////////////////////////////////
                                          //////////////(- Email textfeild -)/////////////////
                                          CustomTextFieldWithLabel(
                                            controller: usernameController,
                                            labelText: 'Username/Email',
                                            hintText: "Enter username or email",
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            prefixIcon:
                                                Icons.person_outline_rounded,
                                            onChanged: (value) {
                                              username = value!;
                                              return;
                                            },
                                            //(Validation)//
                                            validator: (value) => authValidate
                                                .validateNotEmpty(value),

                                            onSaved: (value) {
                                              usernameController.text = value!;
                                            },
                                          ),
                                          SizedBox(
                                            height: d.pSH(20),
                                          ),
                                          ///////////////////////////////////////////////////////
                                          //////////////(- Password textfeild -)/////////////////
                                          CustomTextFieldWithLabel(
                                            controller: passwordController,
                                            labelText: 'Password',
                                            hintText: "Enter password",
                                            obscureText: hidePassword,
                                            prefixIcon: Icons.lock_outline,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  hidePassword = !hidePassword;
                                                });
                                              },
                                              icon: Icon(
                                                hidePassword
                                                    ? Icons
                                                        .remove_red_eye_outlined
                                                    : Icons.visibility_off,
                                                size: d.pSH(22),
                                                color: bright == Brightness.dark
                                                    ? AppColors.kTrendEmojiColor
                                                    : AppColors.kIconColor,
                                              ),
                                            ),
                                            validator: (value) => authValidate
                                                .validateLoginPassword(value),
                                            onSaved: (value) {
                                              passwordController.text = value!;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //////////////////////////////////////////////////
                                  //////////////(- Login Button -)/////////////////
                                  SizedBox(
                                    height: height * 0.28,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CustomButton(
                                                key: const Key('login-button'),
                                                onTap: () async {
                                                  // final provider =Provider.of<LoadingProvider>(context, listen: false);

                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  if (_loginFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    _loginFormKey.currentState!
                                                        .save();
                                                    if ((RegExp(
                                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]"))
                                                        .hasMatch(
                                                            usernameController
                                                                .text)) {
                                                      email = usernameController
                                                          .text
                                                          .trim();
                                                      username = "";
                                                    } else {
                                                      email = "";
                                                      username =
                                                          usernameController
                                                              .text
                                                              .trim();
                                                    }
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    final userDetailsProvider =
                                                        Provider.of<
                                                                UserDetailsProvider>(
                                                            context,
                                                            listen: false);

                                                    final loginResponse =
                                                        await Authentications()
                                                            .loginUser(
                                                                context:
                                                                    context,
                                                                username:
                                                                    username,
                                                                email: email,
                                                                password:
                                                                    passwordController
                                                                        .text
                                                                        .trim(),
                                                                keepLoggedIn:
                                                                    keepMeLoggedIn);

                                                    if (loginResponse
                                                        is AppUser) {
                                                      userDetailsProvider
                                                          .setAccessToken(
                                                              loginResponse
                                                                  .accessToken!);
                                                      userDetailsProvider
                                                          .setUserDetails(
                                                              loginResponse);

                                                      FirebaseMessaging.instance
                                                          .getToken(
                                                              vapidKey: FcmData
                                                                  .webTOken)
                                                          .then((value) async {
                                                        value != null
                                                            ? await FCMFunctions()
                                                                .setFCMToken(
                                                                    value,
                                                                    loginResponse
                                                                        .outerId!)
                                                            : null;
                                                      });

                                                      setState(() {
                                                        isLoading = false;
                                                      });

                                                      // Navigator.of(context)
                                                      //     .push(
                                                      //   PageRouteBuilder(
                                                      //       pageBuilder: (_, __,
                                                      //               ___) =>
                                                      //           BottomNavigation(
                                                      //               uri: initialGlobalDeepLinkURI ??
                                                      //                   HalloaDeepLinkHandler()
                                                      //                       .initialUri ??
                                                      //                   HalloaDeepLinkHandler()
                                                      //                       .latestUri)),
                                                      //);
                                                    }
                                                    /////////////////////////////////////////// Inactive Account ////////////////
                                                    else if (loginResponse
                                                        is ErrorResponse) {
                                                      if (loginResponse
                                                              .errorCode ==
                                                          103) {
                                                        //////////////////////// If account not activated //////////////
                                                        //Send Otp
                                                        if (mounted) {
                                                          final emailVerifyResponse =
                                                              await Authentications()
                                                                  .emailVerify(
                                                                      context,
                                                                      username,
                                                                      email);

                                                          if (emailVerifyResponse ==
                                                              "success") {
                                                            //todo: stop dialog from loading
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            Fluttertoast.showToast(
                                                                msg: loginResponse
                                                                        .errorMsg ??
                                                                    "");
                                                            if (mounted) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => EmailVerification(
                                                                          pageFrom:
                                                                              'signup',
                                                                          email:
                                                                              email,
                                                                          username:
                                                                              username)));
                                                            }
                                                          } else if (emailVerifyResponse
                                                              is ErrorResponse) {
                                                            setState(() {
                                                              isLoading = false;
                                                            });

                                                            Fluttertoast.showToast(
                                                                msg: emailVerifyResponse
                                                                        .errorMsg ??
                                                                    "");
                                                          }
                                                        }
                                                      }
                                                      /////////////// Login Failed //////////////////////////
                                                      else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        Fluttertoast.showToast(
                                                            msg: loginResponse
                                                                    .errorMsg ??
                                                                '');
                                                      }
                                                    }
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'LOGIN',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: d.pSH(16),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            Align(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ForgotPassword(
                                                          username: username,
                                                        ),
                                                      ));
                                                },
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent),
                                                child: Text(
                                                  'Forgotten password',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: d.pSH(16),
                                                      color: bright ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFFF63E49),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ////////////////////////////////////////////////////////
                                        //////////////(- Create an account -)/////////////////
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: d.pSH(5)),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignUp(),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent),
                                            child: RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: d.pSH(17),
                                                    color: bright ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : AppColors
                                                            .kSecondaryColor,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "Don't have an account?  ",
                                                        style: TextStyle(
                                                          color: bright ==
                                                                  Brightness
                                                                      .dark
                                                              ? AppColors
                                                                  .kTrendEmojiColor
                                                              : AppColors
                                                                  .kSecondaryColor,
                                                        )),
                                                    TextSpan(
                                                        text: "Sign up",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: bright ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : AppColors
                                                                    .kPrimaryColor)),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const UnathorisedNavigator()));
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: d.pSH(28),
                                  color: bright == Brightness.dark
                                      ? const Color(0xFFE4E4E4)
                                      : AppColors.kSecondaryColor,
                                )),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                  onPressed: bright == Brightness.dark
                                      ? () {
                                          value.setTheme(1);
                                        }
                                      : () {
                                          value.setTheme(2);
                                        },
                                  icon: Icon(
                                    bright == Brightness.dark
                                        ? Icons.light_mode
                                        : Icons.dark_mode,
                                    size: d.pSH(28),
                                    color: bright == Brightness.dark
                                        ? const Color(0xFFE4E4E4)
                                        : AppColors.kSecondaryColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /////////////////////////////////////////////////////////
                  /////////// CIRCULAR PROGRESS INDICATOR///////////////////
                  isLoading
                      ? LoadIndicator(
                          child: appDialog(
                              context: context, loadingMessage: "signing in"))
                      : const SizedBox()
                ],
              ),
            ),
          ));
    });
  }

  Future<bool> onWillPop(bool? value) {
    if (!isLoading) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Double tap to exit app');
        return Future.value(false);
      } else {
        SystemNavigator.pop();
      }
    }
    return Future.value(false);
  }
}
