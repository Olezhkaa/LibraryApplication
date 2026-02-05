import 'package:dio/dio.dart';
import 'package:library_application/Model/author.dart';
import 'package:library_application/Service/app_constants.dart';

class AuthorRepository {
  //Получить всех авторов
  Future<List<Author>> getAllAuthors() async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/authors");
    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final authorData = e as Map<String, dynamic>;
      return Author(
        id: authorData['id'],
        lastName: authorData['lastName'],
        firstName: authorData['firstName'],
        middleName: authorData['middleName'],
        dateOfBirth: authorData['dateOfBirth'],
        dateOfDeath: authorData['dateOfDeath'],
        country: authorData['country'],
      );
    }).toList();
    return dataList;
  }

  //Получить автора по id
  Future<Author> getAuthorById(int authorId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/authors/$authorId",
    );
    final authorData = response.data as Map<String, dynamic>;
    return Author(
      id: authorData['id'],
      lastName: authorData['lastName'],
      firstName: authorData['firstName'],
      middleName: authorData['middleName'],
      dateOfBirth: authorData['dateOfBirth'],
      dateOfDeath: authorData['dateOfDeath'],
      country: authorData['country'],
    );
  }

  //Получить изображениеа автора
  Future<String> getMainImageAuthor(int authorId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/authors/$authorId/images",
    );

    final data = response.data as List<dynamic>;

    //Изображение с isMain == true
    for (var item in data) {
      final authorImageData = item as Map<String, dynamic>;
      if (authorImageData['isMain'] == true) {
        final url = authorImageData['url'] as String;
        //Если URL уже полный, возвращаем как есть
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

    return Appconstants.baseAuthorImagePath;
  }
}
