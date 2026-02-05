import 'package:flutter/rendering.dart';
import 'package:library_application/Model/favorite_book.dart';
import 'package:library_application/Repository/favorite_book_repository.dart';

class FavoritebookService {
  Future<List<FavoriteBook>> getAllFavoriteBookByUser(int userId) async {
    return FavoriteBookRepository().getAllFavoriteBookByUserId(userId);
  }

  Future<void> postFavoriteBook(int userId, int bookId) async {
    var response = await FavoriteBookRepository().postFavoriteBook(userId, bookId);
    response == "201" ? debugPrint("Книга $bookId успешно добавлена пользователю $userId") : debugPrint("Не удалось добавить книгу. Код ошибки: $response");
  }

  Future<bool> existBookInList(int userId, int bookId) async {
    return await FavoriteBookRepository().existFavoriteBook(userId, bookId);
  }

  Future<void> deleteFavoriteBook(int userId, int bookId) async {
    var response = await FavoriteBookRepository().deleteFavoriteBook(userId, bookId);
    response == "200" ? debugPrint("Книга $bookId успешно удалена у пользователя $userId") : debugPrint("Не удалось удалить книгу. Код ошибки: $response");
  }
  //Изменение приоритетов книг во всем списке
  Future<void> setPriorityListFavoriteBook(
    List<FavoriteBook> bookListNew,
  ) async {
    debugPrint("Очередь книг:");
    for (int i = 0; i <= bookListNew.length - 1; i++) {
      await FavoriteBookRepository().setPriorityFavoriteBook(
        bookListNew[i].userId,
        bookListNew[i].bookId,
        i + 1,
      );
      debugPrint("book ${bookListNew[i].bookId}");
    }
  }
}
