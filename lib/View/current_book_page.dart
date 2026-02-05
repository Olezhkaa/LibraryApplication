import 'package:flutter/material.dart';
import 'package:library_application/Model/book.dart';
import 'package:library_application/Service/collection_book_service.dart';
import 'package:library_application/Service/collection_service.dart';
import 'package:library_application/Service/favorite_book_service.dart';

class CurrentBook extends StatefulWidget {
  const CurrentBook({super.key, required this.book, required this.userId});

  final Book book;
  final int userId;

  @override
  State<CurrentBook> createState() => _CurrentBookState();
}

class _CurrentBookState extends State<CurrentBook> {
  late int userId = 0;
  IconData iconFavorite = Icons.bookmark_outline;
  bool isInFavorites = false;
  bool isLoading = false;

  List<String> listCollectionTitle = [];

  String dropValue = "";

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _initializeData();
  }

  Future<void> _initializeData() async {
    final isFavorite =
        await FavoritebookService().existBookInList(
          userId,
          widget.book.id,
        );

    var listCollection = await CollectionService().getAllCollectionNoFavorite();

    var idCollectionBook = await CollectionBookService().existBookInCollectionByUser(userId, widget.book.id);
    var collectionTitle = await CollectionService().getTitleByCollectionId(idCollectionBook);

    setState(() {
      isInFavorites = isFavorite;
      iconFavorite = isFavorite ? Icons.bookmark : Icons.bookmark_outline;

      for(var collection in listCollection) {
        listCollectionTitle.add(collection.title);
      }

      dropValue = collectionTitle ?? listCollectionTitle.first;
    });
  }

    Future<void> _toggleFavorite() async {
    // Блокируем кнопку во время выполнения
    setState(() {
      isLoading = true;
    });

    final repository = FavoritebookService();
    
    try {
      // Определяем действие на основе ТЕКУЩЕГО состояния
      if (isInFavorites) {
        // УДАЛЯЕМ из избранного
        await repository.deleteFavoriteBook(userId, widget.book.id);
        debugPrint('Удалено из избранного');
      } else {
        // ДОБАВЛЯЕМ в избранное
        await repository.postFavoriteBook(userId, widget.book.id);
        debugPrint('Добавлено в избранное');
      }
      
      // Инвертируем состояние ЛОКАЛЬНО (не дожидаясь запроса)
      setState(() {
        isInFavorites = !isInFavorites;
        iconFavorite = isInFavorites ? Icons.bookmark : Icons.bookmark_outline;
      });
      
    } catch (e) {
      debugPrint('Ошибка при изменении избранного: $e');

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> setCollection(String value) async {
    debugPrint("Set Collection");
    try {
      int collectionId = await CollectionService().getIdByCollectionName(value);
      debugPrint("$userId, $collectionId, ${widget.book.id}");
      var checkBook = await CollectionBookService().existBookInCollectionByUser(userId, widget.book.id);
      if(collectionId==0 && checkBook!=0) {
        await CollectionBookService().deleteBookFromCollection(userId, checkBook, widget.book.id);
        return;
      }
      if(checkBook==0) {
        await CollectionBookService().postBookInCollection(userId, collectionId, widget.book.id);
      }
      else {
        await CollectionBookService().moveBookFromCollections(userId, checkBook, widget.book.id, collectionId);
      }
    }
    catch (e) {
      debugPrint("Возникла ошибка при добавлении в коллекцию: $e");
    }
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
                DropdownButton(
                  //disabledHint: Text("Выберите..."),
                  value: dropValue,
                  items: listCollectionTitle.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(), 
                onChanged: (String? newValue) async {
                  debugPrint("Новое значение: $newValue");
                  setCollection(newValue!);
                  setState(() {
                    dropValue = newValue;
                  });
                }),
                SizedBox(width: 10,),
                IconButton(
                  onPressed: isLoading ? null : _toggleFavorite,
                  icon: Icon(iconFavorite),
                  tooltip: isInFavorites ? 'Удалить из избранного' : 'Добавить в избранное',
                ),
              ],
            ),
            SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Автор: ${widget.book.author}", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 2),
                      Text("Жанр: ${widget.book.genre}", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(child: SizedBox(width: 40)),
                        TextSpan(
                          text: widget.book.description,
                          style: TextStyle(fontSize: 18, height: 1, color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
