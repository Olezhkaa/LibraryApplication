import 'package:flutter/material.dart';
//import 'package:library_application/View/main.dart';

class ProfilePage extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final bool isLight;
  const ProfilePage({super.key,required this.onThemeChanged, required this.isLight});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const WidgetStateProperty<Icon> thumbIcon = WidgetStateProperty<Icon>.fromMap(
      <WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.sunny, color: Colors.amber),
        WidgetState.any: Icon(Icons.dark_mode,),
  },);

  late bool valueThemeMode;

  @override
  void initState() {
    super.initState();
    valueThemeMode = widget.isLight; // ставим switch в сохранённое положение
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(20)),
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
                    backgroundImage: NetworkImage('https://i.pinimg.com/originals/82/1b/bb/821bbbb461beaeda0f8d3cc224ba631c.jpg'),
                  ),
                  SizedBox(height: 10,),
                  Text("Фадеев Олег", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)
                ],
              ),
            )
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text("Тема: "),
                SizedBox(width: 8,),
                SizedBox(
                  width: 50,
                  child: Switch(
                  thumbIcon: thumbIcon,
                  value: valueThemeMode, 
                  onChanged: (bool value) {
                    setState(() {
                    valueThemeMode = value;
                    });
                    widget.onThemeChanged(value);
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

