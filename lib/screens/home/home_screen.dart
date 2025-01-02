import 'package:book_sale_apps/data/api/book_api.dart';
import 'package:book_sale_apps/data/api/user_api.dart';
import 'package:book_sale_apps/data/models/book_model.dart';
import 'package:book_sale_apps/data/models/user_model.dart';
import 'package:book_sale_apps/screens/home/book_reading_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      drawer: MyDrawer(),
      body: Container(
        // Background
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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: FutureBuilder(
                  future: userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Lỗi: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                          child: Text("Không có dữ liệu người dùng."));
                    } else {
                      var data = snapshot.data!;
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage("${data.image}"),
                          ),
                          // User Name
                          SizedBox(width: 10),
                          Text(
                            '${data.firstName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              // SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thanh tìm kiếm
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.keyboard_voice,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // Thêm hành động khi nhấn vào icon
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors
                                    .grey, // Màu viền khi không được focus
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Màu viền khi được focus
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        // Looking For
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Looking For',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'More',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        FutureBuilder(
                          future: lstBook,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text("${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return Center(child: Text("Không có dữ liệu."));
                            } else {
                              // Lấy 5 phần tử đầu tiên
                              var limitedBooks =
                                  snapshot.data!.take(5).toList();

                              return Row(
                                children: limitedBooks
                                    .map((e) => CategoryCard(e))
                                    .toList(),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        // Popular
                        Text(
                          'Popular',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Popular ListBookCard()
                        SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ListBookCard(),
                        ),
                        SizedBox(height: 20),
                        // List of Books BookList()
                        Text(
                          'List of Books',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: BookList(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CategoryCard(BookModel book) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6), // Bo góc ảnh
              child: Image.network(
                '${book.volumeInfo?.imageLinks?.thumbnail}',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${book.volumeInfo?.title}',
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class ListBookCard extends StatefulWidget {
  const ListBookCard({super.key});

  @override
  State<ListBookCard> createState() => _ListBookCardState();
}

class _ListBookCardState extends State<ListBookCard> {
  late Future<List<BookModel>> lstBook;
  @override
  void initState() {
    super.initState();
    lstBook = BookApi.getBook();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            scrollDirection: Axis.horizontal,
            children: data.map((e) => BookCard(e)).toList(),
          );
        }
      },
    );
  }

  Widget BookCard(BookModel book) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Card(
        elevation: 5,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${book.volumeInfo?.imageLinks?.thumbnail}',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${book.volumeInfo?.title}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Text(
                          '${book.volumeInfo?.publishedDate}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '${book.volumeInfo?.description}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${book.volumeInfo?.averageRating}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '(${book.volumeInfo?.ratingsCount})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReadingScreen(
                                  chapterTitle: '${book.volumeInfo?.title}',
                                  chapterContent:
                                      '${book.volumeInfo?.description}',
                                  image:
                                      '${book.volumeInfo?.imageLinks?.thumbnail}',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Read',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  late Future<List<BookModel>> lstBook;

  @override
  void initState() {
    super.initState();
    lstBook = BookApi.getBook();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lstBook,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Không có dữ liệu người dùng."));
          } else {
            var data = snapshot.data!;
            return Column(
              children: data.map((e) => BookCard(e)).toList(),
            );
          }
        });
  }

  Widget BookCard(BookModel book) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 80,
                child:
                    Image.network('${book.volumeInfo?.imageLinks?.thumbnail}'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${book.volumeInfo?.title}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${book.volumeInfo?.publishedDate}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${book.volumeInfo?.description}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: () {},
                          child: Text(
                            'Download',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReadingScreen(
                                  chapterTitle: '${book.volumeInfo?.title}',
                                  chapterContent:
                                      '${book.volumeInfo?.description}',
                                  image:
                                      '${book.volumeInfo?.imageLinks?.thumbnail}',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Read',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late Future<List<BookModel>> lstBook;

  @override
  void initState() {
    super.initState();
    lstBook = BookApi.getBook();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2 / 3,
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
      child: ListView(
        children: [
          SizedBox(height: 10),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/logo_app.png"),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Nguyễn Quân
          Center(
            child: Text(
              "Nguyễn Quân",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          //indent: 0
          const Divider(
            color: Colors.white,
            thickness: 0.4,
          ),
          //Home
          listTileWidget(Icons.home, "Home"),
          //Product List
          listTileWidget(Icons.shopify, "Product List"),
          //Notifications
          listTileWidget(Icons.notifications, "Notifications"),
          //indent: 40
          const Divider(
            color: Colors.white,
            thickness: 0.4,
            indent: 40,
          ),
          //PRODUCT LIST
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "PRODUCT LIST",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder(
            future: lstBook,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                var data = snapshot.data!;

                return Column(
                  children: data.map((e) => ProductDrawer(context, e)).toList(),
                );
              }
            },
          ),
          const Divider(
            color: Colors.white,
            height: 20,
            thickness: 0.2,
            indent: 40,
          ),
          //Setting
          listTileWidget(Icons.settings, "Setting"),
          //Help
          listTileWidget(Icons.help_outline_rounded, 'Help'),
        ],
      ),
    );
  }

  Widget listTileWidget(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: () {},
    );
  }

  Widget ProductDrawer(BuildContext context, BookModel book) {
    return InkWell(
      onTap: () {
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
      child: Container(
        color: Colors.blueAccent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            '${book.volumeInfo?.imageLinks?.thumbnail}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2.1,
                    child: Text(
                      '${book.volumeInfo?.title}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
