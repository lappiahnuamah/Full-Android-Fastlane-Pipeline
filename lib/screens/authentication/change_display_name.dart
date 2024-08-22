import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/auth/auth_functions.dart';
import 'package:savyminds/functions/auth/profile_functions.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_gradients.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/settings/personalization.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/page_template.dart';

class ChangeDisplayName extends StatefulWidget {
  const ChangeDisplayName(
      {super.key, required this.username, this.fromSettingsPage = false});
  final String username;
  final bool fromSettingsPage;

  @override
  State<ChangeDisplayName> createState() => _ChangeDisplayNameState();
}

class _ChangeDisplayNameState extends State<ChangeDisplayName> {
  TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  String username = "";
  bool isLoading = false;

  @override
  void initState() {
    usernameController.text = widget.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: widget.fromSettingsPage,
      child: PageTemplate(
          pageTitle: 'Change Display Name',
          backgroundGradient: AppGradients.landingGradient,
          child: Padding(
            padding: d.isTablet
                ? EdgeInsets.symmetric(
                    horizontal: size.width * 0.12, vertical: d.pSH(16))
                : EdgeInsets.symmetric(
                    horizontal: d.pSW(25), vertical: d.pSH(16)),
            child: Form(
              key: _nameFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    label:
                        "Please choose a display name that will be visible to others. Make sure it's unique, appropriate, and reflects how you'd like to be identified.",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 20),
                  ////////////////////////////////////////////////////
                  //////////////(- Email textfeild -)/////////////////
                  CustomTextFieldWithLabel(
                    initialValue: widget.username,
                    controller: usernameController,
                    labelText: 'Display Name',
                    hintText: "Enter display name",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.person_outline_rounded,
                    onChanged: (value) {
                      username = value ?? '';
                      return;
                    },
                    //(Validation)//
                    validator: (value) =>
                        AuthValidate().validateNotEmpty(value),

                    onSaved: (value) {
                      usernameController.text = value!;
                    },
                  ),
                  SizedBox(
                    height: d.pSH(40),
                  ),
                  CustomButton(
                    key: const Key('display-name-button'),
                    onTap: () async {
                      checkUsername();
                    },
                    child: isLoading
                        ? SizedBox(
                            width: d.pSW(20),
                            height: d.pSH(20),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: getFontSize(14, size),
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                  SizedBox(height: d.pSH(40)),
                  if (!widget.fromSettingsPage)
                    Align(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const Personalization()));
                          },
                          child: CustomText(
                            label: 'Skip',
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueBird,
                          )),
                    ),
                ],
              ),
            ),
          )),
    );
  }

  checkUsername() async {
    if (_nameFormKey.currentState?.validate() ?? false) {
      _nameFormKey.currentState?.save();

      setState(() {
        isLoading = true;
      });

      final result = await Authentications().checkDisplayName(
          context: context, username: usernameController.text);

      if (result == true) {
        final response = await ProfileFunctions().updateDisplayName(
            context: context, displayName: usernameController.text);
        if (response) {
          Fluttertoast.showToast(msg: 'Display name updated successfully');
          final userProvider = context.read<UserDetailsProvider>();
          userProvider.setDisplayName(usernameController.text);
          if (widget.fromSettingsPage) {
            Fluttertoast.showToast(msg: 'Display name updated successfully');
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const CustomBottomNav()),
            );
          }
        } else {
          Fluttertoast.showToast(msg: 'Failed to update display name');
        }
      } else {
        Fluttertoast.showToast(msg: 'Username is already taken');
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
