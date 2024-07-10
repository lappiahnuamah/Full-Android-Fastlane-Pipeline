import '../constants.dart';

class AuthUrl {
  static const baseUrl = "$halloaBaseUrl/accounts/v1/";

  static const String register = "${baseUrl}signup/";
  static const String login = "${baseUrl}login/";
  static const String logout = "${baseUrl}logout/";

  static const String activateOtp = "${baseUrl}activate-account/";
  static const String passwordResetOtp = "${baseUrl}password-reset-otp/";
  static const String confirmPasswordResetOtp =
      "${baseUrl}confirm-password-reset-otp/";
  static const String resendActivationOtp = "${baseUrl}resend-activation-otp/";
  static const String resetPassword = "${baseUrl}password-reset/";

  static const String sendRegisterOTP = "${baseUrl}send-otp/";
  static const String verifyRegisterOTP = "${baseUrl}verify-otp/";

  ////// Get Access Token From Refresh Token ////////////
  static const String tokenRefresh = "${baseUrl}token/refresh/";

  //////////////////// Change Email /////////////////////
  static const String emailChangeOTP = "${baseUrl}email-change-otp/";
  static const String confirmEmailChange = "${baseUrl}email-change/";

  static const String validateInfo = "${baseUrl}validate-info/";

  static const String checkPassword = "${baseUrl}check-password";

  static const String oauthGoogle = "$halloaBaseUrl/oauth/google/";
  static const String oauthApple = "$halloaBaseUrl/oauth/apple/";

///////////////// Profile /
  static const String profile = "${baseUrl}profile/";
}
