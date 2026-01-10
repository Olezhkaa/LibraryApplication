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
    for(User user in userList) {
      if(user.email == email) {
        return user.id;
      }
    }
    return 0;
  }

  //Регистраиця пользователя
  Future<String> registerNewUser(
    String email,
    String password,
    String firstName,
    String lastName,
    String middleName,
  ) async {
    final response = await UserRepository().postUser(
      email,
      password,
      firstName,
      lastName,
      middleName,
    );
    try {
      if (response[0] == "201") {
        debugPrint("Пользователь $email зарегестрировался");
        return "Регистрация прошла успешно";
      } else {
        debugPrint(response[1]);
        return "Произошла ошибка, попробуйте заполнить поля заново";
      }
    } catch (e) {
      debugPrint("$e");
      return "Произошла ошибка регистрации пользователя";
    }
  }

  //Авторизация пользователя
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await UserRepository().loginUser(email, password);
      if (response) return "Авторизация прошла успешно";
      return "Неверный email или пароль";
    } catch (e) {
      debugPrint("Произошла ошибка авторизации: $e");
      return "Произошла ошибка авторизации";
    }
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
