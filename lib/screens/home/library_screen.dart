import 'package:book_sale_apps/data/controller/book_controller.dart';
import 'package:book_sale_apps/data/controller/user_controller.dart';
import 'package:book_sale_apps/data/models/book_model.dart';
import 'package:book_sale_apps/screens/home/book_reading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final UserController userController = Get.put(UserController());
  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Library',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // avatar
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Obx(() {
                if (userController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (userController.user.value == null) {
                  return Center(
                    child: Text("Không có dữ liệu người dùng."),
                  );
                } else {
                  var user = userController.user.value!;
                  return CircleAvatar(
                    backgroundImage: NetworkImage("${user.image}"),
                  );
                }
              })),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Available offline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // Book List
              Expanded(
                child: Obx(() {
                  if (bookController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (bookController.books.isEmpty) {
                    return Center(
                      child: Text("Không có dữ liệu."),
                    );
                  } else {
                    var book = bookController.books..toList();
                    return ListView(
                      children: book.map((e) => BookItem(e)).toList(),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(
            duration: GetNumUtils(2).seconds,
          )
          .moveY(
            begin: 50,
            end: 0,
            duration: GetNumUtils(2).seconds,
          ),
    );
  }

  Widget BookItem(BookModel book) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 74, 42, 129),
              Colors.blueGrey,
            ], // Updated gradient colors
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Book Image
            Container(
              margin: EdgeInsets.all(5),
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image:
                      NetworkImage('${book.volumeInfo?.imageLinks?.thumbnail}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${book.volumeInfo?.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${book.volumeInfo?.printType}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Thanh tải xuống
                  LinearProgressIndicator(
                    value:
                        (book.volumeInfo?.averageRating?.toDouble() ?? 0) / 10,
                    backgroundColor: Colors.white,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  // Read
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookReadingScreen(
                            chapterTitle: '${book.volumeInfo?.title}',
                            chapterContent: '${book.volumeInfo?.description}',
                            image: '${book.volumeInfo?.imageLinks?.thumbnail}',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Read',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Download Icon
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.download),
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
