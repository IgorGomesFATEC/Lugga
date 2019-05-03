import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPage createState() => _ProductPage();
}

class _ProductPage extends State<ProductPage> {
  bool photoView = false;

void clicaPhoto(){
  this.setState(() {
      photoView = true;
  });
}

Widget _photoGallery(){
  if (photoView == false) {
    return Container();
  } else {
    return 
    Container(
          child: PhotoViewGallery(
          pageOptions: <PhotoViewGalleryPageOptions>[
          PhotoViewGalleryPageOptions(
            imageProvider: AssetImage("assets/example.png"),
            heroTag: "tag1",
          ),
          PhotoViewGalleryPageOptions(
              imageProvider: AssetImage("assets/googleG.png"),
              heroTag: "tag2",
              maxScale: PhotoViewComputedScale.contained * 0.3),
          PhotoViewGalleryPageOptions(
            imageProvider: AssetImage("assets/profile.png"),
            initialScale: PhotoViewComputedScale.contained * 0.98,
            heroTag: "tag3",
          ),
        ],
        backgroundDecoration: BoxDecoration(color: Colors.black),
          ),
      );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: new Text('Produto',
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            //onTap: clicaPhoto() ,
            child:Container(
            child: Image.asset(
            'assets/example.png',
            width: 450.0,
            height: 275.0,
            fit: BoxFit.cover,
          ),
          ),
          ),
          Text(
            'Título do produto',
            style: TextStyle(),
          ),
          Text(
            'Descrição do produto',
            style: TextStyle(),
          )
        ],
      ),
      floatingActionButton: Container(
        height: 125.0,
        width: 125.0,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {},
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            label: Text(
              "Lugga!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: new Color.fromARGB(127, 0, 243, 255),
          ),
        ),
      ),  
      );
  }
}

//TODO Help with Igor
 