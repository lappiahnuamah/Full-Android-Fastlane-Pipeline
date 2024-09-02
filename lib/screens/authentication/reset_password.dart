// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_gradients.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_textfeild.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';
import '../../models/error_response.dart';
import '../../utils/func_new.dart';
import '../../widgets/default_snackbar.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, this.email, this.username, this.otp})
      : super(key: key);
  final String? email;
  final String? username;
  final String? otp;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool hidePassword = true;
  AuthValidate authValidate = AuthValidate();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;

    d.init(context);
    return PageTemplate(
      pageTitle: "Reset Password",
      backgroundGradient: AppGradients.landingGradient,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: d.pSH(60), left: d.pSW(25), right: d.pSW(25)),
              child: Form(
                key: _passwordFormKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    ////////////////////////////////////////////////////////
                    //////////////(-Setting new password -)/////////////////

                    Text(
                      "Create a new password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: d.pSH(17),
                      ),
                    ),

                    SizedBox(
                      height: d.pSH(40),
                    ),
                    /////////////////////////////////////////////////////////
                    //////////////(- Password textfeild -)/////////////////
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
                      child: CustomTextField(
                        noPrefix: true,
                        controller: passwordController,
                        labelText: 'New Password',
                        obscureText: hidePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off,
                            size: d.pSH(22),
                            color: bright == Brightness.dark
                                ? AppColors.kTrendEmojiColor
                                : AppColors.kIconColor,
                          ),
                        ),
                        onChanged: (value) {
                          passwordController.text = value!;
                          return;
                        },
                        validator: (value) =>
                            authValidate.validatePassword(value),
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: d.pSH(30),
                    ),
                    ///////////////////////////////////////////////////////
                    //////////////(- Confirm textfeild -)/////////////////
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
                      child: CustomTextField(
                        noPrefix: true,
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password',
                        obscureText: hidePassword,
                        validator: (value) =>
                            authValidate.validateConfirmPassword(
                          password: passwordController.text,
                          confirmPassword: value!,
                        ),
                        onSaved: (value) {
                          confirmPasswordController.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: d.pSH(30),
                    ),

                    Text(
                      "Your password must have at least 8 characters | 1 uppercase letter |\n 1 lowercase letter | 1 number | 1 symbol",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: d.pSH(13),
                      ),
                    ),

                    SizedBox(
                      height: d.pSH(30),
                    ),

                    ////////////////////////////////////////////////////////
                    //////////////(- Set Password Button -)/////////////////
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
                      child: CustomButton(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_passwordFormKey.currentState!.validate()) {
                              _passwordFormKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              final resetResponse = await Authentications()
                                  .resetLoginPassword(
                                      context,
                                      passwordController.text.trim(),
                                      widget.email ?? '',
                                      widget.username ?? '',
                                      widget.otp ?? '',
                                      confirmPasswordController.text.trim());

                              if (resetResponse == 201) {
                                setState(() {
                                  isLoading = false;
                                });
                                showSnackBar(
                                    context, "Password reset successfully");
                                Navigator.of(context).pushAndRemoveUntil(
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            const Login()),
                                    ((route) => false));
                              } else if (resetResponse is ErrorResponse) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (resetResponse.errorCode == 112) {
                                  showSnackBar(context, 'OTP has expired');
                                  Navigator.pop(context);
                                } else {
                                  showSnackBar(context, resetResponse.errorMsg);
                                }
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Text(
                            'CHANGE PASSWORD',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: d.pSH(14),
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                  ]),
                ),
              ),
            ),
            ///////////////////////////////////////////////////////////
            ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
            /////////////////////////////////////////////////////////
            isLoading
                ? LoadIndicator(
                    child: appDialog(
                        context: context, loadingMessage: "Please wait"))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
