import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_application/Model/book.dart';
import 'package:library_application/Service/book_service.dart';
import 'package:library_application/View/current_book_page.dart';

class SearchBookPage extends StatefulWidget {
  const SearchBookPage({required this.userId, super.key});

  final int userId;

  @override
  State<SearchBookPage> createState() => _SearchBookPage();
}

class _SearchBookPage extends State<SearchBookPage> {
  List<Book> listBookSearch = [];
  List<Book> allBooks = [];

  late int userId;

  bool isLoading = true;
  Timer? debounceTimer;

  final controllerSearch = TextEditingController();

  @override
  void initState() {
    userId = widget.userId;
    initData();
    super.initState();
  }

  void initData() async {
    try {
      final books = await BookService().getAllBooks();
      setState(() {
        allBooks = books;
        listBookSearch = allBooks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        allBooks = [];
        listBookSearch = [];
        isLoading = false;
      });
      debugPrint('Ошибка при загрузке книг: $e');
    }
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> onChanged(String value) async {
    //Отменяем предыдущий таймер
    if (debounceTimer?.isActive ?? false) {
      debounceTimer!.cancel();
    }

    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });

        try {
          String searchTerm = value.trim();
          List<Book> searchResult;

          debugPrint('Поиск: "$searchTerm"');

          if (searchTerm.isEmpty) {
            searchResult = allBooks;
            debugPrint(
              'Поиск по пустой строке, показываем все книги: ${allBooks.length}',
            );
          } else {
            final result = await BookService().getSearchBook(searchTerm);
            debugPrint('Результат поиска от сервера: ${result.length} книг');
            searchResult = result;
          }

          if (mounted) {
            setState(() {
              listBookSearch = searchResult;
              isLoading = false;
            });
            debugPrint(
              'Обновлен listBookSearch: ${listBookSearch.length} книг',
            );
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          debugPrint('Ошибка при поиске: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //titleSpacing: 0,
        actions: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                left: 50,
                top: 5,
                bottom: 5,
                right: 8,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: TextField(
                  maxLines: 1,
                  onChanged: (value) => onChanged(value),
                  controller: controllerSearch,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: "Поиск",
                    hintText: "Введите название книги...",
                  //filled: true,
                    suffixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: buildBody(userId),
    );
  }

  Widget buildBody(int userId) {
    if (isLoading && listBookSearch.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (listBookSearch.isEmpty) {
      return Center(
        child: Text(
          controllerSearch.text.isEmpty
              ? "Нет доступных книг"
              : "Книги не найдены",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: listBookSearch.length,
      itemBuilder: (BuildContext context, int index) {
        final book = listBookSearch[index];
        return buildBookItem(book, userId);
      },
    );
  }

  Widget buildBookItem(Book book, int userId) {
    return GestureDetector(
      key: Key('$book.id}'),
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
                  book.imagePath,
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
                      book.title,
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
                    Text("Автор: ${book.author}"),
                  ],
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
            builder: (_) => CurrentBook(book: book, userId: userId),
          ),
        );
      },
    );
  }
}
