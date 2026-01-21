import 'package:flutter/material.dart';
import 'package:library_application/Model/book.dart';
import 'package:library_application/Model/genre.dart';
import 'package:library_application/Service/book_service.dart';
import 'package:library_application/Service/genre_service.dart';
import 'package:library_application/View/current_book_page.dart';
// import 'package:library_application/View/current_book_page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key, required this.userId});

  final int userId;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<Book>? bookList;
  List<Genre>? genreList;

  late int userId = 0;

  @override
  void initState() {
    _initializeData();
    userId = widget.userId;
    super.initState();
  }

  Future<void> _initializeData() async {
    bookList = await BookService().getAllBooks();
    genreList = await GenreService().getAllGenres();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: genreList == null
          ? EmptyFavoriteBookList()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 5),
              itemCount: genreList!.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (getGenreBookList(
                      bookList!,
                      genreList![index],
                    ).isNotEmpty)
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              genreList![index].title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          BookGenreListView(
                            genreBookList: getGenreBookList(
                              bookList!,
                              genreList![index],
                            ),
                            genreCurrentBook: genreList![index],
                            userId: userId,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
    );
  }
}

class EmptyFavoriteBookList extends StatelessWidget {
  const EmptyFavoriteBookList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Список пуст",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Книги скоро появятся здесь", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class BookGenreListView extends StatelessWidget {
  const BookGenreListView({
    super.key,
    required this.genreBookList,
    required this.genreCurrentBook,
    required this.userId,
  });

  final int userId;
  final Genre genreCurrentBook;
  final List<Book> genreBookList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genreBookList.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 300,
            width: 150,
            child: InkWell(
              child: Card(
                elevation: 0,
                margin:  EdgeInsets.only(right: index==genreBookList.length-1 ? 8 : 4 , left: index==0 ? 8 : 4),
                color: Theme.of(context).cardColor,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        genreBookList[index].imagePath,
                        height: 225,
                        //width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        genreBookList[index].title,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CurrentBook(book: genreBookList[index], userId: userId),
                    //builder: (_) => CollectionBooks(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

List<Book> getGenreBookList(List<Book> allBookList, Genre genre) {
  List<Book> bookListThisGenre = [];
  for (var bookInAllList in allBookList) {
    if (bookInAllList.genre == genre.title) {
      bookListThisGenre.add(bookInAllList);
    }
  }
  return bookListThisGenre;
}
