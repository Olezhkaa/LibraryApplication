import 'package:dio/dio.dart';
import 'package:library_application/Model/book.dart';
import 'package:library_application/Service/app_constants.dart';

class BookRepository {
  Future<List<Book>> getAll() async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/books");

        final data = response.data as List<dynamic>;
        final dataList = data.map((e) async {
          final bookData = e as Map<String, dynamic>;

          final imagePath = await getMainImageBook(bookData['id']);

          return Book(
            id: bookData['id'],
            title: bookData['title'],
            author: bookData['authorFullName'],
            genre: bookData['genreTitle'],
            description: bookData['description'],
            imagePath: imagePath,
          );
        }).toList();
        return await Future.wait(dataList);
  }

  Future<Book> getById(int bookId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/books/$bookId",
    );
    final data = response.data as Map<String, dynamic>;
    String imagePath = await getMainImageBook(bookId);
    return Book(
      id: data['id'],
      title: data['title'],
      author: data['authorFullName'],
      genre: data['genreTitle'],
      description: data['description'],
      imagePath: imagePath,
    );
  }

  Future<String> getMainImageBook(int bookId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/books/$bookId/images",
    );

    final data = response.data as List<dynamic>;

    // Ищем изображение с isMain == true
    for (var item in data) {
      final bookImageData = item as Map<String, dynamic>;
      if (bookImageData['isMain'] == true) {
        final url = bookImageData['url'] as String;
        // Если URL уже полный, возвращаем как есть
        if (url.startsWith('http')) {
          return url;
        }
        // Иначе добавляем baseUrl
        return "${Appconstants.baseUrl}$url";
      }
    }

    // Если нет главного изображения, возвращаем первое или заглушку
    if (data.isNotEmpty) {
      final firstImage = data[0] as Map<String, dynamic>;
      final url = firstImage['url'] as String;
      if (url.startsWith('http')) {
        return url;
      }
      return "${Appconstants.baseUrl}$url";
    }

    // Если вообще нет изображений
    return Appconstants.baseBookImagePath;
  }
}