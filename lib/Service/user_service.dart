import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_application/Model/user.dart';
import 'package:library_application/Repository/user_repository.dart';

class UserService {
  //Получение данных пользователя по id
  Future<User> getUserById(int userId) async {
    return await UserRepository().getUserById(userId);
  }

  Future<int> getUserIdByEmail(String email) async {
    var userList = await UserRepository().getAllUsers();
    for (User user in userList) {
      if (user.email == email) {
        return user.id;
      }
    }
    return 0;
  }

  //Регистраиця пользователя
  Future<String?> registerNewUser(
    String email,
    String password,
    String firstName,
    String lastName,
    String middleName,
  ) async {
    final response = await UserRepository()
        .postUser(email, password, firstName, lastName, middleName)
        .timeout(Duration(seconds: 10));
    if (response == 201) {
      debugPrint("Пользователь $email зарегестрировался");
      return null;
    } else if (response == 400) {
      if (await getUserIdByEmail(email) != 0) return "Пользователь с таким адрессом электронной почты уже существует";
      return "Произошла ошибка, попробуйте заполнить поля заново";
    }
    return "Произошла ошибка на стороне сервера. Попробуйте повторить попытку позже.";
  }

  //Авторизация пользователя
  Future<String?> loginUser(String email, String password) async {
    final response = await UserRepository().loginUser(email, password);
    debugPrint("Статус код авторизации: $response");
    if (response == 200) return null;
    if (response == 401) return "Неверный email или пароль";
    return "Произошла ошибка на стороне сервера. Попробуйте повторить попытку позже.";
  }

  //Получение изображение пользоватлея
  Future<String> getImageUser(int userId) async {
    return await UserRepository().getImageUser(userId);
  }

  //Загрузка изображения пользовалетя
  Future<String> postImageUser(int userId) async {
    File image;
    var imagePicker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imagePicker != null) {
      image = imagePicker as File;

      try {
        final response = await UserRepository().uploadImageUser(userId, image);
        if (response[0] == "201") {
          return "Изображение успешно загружено";
        } else {
          return "Произошла ошибка";
        }
      } catch (e) {
        debugPrint("$e");
        return ("Ошибка загрузки изображения");
      }
    }
    return "Изображение не было выбрано";
  }
}
