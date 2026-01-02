import 'package:flutter/rendering.dart';
import 'package:library_application/Model/user.dart';
import 'package:library_application/Repository/user_repository.dart';

class UserService {
  //Получение данных пользователя по id
  Future<User> getUserById(int userId) async {
    return await UserRepository().getUserById(userId);
  }

  //Регистраиця пользователя
  Future<String> registerNewUser(User user, String password) async {
    final response = await UserRepository().postUser(
      user.email,
      password,
      user.firstName,
      user.lastName,
      user.middleName,
    );
    if (response[0] == "201") {
      debugPrint("Пользователь ${user.email} зарегестрировался");
      return "Регистрация прошла успешно";
    } else {
      debugPrint(response[1]);
      return response[1];
    }
  }

  //Авторизация пользователя
  Future<String> loginUser(String email, String password) async {
    final response = await UserRepository().loginUser(email, password);
    if (!response) {
      return "Неверный email или пароль";
    }
    return "Авторизация прошла успешно";
  }

  //Получение изображение пользоватлея
  Future<String> getImageUser(int userId) async {
    return await UserRepository().getImageUser(userId);
  }
}
