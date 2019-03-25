import 'dart:io';

import 'package:flutter/material.dart';

//pages
//import './main.dart';
//import './about.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPage createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true ,
        title: new Text("Lugga",
        style: TextStyle(
        color: Colors.white,
        shadows: <Shadow>[
        Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 8.0,
        color: Colors.black54
              )
            ]
          )
        ),

        backgroundColor: new Color.fromARGB(127, 0, 243, 255),       
          /*PopupMenuButton(
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem(child: Text('Minha conta')),
                PopupMenuItem(child: Text('Historico'))
              ];
            },
          )*/
      ),
      
      body: ListView(
        children: <Widget>[
          ButtonBar(
            children: <Widget>[
              IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async => await _tiraFoto(),
              tooltip: 'Tire uma Foto',
              ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () async => await _galeria(),
              tooltip: 'Pegue da galeria',
              ),
            ],
          ),
          this._imageFile == null ? Placeholder() : Image.file(this._imageFile),
        ],
      ),
    );
  }
  Future<Null> _tiraFoto() async{
    final File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(()=> this._imageFile =imageFile);
  }
    Future<Null> _galeria() async{
      final File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(()=> this._imageFile =imageFile);
  }
}