import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:library_application/Repository/user_repository.dart';
import 'package:library_application/Service/user_service.dart';
import 'package:test/test.dart';

void main() {
  test('Добавление нового пользователя', () async {
    try {
        final response = await UserService().registerNewUser("test@test.com", "12345678", "testLast", "testFirst", "testMiddle");
        debugPrint(response);
      } catch (e) {
        debugPrint("Ошибка: $e");
      }
  });

  test('Проверка авторизации пользователя', () async {
    try {
        final response = await UserService().loginUser("test@test.test", "12345678");
        debugPrint(response);
      } catch (e) {
        debugPrint("Ошибка: $e");
      }
  });

  test(
    'Тестирование загрузки изображения пользователя uploadImageUser()',
    () async {
      try {
        File image = File('D://Projects/library_application/test/image.png');
        final response = await UserRepository().uploadImageUser(2, image);
        debugPrint("${response[0]} ----- ${response[1]}");
      } catch (e) {
        debugPrint("Ошибка: $e");
      }
    },
  );
}
