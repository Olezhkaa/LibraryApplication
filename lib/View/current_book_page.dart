import 'package:flutter/material.dart';
import 'package:library_application/Entities/Book.dart';
import 'package:library_application/Repository/FavoriteBookRepository.dart';

class CurrentBook extends StatefulWidget {
  const CurrentBook({super.key, required this.book});

  final Book book;

  @override
  State<CurrentBook> createState() => _CurrentBookState();
}

class _CurrentBookState extends State<CurrentBook> {
  int userId = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.book.title,
          style: TextStyle(overflow: TextOverflow.fade),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(widget.book.imagePath, height: 400),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                widget.book.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 50),
                Column(
                  children: [
                    Text(widget.book.author, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 2),
                    Text(widget.book.genre, style: TextStyle(fontSize: 20)),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    final repository = Favoritebookrepository();
                    final isInFavorites = await repository.extentionBookInList(userId, widget.book.id);
                    
                    setState(() async {
                      isInFavorites ? repository.deleteFavoriteBook(userId, widget.book.id) : repository.postFavoriteBook(userId, widget.book.id);
                    });
                  },
                  icon: FutureBuilder<bool>(
                            future: Favoritebookrepository().extentionBookInList(userId, widget.book.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!
                                    ? Icon(Icons.bookmark)
                                    : Icon(Icons.bookmark_add_outlined);
                              }
                              return Icon(Icons.bookmark_border);
                            },
                          ),
                        ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: SizedBox(width: 40)),
                    TextSpan(
                      text: widget.book.description,
                      style: TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
              //Text(widget.book.description, style: TextStyle(fontSize: 18, height: 1.5), textAlign: TextAlign.justify,),
            ),
          ],
        ),
      ),
    );
  }
}

