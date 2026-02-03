
import 'package:library_application/Model/collection.dart';
import 'package:library_application/Repository/collection_repository.dart';

class CollectionService {
  //Получить все коллекции
  Future<List<Collection>> getAllCollection() async {
    List<Collection> listCollection = await CollectionRepository().getAllCollection();
    if(listCollection.isNotEmpty) listCollection.insert(0, Collection(id: 0, title: "Избранное"));
    return listCollection;
  }

  //Получить все коллекции Кроме избранного
  Future<List<Collection>> getAllCollectionNoFavorite() async {
    List<Collection> listCollection = await CollectionRepository().getAllCollection();
    if(listCollection.isNotEmpty) listCollection.insert(0, Collection(id: 0, title: "Выберите коллекцию"));
    return listCollection;
  }

  //Получить id по title
  Future<int> getIdByCollectionName(String value) async {
    List<Collection> listCollection = await CollectionRepository().getAllCollection();
    for(var collection in listCollection) {
      if(collection.title == value) {
        return collection.id;
      }
    }
    return 0;
  }

  //Получить title по id
  Future<String?> getTitleByCollectionId(int id) async {
    List<Collection> listCollection = await CollectionRepository().getAllCollection();
    for(var collection in listCollection) {
      if(collection.id == id) {
        return collection.title;
      }
    }
    return null;
  }
}