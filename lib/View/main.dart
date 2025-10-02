import 'package:flutter/material.dart';
import 'package:library_application/View/collection_books_page.dart';
import 'package:library_application/View/main_menu_page.dart';
import 'package:library_application/View/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  // читаем сохранённую тему, если нет — ставим светлую
  final isLight = prefs.getBool('isLightTheme') ?? true;

  runApp(MyApp(initialIsLight: isLight));
}

class MyApp extends StatefulWidget {
  final bool initialIsLight;
  const MyApp({super.key, required this.initialIsLight});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Тема поумолчанию
  late ThemeMode _themeMode;
  late bool isLight;

  @override
  void initState() {
    super.initState();
    isLight = widget.initialIsLight;
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
  }

  // Переключение темы + сохранение
  void _toggleTheme(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightTheme', isLight);

    setState(() {
      this.isLight = isLight;
      _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),

      themeMode: _themeMode,

      home: LibraryMainPage(onThemeChanged: _toggleTheme, isLight: isLight),
    );
  }
}

class LibraryMainPage extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final bool isLight;
  const LibraryMainPage({
    super.key,
    required this.onThemeChanged,
    required this.isLight,
  });

  @override
  State<LibraryMainPage> createState() => _LibraryMainPageState();
}

class _LibraryMainPageState extends State<LibraryMainPage> {
  int currentPageIndex = 0;
  //Color colorTheme = Theme.of(context).colorScheme.inversePrimary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppBar(currentPageIndex),
        title: Text(
          "Личная библиотека",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              final snackBar = SnackBar(
                content: const Text(
                  "Это ваша личная библиотека, где вы можете отмечать прочитанные книги, добавлять в избранное и делиться с друзьями.",
                ),
                action: SnackBarAction(label: "Спрятать", onPressed: () {}),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: Icon(Icons.info, color: Colors.deepOrange),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(color: Colors.deepOrange); // активный
            }
            return const TextStyle(color: Colors.grey); // неактивный
          }),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.deepOrange); // активный
            }
            return const IconThemeData(color: Colors.grey); // неактивный
          }),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          //labelTextStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.purple)), //Цвет надписей
          //indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Главная",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.bookmark),
              icon: Icon(Icons.bookmark_outline),
              label: "Коллекция",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: "Профиль",
            ),
          ],
        ),
      ),
      body: <Widget>[
        MainMenu(),
        CollectionBooks(),
        ProfilePage(
          onThemeChanged: widget.onThemeChanged,
          isLight: widget.isLight,
        ),
      ][currentPageIndex],
    );
  }

  Color? colorAppBar(int currentPageIndex) {
    if (currentPageIndex == 2)
      return Theme.of(context).colorScheme.surfaceContainer;
    return null;
  }
}
