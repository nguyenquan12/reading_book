import 'package:book_sale_apps/data/models/book_detail_model.dart';
import 'package:dio/dio.dart';

class BookDetailApi {
  static Future<BookDetailModel> getBook({required String id}) async {
    var dio = Dio();
    try {
      var response = await dio.request(
        'https://www.googleapis.com/books/v1/volumes/$id',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        // Lấy danh sách từ trường items
        var bookData = response.data as Map<String, dynamic>;
        return BookDetailModel.fromJson(bookData);
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
