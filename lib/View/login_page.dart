import 'package:flutter/material.dart';
import 'package:library_application/Service/auth_validators.dart';
import 'package:library_application/Service/user_service.dart';
import 'package:library_application/View/main.dart';
import 'package:library_application/View/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? forceErrorTextEmail;
  String? forceErrorTextPassword;
  String? forceErrorTextServer;
  bool isLoading = false;

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    //При изменения поля очищать forceErrorText
    if (forceErrorTextEmail != null || forceErrorTextPassword != null) {
      setState(() {
        forceErrorTextEmail = null;
        forceErrorTextPassword = null;
      });
    }
  }

  Future<void> onSave() async {
    final bool isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
      //Очищаем ошибку сервера, при новом запуске
      forceErrorTextServer = null;
    });

    String email = controllerEmail.text;
    String password = controllerPassword.text;

    final String? errorTextEmail = AuthValidators().emailValidator(email);
    final String? errorTextPassword = AuthValidators().passwordValidator(
      password,
    );

    int countError = 0;
    if (errorTextEmail != null) {
      setState(() {
        forceErrorTextEmail = errorTextEmail;
      });
      countError++;
    }
    if (errorTextPassword != null) {
      setState(() {
        forceErrorTextPassword = errorTextPassword;
      });
      countError++;
    }
    if (countError != 0) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final String? errorText = await UserService().loginUser(email, password);

      // Проверяем mounted перед setState
      if (!mounted) return;

      setState(() {
        isLoading = false;
        if (errorText != null) {
          forceErrorTextServer = errorText;
        }
      });
    } catch (e) {
      // Обработка исключений
      debugPrint("Ошибка: $e");
      debugPrint("$email и $password");
      if (!mounted) return;

      setState(() {
        isLoading = false;
        forceErrorTextServer =
            "Произошла ошибка при подключении к серверу. Попробуйте повторить попытку позже.";
      });
    }
    if (forceErrorTextServer != null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Ошибка"),
          content: Text(forceErrorTextServer!),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text("Закрыть"),
            ),
          ],
        ),
      );
    } else {
      int userId = await UserService().getUserIdByEmail(email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyApp(initialIsLight: false, userId: userId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Задний фон
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: NetworkImage(
          //     "https://i.pinimg.com/736x/a6/be/bc/a6bebc9f249fcf8f2cf40b87d9f4cdf1.jpg",
          //   ),
          //   fit: BoxFit.cover,
          // ),
        ),
        //Окно заполнения данных
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsetsGeometry.only(
                top: 55,
                left: 35,
                right: 35,
                bottom: 40,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Авторизация",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 50),
                    //Поле ввода Email
                    SizedBox(
                      width: 300,
                      height: forceErrorTextEmail == null ? 80 : 50,
                      child: TextFormField(
                        maxLines: 1,
                        forceErrorText: forceErrorTextEmail,
                        validator: (value) =>
                            AuthValidators().emailValidator(value!),
                        onChanged: (value) => onChanged(value),
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          filled: false,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          labelText: "Электронная почта",
                          //hintText: "Электронная почта",
                          suffixIcon: Icon(Icons.email, size: 20),
                          errorMaxLines: 1,
                          errorStyle: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 15),
                    //Поле ввода пароля
                    SizedBox(
                      width: 300,
                      height: forceErrorTextEmail == null ? 80 : 50,
                      child: TextFormField(
                        maxLines: 1,
                        //СКрыть содержимое
                        obscureText: true,
                        validator: (value) =>
                            AuthValidators().passwordValidator(value!),
                        controller: controllerPassword,
                        forceErrorText: forceErrorTextPassword,
                        onChanged: (value) => onChanged(value),
                        decoration: InputDecoration(
                          filled: false,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          labelText: 'Пароль',
                          //hintText: 'Пароль',
                          suffixIcon: Icon(Icons.lock, size: 20),
                          errorMaxLines: 1,
                          errorStyle: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    //Отступ
                    SizedBox(height: 5),

                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      //Кнопка войти
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () async {
                            onSave();
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
