import 'package:dio/dio.dart';
import 'package:library_application/Model/collection.dart';
import 'package:library_application/Service/app_constants.dart';

class CollectionRepository {
  //Получить все коллекуции
  Future<List<Collection>> getAllCollection() async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/collection");
    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final collectionData = e as Map<String, dynamic>;
      return Collection(id: collectionData['id'], title: collectionData['title']);
    }).toList();
    return dataList;
  }
}