import 'package:flutter/material.dart';
import 'package:Lugga/const.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: new Text("Sobre",
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: corTema,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                'Lugga um aplicativo da empresa Zukunfty.\nCriado pelos alunos da Fatec Rio Preto!\nIgor Augusto Gomes\nPedro Brandt Zanqueta\nGabriel Bezerra Pereira',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Todos os direitos reservados©',
                    style: TextStyle(fontSize: 8.0),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
