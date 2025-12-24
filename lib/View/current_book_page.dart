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
  IconData? iconFavorite;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    iconFavorite =
        await Favoritebookrepository().extentionBookInList(
          userId,
          widget.book.id,
        )
        ? Icons.bookmark
        : Icons.bookmark_outline;
    setState(() {});
  }

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
                    final isInFavorites = await repository.extentionBookInList(
                      userId,
                      widget.book.id,
                    );
                    debugPrint("${widget.book.id}");
                    setState(() {
                      isInFavorites
                          ? repository.deleteFavoriteBook(
                              userId,
                              widget.book.id,
                            )
                          : repository.postFavoriteBook(userId, widget.book.id);
                      _initializeData();
                    });
                  },
                  icon: Icon(iconFavorite),
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
