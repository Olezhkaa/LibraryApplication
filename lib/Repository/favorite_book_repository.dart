import 'package:dio/dio.dart';
import 'package:library_application/Model/favorite_book.dart';
import 'package:library_application/Service/app_constants.dart';

class FavoriteBookRepository {
  //Получить все избранные книги у пользователя
  Future<List<FavoriteBook>> getAllFavoriteBookByUserId(int userId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/users/$userId/favorites",
    );
    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final favoriteBookData = e as Map<String, dynamic>;
      return FavoriteBook(
        id: favoriteBookData['id'],
        userId: favoriteBookData['userId'],
        bookId: favoriteBookData['bookId'],
        priorityInList: favoriteBookData['priorityInList'],
      );
    }).toList();
    return dataList;
  }
  //Добавить книгу в избранное
  Future<String> postFavoriteBook(int userId, int bookId) async {
    List<FavoriteBook> favoriteBookList = await getAllFavoriteBookByUserId(
      userId,
    );
    final response = await Dio().post(
      "${Appconstants.baseUrl}/api/users/$userId/favorites",
      data: {'bookId': bookId, 'priorityInList': favoriteBookList.length + 1},
    );
    return response.statusCode.toString();
  }
  //Существует ли данная книга
  Future<bool> existFavoriteBook(int userId, int bookId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId/check",
    );
    return response.data;
  }
  //Удаление книги из избранного
  Future<String> deleteFavoriteBook(int userId, int bookId) async {
    final response = await Dio().delete(
      "${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId",
    );
    return response.statusCode.toString();
  }
  //Смена приоритета книги
  Future<String> setPriorityFavoriteBook(
    int userId,
    int bookId,
    int priorityInList,
  ) async {
    final response = await Dio().put(
      "${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId/priority",
      data: {'priorityInList': priorityInList},
    );
    return response.statusCode.toString();
  }
}
