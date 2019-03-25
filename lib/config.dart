import 'package:flutter/material.dart';

//pages
import './main.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPage  createState() => new _ConfigPage();    
}

class _ConfigPage extends State<ConfigPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Configurações"),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
      ),
   );
  }
}