import 'package:library_application/Model/collection.dart';
import 'package:library_application/Repository/collection_repository.dart';

class CollectionService {
  //Получить все коллекции
  Future<List<Collection>> getAllCollection() async {
    List<Collection> listCollection = await CollectionRepository().getAllCollection();
    if(listCollection.isNotEmpty) listCollection.insert(0, Collection(id: 0, title: "Избранное"));
    return listCollection;
  }
}