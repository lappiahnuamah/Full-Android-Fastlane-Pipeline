import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
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
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _deactivatepasswordFormKey =
      GlobalKey<FormState>();
  bool hidePassword = true;
  String password = '';
  bool isLoading = false;
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
                //////////////(- Password textfeild -)/////////////////
                Form(
                  key: _deactivatepasswordFormKey,
                  child: CustomTextFieldWithLabel(
                    key: const ValueKey('password-deactivate'),
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
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off,
                        size: d.pSH(22),
                        color: AppColors.kIconColor,
                      ),
                    ),
                    validator: (value) =>
                        AuthValidate().validateLoginPassword(value),
                    onChanged: (value) {
                      password = value ?? '';
                      setState(() {});
                      return '';
                    },
                    onTap: () {
                      _deactivatepasswordFormKey.currentState?.reset();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: d.pSH(24),
                ),

                ///Deactivate button
                SizedBox(
                  height: d.isTablet ? d.pSH(45) : null,
                  width: double.infinity,
                  child: CustomButton(
                    onTap: password.isEmpty
                        ? () {
                            _deactivatepasswordFormKey.currentState?.validate();
                            setState(() {});
                            (() {});
                          }
                        : () {
                            _deactivateAccount();
                          },
                    height: d.isTablet ? d.pSH(60) : null,
                    child: Padding(
                      padding: EdgeInsets.all(d.pSH(6)),
                      child: Text(
                        'Deactivate',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: d.pSH(17)),
                      ),
                    ),
                    // style: TextButton.styleFrom(
                    //   backgroundColor: AppColors.kPrimaryColor,
                    // ),
                  ),
                )
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
                  loadingMessage: ' Deactivating account ...'))
          : const SizedBox()
    ]);
  }

  ///
  ////Deactivate Accounts
  Future _deactivateAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isLoading = true;
    });

    // var response = await AcccountFunctions()
    //     .deactivateAccount(context: context, password: password.trim());

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
}
