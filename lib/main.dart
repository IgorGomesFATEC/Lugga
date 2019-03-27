
import 'package:flutter/material.dart';

//Página
import './login.dart';

void main() => runApp(LuggaApp());

class LuggaApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp
    (
      theme: ThemeData(primarySwatch: Colors.cyan,cursorColor: Colors.white),
      home: new LoginPage(),
      debugShowCheckedModeBanner: false, 
    );
  }   
}