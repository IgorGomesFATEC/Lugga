import 'package:flutter/material.dart';

//pages
import './main.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState  createState() => new _AboutPageState();    
}

class _AboutPageState extends State<AboutPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Sobre"),
        backgroundColor: new Color.fromRGBO(153, 255, 153, 30),
      ),
   );
  }
}