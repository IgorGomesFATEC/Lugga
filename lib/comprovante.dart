import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String nomeDoAnunciante;
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
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });
    //imagens.add('');
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
    //imagens.removeLast();
    //imagens.add(await documento.data['imagens']);
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

    DocumentSnapshot nomeAnunciante =
        await Firestore.instance.collection('users').document(idUser).get();

    nomeDoAnunciante = await nomeAnunciante.data['nome'];

    this.setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(msg: 'LOCALIZAÇÃO');
  }

  @override
  Widget build(BuildContext context) {
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
              height: 130,
              // width: 600,
              margin: EdgeInsets.all(5),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(10),
                elevation: 7,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      child: imagens == null
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.cyan)),
                              ),
                              color: Colors.white.withOpacity(0.8),
                            )
                          : imagens.isEmpty
                              ? Image.asset(
                                  'assets/img_nao_disp.png',
                                  fit: BoxFit.contain,
                                  height: 300,
                                  width: 400,
                                )
                              : CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.cyan)),
                                        ),
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                  imageUrl: imagens.first.toString(),
                                  width: 110,
                                  fit: BoxFit.fill,
                                  height: 110,
                                ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'produto: $title',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: cinza),
                            ),
                          ),
                          Container(
                            child: Divider(color: cinza),
                          ),
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
