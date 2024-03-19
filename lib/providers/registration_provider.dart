import 'package:flutter/material.dart';
import 'package:savyminds/models/user_register_model.dart';

class RegistrationProvider extends ChangeNotifier {
  UserRegisterModel registerUser = UserRegisterModel();

  UserRegisterModel getUser() {
    return registerUser;
  }

  updateUserDetails(UserRegisterModel user) {
    registerUser = registerUser.copy(user: user);
    notifyListeners();
  }

  clearUserData() {
    registerUser = UserRegisterModel();
    notifyListeners();
  }
}
