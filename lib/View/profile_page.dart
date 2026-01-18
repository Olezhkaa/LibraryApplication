import 'package:flutter/material.dart';
import 'package:library_application/Model/user.dart';
import 'package:library_application/Service/app_constants.dart';
import 'package:library_application/Service/user_service.dart';
import 'package:library_application/View/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:library_application/View/main.dart';

class ProfilePage extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final bool isLight;
  final int userId;
  const ProfilePage({
    super.key,
    required this.onThemeChanged,
    required this.isLight,
    required this.userId,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int userId = 0;
  late User user = User(
    id: 0,
    email: "",
    firstName: "",
    lastName: "",
    middleName: "",
  );
  late String userImage = Appconstants.baseUserAnImagePath;
  late bool valueThemeMode;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    initData();
  }

  void initData() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('userId: $userId');
    user = await UserService().getUserById(userId);
    userImage = await UserService().getImageUser(userId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainer,
                // width: 3.0
              ),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 48, // Image radius
                    backgroundImage: NetworkImage(userImage),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),
                    buttonReplaceTheme(),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 8),
                    buttonInfo(),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 8),
                    buttonOutLogin(),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buttonReplaceTheme() {
    bool currentTheme = widget.isLight;
    IconData iconTheme = currentTheme ? Icons.sunny : Icons.dark_mode;
    String textTheme = currentTheme ? "Светлая тема" : "Темная тема";

    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(animationDuration: Duration(microseconds: 100)),
          onPressed: () {
            setState(() {
              valueThemeMode = !currentTheme;
            });
            widget.onThemeChanged(!currentTheme);
          },
          child: Row(
            children: [Icon(iconTheme), SizedBox(width: 20), Text(textTheme)],
          ),
        ),
      ),
    );
  }

    Expanded buttonInfo() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(animationDuration: Duration(microseconds: 100)),

          onPressed: () {
            final snackBar = SnackBar(
                content: const Text(
                  "Это ваша личная библиотека, где вы можете отмечать прочитанные книги, добавлять в избранное и делиться с друзьями.",
                ),
                action: SnackBarAction(label: "Спрятать", onPressed: () {}),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 20),
              Text(
                "О приложении",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buttonOutLogin() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(animationDuration: Duration(microseconds: 100)),

          onPressed: () {
            setState(() async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('userIdIsLogin', 0);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            });
          },
          child: Row(
            children: [
              Icon(Icons.output, color: Colors.redAccent),
              SizedBox(width: 20),
              Text(
                "Выйти из аккаунта",
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
