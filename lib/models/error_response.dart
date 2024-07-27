import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorResponse {
  int? errorCode;
  String? errorMsg;
  Map<String, dynamic>? userAccount;
  List? error;

  ErrorResponse({this.errorCode, this.errorMsg});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    error = json['error'];
    errorMsg =
        json['errorMsg'] ?? ((json['error'] is String) ? json['error'] : '');
    userAccount = json['user_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }

  showErrorMessage(BuildContext context) {
    if ((error ?? []).isNotEmpty) {
      for (var element in (error ?? [])) {
        Fluttertoast.showToast(msg: '$element');
      }
    } else {
      Fluttertoast.showToast(msg: errorMsg ?? "An unexpected error occured");
    }
  }
}
