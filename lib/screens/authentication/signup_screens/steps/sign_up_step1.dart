import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/models/user_register_model.dart';
import 'package:savyminds/providers/registration_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/authentication/login.dart';
import 'package:savyminds/utils/connection_check.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_intl_textfeild.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/intl_phone_number_input-develop/lib/intl_phone_number_input.dart';

class SignUpStep1 extends StatefulWidget {
  final void Function() nextStep;
  const SignUpStep1({Key? key, required this.nextStep}) : super(key: key);

  @override
  State<SignUpStep1> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  final GlobalKey<FormState> _firstSignUpFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AuthValidate authValidate = AuthValidate();

  PhoneNumber? phoneNumber;

  int usernameState = -1;
  int emailState = -1;
  int phoneNumberSate = -1;
  int name = -1;

  bool enabled = true;

  String state = "normal";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    final userRegister =
        Provider.of<RegistrationProvider>(context, listen: false);
    UserRegisterModel userInfo = userRegister.getUser();
    // Size size = MediaQuery.of(context).size;

    d.init(context);
    return Container(
      color: bright == Brightness.dark
          ? AppColors.kDarkScaffoldBackground
          : AppColors.kScaffoldBackground,
      padding:
          EdgeInsets.only(left: d.pSW(25), right: d.pSW(25), top: d.pSH(4)),
      child: Form(
        key: _firstSignUpFormKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: Platform.isIOS
                  ? d.getPhoneScreenHeight() - d.pSH(165)
                  : d.getPhoneScreenHeight() - d.pSH(135),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          SizedBox(
                            height: d.pSH(50),
                          ),
                          /////////////////////////////////////////////////////////
                          //////////////(- Firstname textfeild -)/////////////////
                          CustomTextFieldWithLabel(
                            enabled: enabled,
                            initialValue: userInfo.fullname,
                            controller: fullNameController,
                            labelText: 'Full name',
                            hintText: "Full name",
                            labelStyle: TextStyle(color: getColor(name)),
                            prefixIcon: Icons.edit_outlined,
                            //(Validation)//
                            validator: (value) =>
                                authValidate.validateFullName(value),

                            onSaved: (value) {
                              fullNameController.text = value!;
                            },
                          ),
                          SizedBox(
                            height: d.pSH(15),
                          ),
                          ////////////////////////////////////////////////////
                          //////////////(- Middle textfeild -)/////////////////
                          CustomTextFieldWithLabel(
                              enabled: enabled,
                              initialValue: userInfo.username,
                              controller: usernameController,
                              labelStyle:
                                  TextStyle(color: getColor(usernameState)),
                              labelText: usernameState == 0
                                  ? "Username not available"
                                  : 'Username',
                              hintText: "Username",
                              prefixIcon: Icons.person_outline_rounded,

                              //(Validation)//
                              validator: (value) =>
                                  authValidate.validateusername(value),
                              onSaved: (value) {
                                usernameController.text = value!;
                              }),
                          SizedBox(
                            height: d.pSH(15),
                          ),

                          ///////////////////////////////////////////////////////////
                          //////////////(- Phone number textfeild -)/////////////////
                          CustomIntlTextFeild(
                            enabled: enabled,
                            initialValue: userInfo.phoneNumber,
                            controller: numberController,
                            labelStyle:
                                TextStyle(color: getColor(phoneNumberSate)),
                            labelText: phoneNumberSate == 0
                                ? "Phone number not available"
                                : 'Phone number',
                            counterText: '',
                            onChanged: (text) {},
                            onSaved: (phone) {
                              phoneNumber = phone;
                            },
                          ),
                          SizedBox(
                            height: d.pSH(15),
                          ),

                          /////////////////////////////////////////////////////
                          //////////////(- Email textfeild -)/////////////////
                          CustomTextFieldWithLabel(
                            enabled: enabled,
                            initialValue: userInfo.email,
                            controller: emailController,
                            labelText: emailState == 0
                                ? "Email not available"
                                : 'Email',
                            hintText: "Email",
                            labelStyle: TextStyle(color: getColor(emailState)),
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            //(Validation)//
                            validator: (value) =>
                                authValidate.validateEmail(value),
                            onSaved: (value) {
                              emailController.text = value!;
                            },
                          ),

                          SizedBox(
                            height: d.pSH(25),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///////////////////////////////////////////////////
                        //////////////(- NEXT STEP Button -)/////////////////
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                              enabled: enabled,
                              onTap: () async {
                                bool hasNetWork =
                                    await ConnectionCheck().hasConnection();

                                if (hasNetWork) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_firstSignUpFormKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      enabled = false;
                                      state = "checking";
                                    });
                                    _firstSignUpFormKey.currentState!.save();
                                    userRegister.updateUserDetails(
                                      UserRegisterModel(
                                          fullname:
                                              fullNameController.text.trim(),
                                          username:
                                              usernameController.text.trim(),
                                          phoneNumber:
                                              phoneNumber?.phoneNumber ?? '',
                                          email: emailController.text.trim(),
                                          countryCode:
                                              phoneNumber?.dialCode ?? '',
                                          country: phoneNumber?.country ?? ''),
                                    );

                                    // ignore: use_build_context_synchronously
                                    final response = await Authentications()
                                        .checkAllCredentials(
                                            context: context,
                                            email: emailController.text,
                                            username: usernameController.text,
                                            phoneNumber:
                                                phoneNumber?.phoneNumber ?? '');

                                    if (response == "all good") {
                                      emailState = 1;
                                      usernameState = 1;
                                      phoneNumberSate = 1;
                                      name = 1;

                                      state = "passed";

                                      setState(() {});

                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        widget.nextStep();
                                      });
                                    } else if (response ==
                                        "something went wrong") {
                                      widget.nextStep();
                                    } else {
                                      if (response!.contains("email")) {
                                        emailState = 0;
                                      }
                                      if (response.contains("username")) {
                                        usernameState = 0;
                                      }
                                      if (response.contains("phone")) {
                                        phoneNumberSate = 0;
                                      }

                                      if (!response.contains("email")) {
                                        emailState = 1;
                                      }
                                      if (!response.contains("username")) {
                                        usernameState = 1;
                                      }
                                      if (!response.contains("phone")) {
                                        phoneNumberSate = 1;
                                      }

                                      name = 1;

                                      setState(() {
                                        enabled = true;
                                        state = "failed";
                                      });
                                    }
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'check internet connectivity');
                                }
                              },
                              child: getWidget(state)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ///////////////////////////////////////////////////////
                              //////////////(- login account -)/////////////////
                              TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const Login(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    fontSize: d.pSH(17),
                                    color: bright == Brightness.dark
                                        ? AppColors.kTrendEmojiColor
                                        : AppColors.kSecondaryColor,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Already have an account?  ",
                                    ),
                                    TextSpan(
                                        text: "Sign In",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: bright == Brightness.dark
                                                ? Colors.white
                                                : AppColors.kPrimaryColor)),
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
          ),
        ),
      ),
    );
  }

  Color getColor(int index) {
    switch (index) {
      case -1:
        return AppColors.kFormLabelColor;
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;

      default:
        return AppColors.kFormLabelColor;
    }
  }

  Widget getWidget(String state) {
    switch (state) {
      case "normal":
        return Text(
          'NEXT',
          style: TextStyle(
              color: Colors.white,
              fontSize: d.pSH(16),
              fontWeight: FontWeight.w500),
        );
      case "checking":
        return SizedBox(
            width: d.pSW(20),
            height: d.pSH(20),
            child: const CircularProgressIndicator(
              color: Colors.white,
            ));
      case "passed":
        return SizedBox(
            width: d.pSW(20),
            height: d.pSH(20),
            child: Icon(
              Icons.check,
              size: d.pSW(20),
              color: Colors.white,
            ));

      case "failed":
        return Text(
          'NEXT',
          style: TextStyle(
              color: Colors.white,
              fontSize: d.pSH(16),
              fontWeight: FontWeight.w500),
        );

      default:
        return Text(
          'NEXT',
          style: TextStyle(
              color: Colors.white,
              fontSize: d.pSH(16),
              fontWeight: FontWeight.w500),
        );
    }
  }
}
