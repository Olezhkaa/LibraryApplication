import 'package:library_application/Entities/Book.dart';
import 'package:dio/dio.dart';

class BookRepository {
  Future<List<Book>> getAllBooks() async {
    final response = await Dio().get("http://10.27.105.230:5000/api/books");

    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final bookData = e as Map<String, dynamic>;
      return Book(
        id: bookData['id'],
        title: bookData['title'],
        author: bookData['authorFullName'],
        genre: bookData['genreTitle'],
        description: bookData['description'],
        imagePath:
            "https://otvet.cdn-vk.net/api/pictures/images/4ba11f583ec5fa1e234de222406fc0cf044d996c7869395cffdcf5b35624368d49da6c3c811fc5f8072a30a3b562b775.jpg?size=origin",
      );
    }).toList();
    return dataList;
  }
}