// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_gradients.dart';
import 'package:savyminds/screens/authentication/reset_password.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';
import '../../utils/func_new.dart';
import '../../widgets/default_snackbar.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification(
      {Key? key,
      required this.pageFrom,
      required this.email,
      required this.username})
      : super(key: key);

  final String pageFrom;
  final String email;
  final String username;

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  String otpText = "";
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  String loadingMessage = 'Please wait';

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;

    d.init(context);
    return PageTemplate(
      pageTitle: "Email Verification",
      backgroundGradient: AppGradients.landingGradient,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  top: d.pSH(60), left: d.pSW(25), right: d.pSW(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Enter 6-digit OTP sent to your email below",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bright == Brightness.dark
                            ? Colors.white
                            : AppColors.kSecondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: d.pSH(14),
                      )),

                  SizedBox(
                    height: d.pSH(30),
                  ),
                  //////////////////////////////////////////////////
                  /////////////(- OTP Feilds -)/////////////////
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: d.pSW(15.0)),
                    child: Form(
                      key: otpFormKey,
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        length: 6,
                        cursorHeight: d.pSH(16),
                        animationType: AnimationType.fade,
                        onCompleted: (v) async {
                          //Verify OTP entered
                          if (otpFormKey.currentState!.validate()) {
                            //////// Activate account////////////////
                            if (widget.pageFrom == "signup") {
                              setState(() {
                                loadingMessage = 'Activating acccount';
                                isLoading = true;
                              });
                              final activateResponse = await Authentications()
                                  .activateAccountOTP(
                                      context: context,
                                      otp: otpText,
                                      email: widget.email,
                                      username: widget.username);
                              if (activateResponse == 200) {
                                setState(() {
                                  isLoading = false;
                                });
                                showSnackBar(context, "Activated successfully");
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     PageRouteBuilder(
                                //         pageBuilder: (_, __, ___) =>
                                //             const PersonalizeShs()),
                                //     ((route) => false));
                              } else if (activateResponse is ErrorResponse) {
                                showSnackBar(
                                    context, activateResponse.errorMsg);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                loadingMessage = 'Verifying OTP';
                                isLoading = true;
                              });
                              //////// Allow password reset
                              final otpVerifyResponse = await Authentications()
                                  .confirmPasswordRequestOTP(context,
                                      widget.username , widget.email, otpText);
                              if (otpVerifyResponse == 200) {
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          ResetPassword(
                                            email: widget.email,
                                            username: widget.username,
                                            otp: otpText,
                                          )),
                                );
                              } else if (otpVerifyResponse is ErrorResponse) {
                                Fluttertoast.showToast(
                                    msg: otpVerifyResponse.errorMsg ?? '');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        validator: (value) =>
                            (AuthValidate().validateOTP(value)),
                        onChanged: (value) {
                          otpText = value;
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
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "I did not receive the code.",
                      style: TextStyle(
                        fontSize: d.pSH(17),
                        color: bright == Brightness.dark
                            ? AppColors.kTrendEmojiColor
                            : AppColors.kSecondaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          loadingMessage = 'Resending OTP ...';
                          isLoading = true;
                        });

                        ////////////////////////////// Activating account resend ////////////////////
                        if (widget.pageFrom == "signup") {
                          final resendResponse = await Authentications()
                              .resendOTP(
                                  context, widget.email, widget.username);

                          if (resendResponse is ErrorResponse) {
                            showSnackBar(context, resendResponse.errorMsg);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                        /////////////////////////////// password reset resend ///////////////////////////
                        else {
                          final resendResponse = await Authentications()
                              .resendPasswordResetOTP(
                                  context, widget.username, widget.email);

                          if (resendResponse is ErrorResponse) {
                            showSnackBar(context, resendResponse.errorMsg);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: Text("Resend",
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
                    height: d.pSH(10),
                  ),

                  Text("You can check your spam if OTP is not in your inbox",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: d.pSH(14),
                      )),
                ],
              ),
            ),
          ),
          ///////////////////////////////////////////////////////////
          ///////////// CIRCULAR PROGRESS INDICATOR///////////////////

          isLoading
              ? LoadIndicator(
                  child: appDialog(
                      context: context, loadingMessage: loadingMessage),
                )
              : Container(),
        ],
      ),
    );
  }

  void navigateUser(BuildContext context) {
    switch (widget.pageFrom) {
      case "forgotpassword":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const ResetPassword())));
        break;
      case "signup":
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: ((context) => const HomePage())));
        break;
    }
  }
}
