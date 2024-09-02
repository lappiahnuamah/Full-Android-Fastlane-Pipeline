import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_text.dart';

class DeactivateOTPVerify extends StatefulWidget {
  const DeactivateOTPVerify(
      {super.key,
      required this.verifyOTP,
      required this.onResendOTP,
      this.isLoading = false,
      this.errorMsg = ""});
  final Function(String otp) verifyOTP;
  final VoidCallback onResendOTP;

  final bool isLoading;
  final String errorMsg;

  @override
  State<DeactivateOTPVerify> createState() => _DeactivateOTPVerifyState();
}

class _DeactivateOTPVerifyState extends State<DeactivateOTPVerify> {
  String otpText = "";
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  String loadingMessage = 'Please wait';

  @override
  Widget build(BuildContext context) {
    Brightness bright = Theme.of(context).brightness;
    Size size = MediaQuery.of(context).size;

    d.init(context);
    return SizedBox(
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: AppColors.kGameRed,
                )),
          ),
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
                  if (otpFormKey.currentState?.validate() ?? false) {
                    widget.verifyOTP(otpText);
                  }
                },
                validator: (value) => (AuthValidate().validateOTP(value)),
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
          if (widget.errorMsg.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: d.pSH(10)),
              child: CustomText(
                label: widget.errorMsg,
                color: AppColors.kGameRed,
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
                fontSize: d.pSH(15),
                color: bright == Brightness.dark
                    ? AppColors.kTrendEmojiColor
                    : AppColors.kSecondaryColor,
              ),
            ),
            TextButton(
              onPressed: widget.onResendOTP,
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child: Text("Resend",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: bright == Brightness.dark
                        ? Colors.white
                        : AppColors.kPrimaryColor,
                    fontFamily: "Sofia",
                    fontSize: d.pSH(15),
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
                fontSize: d.pSH(13),
              )),
        ],
      ),
    );
  }
}
