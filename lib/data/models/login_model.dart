class LoginModel {
  String? username;
  String? password;
  int? expiresInMins;
  String? accessToken;

  LoginModel({
    this.username,
    this.password,
    this.expiresInMins,
    this.accessToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final login = LoginModel(
      username: json['username'],
      password: json['password'],
      expiresInMins: json['expiresInMins'],
      accessToken: json['accessToken'],
    );
    return login;
  }

  toJson() {}
}
