class UserRegisterModel {
  final String? fullname;
  final String? username;
  final String? registrationToken;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? country;
  final String? countryCode;

  //auth 2.0
  final String? idToken;
  final String? auth2Id;
  final String? auth2AcceessToken;
  final String? googleCode;

  UserRegisterModel(
      {this.fullname,
      this.email,
      this.password,
      this.phoneNumber,
      this.registrationToken,
      this.username,
      this.country,
      this.countryCode,

      //auth2.0
      this.auth2AcceessToken,
      this.googleCode,
      this.auth2Id,
      this.idToken});

  UserRegisterModel copy({
    required UserRegisterModel user,
  }) =>
      UserRegisterModel(
          fullname: user.fullname ?? fullname,
          username: user.username ?? username,
          registrationToken: user.registrationToken ?? registrationToken,
          email: user.email ?? email,
          phoneNumber: user.phoneNumber ?? phoneNumber,
          password: user.password ?? password,
          country: user.country ?? country,
          countryCode: user.countryCode ?? countryCode);

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname ?? "",
      'registration_token': registrationToken,
      'username': username ?? "",
      'email': email ?? "",
      'phone_number': phoneNumber ?? "",
      'password1': password ?? "",
      'password2': password ?? "",
      'country': country,
      'country_code': countryCode,
    };
  }
}
