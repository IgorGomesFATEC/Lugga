import 'package:flutter/material.dart';


//paginas
import './login.dart';


void main() => runApp(LuggaApp());

class LuggaApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp
    (
      home: new LoginPage(),
      debugShowCheckedModeBanner: false, 
    );
  }
}