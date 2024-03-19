import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/models/user_register_model.dart';
import 'package:savyminds/providers/registration_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import '../../../../widgets/load_indicator.dart';

class SignUpStep2 extends StatefulWidget {
  final void Function() nextStep;
  const SignUpStep2({Key? key, required this.nextStep}) : super(key: key);

  @override
  State<SignUpStep2> createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  final GlobalKey<FormState> _secondSignUpFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController schoolController = TextEditingController();
  TextEditingController hallController = TextEditingController();

  AuthValidate authValidate = AuthValidate();
  bool hidePassword = true;
  String? uniDropDownValue;
  String? hallDropDownValue;
  List<String> hallList = [];
  List<String> universitiesList = [];

  bool loadingHall = true;

  bool hallEnabled = false;
  bool isLoading = false;

  bool checkPassword = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Brightness bright = Theme.of(context).brightness;

    d.init(context);
    final userRegister =
        Provider.of<RegistrationProvider>(context, listen: false);

    return PopScope(
      canPop: !isLoading,
      child: Container(
        height: d.getPhoneScreenHeight(),
        color: bright == Brightness.dark
            ? AppColors.kDarkScaffoldBackground
            : AppColors.kScaffoldBackground,
        child: SafeArea(
          child: SizedBox(
            child: Stack(
              children: [
                Form(
                  key: _secondSignUpFormKey,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: d.pSW(25), right: d.pSW(25), top: d.pSH(4)),
                    child: Scaffold(
                      body: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Stack(
                              children: [
                                Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /////////////////////////////////////////////////////////
                                          //////////////(- Display sign up text -)/////////////////

                                          SizedBox(
                                            height: d.pSH(25),
                                          ),

                                          SizedBox(
                                            height: d.pSH(20),
                                          ),

                                          ///////////////////////////////////////////////////////
                                          //////////////(- Password textfeild -)/////////////////
                                          CustomTextFieldWithLabel(
                                            controller: passwordController,
                                            labelText: 'Password',
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
                                            onChanged: (value) {
                                              passwordController.text = value!;
                                              return;
                                            },
                                            validator: (value) => authValidate
                                                .validatePassword(value),
                                            onSaved: (value) {
                                              passwordController.text = value!;
                                            },
                                          ),
                                          SizedBox(
                                            height: d.pSH(15),
                                          ),

                                          ///////////////////////////////////////////////////////
                                          //////////////(-Confirm  Password textfeild -)/////////////////
                                          CustomTextFieldWithLabel(
                                            controller:
                                                confirmPasswordController,
                                            labelText: 'Confirm Password',
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
                                            onChanged: (value) {
                                              confirmPasswordController.text =
                                                  value!;
                                              return;
                                            },
                                            validator: (value) => authValidate
                                                .validateConfirmPassword(
                                              password: passwordController.text,
                                              confirmPassword: value!,
                                            ),
                                            onSaved: (value) {
                                              confirmPasswordController.text =
                                                  value!;
                                            },
                                          ),
                                          SizedBox(
                                            height: d.pSH(25),
                                          ),

                                          //Terms
                                          Wrap(
                                            children: [
                                              Text(
                                                'By signing up, you agree to our ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize:
                                                      getFontSize(16, size),
                                                  height: 1.5,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             const AboutApp()));
                                                },
                                                child: Text('Terms',
                                                    style: TextStyle(
                                                      color: bright ==
                                                              Brightness.dark
                                                          ? AppColors
                                                              .kDarkPrimaryColor
                                                          : AppColors
                                                              .kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          getFontSize(16, size),
                                                      height: 1.5,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             const AboutApp()));
                                                },
                                                child: Text(' and',
                                                    style: TextStyle(
                                                      color: bright ==
                                                              Brightness.dark
                                                          ? AppColors
                                                              .kDarkPrimaryColor
                                                          : AppColors
                                                              .kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          getFontSize(16, size),
                                                      height: 1.5,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             const AboutApp()));
                                                },
                                                child: Text(' Privacy Policy.',
                                                    style: TextStyle(
                                                      color: bright ==
                                                              Brightness.dark
                                                          ? AppColors
                                                              .kDarkPrimaryColor
                                                          : AppColors
                                                              .kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          getFontSize(16, size),
                                                      height: 1.5,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: d.pSH(25),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ///////////////////////////////////////////////////
                                //////////////(- NEXT STEP Button -)/////////////////
                                Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                      onTap: checkPassword
                                          ? () {}
                                          : () async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (_secondSignUpFormKey
                                                  .currentState!
                                                  .validate()) {
                                                _secondSignUpFormKey
                                                    .currentState!
                                                    .save();
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                // check
                                                userRegister.updateUserDetails(
                                                  UserRegisterModel(
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                  ),
                                                );
                                                var response =
                                                    await Authentications()
                                                        .checkPassword(
                                                  context: context,
                                                  email: userRegister
                                                          .registerUser.email ??
                                                      '',
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                );
                                                if (response is ErrorResponse) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: response.errorMsg ??
                                                          '');
                                                } else {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  widget.nextStep();
                                                }
                                              }
                                            },
                                      child: Text(
                                        'NEXT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: d.pSH(16),
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///////////////////////////////////////////////////////////
                ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
                /////////////////////////////////////////////////////////
                isLoading
                    ? LoadIndicator(
                        child: appDialog(
                            context: context,
                            loadingMessage: "Checking password acceptance"))
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
