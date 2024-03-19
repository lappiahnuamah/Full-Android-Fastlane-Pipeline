import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/user_register_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_intl_textfeild.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/intl_phone_number_input-develop/lib/intl_phone_number_input.dart';
import 'package:savyminds/widgets/page_template.dart';

class Auth2Login extends StatefulWidget {
  const Auth2Login({super.key, required this.isApple, required this.user});
  final bool isApple;

  final UserRegisterModel user;

  @override
  State<Auth2Login> createState() => _Auth2LoginState();
}

class _Auth2LoginState extends State<Auth2Login> {
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  PhoneNumber? phoneNumber;

  int usernameState = -1;
  int phoneNumberSate = -1;
  bool enabled = true;
  AuthValidate authValidate = AuthValidate();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: '',
      child: Container(
        padding:
            EdgeInsets.only(left: d.pSW(25), right: d.pSW(25), top: d.pSH(25)),
        child: SingleChildScrollView(
          child: Form(
            key: _authFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Addiional Information',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: d.pSH(18)),
                ),
                SizedBox(height: d.pSH(15)),
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",
                    style: TextStyle(
                      fontSize: d.pSH(17),
                    )),
                Text(
                  'type:${widget.isApple ? 'Apple' : 'Google'}\nfullame: ${widget.user.fullname}\nemail:${widget.user.email}\nidToken:${widget.user.idToken}\nid: ${widget.user.auth2Id}\naccessToken:${widget.user.auth2AcceessToken}',
                  style: const TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: d.pSH(35),
                ),
                ////////////////////////////////////////////////////
                //////////////(- Middle textfeild -)/////////////////
                CustomTextFieldWithLabel(
                    enabled: enabled,
                    controller: usernameController,
                    labelStyle: TextStyle(color: getColor(usernameState)),
                    labelText: usernameState == 0
                        ? "Username not available"
                        : 'Username',
                    hintText: "Username",
                    prefixIcon: Icons.person_outline_rounded,

                    //(Validation)//
                    validator: (value) => authValidate.validateusername(value),
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
                  controller: numberController,
                  labelStyle: TextStyle(color: getColor(phoneNumberSate)),
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
                  height: d.pSH(55),
                ),
                CustomButton(
                    enabled: !isLoading,
                    key: const Key('login-button'),
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_authFormKey.currentState?.validate() ?? true) {
                        _authFormKey.currentState?.save();
                        //  register();
                      }
                      // lg('${widget.user.auth2AcceessToken}:;;;;;;;;;; ${widget.user.idToken} : ${widget.user.googleCode}');
                    },
                    child: isLoading
                        ? SizedBox(
                            width: d.pSW(30),
                            child: const CircularProgressIndicator(
                              color: AppColors.kWhite,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Done',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: d.pSH(16),
                                fontWeight: FontWeight.w500),
                          )),
              ],
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

  ////////////////////////////////////////
  ///////////  register User  ///////////
}
