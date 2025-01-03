import 'package:get/get.dart';
import 'package:book_sale_apps/data/models/book_model.dart';
import 'package:book_sale_apps/data/api/book_api.dart';

class BookController extends GetxController {
  // Danh sách sách
  var books = <BookModel>[].obs;

  // Trạng thái loading
  var isLoading = false.obs;

  // Hàm lấy dữ liệu từ API
  Future<void> fetchBooks() async {
    isLoading.value = true; // Bắt đầu loading
    try {
      var fetchedBooks = await BookApi.getBook();
      books.assignAll(fetchedBooks); // Gán dữ liệu vào danh sách
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch books: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }
}
