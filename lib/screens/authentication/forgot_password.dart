// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/resources/app_gradients.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';

import '../../utils/func_new.dart';
import '../../widgets/default_snackbar.dart';
import 'email_verification.dart';

GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
AuthValidate authValidate = AuthValidate();
String? email;
String? userName;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return PageTemplate(
      pageTitle: "Forgot Password",
      backgroundGradient: AppGradients.landingGradient,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: d.pSH(50), left: d.pSW(25), right: d.pSW(25)),
              child: Form(
                key: emailFormKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    ////////////////////////////////////////////////////////////////////
                    //////////////(- Display enter email address or username text -)/////////////////

                    Text("Retrieve your password in less than a minute",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: d.pSH(17),
                        )),

                    SizedBox(
                      height: d.pSH(50),
                    ),
                    ///////////////////////////////////////////////////
                    //////////////(- Email textfeild -)/////////////////
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
                      child: CustomTextFieldWithLabel(
                        noPrefix: true,
                        controller: emailController,
                        labelText: 'Email / username',
                        initialValue:
                            widget.username != "" ? widget.username : null,
                        //(Validation)//
                        validator: (value) =>
                            authValidate.validateEmailUsername(value),
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: d.pSH(30),
                    ),

                    Text(
                        "A 6-digit OTP will be sent to your email to help you reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: d.pSH(14),
                        )),

                    SizedBox(
                      height: d.pSH(30),
                    ),

                    //////////////////////////////////////////////////
                    //////////////(- Get OTP Button -)/////////////////
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
                        child: CustomButton(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (emailFormKey.currentState!.validate()) {
                                emailFormKey.currentState!.save();
                                setState(() {
                                  isLoading = true;
                                });
                                if ((RegExp("^[a-zA-Z0-9_.-]+@[a-zA-Z0-9.-]"))
                                    .hasMatch(emailController.text)) {
                                  email = emailController.text.trim();
                                  userName = "";
                                } else {
                                  email = "";
                                  userName = emailController.text.trim();
                                }
                                final passwordRequestResponse =
                                    await Authentications().passwordRequestOTP(
                                        context, userName!, email!);

                                ///////////////// OTP sent successfully ////////////////
                                if (passwordRequestResponse == 201) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showSnackBar(
                                      context, "OTP sent successfully");

                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            EmailVerification(
                                              pageFrom: "forgotpassword",
                                              username: userName ?? '',
                                              email: email ?? '',
                                            )),
                                  );
                                }
                                ///////////////// Error ////////////////

                                else if (passwordRequestResponse
                                    is ErrorResponse) {
                                  if (passwordRequestResponse.errorCode ==
                                      103) {
                                    //////////////////////// If account not activated //////////////
                                    //Send Otp
                                    final emailVerifyResponse =
                                        await Authentications().emailVerify(
                                            context,
                                            userName ?? "",
                                            email ?? "");

                                    if (emailVerifyResponse == "success") {
                                      //todo: stop dialog from loading
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showSnackBar(context,
                                          passwordRequestResponse.errorMsg);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmailVerification(
                                                      pageFrom: 'signup',
                                                      email: email ?? '',
                                                      username:
                                                          userName ?? '')));
                                    } else if (emailVerifyResponse
                                        is ErrorResponse) {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      showSnackBar(context,
                                          passwordRequestResponse.errorMsg);
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showSnackBar(context,
                                        passwordRequestResponse.errorMsg);
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Text(
                              'RECOVER ACCOUNT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: d.pSH(16),
                                  fontWeight: FontWeight.w500),
                            ))),
                  ]),
                ),
              ),
            ),
            ///////////////////////////////////////////////////////////
            ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
            ///////////////////////////////////////////////////////////
            ///////////// CIRCULAR PROGRESS INDICATOR///////////////////

            isLoading
                ? LoadIndicator(
                    child: appDialog(
                        context: context, loadingMessage: 'Requesting otp..'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
