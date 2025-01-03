import 'package:get/get.dart';
import 'package:book_sale_apps/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  // Lấy dữ liệu người dùng
  Future<void> fetchUser() async {
    isLoading.value = true;
    try {
      String? token = await _getToken();
      if (token == null) {
        throw Exception("No token found. Please login.");
      }

      var headers = {'Authorization': 'Bearer $token'};
      var dio = Dio();

      var response = await dio.request(
        'https://dummyjson.com/auth/me',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var userData = response.data as Map<String, dynamic>;
        user.value = UserModel.fromJson(userData);
      } else {
        throw Exception("Failed to fetch user data: ${response.statusMessage}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error while fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy token từ SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    print('Token retrieved: $token'); // Kiểm tra giá trị token
    return token;
  }

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }
}
