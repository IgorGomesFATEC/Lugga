import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPage createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: new Text("Câmera",
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
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

  Future<Null> _tiraFoto() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() => this._imageFile = imageFile);
  }

  Future<Null> _galeria() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => this._imageFile = imageFile);
  }
}
