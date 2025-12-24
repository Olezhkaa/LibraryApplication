import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:library_application/Entities/Book.dart';
import 'package:library_application/Entities/FavoriteBook.dart';
import 'package:library_application/Repository/BookRepository.dart';
import 'package:library_application/Repository/FavoriteBookRepository.dart';
import 'package:library_application/View/current_book_page.dart';

class CollectionBooks extends StatefulWidget {
  final int viewCollectionPage;
  const CollectionBooks({required this.viewCollectionPage, super.key});

  @override
  State<CollectionBooks> createState() => _CollectionBooksState();
}

class _CollectionBooksState extends State<CollectionBooks> {
  final int userId = 1;
  List<FavoriteBook>? favoriteBookList;
  List<Book>? bookList;
  bool isLoading = false;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    favoriteBookList = await Favoritebookrepository().getAllFavoriteBookByUser(
      userId,
    );

    setState(() {
      isLoading = true;
    });

    // Загружаем информацию о книгах
    if (favoriteBookList != null && favoriteBookList!.isNotEmpty) {
      final bookRepository = BookRepository();
      bookList = [];
      for (final favoriteBook in favoriteBookList!) {
        try {
          Book book = await bookRepository.getBookById(favoriteBook.bookId);
          bookList!.add(book);
        } catch (e) {
          debugPrint('Не удалось загрузить книгу ${favoriteBook.bookId}: $e');
        }
      }
    }
    setState(() { isLoading = false;});
  }

  @override
  Widget build(BuildContext context) {
    return collectionContent();
  }

  Scaffold collectionContent() {
    if (favoriteBookList == null || favoriteBookList!.isEmpty) {
      return Scaffold(
        body: Center(
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
                Text(
                  "Добавьте книгу в коллецию",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.viewCollectionPage == 1) {
      return Scaffold(
        body: Center(
          child: AnimatedReorderableGridView(
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 20),
            items: bookList!,
            itemBuilder: (BuildContext context, int index) {
              Book book = bookList![index];
              return SizedBox(
                key: ValueKey(book),
                width: 180,
                height: 340,
                child: GestureDetector(
                  key: ValueKey(book),
                  child: Card.outlined(
                    margin: EdgeInsets.zero,
                    shape: null,
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                book.imagePath,
                                width: 160,
                                height: 260,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            book.title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Expanded(child: Text("Автор: ${book.author}")),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CurrentBook(book: book),
                        // builder: (_) => CollectionBooks(),
                      ),
                    );
                  },
                ),
              );
            },
            sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 2,
              mainAxisExtent: 340,
            ),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                final Book item = bookList!.removeAt(oldIndex);
                bookList!.insert(newIndex, item);
              });
            },
            enterTransition: [FlipInX(), ScaleIn()],
            exitTransition: [SlideInLeft()],
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
            dragStartDelay: const Duration(milliseconds: 300),
            isSameItem: (a, b) => a.id == b.id,
            proxyDecorator:
                (Widget child, int index, Animation<double> animation) {
                  return Material(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: null,
                    elevation: 6,
                    borderRadius: BorderRadius.circular(12),
                    child: child,
                  );
                },
          ),
        ),
      );
    } else {
      return Scaffold(
        body: ReorderableListView(
          padding: const EdgeInsets.all(8),
          children: [
            for (int indexBook = 0; indexBook < bookList!.length; indexBook++)
              GestureDetector(
                key: Key('${favoriteBookList![indexBook].id}'),
                child: Card.outlined(
                  margin: EdgeInsets.only(bottom: 8),
                  //elevation: 4.0,
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        //Icon(Icons.menu_book, size: 40,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            bookList![indexBook].imagePath,
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                bookList![indexBook].title,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text("Автор: ${bookList![indexBook].author}"),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final repository = Favoritebookrepository();
                            final isInFavorites = await repository
                                .extentionBookInList(
                                  userId,
                                  bookList![indexBook].id,
                                );
                            setState(() async {
                              if (isInFavorites) {
                                await repository.deleteFavoriteBook(
                                  userId,
                                  bookList![indexBook].id,
                                );
                                // Обновляем данные
                                await _initializeData();
                              } else {
                                await repository.postFavoriteBook(
                                  userId,
                                  bookList![indexBook].id,
                                );
                                // Обновляем данные
                                await _initializeData();
                              }
                            });
                          },
                          icon: FutureBuilder<bool>(
                            future: Favoritebookrepository()
                                .extentionBookInList(
                                  userId,
                                  bookList![indexBook].id,
                                ),
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
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CurrentBook(book: bookList![indexBook]),
                      //builder: (_) => CollectionBooks(),
                    ),
                  );
                },
              ),
          ],
          proxyDecorator:
              (Widget child, int index, Animation<double> animation) {
                return Material(
                  color: Colors.transparent,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                );
              },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Book item = bookList!.removeAt(oldIndex);
              bookList!.insert(newIndex, item);
            });
          },
        ),
      );
    }
  }
}
