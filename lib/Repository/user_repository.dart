import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:library_application/Model/user.dart';
import 'package:library_application/Service/app_constants.dart';

class UserRepository {
  //Получение всех пользователей
  Future<List<User>> getAllUsers() async {
    final response = await Dio().get("${Appconstants.baseUrl}/api/users");
    final data = response.data as List<dynamic>;
    final dataList = data.map((e) {
      final userData = e as Map<String, dynamic>;
      return User(
        id: userData['id'],
        email: userData['email'],
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        middleName: userData['middleName'],
      );
    }).toList();
    return dataList;
  }

  //Получить пользователя по id
  Future<User> getUserById(int userId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/users/$userId",
    );
    final data = response.data as Map<String, dynamic>;
    return User(
      id: data['id'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      middleName: data['middleName'],
    );
  }

  //Добавление нового пользователя
  Future<List<String>> postUser(
    String email,
    String password,
    String firstName,
    String lastName,
    String middleName,
  ) async {
    final response = await Dio().post(
      "${Appconstants.baseUrl}/api/users",
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'middleName': middleName,
      },
    );
    return [response.statusCode.toString(), response.data];
  }

  //Проверка авторизации пользователя
  Future<bool> loginUser(String email, String password) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/users/login",
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 201) {
      debugPrint("Авторизия пользователя $email прошла успешно");
      return true;
    } else {
      debugPrint(response.data);
      return false;
    }
  }

  //Получение изображения пользователя
  Future<String> getImageUser(int userId) async {
    final response = await Dio().get(
      "${Appconstants.baseUrl}/api/users/$userId/image",
    );

    final userImageData = response.data as Map<String, dynamic>;
    if (response.statusCode != 404) {
      final url = userImageData['url'].toString();
      // Если URL уже полный, возвращаем как есть
      if (url.startsWith('http')) {
        return url;
      }
      // Иначе добавляем baseUrl
      return "${Appconstants.baseUrl}$url";
    }
    return Appconstants.baseUserAnImagePath;
  }
}
