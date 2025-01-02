import 'package:book_sale_apps/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static Future<UserModel> getuser() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception("No token found. Please login.");
    }
    var headers = {'Authorization': 'Bearer $token'};
    var dio = Dio();
    try {
      var response = await dio.request(
        'https://dummyjson.com/auth/me',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        // Parse response.data thành đối tượng User
        var userData = response.data as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        throw Exception("Failed to fetch user data");
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception("Error while fetching user data");
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    print('Token retrieved: $token'); // Kiểm tra giá trị token
    return token;
  }
}
