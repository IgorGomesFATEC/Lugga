import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Teste extends StatefulWidget {
  @override
  _TestePage createState() => new _TestePage();
}

class _TestePage extends State<Teste> {
  List<File> image = [];
  File imageAtual;
  List<String> url = [];

  Future getImage() async {
    imageAtual = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      image.add(imageAtual);
    });
  }

  Future upload() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    for (var x = 0; x < image.length; x++) {
      StorageUploadTask uploadTask = reference.putFile(image[x]);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
        url[x] = downloadUrl;
        print(url[x]);
        //_photos.add(downloadUrl);
        for (var i = 0; i < url.length; i++) {
          print('array: ' + url[i]);
        }
      });
    }
  }

  Widget _arrayPhotos(File photo) {
    return Container(
      height: 110,
      width: 110,
      child: Image.file(photo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Flexible(
                child: Row(
              children: <Widget>[
                image.length == 0
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) =>
                              _arrayPhotos(image[index]),
                          itemCount: image.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                IconButton(
                  onPressed: getImage,
                  icon: Icon(Icons.camera),
                )
              ],
            )),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 40,
                width: 170,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  shadowColor: Colors.black87,
                  elevation: 10.0,
                  child: MaterialButton(
                    onPressed: upload,
                    child: Center(
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
