import 'package:flutter/material.dart';

class BookReadingScreen extends StatefulWidget {
  final String chapterTitle;
  final String chapterContent;
  final String image;

  const BookReadingScreen({
    super.key,
    required this.chapterTitle,
    required this.chapterContent,
    required this.image,
  });

  @override
  _BookReadingScreenState createState() => _BookReadingScreenState();
}

class _BookReadingScreenState extends State<BookReadingScreen> {
  double _fontSize = 16.0;

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 10) {
        _fontSize -= 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.chapterTitle),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: _increaseFontSize,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.text_decrease),
              onPressed: _decreaseFontSize,
            ),
          ),
        ],
      ),
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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Image.network(widget.image),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                widget.chapterContent,
                style: TextStyle(
                  fontSize: _fontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Logic chuyển đến chương trước
                },
                child: const Text(
                  'Chương trước',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Logic chuyển đến chương tiếp theo
                },
                child: const Text(
                  'Chương sau',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class WebViewBook extends StatelessWidget {
//   final String webReaderLink;

//   const WebViewBook({super.key, required this.webReaderLink});

//   @override
//   Widget build(BuildContext context) {
//     final WebViewController controller = WebViewController()
//       ..loadRequest(Uri.parse(webReaderLink));
//     return Scaffold(
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }
