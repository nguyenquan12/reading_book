import 'package:book_sale_apps/data/models/book_model.dart';
import 'package:dio/dio.dart';

class BookApi {
  static Future<List<BookModel>> getBook() async {
    var dio = Dio();
    try {
      var response = await dio.request(
        'https://www.googleapis.com/books/v1/volumes',
        queryParameters: {
          'q': 'books',
          'maxResults': 20,
        },
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        // Lấy danh sách từ trường items
        var jsonData = response.data['items'] as List;

        // Chuyển đổi từng mục trong danh sách thành BookModel
        return jsonData.map((item) => BookModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception("Error while fetching user data");
    }
  }
}
