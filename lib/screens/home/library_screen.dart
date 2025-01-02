import 'package:book_sale_apps/data/api/book_api.dart';
import 'package:book_sale_apps/data/api/user_api.dart';
import 'package:book_sale_apps/data/models/book_model.dart';
import 'package:book_sale_apps/data/models/user_model.dart';
import 'package:book_sale_apps/screens/home/book_reading_screen.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<UserModel> userFuture;
  late Future<List<BookModel>> lstBook;

  @override
  void initState() {
    super.initState();
    userFuture = UserApi.getuser();
    lstBook = BookApi.getBook();
  }

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
            child: FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("Không có dữ liệu người dùng."));
                } else {
                  var data = snapshot.data!;
                  return CircleAvatar(
                    backgroundImage: NetworkImage("${data.image}"),
                  );
                }
              },
            ),
          ),
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
                child: FutureBuilder(
                  future: lstBook,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text("Không có dữ liệu."));
                    } else {
                      var data = snapshot.data!;
                      return ListView(
                        children: data.map((e) => BookItem(e)).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BookItem(BookModel book) {
    return Card(
      color: Colors.grey[400],
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
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${book.volumeInfo?.printType}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                // Thanh tải xuống
                LinearProgressIndicator(
                  value: (book.volumeInfo?.averageRating?.toDouble() ?? 0) / 10,
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
                  child: Text('Read'),
                ),
              ],
            ),
          ),
          // Download Icon
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.download),
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
