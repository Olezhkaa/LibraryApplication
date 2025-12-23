import 'package:flutter/material.dart';
import 'package:library_application/Entities/Book.dart';
import 'package:library_application/Entities/Genre.dart';
import 'package:library_application/Repository/BookRepository.dart';
import 'package:library_application/Repository/GenreRepository.dart';
import 'package:library_application/View/current_book_page.dart';
// import 'package:library_application/View/current_book_page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<Book>? bookList;
  List<Genre>? genreList;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    bookList = await BookRepository().getAllBooks();
    genreList = await GenreRepository().getAllGenres();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //var romanticGenreBook = getRomanticGenreBook(bookList);
    //var detectiveGenreBook = getDetectiveGenreBook(bookList);
    return Scaffold(
      body: genreList == null
          ? const SizedBox()
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: genreList!.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (getGenreBookList(
                      bookList!,
                      genreList![index],
                    ).isNotEmpty)
                      Text(
                        genreList![index].title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (getGenreBookList(
                      bookList!,
                      genreList![index],
                    ).isNotEmpty)
                      SizedBox(height: 8),
                    if (getGenreBookList(
                      bookList!,
                      genreList![index],
                    ).isNotEmpty)
                      BookGenreListView(
                        genreBookList: getGenreBookList(
                          bookList!,
                          genreList![index],
                        ),
                        genreCurrentBook: genreList![index],
                      ),
                  ],
                );
                //Тупое решение, надо вернуться исправить
              },
            ),
    );
  }
}

class BookGenreListView extends StatelessWidget {
  const BookGenreListView({
    super.key,
    required this.genreBookList,
    required this.genreCurrentBook,
  });

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
                margin: const EdgeInsets.only(right: 8.0),
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
                    builder: (_) => CurrentBook(book: genreBookList[index]),
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
    if (bookInAllList.genre == genre.title)
      bookListThisGenre.add(bookInAllList);
  }
  return bookListThisGenre;
}
