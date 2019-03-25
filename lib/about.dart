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
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
      ),
      body: Center(
          child: Text('Lugga um aplicativo da empresa Zukunfty Criado pelos alunos da Fatec Rio Preto Igor Augusto Gomes Pedro Brandt Zanqueta Gabriel Bezerra Pereira'),
   ),
    
    );
  }
}