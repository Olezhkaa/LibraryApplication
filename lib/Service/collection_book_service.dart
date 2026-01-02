import 'package:library_application/Model/collection_book.dart';
import 'package:library_application/Repository/collection_book_repository.dart';

class CollectionBookService {

  //Покзать все книги в опеределенной коллекции у пользователя
  Future<List<CollectionBook>> getAllBookInCollectionByUser(int userId, int collectionId) async {
    return CollectionBookRepository().getAllBookInCollectionByUser(userId, collectionId);
  }

  //Добавить книгу в коллекию
  Future<void> postBookInCollection(int userId, int collectionId, int bookId ) async {
    await CollectionBookRepository().postBookInCollection(userId, collectionId, bookId);
  } 

  //Удалить книгу из коллекции
  Future<void> deleteBookFromCollection(int userId, int collectionId, int bookId) async {
    await CollectionBookRepository().deleteBookFromCollection(userId, collectionId, bookId);
  }

  //Переместить книгу из коллекции в коллекцию
  Future<void> moveBookFromCollections(int userId, int collectionId, int bookId, int targetCollectionId) async {
    await CollectionBookRepository().moveBookFromCollections(userId, collectionId, bookId, targetCollectionId);
  }

  //Есть ли эта книга в коллекция, вернуть id коллекции, иначе 0
  Future<int> existBookInCollectionByUser(int userId, int bookId) async {
    final listCollectionBook = await CollectionBookRepository().getAllBookByUser(userId);
    for(var item in listCollectionBook) {
      if(item.bookId == bookId) {
        return item.collectionId;
      }
    }
    return 0;
  }
}