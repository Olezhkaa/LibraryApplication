import 'package:flutter/material.dart';
import 'package:library_application/Model/book.dart';
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
    setState(() {
      isInFavorites = isFavorite;
      iconFavorite = isFavorite ? Icons.bookmark : Icons.bookmark_outline;
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
                  onPressed: isLoading ? null : _toggleFavorite,
                  icon: Icon(iconFavorite),
                  tooltip: isInFavorites ? 'Удалить из избранного' : 'Добавить в избранное',
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
                      style: TextStyle(fontSize: 18, height: 1, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
