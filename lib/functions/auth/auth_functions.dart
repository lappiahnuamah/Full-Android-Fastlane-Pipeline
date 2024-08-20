import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savyminds/api_urls/auth_url.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/fcm_data.dart';
import 'package:savyminds/functions/auth/fcm_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/providers/registration_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/utils/block_utils.dart';
import 'package:savyminds/utils/cache/save_secure.dart';
import 'package:savyminds/utils/connection_check.dart';
import 'package:savyminds/utils/enums/auth_eums.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:provider/provider.dart';

const apiHeader = {
  "content-type": "application/json",
  "accept": "application/json",
};

class Authentications {
  /////////////////////////////////////////////////////
  //////////////(- Register User -)///////////////////
  Future<bool> registerUser(BuildContext context) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    final user =
        Provider.of<RegistrationProvider>(context, listen: false).getUser();
    bool hasNetWork = await ConnectionCheck().hasConnection();
    if (hasNetWork) {
      try {
        http.Response response = await http.post(
          Uri.parse(AuthUrl.register),
          headers: apiHeader,
          body: json.encode(user.toMap()),
        );
        log('register response: ${response.body}');
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Account created successfully");
          AppUser user0 = AppUser.fromJson(jsonDecode(response.body));
          userDetailsProvider.setAccessToken(user0.accessToken ?? '');
          userDetailsProvider.setUserDetails(user0);
          userSecureStorage(user0, true, json.decode(response.body)['user']);

          saveAuthType(AuthType.api);

          return true;
        } else {
          final errMessage = ErrorResponse.fromJson(json.decode(response.body));
          Fluttertoast.showToast(msg: '${errMessage.errorMsg} ${user.email}');
          return false;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Unexpected  error, try again');
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: 'No internet connection');
      return false;
    }
  }

  ////////////////////////////////////////////////////////
  //////////////(- Confirm OTP and Activate Account -)////
  Future activateAccountOTP(
      {required BuildContext context,
      required String otp,
      required String email,
      required String username}) async {
    try {
      final userRegProvider =
          Provider.of<RegistrationProvider>(context, listen: false);
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      http.Response response = await http.post(Uri.parse(AuthUrl.activateOtp),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({
            "otp": otp,
            "email": email,
            "username": username,
          }));

      if (response.statusCode == 200) {
        userRegProvider.clearUserData();

        AppUser user = AppUser.fromJson(jsonDecode(response.body));
        //Successful login
        userSecureStorage(user, true, json.decode(response.body)['user']);
        userDetailsProvider.setAccessToken(user.accessToken!);
        userDetailsProvider.setUserDetails(user);
        return 200;
      } else {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  Future<bool> checkUsername(
      {required BuildContext context, required String username}) async {
    try {
      http.Response response = await http.post(Uri.parse(AuthUrl.validateInfo),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({
            "username": username,
          }));

      log('username: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkDisplayName(
      {required BuildContext context, required String username}) async {
    try {
      http.Response response =
          await http.post(Uri.parse(AuthUrl.changeDisplayName),
              headers: {
                "content-type": "application/json",
                "accept": "application/json",
              },
              body: json.encode({
                "display_name": username,
              }));

      log('username: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> checkAllCredentials(
      {required BuildContext context,
      required String email,
      required String username,
      required String phoneNumber}) async {
    try {
      http.Response response = await http.post(Uri.parse(AuthUrl.validateInfo),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({
            "email": email,
            "username": username,
            "phone_number": phoneNumber
          }));
      if (response.statusCode == 200) {
        return "all good";
      } else if (response.statusCode == 400) {
        return response.body;
      } else {
        return "something went wrong";
      }
    } catch (e) {
      return null;
    }
  }

  Future checkPhoneNumber(
      {required BuildContext context,
      required String phoneNumber,
      required String email,
      required String username}) async {
    try {
      http.Response response = await http.post(Uri.parse(AuthUrl.validateInfo),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({"phone_number": phoneNumber}));
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      return null;
    }
  }

  Future checkEmail(
      {required BuildContext context, required String email}) async {
    try {
      http.Response response = await http.post(Uri.parse(AuthUrl.validateInfo),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({"email": email}));
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      return null;
    }
  }

  ////////////////////////////////////////////////////////
  //////////////(- Password Request OTP Account -)//////
  Future passwordRequestOTP(
      BuildContext context, String username, String email) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.passwordResetOtp),
        headers: apiHeader,
        body: json.encode({
          "email": email,
          "username": username,
        }),
      );
      if (response.statusCode == 201) {
        return 201;
      } else {
        return ErrorResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

///////////////////////////////////////////////////////
  //////////////(- Confirm Password Request OTP Account -)//////
  Future confirmPasswordRequestOTP(
      BuildContext context, String username, String email, String otp) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.confirmPasswordResetOtp),
        headers: apiHeader,
        body: json.encode({"email": email, "username": username, "otp": otp}),
      );
      if (response.statusCode == 200) {
        return 200;
      } else {
        return ErrorResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  //////////////////////////////////////////////////////
  //////////////(- Log In User -)//////////////////////
  Future<dynamic> loginUser(
      {required BuildContext context,
      required String username,
      required String email,
      required String password,
      required bool keepLoggedIn}) async {
    try {
      bool hasNetWork = await ConnectionCheck().hasConnection();

      if (hasNetWork) {
        final response = await http.post(
          Uri.parse(AuthUrl.login),
          headers: apiHeader,
          body: json.encode({
            "email": email,
            "username": username,
            "password": password,
          }),
        );
        log('response: ${response.body}');

        if (response.statusCode == 200) {
          AppUser user0 = AppUser.fromJson(jsonDecode(response.body));
          if (user0.isBlocked ?? false) {
            Fluttertoast.showToast(msg: 'Your account has been suspended');
            return null;
          } else {
            if (context.mounted) {
              GameFunction().getGameStreaks(context: context);
            }
            //Successful login
            userSecureStorage(
                user0, keepLoggedIn, json.decode(response.body)['user']);

            return user0;
          }
        } else {
          ErrorResponse error =
              ErrorResponse.fromJson(jsonDecode(response.body));
          if (error.errorCode == 125) {
            Fluttertoast.showToast(msg: 'Your account has been suspended');
            AppUser user = AppUser.fromUserDetails(error.userAccount ?? {});
            if (context.mounted) {
              BlockUtils.blockcUser(context: context, user: user);
            }
          }
          return error;
        }
      } else {
        Fluttertoast.showToast(msg: 'No internet connection');

        return 900;
      }
    } catch (e) {
      lg("$e");
      Fluttertoast.showToast(msg: 'Unexpected  error, try again');
      return 700;
    }
  }

  ////////////////////////////////////////////////////////
  //////////////(- Resend Activation OTP Account -)//////
  Future resendOTP(BuildContext context, String email, String username) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.resendActivationOtp),
        headers: apiHeader,
        body: json.encode({"email": email, "username": username}),
      );
      log('otp response: ${response.body}');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "OTP sent");
        return 200;
      } else {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  ////////////////////////////////////////////////////////
  //////////////(- Get OTP for  Account Registration -)//////
  Future getRegisterOTP(BuildContext context) async {
    final registerUser =
        Provider.of<RegistrationProvider>(context, listen: false).getUser();
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.sendRegisterOTP),
        headers: apiHeader,
        body: json.encode({
          "email": registerUser.email,
          "username": registerUser.username,
          'phone_number': registerUser.phoneNumber
        }),
      );
      log('otp response: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "OTP sent");
        return 200;
      } else {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  ////////////////////////////////////////////////////////
  /////////////(- Get OTP for  Account Registration -)//////
  Future verifyRegisterOTP(
      {required BuildContext context, required String otp}) async {
    final registerUser =
        Provider.of<RegistrationProvider>(context, listen: false).getUser();

    log('email: ${registerUser.email} otp: $otp  phone: ${registerUser.phoneNumber}');
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.verifyRegisterOTP),
        headers: apiHeader,
        body: json.encode({
          "email": registerUser.email,
          "otp": otp,
          'phone_number': registerUser.phoneNumber
        }),
      );

      log('otp verify response: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  ////////////////////////////////////////////////////////
  //////////////(- Resend Activation OTP Account -)//////
  Future resendPasswordResetOTP(
      BuildContext context, String username, String email) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.passwordResetOtp),
        headers: apiHeader,
        body: json.encode({
          "email": email,
          "username": username,
        }),
      );
      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: "OTP sent");
      } else {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  ///////////////////////////////////////////////////////
  //////////////(- Reset Password -)//////
  Future resetLoginPassword(BuildContext context, String password1,
      String email, String username, String password2) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.resetPassword),
        headers: apiHeader,
        body: json.encode({
          "email": email,
          "username": username,
          "new_password1": password1,
          "new_password2": password2,
        }),
      );
      if (response.statusCode == 201) {
        return 201;
      } else {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  Future<dynamic> emailVerify(
      BuildContext context, String username, String email) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.resendActivationOtp),
        headers: apiHeader,
        body: json.encode({
          "username": username,
          "email": email,
        }),
      );
      if (response.statusCode == 200) {
        return "success";
      } else if (response.statusCode == 400) {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

  getErrorValues(dynamic input, BuildContext context) {
    String errors = "";
    (json.decode(input) as Map).forEach((key, value) {
      if (value.runtimeType == List) {
        for (var value in (value as List)) {
          Fluttertoast.showToast(msg: value);
        }
      } else if (value.runtimeType == String) {
        Fluttertoast.showToast(msg: value);
      } else {
        errors = "Unexpected error";
      }
    });
    return errors;
  }

  bool checkInvalidAccount(dynamic input) {
    bool invalid = false;
    (jsonDecode(input) as Map).forEach((key, value) {
      if (value.runtimeType == List) {
        if (key == "is_active") {
          invalid = (value[0] == "False");
        }
      }
    });
    return invalid;
  }

  Future<bool> logout(
      {required String accessToken, required BuildContext context}) async {
    if (await ConnectionCheck().hasConnection()) {
      try {
        var res = await Dio().get(AuthUrl.logout,
            options: Options(
              headers: {"Authorization": "Bearer  $accessToken"},
              responseType: ResponseType.json,
            ));
        if (res.statusCode == 200) {
          await clearStorageData();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  /// Check password
  Future checkPassword({
    required BuildContext context,
    required String password,
    required String email,
  }) async {
    try {
      log(AuthUrl.checkPassword);
      http.Response response = await http.post(Uri.parse(AuthUrl.checkPassword),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({"email": email, 'password': password}));

      if (jsonDecode(response.body)['error'] == null) {
        return true;
      } else {
        return ErrorResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      log('error:$e');
      return ErrorResponse(errorMsg: 'Unexpected error, try again');
    }
  }

//////
  Future apiTokenRefresh({
    required BuildContext context,
    required String refreshToken,
  }) async {
    try {
      http.Response response = await http.post(Uri.parse(AuthUrl.tokenRefresh),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: json.encode({"refresh": refreshToken}));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  Future<bool> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: Platform.isAndroid
              ? "642728101123-j64hbdcp1k4dsnhp5tl4aqfms8k72knn.apps.googleusercontent.com"
              : null,
          scopes: <String>[
            'email',
            'profile',
            'https://www.googleapis.com/auth/user.phonenumbers.read',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
          serverClientId: Platform.isAndroid
              ? null
              : "642728101123-j64hbdcp1k4dsnhp5tl4aqfms8k72knn.apps.googleusercontent.com");
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication? gAuth =
          await googleAccount?.authentication;

      log('accessToken: ${gAuth?.accessToken} \n idToken: ${gAuth?.idToken} \n authCode ${googleAccount?.serverAuthCode}');

      if (googleAccount != null) {
        debugPrint('not null');
        if (context.mounted) {
          final result = await oauthGoogle(
            context: context,
            idToken: gAuth?.idToken,
            accessToken: gAuth?.accessToken,
            code: googleAccount.serverAuthCode,
          );

          return result;
        }

        return false;
      } else {
        log('google error: google account is null');

        Fluttertoast.showToast(msg: 'An unexpected error occurred');
        return false;
      }
    } catch (e) {
      log('catch error : $e');
      Fluttertoast.showToast(msg: 'An unexpected error occurred');
      return false;
    }
  }

  Future appleSignIn(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: Platform.isAndroid
            ? WebAuthenticationOptions(
                clientId: halloaAppleClientId,
                redirectUri: Uri.parse(
                  halloaAppleRedirectUrl,
                ))
            : null,
      );

      log('credential identityToken: ${credential.identityToken}');
      log('credential authorizationCode: ${credential.authorizationCode}');
      log('credential userIdentifier: ${credential.userIdentifier}');

      if (context.mounted) {
        final result = await oauthApple(
          context: context,
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
          code: credential.userIdentifier,
        );

        return result;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: 'An unexpected error occurred');
      return false;
    }
  }

  //////Auth Api
  Future<bool> oauthGoogle(
      {required BuildContext context,
      String? accessToken,
      String? code,
      String? idToken}) async {
    try {
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);

      http.Response response = await http.post(
        Uri.parse(AuthUrl.oauthGoogle),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: json.encode({
          // "access_token": accessToken,
          // "code": code,
          "auth_token": idToken
        }),
      );

      log('google response: ${response.body}');

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Login successful");
        AppUser user = AppUser.fromJson(jsonDecode(response.body));
        userDetailsProvider.setAccessToken(user.accessToken!);
        userDetailsProvider.setUserDetails(user);
        //Successful login
        userSecureStorage(user, true, json.decode(response.body)['user']);
        saveAuthType(AuthType.google);
        FirebaseMessaging.instance
            .getToken(vapidKey: FcmData.webTOken)
            .then((value) async {
          value != null ? await FCMFunctions().setFCMToken(value) : null;
        });

        if (context.mounted) {
          GameFunction().getGameStreaks(context: context);
        }

        return true;
      } else {
        final error = ErrorResponse.fromJson(jsonDecode(response.body));
        if ((error.error ?? []).isNotEmpty) {
          for (var element in (error.error ?? [])) {
            Fluttertoast.showToast(msg: '$element');
          }
        } else {
          Fluttertoast.showToast(
              msg: error.errorMsg ?? "An unexpected error occured");
        }

        //logout google
        final GoogleSignIn googleSignIn = GoogleSignIn();
        googleSignIn.isSignedIn().then((s) {
          googleSignIn.signOut();
        });
        return false;
      }
    } catch (e) {
      //logout google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.isSignedIn().then((s) {
        googleSignIn.signOut();
      });
      Fluttertoast.showToast(msg: 'An unexpected error occured');
      return false;
    }
  }

  Future<bool> oauthApple(
      {required BuildContext context,
      String? accessToken,
      String? code,
      String? idToken}) async {
    try {
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      http.Response response = await http.post(
        Uri.parse(AuthUrl.oauthApple),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: json.encode({
          "access_token": accessToken,
          "code": code,
          "id_token": idToken,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Login successful");
        AppUser user = AppUser.fromJson(jsonDecode(response.body));
        userDetailsProvider.setAccessToken(user.accessToken!);
        userDetailsProvider.setUserDetails(user);
        //Successful login
        userSecureStorage(user, true, json.decode(response.body)['user']);
        saveAuthType(AuthType.google);

        FirebaseMessaging.instance
            .getToken(vapidKey: FcmData.webTOken)
            .then((value) async {
          value != null ? await FCMFunctions().setFCMToken(value) : null;
        });

        if (context.mounted) {
          GameFunction().getGameStreaks(context: context);
        }

        return true;
      } else {
        final error = ErrorResponse.fromJson(jsonDecode(response.body));
        if ((error.error ?? []).isNotEmpty) {
          for (var element in (error.error ?? [])) {
            Fluttertoast.showToast(msg: '$element');
          }
        } else {
          Fluttertoast.showToast(
              msg: error.errorMsg ?? "An unexpected error occured");
        }
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An unexpected error occured');
      return false;
    }
  }

  ////////////////////////////////////////////////////////
  //////////////(- Delete Account -)////
  Future deactivateAccount({
    required BuildContext context,
    required String password,
  }) async {
    bool hasNetWork = await ConnectionCheck().hasConnection();
    if (hasNetWork) {
      final String _accessToken =
          Provider.of<UserDetailsProvider>(context, listen: false)
              .getAccessToken();

      try {
        http.Response _response = await http.post(Uri.parse(AuthUrl.deactivate),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": " Bearer $_accessToken"
            },
            body: jsonEncode({'password': password}));

        if (_response.statusCode == 200) {
          lg('deactivate response: ${_response.body}');
          return true;
        } else {
          lg('deactivate error: ${_response.body}');
          return ErrorResponse.fromJson(json.decode(_response.body));
        }
      } catch (e) {
        lg('deactivate acoount e :$e');
        return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
      }
    } else {
      return ErrorResponse(errorCode: 900, errorMsg: 'No internet connection');
    }
  }

  ////
  Future<dynamic> deactivateOtpSend(
      {required BuildContext context, required String email}) async {
    final String _accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    log('accessToken: $_accessToken');
    log('email: $email');
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.deactivateOtpSend),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": " Bearer $_accessToken"
        },
        body: json.encode({
          "email": email,
        }),
      );
      log('response.body: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }

//   {
//   "success": true,
//   "message": "OTP has been sent to your email or phone number."
// }

  Future<dynamic> deactivateOtpVerify(
      {required BuildContext context, required String otp}) async {
    final String _accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    try {
      http.Response response = await http.post(
        Uri.parse(AuthUrl.deactivateOtpSend),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": " Bearer $_accessToken"
        },
        body: json.encode({
          "otp": otp,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return ErrorResponse.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return ErrorResponse(errorCode: 700, errorMsg: 'Unexpected error');
    }
  }
}
