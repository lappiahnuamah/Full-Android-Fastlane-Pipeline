import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/models/user_register_model.dart';
import 'package:savyminds/providers/registration_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpStep3 extends StatefulWidget {
  const SignUpStep3({Key? key}) : super(key: key);

  @override
  State<SignUpStep3> createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final Duration duration = const Duration(milliseconds: 400);
  final Duration duration2 = const Duration(milliseconds: 1200);
  AnimationController? _controller;
  String? _otpText;
  AuthValidate authValidate = AuthValidate();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  bool sendingOTP = false;

  int otpCounter = 0;

  @override
  void initState() {
    super.initState();
    sendOTP();

    _controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserRegisterModel userInfo =
        Provider.of<RegistrationProvider>(context, listen: false).getUser();
    Brightness bright = Theme.of(context).brightness;
    Size size = MediaQuery.of(context).size;

    d.init(context);
    return PopScope(
      canPop: !isLoading,
      child: SizedBox(
          height: d.getPhoneScreenHeight(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: d.pSH(0), left: d.pSW(25), right: d.pSW(25)),
                  child: Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'We have sent a 6 digit OTP to \n ${userInfo.email ?? 'your email address'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: d.pSH(17),
                          ),
                        ),
                        SizedBox(
                          height: d.pSH(25),
                        ),
                        //////////////////////////////////////////////////
                        /////////////(- OTP Feilds -)/////////////////
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: d.pSW(15.0)),
                          child: Form(
                            key: _otpFormKey,
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.number,
                              cursorHeight: d.pSH(16),
                              textStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              length: 6,
                              animationType: AnimationType.fade,
                              onCompleted: (v) async {
                                register();
                              },
                              validator: (value) =>
                                  (AuthValidate().validateOTP(value)),
                              onChanged: (value) {
                                _otpText = value;
                              },
                              pinTheme: PinTheme(
                                activeColor: Colors.green,
                                inactiveColor: AppColors.kBorderColor,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                borderWidth: 1,
                                fieldHeight: d.pSH(40),
                                fieldWidth: d.pSH(40),
                                activeFillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: d.pSH(10),
                        ),
                        ///////////////////////////////////////////////////////
                        //////////////(- Resend OTP -)/////////////////
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                sendingOTP
                                    ? 'You will receive an OTP in'
                                    : "I did not receive the code.",
                                style: TextStyle(
                                  fontSize: d.pSH(17),
                                  color: bright == Brightness.dark
                                      ? AppColors.kTrendEmojiColor
                                      : AppColors.kSecondaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: sendingOTP
                                    ? () {}
                                    : () {
                                        sendOTP();
                                      },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent),
                                child: Text(
                                    sendingOTP
                                        ? "00:${otpCounter.toString().padLeft(2, "0")}"
                                        : "Resend",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: bright == Brightness.dark
                                          ? Colors.white
                                          : AppColors.kPrimaryColor,
                                      fontFamily: "Sofia",
                                      fontSize: d.pSH(16),
                                    )),
                              ),
                            ]),

                        SizedBox(
                          height: d.pSH(40),
                        ),
                        Text(
                          "Users with Ghanaian phone number will receive an OTP on both their email and phone number",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bright == Brightness.dark
                                ? Colors.grey
                                : Colors.grey,
                            fontSize: getFontSize(14, size),
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ///////////////////////////////////////////////////////////
              ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
              isLoading
                  ? LoadIndicator(
                      child: appDialog(
                          context: context, loadingMessage: "Registering user"))
                  : Container(),
            ],
          )),
    );
  }

  ////////////////////////////////////
  ///////////// Send OTP  ////////////
  void sendOTP() async {
    setState(() {});
    otpCounter = 20;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (otpCounter == 0) {
            timer.cancel();
            setState(() {
              sendingOTP = false;
            });
          } else {
            otpCounter--;
          }
        });
      }
    });
    setState(() {
      sendingOTP = true;
    });

    await Authentications().getRegisterOTP(context);
  }

  ////////////////////////////////////////
  ///////////  register User  ///////////
  void register() async {
    // Verify  entered OTP
    try {
      setState(() {
        isLoading = true;
      });
      final regProvider =
          Provider.of<RegistrationProvider>(context, listen: false);

      final activateResponse = await Authentications().verifyRegisterOTP(
        context: context,
        otp: _otpText!,
      );

      

      if (activateResponse is ErrorResponse) {
        Fluttertoast.showToast(msg: activateResponse.errorMsg ?? '');
        setState(() {
          isLoading = false;
        });
      } else {
        String registrationToken = activateResponse['registration_token'];

        regProvider.updateUserDetails(UserRegisterModel(
          registrationToken: registrationToken,
        ));

        if (mounted) {
          final registerSuccess = await Authentications().registerUser(context);
          if (registerSuccess) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Activated successfully");
            if (context.mounted) {
              nextScreen(context, const CustomBottomNav());
            }
          } else {
            setState(() {
              isLoading = false;
            });
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
