import 'package:flutter/material.dart';
import 'package:Lugga/const.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProducts createState() => new _MyProducts();
}

class _MyProducts extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: new Text("Meus Produtos",
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: corTema,
      ),
    );
  }
}
