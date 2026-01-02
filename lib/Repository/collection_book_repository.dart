import 'package:dio/dio.dart';
import 'package:library_application/Model/collection_book.dart';
import 'package:library_application/Service/app_constants.dart';

class CollectionBookRepository {

  //Показать все книги пользователя по коллекциям
  Future<List<CollectionBook>> getAllBookByUser(int userId) async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/users/$userId/collections");
    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final collectionBookData = e as Map<String, dynamic>;
      return CollectionBook(id: collectionBookData['id'], userId: collectionBookData['userId'], collectionId: collectionBookData['collectionId'], bookId: collectionBookData['bookId']);
    }).toList();
    return dataList;
  }

  //Покзать все книги в опеределенной коллекции у пользователя
  Future<List<CollectionBook>> getAllBookInCollectionByUser(int userId, int collectionId) async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/users/$userId/collections/$collectionId/books");
    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final collectionBookData = e as Map<String, dynamic>;
      return CollectionBook(id: collectionBookData['id'], userId: collectionBookData['userId'], collectionId: collectionBookData['collectionId'], bookId: collectionBookData['bookId']);
    }).toList();
    return dataList;
  }

  //Добавить книгу в коллекию
  Future<List<String>> postBookInCollection(int userId, int collectionId, int bookId ) async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/users/$userId/collections/$collectionId/books", data: {'bookId': bookId});
    return [response.statusCode.toString(), response.data];
  } 

  //Удалить книгу из коллекции
  Future<List<String>> deleteBookFromCollection(int userId, int collectionId, int bookId) async {
    final response = await Dio().delete("${Appconstants.baseUrl}/api/users/$userId/collections/$collectionId/books/$bookId");
    return [response.statusCode.toString(), response.data];
  }

  //Переместить книгу из коллекции в коллекцию
  Future<List<String>> moveBookFromCollections(int userId, int collectionId, int bookId, int targetCollectionId) async {
    final response = await Dio().put("${Appconstants.baseUrl}/api/users/$userId/collections/$collectionId/books/$bookId/move", data: {'targetCollectionId': targetCollectionId});
    return [response.statusCode.toString(), response.data];
  }
}