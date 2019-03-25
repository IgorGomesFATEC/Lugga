import 'package:flutter/material.dart';

//Páginas
import './login.dart';

void main() => runApp(LuggaApp());

class LuggaApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp
    (
      title: 'Lugga',
      theme: ThemeData(primaryColor:  Color.fromARGB(127, 0, 243, 255),primarySwatch: Colors.green),
      home: new LoginPage(),
      debugShowCheckedModeBanner: false, 
    );
  }
    
}
