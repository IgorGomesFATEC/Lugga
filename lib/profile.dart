import 'package:flutter/material.dart';

//pages
import './main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => new _ProfilePage();    
}

class _ProfilePage extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Meu perfil"),
        backgroundColor: new Color.fromRGBO(153, 255, 153, 30),
      ),
   );
  }
}