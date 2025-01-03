import 'package:book_sale_apps/data/controller/book_controller.dart';
import 'package:book_sale_apps/data/controller/user_controller.dart';
import 'package:book_sale_apps/data/models/book_model.dart';
import 'package:book_sale_apps/screens/home/book_reading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.put(UserController());
  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBar(),
                        SizedBox(height: 10),
                        _buildSectionHeader('Looking For',
                            onMorePressed: () {}),
                        SizedBox(height: 10),
                        _buildCategoryCards(),
                        SizedBox(height: 20),
                        _buildSectionHeader('Popular'),
                        SizedBox(height: 10),
                        _buildPopularBooks(),
                        SizedBox(height: 20),
                        _buildSectionHeader('List of Books'),
                        SizedBox(height: 10),
                        _buildBookList(),
                      ],
                    ),
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
                  ), // Hiệu ứng moveY (di chuyển lên)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Obx(() {
        if (userController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (userController.user.value == null) {
          return Center(child: Text("Không có dữ liệu người dùng."));
        } else {
          var user = userController.user.value!;
          return Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.image ?? ''),
              ),
              SizedBox(width: 10),
              Text(
                user.firstName ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }
      }),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.keyboard_voice, color: Colors.black),
          onPressed: () {},
        ),
        filled: true,
        fillColor: Colors.grey[300],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onMorePressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onMorePressed != null)
          TextButton(
            onPressed: onMorePressed,
            child: Text(
              'More',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryCards() {
    return Obx(() {
      var limitedBooks = bookController.books.take(5).toList();
      return Row(
        children: limitedBooks.map((book) => _buildCategoryCard(book)).toList(),
      ).animate().fadeIn(duration: GetNumUtils(2).seconds).moveX(
            begin: 50,
            end: 0,
            duration: GetNumUtils(2).seconds,
          );
    })
        .animate()
        .fadeIn(
          duration: GetNumUtils(2).seconds,
        )
        .moveX(
          begin: 50,
          end: 0,
          duration: GetNumUtils(2).seconds,
        );
  }

  Widget _buildCategoryCard(BookModel book) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                book.volumeInfo?.imageLinks?.thumbnail ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            book.volumeInfo?.title ?? '',
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBooks() {
    return SizedBox(
      height: 200,
      child: ListBookCard(),
    );
  }

  Widget _buildBookList() {
    return SizedBox(
      width: double.infinity,
      child: BookList(),
    );
  }
}

class ListBookCard extends StatefulWidget {
  const ListBookCard({super.key});

  @override
  State<ListBookCard> createState() => _ListBookCardState();
}

class _ListBookCardState extends State<ListBookCard> {
  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bookController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (bookController.books.isEmpty) {
        return const Center(child: Text("Không có dữ liệu."));
      } else {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bookController.books.length,
          itemBuilder: (context, index) {
            return _buildBookCard(bookController.books[index]);
          },
        );
      }
    });
  }

  Widget _buildBookCard(BookModel book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 74, 42, 129),
                Colors.blueGrey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      book.volumeInfo?.imageLinks?.thumbnail ?? '',
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.volumeInfo?.title ?? 'Unknown Title',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.volumeInfo?.publishedDate ?? 'Unknown Date',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  book.volumeInfo?.description ?? 'No description available.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        (book.volumeInfo?.averageRating?.toStringAsFixed(1) ??
                            'N/A'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${book.volumeInfo?.ratingsCount ?? 0})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookReadingScreen(
                            chapterTitle:
                                book.volumeInfo?.title ?? 'Unknown Title',
                            chapterContent: book.volumeInfo?.description ??
                                'No content available.',
                            image: book.volumeInfo?.imageLinks?.thumbnail ?? '',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Read',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
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
  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bookController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (bookController.books.isEmpty) {
        return Center(child: Text("Không có dữ liệu người dùng."));
      } else {
        var book = bookController.books.toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: book.length,
          itemBuilder: (context, index) {
            return _buildBookCard(book[index]);
          },
        );
      }
    });
  }

  Widget _buildBookCard(BookModel book) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
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
              // Display book image with error handling
              _buildBookImage(book),

              const SizedBox(width: 16),

              // Display book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBookTitle(book),
                    const SizedBox(height: 4),
                    _buildBookDate(book),
                    const SizedBox(height: 8),
                    _buildBookDescription(book),
                    const SizedBox(height: 12),
                    _buildActionButtons(book),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage(BookModel book) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        book.volumeInfo?.imageLinks?.thumbnail ?? '',
        height: 120,
        width: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
            width: 90,
            color: Colors.grey[700],
            child: const Icon(
              Icons.broken_image,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookTitle(BookModel book) {
    return Text(
      book.volumeInfo?.title ?? 'Unknown Title',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _buildBookDate(BookModel book) {
    return Text(
      book.volumeInfo?.publishedDate ?? 'Unknown Date',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildBookDescription(BookModel book) {
    return Text(
      book.volumeInfo?.description ?? 'No description available.',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons(BookModel book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Download action
          },
          child: const Text(
            'Download',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookReadingScreen(
                  chapterTitle: book.volumeInfo?.title ?? 'Unknown Title',
                  chapterContent:
                      book.volumeInfo?.description ?? 'No content available.',
                  image: book.volumeInfo?.imageLinks?.thumbnail ?? '',
                ),
              ),
            );
          },
          child: const Text(
            'Read',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final BookController bookController = Get.put(BookController());

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
          Obx(
            () {
              if (bookController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (bookController.books.isEmpty) {
                return Center(child: Text("Không có dữ liệu."));
              } else {
                var book = bookController.books.toList();
                return Column(
                  children: book.map((e) => ProductDrawer(context, e)).toList(),
                );
              }
            },
          ),
          SizedBox(height: 10),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.blue,
              Colors.purple,
            ], // Updated gradient colors
          ),
        ),
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
              height: 2,
              color: Colors.white,
              thickness: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
