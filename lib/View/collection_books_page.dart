import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:library_application/Model/book.dart';
import 'package:library_application/Model/favorite_book.dart';
import 'package:library_application/Service/book_service.dart';
import 'package:library_application/Service/favorite_book_service.dart';
import 'package:library_application/View/current_book_page.dart';

class CollectionBooks extends StatefulWidget {
  final int viewCollectionPage;
  final int userId;
  const CollectionBooks({required this.viewCollectionPage, required this.userId, super.key});

  @override
  State<CollectionBooks> createState() => _CollectionBooksState();
}

class _CollectionBooksState extends State<CollectionBooks> {
  late int userId = 0;
  List<FavoriteBook>? favoriteBookList;
  List<Book>? bookList;
  bool isLoading = false;

  IconData iconFavorite = Icons.bookmark;

  @override
  void initState() {
    userId = widget.userId;
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    favoriteBookList = await FavoritebookService().getAllFavoriteBookByUser(
      userId,
    );

    // Загружаем информацию о книгах
    if (favoriteBookList != null && favoriteBookList!.isNotEmpty) {
      final bookRepository = BookService();
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
    setState(() {});
  }

  Future<void> _toggleFavorite(Book book) async {
    // Блокируем кнопку во время выполнения
    setState(() {
      isLoading = true;
    });

    final repository = FavoritebookService();

    final isInFavorites = await repository.existBookInList(userId, book.id);
    setState(() {
      iconFavorite = isInFavorites ? Icons.bookmark : Icons.bookmark_outline;
    });

    try {
      // Определяем действие на основе ТЕКУЩЕГО состояния
      if (isInFavorites) {
        // УДАЛЯЕМ из избранного
        await repository.deleteFavoriteBook(userId, book.id);
        debugPrint('Удалено из избранного');
      } else {
        // ДОБАВЛЯЕМ в избранное
        await repository.postFavoriteBook(userId, book.id);
        debugPrint('Добавлено в избранное');
      }

      // Инвертируем состояние ЛОКАЛЬНО (не дожидаясь запроса)
      setState(() {
        iconFavorite = isInFavorites ? Icons.bookmark : Icons.bookmark_outline;
      });

      // Опционально: проверяем реальное состояние на сервере
      await _initializeData();
    } catch (e) {
      debugPrint('Ошибка при изменении избранного: $e');
      // В случае ошибки возвращаемся к исходному состоянию
      await _initializeData();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
            onReorder: (int oldIndex, int newIndex) async {
              setState(() {
                final Book itemBook = bookList!.removeAt(oldIndex);
                bookList!.insert(newIndex, itemBook);
                final FavoriteBook itemFavoriteBook = favoriteBookList!
                    .removeAt(oldIndex);
                favoriteBookList!.insert(newIndex, itemFavoriteBook);
              });

              await FavoritebookService().setPriorityListFavoriteBook(
                favoriteBookList!,
              );

              _initializeData();
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
                            isLoading
                                ? null
                                : _toggleFavorite(bookList![indexBook]);
                          },
                          icon: Icon(iconFavorite),
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
          onReorder: (int oldIndex, int newIndex) async {
            await setPriority(oldIndex, newIndex);
          },
        ),
      );
    }
  }

  Future<void> setPriority(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Book itemBook = bookList!.removeAt(oldIndex);
      bookList!.insert(newIndex, itemBook);
      final FavoriteBook itemFavoriteBook = favoriteBookList!.removeAt(
        oldIndex,
      );
      favoriteBookList!.insert(newIndex, itemFavoriteBook);
    });

    await FavoritebookService().setPriorityListFavoriteBook(
      favoriteBookList!,
    );

    _initializeData();
  }
}
