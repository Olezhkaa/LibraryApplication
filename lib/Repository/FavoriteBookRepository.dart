import 'package:dio/dio.dart';
import 'package:library_application/Entities/FavoriteBook.dart';
import 'package:library_application/Repository/AppConstants.dart';

class Favoritebookrepository {
  Future<List<FavoriteBook>> getAllFavoriteBookByUser(int userId) async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/users/$userId/favorites");
    final data = response.data as List<Map>;
    final dataList = data.map((e) {
      final favoriteBookData = e as Map<String, dynamic>;
      return FavoriteBook(id: favoriteBookData['id'], userId: favoriteBookData['userId'], bookId: favoriteBookData['bookId']);
    }).toList();
    return dataList;
  }

  Future<String> postFavoriteBook(int userId, int bookId) async {
    List<FavoriteBook> favoriteBookList = await getAllFavoriteBookByUser(userId);
    final response = await Dio().post("${Appconstants.baseUrl}/api/users/$userId/favorites", data: {'bookId': bookId, 'priorityInList': favoriteBookList.length});
    return response.statusCode.toString();
  }

  Future<bool> extentionBookInList(int userId, int bookId) async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId/check");
    return response.data;
  }

  Future<String> deleteFavoriteBook(int userId, int bookId) async {
    final response = await Dio().delete("${Appconstants.baseUrl}/api/users/$userId/favorites/$bookId");
    return response.statusCode.toString();
  }
}