import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:haversine/haversine.dart';
import './const.dart';

class ProductPage extends StatefulWidget {
  final String currentProductId;

  ProductPage({Key key, @required this.currentProductId}) : super(key: key);
  @override
  _ProductPage createState() =>
      _ProductPage(currentProductId: currentProductId);
}

class _ProductPage extends State<ProductPage> {
  final String currentProductId;

  _ProductPage({Key key, @required this.currentProductId});
  bool photoView = false;
  bool isLoading = false;

  SharedPreferences prefs;

  List<String> imagens;
  String title;
  String idUser;
  String descricao;
  String periodo;
  String categoria;
  double distancia;
  double preco;
  double latitudeProd;
  double longitudeProd;
  double latitudeUser;
  double longitudeUser;

  String nomePessoaAnuncio;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();

    DocumentSnapshot documento = await Firestore.instance
        .collection('anuncio')
        .document(currentProductId)
        .get();

    idUser = await documento.data['id-user'];
    title = await documento.data['titulo'];
    descricao = await documento.data['descricao'];
    categoria = await documento.data['categoria'];
    periodo = await documento.data['periodo'];
    preco = double.parse(await documento.data['preco']);
    latitudeProd = double.parse(await documento.data['latitude']);
    longitudeProd = double.parse(await documento.data['longitude']);
    imagens = List.from(await documento.data['imagens']);

    latitudeUser = prefs.getDouble('latitude') ?? 0;
    longitudeUser = prefs.getDouble('longitude') ?? 0;

    final harvesine = new Haversine.fromDegrees(
      latitude1: latitudeProd,
      longitude1: longitudeProd,
      latitude2: latitudeUser,
      longitude2: longitudeUser,
    );

    distancia = harvesine.distance() * 0.001;

    nomeAnunciante(idUser);

    this.setState(() {
      isLoading = false;
    });
  }

  void nomeAnunciante(String idUser) async {
    this.setState(() {
      isLoading = true;
    });
    DocumentSnapshot documento =
        await Firestore.instance.collection('users').document(idUser).get();

    nomePessoaAnuncio = documento.data['nome'];
    this.setState(() {
      isLoading = false;
    });
  }

  void clicaPhoto() {
    this.setState(() {
      photoView = true;
    });
  }

  Widget _photoGallery() {
    if (photoView == false) {
      return Container();
    } else {
      return Container(
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
          title: new Text('Anuncio',
              style: TextStyle(color: Colors.white, shadows: <Shadow>[
                Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    color: Colors.black54)
              ])),
          backgroundColor: corTema,
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: Text('Denunciar')),
              ];
            })
          ]),
      body: Stack(
        children: <Widget>[
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
            elevation: 7,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  //onTap: clicaPhoto() ,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black87, blurRadius: 10.0)
                      ],
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.cyan),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                      imageUrl: imagens[0],
                      width: 400,
                      fit: BoxFit.fill,
                      height: 300,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 1),
                  child: Text(
                    '$title',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: corTema),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(10, 1, 10, 10),
                  child: Text(
                    'por $nomePessoaAnuncio',
                    style: TextStyle(),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'R\$ $preco',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: corTema),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Distancia: ${distancia.toStringAsFixed(2)} KM',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: corTema),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Divider(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: Text(
                        'Categoria',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: corTema),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Divider(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '$categoria',
                    style: TextStyle(),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Divider(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: corTema),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Divider(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '$descricao',
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan)),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
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
