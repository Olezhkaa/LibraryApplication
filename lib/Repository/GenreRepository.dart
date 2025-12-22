import 'package:library_application/Entities/Genre.dart';
import 'package:dio/dio.dart';

class GenreRepository {
  Future<List<Genre>> getAllGenres() async {
    final response = await Dio().get("http://10.27.105.230:5000/api/genres");

    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final bookData = e as Map<String, dynamic>;
      return Genre(id: bookData['id'], title: bookData['title']);
    }).toList();
    return dataList;
  }

  // Future<Genre> getGenreById() async {
  //   final response = await Dio().get("http://10.100.0.25:5000/api/genre/");

  //   final data = response.data as List<dynamic>;
  //   final dataList = data.map((e) {
  //     final bookData = e as Map<String, dynamic>;
  //     return Genre(id: bookData['id'], title: bookData['title']);
  //   }).toList();
  //   return dataList;
  // }
}