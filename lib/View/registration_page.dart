import 'package:flutter/material.dart';
import 'package:library_application/Service/auth_validators.dart';
import 'package:library_application/Service/user_service.dart';
import 'package:library_application/View/login_page.dart';
import 'package:library_application/View/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  String? forceErrorTextEmail;
  String? forceErrorTextFirstName;
  String? forceErrorTextLastName;
  String? forceErrorTextMiddleName;
  String? forceErrorTextPassword;
  String? forceErrorTextServer;
  bool isLoading = false;

  final controllerEmail = TextEditingController();
  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerMiddleName = TextEditingController();
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
    setState(() {
        forceErrorTextEmail = null;
        forceErrorTextPassword = null;
        forceErrorTextFirstName = null;
        forceErrorTextLastName = null;
        forceErrorTextMiddleName = null;
      });
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
    String lastName = controllerLastName.text;
    String firstName = controllerFirstName.text;
    String middleName = controllerMiddleName.text;

    final String? errorTextEmail = AuthValidators().emailValidator(email);
    final String? errorTextPassword = AuthValidators().passwordValidator(
      password,
    );
    final String? errorTextLastName = AuthValidators().requiredFieldValidator(lastName);
    final String? errorTextFirstName = AuthValidators().requiredFieldValidator(firstName);
    final String? errorTextMiddleName = AuthValidators().noRequiredFieldValidator(middleName);

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
    if (errorTextLastName != null) {
      setState(() {
        forceErrorTextLastName = errorTextLastName;
      });
      countError++;
    }
    if (errorTextFirstName != null) {
      setState(() {
        forceErrorTextFirstName = errorTextFirstName;
      });
      countError++;
    }
    if (errorTextMiddleName != null) {
      setState(() {
        forceErrorTextMiddleName = errorTextMiddleName;
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
      final String? errorText = await UserService().registerNewUser(email, password, firstName, lastName, middleName);

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
      debugPrint("$email и $password, $lastName, $firstName, $middleName");
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userIdIsLogin', userId);
      final isLight = prefs.getBool('isLightTheme') ?? true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyApp(initialIsLight: isLight, userId: userId),
        ),
      );
      controllerEmail.clear();
      controllerPassword.clear();
      controllerLastName.clear();
      controllerFirstName.clear();
      controllerMiddleName.clear();
    }
  }

  final double isSizedBoxBetweenFields = 10;

  Future<bool> _onWillPop() async {
        return false;
    }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
          body: Center(
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
                        "Регистрация",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      //Отступ
                      SizedBox(height: 50),
      
                      //Поле ввода Фамилии
                      SizedBox(
                        width: 300,
                        height: forceErrorTextLastName == null ? 80 : 50,
                        child: TextFormField(
                          maxLines: 1,
                          forceErrorText: forceErrorTextLastName,
                          validator: (value) =>
                              AuthValidators().requiredFieldValidator(value!),
                          onChanged: (value) => onChanged(value),
                          controller: controllerLastName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: "Фамилия",
                            suffixIcon: Icon(Icons.person, size: 20),
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                      //Отступ
                      SizedBox(height: isSizedBoxBetweenFields),
      
                      //Поле ввода Фамилии
                      SizedBox(
                        width: 300,
                        height: forceErrorTextFirstName == null ? 80 : 50,
                        child: TextFormField(
                          maxLines: 1,
                          forceErrorText: forceErrorTextFirstName,
                          validator: (value) =>
                              AuthValidators().requiredFieldValidator(value!),
                          onChanged: (value) => onChanged(value),
                          controller: controllerFirstName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: "Имя",
                            suffixIcon: Icon(Icons.person, size: 20),
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                      //Отступ
                      SizedBox(height: isSizedBoxBetweenFields),
      
                      //Поле ввода Фамилии
                      SizedBox(
                        width: 300,
                        height: forceErrorTextMiddleName == null ? 80 : 50,
                        child: TextFormField(
                          maxLines: 1,
                          forceErrorText: forceErrorTextMiddleName,
                          validator: (value) =>
                              AuthValidators().noRequiredFieldValidator(value!),
                          onChanged: (value) => onChanged(value),
                          controller: controllerMiddleName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: "Отчество",
                            suffixIcon: Icon(Icons.person, size: 20),
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                      //Отступ
                      SizedBox(height: isSizedBoxBetweenFields),
      
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
                      SizedBox(height: isSizedBoxBetweenFields),
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
                          debugPrint("Перейти на авторизацию");
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
                                builder: (_) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Есть аккаунт? Нажмите, чтобы авторизоваться",
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
                        //Кнопка зарегестрироваться
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () async {
                              onSave();
                            },
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                EdgeInsets.only(
                                  left: 55,
                                  right: 55,
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
                              "Зарегестрироваться",
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
