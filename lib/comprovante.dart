import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haversine/haversine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './const.dart';

class ComprovantePage extends StatefulWidget {
  final String currentProductId;

  ComprovantePage({Key key, @required this.currentProductId}) : super(key: key);
  @override
  _ComprovantePage createState() =>
      _ComprovantePage(currentProductId: currentProductId);
}

class _ComprovantePage extends State<ComprovantePage> {
  final String currentProductId;

  _ComprovantePage({Key key, @required this.currentProductId});

  //Anunciante
  String nomeAnunciante;
  String contatoAnunciante;
  String fotoUrlAnunciante;
  //Anuncio
  List<String> imagens;
  String title;
  String idUser;
  String descricao;
  String periodo;
  String categoria;
  double preco;
  double latitudeProd;
  double longitudeProd;
  //comprador
  double latitudeUser;
  double longitudeUser;
  SharedPreferences prefs;

  bool isLoading = false;
  double distancia;

  @override
  void initState() {
    super.initState();
    getVariaveis(currentProductId);
    readLocal();
  }

  void readLocal() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();

    latitudeUser = prefs.getDouble('latitude') ?? 0;
    longitudeUser = prefs.getDouble('longitude') ?? 0;

    final harvesine = new Haversine.fromDegrees(
      latitude1: latitudeProd,
      longitude1: longitudeProd,
      latitude2: latitudeUser,
      longitude2: longitudeUser,
    );

    distancia = harvesine.distance() * 0.001;

    this.setState(() {
      isLoading = false;
    });
  }

  Future getVariaveis(String id) async {
    DocumentSnapshot documentoAnuncio =
        await Firestore.instance.collection('anuncio').document(id).get();
    idUser = await documentoAnuncio.data['id-user'];
    title = await documentoAnuncio.data['titulo'];
    descricao = await documentoAnuncio.data['descricao'];
    categoria = await documentoAnuncio.data['categoria'];
    periodo = await documentoAnuncio.data['periodo'];
    preco = double.parse(await documentoAnuncio.data['preco']);
    latitudeProd = double.parse(await documentoAnuncio.data['latitude']);
    longitudeProd = double.parse(await documentoAnuncio.data['longitude']);
    imagens = List.from(await documentoAnuncio.data['imagens']);

    DocumentSnapshot documentoUsuario =
        await Firestore.instance.collection('users').document(idUser).get();
    nomeAnunciante = await documentoUsuario.data['id-usuario'];
    contatoAnunciante = await documentoUsuario.data['email'];
    fotoUrlAnunciante = await documentoUsuario.data['foto-url'];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            centerTitle: true,
            title: new Text('Comprovante',
                style: TextStyle(color: Colors.white, shadows: <Shadow>[
                  Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 8.0,
                      color: Colors.black54)
                ])),
            backgroundColor: corTema),
        body: Stack(
          children: <Widget>[
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(10),
                elevation: 7,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(corTema),
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
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text('$title'),
                          Divider(),
                          Text('$categoria'),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Text('$preco'),
                              Text('por'),
                              Text('$periodo')
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(corTema)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ));
  }
}
