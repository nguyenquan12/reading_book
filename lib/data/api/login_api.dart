import 'dart:convert';

import 'package:book_sale_apps/data/models/login_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<LoginModel?> getLogin(LoginModel login) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    // Sử dụng phương thức toJson của đối tượng Login
    var data = json.encode({
      "username": login.username,
      "password": login.password,
    });
    var dio = Dio();
    try {
      var response = await dio.request(
        'https://dummyjson.com/auth/login',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        var token = response.data['accessToken'];
        await saveToken(token);
        return LoginModel.fromJson(response.data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setString('accessToken', token);
    if (success) {
      print("Token saved successfully.");
    } else {
      print("Failed to save token.");
    }
  }
}
