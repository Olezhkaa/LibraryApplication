import 'package:flutter/material.dart';
import 'package:library_application/Service/user_service.dart';
import 'package:library_application/View/main.dart';
import 'package:library_application/View/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int errorsCount = 0;

  String login = "";
  String password = "";

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Задний фон
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://i.pinimg.com/736x/a6/be/bc/a6bebc9f249fcf8f2cf40b87d9f4cdf1.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        //Окно заполнения данных
        child: Center(
          child: SingleChildScrollView(
            //Рамки
            child: Container(
              padding: EdgeInsets.only(
                top: 55,
                left: 35,
                right: 35,
                bottom: 40,
              ),
              //margin: EdgeInsets.only(top: 200),
              width: 350,
              height: 450,
              // decoration: BoxDecoration(
              //   //color: Colors.white,
              //   //border: Border.all(width: 2, color: Colors.black),
              //   //borderRadius: BorderRadius.all(Radius.circular(25)),
              // ),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Авторизация",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 50),
                    //Поле ввода Email
                    SizedBox(
                      width: 300,
                      height: 55,
                      child: TextFormField(
                        //maxLength: 36,
                        maxLines: 1,

                        validator: (value) {
                          int errorsCountEmail = 0;

                          if (value == null) {
                            errorsCountEmail++;
                            return "Введите адресс электронной почты";
                          }
                          if (value.length !=
                              value.replaceAll(' ', '').length) {
                            errorsCountEmail++;
                            return "Адресс электронной почты не должен содержать пробелы";
                          }
                          if (!value.contains("@")) {
                            errorsCountEmail++;
                            return "Введите корректный адресс электронной почты";
                          }
                          if (value[value.indexOf("@") + 1] == '') {
                            errorsCountEmail++;
                            return "Введите корректный адресс электронной почты";
                          }
                          if (value.length <= 2) {
                            errorsCountEmail++;
                            return "Адресс электронной почты должен быть больше 2 символов";
                          }

                          setState(() {
                            errorsCount += errorsCountEmail;
                          });

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            login = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          labelText: "Электронная почта",
                          //hintText: "Электронная почта",
                          suffixIcon: Icon(Icons.email, size: 20),

                          errorStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 15),
                    //Поле ввода пароля
                    SizedBox(
                      width: 300,
                      height: 55,
                      child: TextFormField(
                        maxLines: 1,
                        //СКрыть содержимое
                        obscureText: true,
                        validator: (value) {
                          int errorsCountPassword = 0;

                          if (value == null) {
                            errorsCountPassword++;
                            return "Введите пароль";
                          }
                          if (value.length !=
                              value.replaceAll(' ', '').length) {
                            errorsCountPassword++;
                            return "Пароль не должен содержать пробелы";
                          }
                          if (value.length <= 2 && value.length > 16) {
                            errorsCountPassword++;
                            return "Пароль должен быть от 2 до 16 символов";
                          }

                          setState(() {
                            errorsCount += errorsCountPassword;

                          });

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          labelText: 'Пароль',
                          //hintText: 'Пароль',
                          suffixIcon: Icon(Icons.lock, size: 20),

                          errorStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        debugPrint("Перейти на регистрацию");
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistrationPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Нет аккаунта? Нажмите, чтобы создать новый",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 5),
                    //Кнопка войти
                    ElevatedButton(
                      onPressed: () async {
                        debugPrint("$login, $password");
                        if (errorsCount == 0) {
                          var isAuthorization = await UserService().loginUser(
                            login,
                            password,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(isAuthorization, style: TextStyle(fontSize: 16),), 
                            padding: EdgeInsets.all(20),));
                          if (isAuthorization == "Авторизация прошла успешно") {
                            int userId = await UserService().getUserIdByEmail(login);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MyApp(initialIsLight: false, userId: userId),
                              ),
                            );
                          }
                        }
                        //     Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //           builder: (_) => MyApp(initialIsLight: false, userId: 1),
                        // ), );
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          EdgeInsets.only(
                            left: 65,
                            right: 65,
                            top: 5,
                            bottom: 5,
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.deepOrange,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.deepOrange),
                          ),
                        ),
                      ),
                      child: Text(
                        "Войти",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
