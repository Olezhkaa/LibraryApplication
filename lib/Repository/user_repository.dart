import 'dart:io';

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
  Future<int> postUser(
    String email,
    String password,
    String firstName,
    String lastName,
    String middleName,
  ) async {
    try 
      {final response = await Dio().post(
      "${Appconstants.baseUrl}/api/users",
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'middleName': middleName,
      },
    );
    return response.statusCode!;
    } on DioException catch (e) {
      // Обработка ошибок Dio
      if (e.response != null) {
        // Сервер ответил с ошибкой 
        return e.response!.statusCode ?? 404;
      } else {
        // Ошибка сети или другая ошибка
        return 404;
      }
    }
    catch (e) {
      return 404;
    }
  }

  //Проверка авторизации пользователя
  Future<int> loginUser(String email, String password) async {
    try {
      final response = await Dio().post(
        "${Appconstants.baseUrl}/api/users/login",
        data: {'email': email, 'password': password},
      );
      return response.statusCode!;
    } on DioException catch (e) {
      // Обработка ошибок Dio
      if (e.response != null) {
        // Сервер ответил с ошибкой (например, 401, 500)
        return e.response!.statusCode ?? 404;
      } else {
        // Ошибка сети или другая ошибка
        return 404;
      }
    } catch (e) {
      // Любые другие исключения
      return 404;
    }
  }

  //Получение изображения пользователя
  Future<String> getImageUser(int userId) async {
    try {
      final response = await Dio().get(
        "${Appconstants.baseUrl}/api/users/$userId/image",
      );
      debugPrint("${response.statusCode}");
      final url = "${Appconstants.baseUrl}/api/users/$userId/image";
      return url;
    } catch (e) {
      return Appconstants.baseUserAnImagePath;
    }
  }

  //Загрузка изображения
  Future<List<String>> uploadImageUser(int userId, File image) async {
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename:
            'User_$userId'
            '_imageProfile.png',
      ),
    });
    final response = await Dio().post(
      "${Appconstants.baseUrl}/api/users/$userId/image",
      data: formData,
    );
    debugPrint(
      "${response.statusCode.toString()}, ${response.data.toString()}",
    );
    return [response.statusCode.toString(), response.data.toString()];
  }
}
