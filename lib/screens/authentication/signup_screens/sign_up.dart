import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/screens/authentication/signup_screens/steps/sign_up_step1.dart';
import 'package:savyminds/screens/authentication/signup_screens/steps/sign_up_step2.dart';
import 'package:savyminds/screens/authentication/signup_screens/steps/sign_up_step3.dart';
import 'package:savyminds/widgets/custom_stepper.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  /// The current Step of the HalloaSteps, where `0` is the first Step
  int _currentStep = 0;

  ///Switch the LinkLounge Step type between [HalloaStepperType.horizontal] and [HalloaStepperType.vertical]

  /// Returns [_currentStep]. and  [step].
  tapped(int step) {
    //on tap of a step
    setState(() => _currentStep = step);
  }

  ///Moves to the next [HalloaStep] if [_currentStep] is completed
  void continued() {
    //a method for handle continue button
    setState(() {});
    _currentStep < 2
        ? setState(() {
            _currentStep += 1;

            _currentStep = _currentStep;
          })
        // ignore: unnecessary_statements
        : null;
  }

  ///Moves to the previous [HalloaStep]
  cancel() {
    //method to handle cancellation
    // ignore: unnecessary_statements
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: d.getPhoneScreenHeight(),
        width: double.infinity,
        child: HalloaStepper(
          physics: const ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: <HalloaStep>[
            ///First HalloaStep
            ///
            /// Handles the user phone number entry
            HalloaStep(
              key: const Key("firstStep"),
              title: const Text(''),
              content: SignUpStep1(nextStep: continued),
              isActive: _currentStep >= 0,
              state: _currentStep == 0
                  ? HalloaStepState.editing
                  : _currentStep > 0
                      ? HalloaStepState.complete
                      : HalloaStepState.disabled,
            ),

            ///Second HalloaStep
            ///
            /// Handles the OTP entry
            HalloaStep(
              key: const Key("secondStep"),
              title: const Text(''),
              content: SignUpStep2(nextStep: continued),
              isActive: _currentStep == 1,
              state: _currentStep == 1
                  ? HalloaStepState.editing
                  : _currentStep > 1
                      ? HalloaStepState.complete
                      : HalloaStepState.disabled,
            ),

            ///Third HalloaStep
            ///
            /// Handles the scanning of ID Card
            HalloaStep(
                key: const Key("thirdStep"),
                title: const Text(''),
                content: const SignUpStep3(),
                isActive: _currentStep == 2,
                state: _currentStep == 2
                    ? HalloaStepState.editing
                    : _currentStep > 2
                        ? HalloaStepState.complete
                        : HalloaStepState.disabled),
          ],
        ),
      ),
    );
  }
}
