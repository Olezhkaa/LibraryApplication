import 'package:library_application/Entities/Genre.dart';
import 'package:dio/dio.dart';
import 'package:library_application/Repository/AppConstants.dart';

class GenreRepository {
  Future<List<Genre>> getAllGenres() async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/genres");

    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final bookData = e as Map<String, dynamic>;
      return Genre(id: bookData['id'], title: bookData['title']);
    }).toList();
    return dataList;
  }
}
