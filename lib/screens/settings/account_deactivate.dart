import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/authentication/deactivate_otp_verify.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/page_template.dart';

class DeactivateAccount extends StatefulWidget {
  const DeactivateAccount({super.key});

  @override
  State<DeactivateAccount> createState() => _DeactivateAccountState();
}

class _DeactivateAccountState extends State<DeactivateAccount> {
  TextEditingController EmailController = TextEditingController();
  final GlobalKey<FormState> _deactivateEmailFormKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;

  String otpVerifyErrorMsg = '';

  bool isEmailVerified = false;

  String otp = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(children: [
      PageTemplate(
        pageTitle: 'Delete Account',
        child: Padding(
          padding: d.isTablet
              ? EdgeInsets.symmetric(vertical: d.pSH(30), horizontal: d.pSW(25))
              : EdgeInsets.all(d.pSH(20)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  child: SvgPicture.asset(
                    'assets/icons/good-bye.svg',
                    height: d.pSH(150),
                  ),
                ),
                SizedBox(height: d.pSH(10)),
                RichText(
                    text: TextSpan(
                  style: TextStyle(
                      fontSize: d.isTablet
                          ? getFontSize(14, size)
                          : getFontSize(16, size),
                      height: 1.5,
                      color: AppColors.kTextColor),
                  children: const [
                    TextSpan(text: 'We\'re sorry to see you leave!\n\n'),
                    TextSpan(
                        text:
                            'Your presence within our community has been invaluable, and your contributions have made a positive impact. We truly appreciate your engagement, and we hope you\'ll reconsider deleting your account. If there\'s an issue or concern that\'s prompted this decision, please don\'t hesitate to reach out to our Terateck Help Desk. Our dedicated team is ready to assist you and address any concerns promptly.\n\n'),
                    TextSpan(
                        text:
                            'However, if you still wish to proceed with deleting your account, please note the following steps:\n\n'),
                    TextSpan(
                        text: 'Account Deactivation: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "Your account will be temporarily placed on hold for a period of seven days. During this time, you have the option to reactivate your account at any time by simply logging in with your credentials on the login page.\n\n"),
                    TextSpan(
                        text: 'Permanent Deletion: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'If no action is taken within seven days, your account will be permanently deleted.\n\n'),
                    TextSpan(
                        text:
                            'After your account is deleted, you are always welcome to create a new account should you decide to return.\n\n'),
                    TextSpan(
                        text:
                            "We appreciate the time you've spent with us and hope you'll consider staying a part of our community."),
                  ],
                )),
                SizedBox(
                  height: d.pSH(10),
                ),
                Wrap(
                  children: [
                    CustomText(
                      label:
                          'If you have any questions or need assistance, please reach out to our ',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    InkWell(
                      onTap: () {
                        //Future.delayed(const Duration(), () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const HalloaWebView(
                        //             initialURL: HALLOA_HELP_URL),
                        //       ));
                        // });
                      },
                      child: CustomText(
                        label: 'Terateck help desk',
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        height: 1.5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const CustomText(
                      label: '.',
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    )
                  ],
                ),
                SizedBox(
                  height: d.pSH(24),
                ),
                const Divider(),
                SizedBox(
                  height: d.pSH(24),
                ),
                ///////////////////////////////////////////////////////
                //////////////(- Email textfeild -)/////////////////
                Form(
                  key: _deactivateEmailFormKey,
                  child: CustomTextFieldWithLabel(
                    controller: EmailController,
                    labelText: 'Email',
                    hintText: "Enter your email",
                    prefixIcon: Icons.mail_outlined,
                    validator: (value) => AuthValidate().validateEmail(value),
                    onChanged: (value) {
                      email = value ?? '';
                      setState(() {});
                      return '';
                    },
                    onSaved: (p0) {
                      email = p0 ?? "";
                    },
                    onTap: () {
                      _deactivateEmailFormKey.currentState?.reset();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: d.pSH(24),
                ),

                ///Verify / Deactivate button
                SizedBox(
                  height: d.isTablet ? d.pSH(45) : null,
                  width: double.infinity,
                  child: CustomButton(
                    onTap: () {
                      if (isEmailVerified) {
                        _deactivateAccount();
                      } else {
                        _sendEmailOTP();
                      }
                    },
                    height: d.isTablet ? d.pSH(60) : null,
                    child: Padding(
                      padding: EdgeInsets.all(d.pSH(6)),
                      child: Text(
                        isEmailVerified ? 'Deactivate' : 'Verify Email',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: d.pSH(17)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: d.pSH(24),
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
                  context: context,
                  loadingMessage: isEmailVerified
                      ? ' Deactivating account ...'
                      : 'Loading ...'),
            )
          : const SizedBox()
    ]);
  }

  ///
  ////Deactivate Accounts
  Future<void> _deactivateAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // var response = await AcccountFunctions()
    //     .deactivateAccount(context: context, Email: Email.trim());

    // if (response == true) {
    //   ContentManagement().clearAll();
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.clear();
    //   setState(() {
    //     isLoading = false;
    //   });
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const Login(),
    //     ),
    //   );
    // } else {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   if (response.runtimeType == ErrorResponse) {
    //     response = response as ErrorResponse;
    //     showSnackBar(context, response.errorMsg);
    //   }
    // }
  }

  Future<void> _sendEmailOTP() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_deactivateEmailFormKey.currentState?.validate() ?? false) {
      _deactivateEmailFormKey.currentState?.save();
      setState(() {
        isLoading = true;
      });

      var response = await Authentications()
          .deactivateOtpSend(context: context, email: email);
      setState(() {
        isLoading = false;
      });
      if (response == true) {
        showOTPVerifyDialog();
      } else if (response is ErrorResponse) {
        Fluttertoast.showToast(msg: response.errorMsg ?? 'Failed to send otp');
      }
    }
  }

  Future<void> _verifyOTP() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_deactivateEmailFormKey.currentState?.validate() ?? false) {
      _deactivateEmailFormKey.currentState?.save();
      setState(() {
        isLoading = true;
      });

      var response = await Authentications()
          .deactivateOtpVerify(context: context, otp: otp);
      setState(() {
        isLoading = false;
      });
      if (response == true) {
        //Log correct OTP
      } else if (response is ErrorResponse) {
        Fluttertoast.showToast(msg: response.errorMsg ?? 'Failed to send otp');
      }
    }
  }

  showOTPVerifyDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: d.pSW(15)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: d.pSW(15), vertical: d.pSH(25)),
          content: DeactivateOTPVerify(
            onResendOTP: () {},
            verifyOTP: (otpValue) {
              Navigator.pop(context);
              otp = otpValue;
              _verifyOTP();
            },
            isLoading: isLoading,
            errorMsg: otpVerifyErrorMsg,
          ),
        );
      },
    );
  }
}
