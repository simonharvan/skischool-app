import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skishool/data/auth.dart';
import 'package:skishool/screens/lessons_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  final Auth _auth = Auth();

  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'SkiSchool',
//      theme: ,
//      home: new LoginPage(),
//    );
  return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>.value(value: _auth),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: true,
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Consumer<Auth>(builder: (context, model, child) {
            if (model?.token != null) return LessonsPage();
            return LoginPage();
          }),
          routes: <String, WidgetBuilder>{
            "/login": (BuildContext context) => LoginPage(),
            "/lessons": (BuildContext context) => LessonsPage(),
          },
        ),
      );
  }
}