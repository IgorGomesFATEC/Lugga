import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './login.dart';

void main() => runApp(LuggaApp());

class LuggaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan, cursorColor: Colors.white),
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
