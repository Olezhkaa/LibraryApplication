import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:library_application/Entities/FavoriteBook.dart';
import 'package:library_application/Repository/AppConstants.dart';

class Favoritebookrepository {
  Future<List<FavoriteBook>> getAllFavoriteBookByUser(int userId) async {
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

  Future<String> postFavoriteBook(int userId, int bookId) async {
    List<FavoriteBook> favoriteBookList = await getAllFavoriteBookByUser(
      userId,
    );
    final response = await Dio().post(
      "${Appconstants.baseUrl}/api/users/$userId/favorites",
      data: {'bookId': bookId, 'priorityInList': favoriteBookList.length + 1},
    );
    return response.statusCode.toString();
  }

  Future<bool> extentionBookInList(int userId, int bookId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId/check",
    );
    return response.data;
  }

  Future<String> deleteFavoriteBook(int userId, int bookId) async {
    final response = await Dio().delete(
      "${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId",
    );
    return response.statusCode.toString();
  }

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

  Future<void> setPriorityListFavoriteBook(
    List<FavoriteBook> bookListNew,
  ) async {
    debugPrint("Очередь книг:");
    for (int i = 0; i <= bookListNew.length - 1; i++) {
      await setPriorityFavoriteBook(
        bookListNew[i].userId,
        bookListNew[i].bookId,
        i + 1,
      );
      debugPrint("book ${bookListNew[i].bookId}");
    }
  }
}
