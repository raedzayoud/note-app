import 'package:flutter/material.dart';
import 'package:note_app/app/auth/login.dart';
import 'package:note_app/app/auth/signup.dart';
import 'package:note_app/app/home.dart';
import 'package:note_app/app/notes/add.dart';
import 'package:note_app/app/notes/edit.dart';
import 'package:note_app/app/profile/homeprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use null-aware access to handle the sharedPreferences instance
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: sharedPreferences.getString("id") == null ? Login() : Home(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "home": (context) => Home(),
        "addnote": (context) => Add(),
        "editnote": (context) => Edit(),
        "Homeprofile": (context) => Homeprofile(),
      },
    );
  }
}
