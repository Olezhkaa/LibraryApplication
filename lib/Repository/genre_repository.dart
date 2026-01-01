import 'package:dio/dio.dart';
import 'package:library_application/Model/genre.dart';
import 'package:library_application/Service/app_constants.dart';

class GenreRepository {
  //Получить полный список жанров
  Future<List<Genre>> getAll() async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/genres");

    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final bookData = e as Map<String, dynamic>;
      return Genre(id: bookData['id'], title: bookData['title']);
    }).toList();
    return dataList;
  }
}