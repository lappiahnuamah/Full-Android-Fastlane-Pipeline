import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/providers/dark_theme_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/authentication/login.dart';
import 'package:savyminds/screens/authentication/signup_screens/sign_up.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';

class LoginOptionsScreen extends StatefulWidget {
  const LoginOptionsScreen({super.key});

  @override
  State<LoginOptionsScreen> createState() => _LoginOptionsScreenState();
}

class _LoginOptionsScreenState extends State<LoginOptionsScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;

    return PopScope(
      canPop: false,
      child: PageTemplate(
        hasTopNav: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(d.pSH(25), d.pSH(25), d.pSH(25), 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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
                  SizedBox(
                    height: d.pSH(100),
                  ),
                  CustomButton(
                    color: Colors.white,
                    onTap: () {
                      nextScreen(context, const Login());
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: d.pSH(16),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: d.pSH(25)),
                  CustomButton(
                    color: Colors.white,
                    onTap: () {
                      nextScreen(context, const SignUp());
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: d.pSH(16),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: d.pSH(25)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        const Text("OR",
                            style: TextStyle(
                              fontSize: 13.0,
                            )),
                        horizontalLine()
                      ],
                    ),
                  ),
                  ////Social Sign Ins //Google //Apple
                  socialButtons(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final result =
                            await Authentications().googleSignIn(context);
                        setState(() {
                          isLoading = false;
                        });

                        if (result) {
                          if (mounted) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      const CustomBottomNav()),
                            );
                          }
                        }
                      },
                      text: 'Continue with Google',
                      image: 'assets/images/google.png'),
                  const SizedBox(height: 18),
                  if (Platform.isIOS)
                    socialButtons(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final result =
                              await Authentications().appleSignIn(context);

                          setState(() {
                            isLoading = false;
                          });
                          if (result) {
                            if (mounted) {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const CustomBottomNav()),
                              );
                            }
                          }
                        },
                        text: 'Continue with Apple',
                        image: 'assets/images/apple.png',
                        apple: true),
                  SizedBox(height: d.pSH(25)),
                ],
              ),
            ),

            Positioned(
              right: d.pSH(5),
              top: d.pSH(70),
              child: Consumer<DarkThemeProvider>(
                  builder: (BuildContext consumerContext, value, child) {
                return IconButton(
                    onPressed: bright == Brightness.dark
                        ? () {
                            value.setTheme(1);
                          }
                        : () {
                            value.setTheme(2);
                          },
                    icon: Icon(
                      bright == Brightness.dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: d.pSH(28),
                      color: bright == Brightness.dark
                          ? const Color(0xFFE4E4E4)
                          : AppColors.kSecondaryColor,
                    ));
              }),
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
    );
  }

  /////////  Social Button Widget
  Widget socialButtons(
      {required VoidCallback onTap,
      required String text,
      required String image,
      bool? apple}) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: double.infinity,
        height: d.pSH(45),
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 24,
                width: 24,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                text,
                style: TextStyle(
                    fontFamily: "Popins",
                    color: Colors.black.withOpacity(0.9),
                    fontSize: getFontSize(15, size)),
              )
            ],
          ),
        )); 
  }

  //////////  Create line horizontal
  Widget horizontalLine() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          width: 30,
          height: 1.0,
          color: Colors.white24.withOpacity(.5),
        ),
      );
}
