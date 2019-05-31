import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:haversine/haversine.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import './payment.dart';
import './const.dart';

class ProductPage extends StatefulWidget {
  final String currentProductId;
  final String currentUserId;

  ProductPage(
      {Key key, @required this.currentProductId, @required this.currentUserId})
      : super(key: key);
  @override
  _ProductPage createState() => _ProductPage(
      currentProductId: currentProductId, currentUserId: currentUserId);
}

class _ProductPage extends State<ProductPage> {
  final String currentProductId;
  final String currentUserId;
  _ProductPage(
      {Key key, @required this.currentProductId, @required this.currentUserId});

  Email emailReport;
  bool photoView = false;
  bool isLoading = false;

  SharedPreferences prefs;

  List<String> imagens;
  String title = '';
  String idUser = '';
  String descricao = '';
  String idUserLogado = '';
  String periodo = '';
  String categoria = '';
  double distancia = 0.00;
  double preco = 0.00;
  double latitudeProd = 0.00;
  double longitudeProd = 0.00;
  double latitudeUser = 0.00;
  double longitudeUser = 0.00;
  String nomePessoaAnuncio = '';

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
    idUserLogado = prefs.getString('id-usuario');

    final harvesine = new Haversine.fromDegrees(
      latitude1: latitudeProd,
      longitude1: longitudeProd,
      latitude2: latitudeUser,
      longitude2: longitudeUser,
    );

    distancia = harvesine.distance() * 0.001;

    DocumentSnapshot nomeAnunciante =
        await Firestore.instance.collection('users').document(idUser).get();

    nomePessoaAnuncio = await nomeAnunciante.data['nome'];

    this.setState(() {
      isLoading = false;
    });
  }

  void clicaPhoto() {
    this.setState(() {
      photoView = true;
    });
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
            IconButton(
              icon: Icon(
                Icons.info_outline,
              ),
              onPressed: () async {
                setState(() {
                  this.isLoading = true;
                });
                emailReport = Email(
                    body: 'email teste',
                    subject: 'email teste',
                    recipients: ['iagomes95@gmail.com'],
                    cc: ['contatolugga@gmail.com']);
                setState(() {
                  this.isLoading = false;
                });
                try {
                  await FlutterEmailSender.send(emailReport);
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Erro: ${e.toString()}');
                  setState(() {
                    this.isLoading = false;
                  });
                }
              },
            ),
          ]),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(10),
                elevation: 7,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      //onTap: clicaPhoto() ,
                      child: Container(
                        height: 300,
                        width: 400,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.grey[200], blurRadius: 7.0)
                          ],
                        ),
                        margin: EdgeInsets.all(10),
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
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.cyan)),
                                          ),
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                    imageUrl: imagens.first.toString(),
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
                        style: TextStyle(
                          color: cinza,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 1, 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'R\$ $preco',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: corTema),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(1, 10, 10, 10),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '($periodo)',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: cinza),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Distancia: ${distancia.toStringAsFixed(2)} KM',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: cinza),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Divider(color: cinza),
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
                            child: Divider(color: cinza),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '$categoria',
                        style: TextStyle(
                          color: cinza,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Divider(color: cinza),
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
                            child: Divider(color: cinza),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '$descricao',
                        style: TextStyle(color: cinza),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.cyan)),
                    ),
                    color: Colors.white.withOpacity(1.0),
                  )
                : Container(),
          )
        ],
      ),
      floatingActionButton: Container(
        height: 125.0,
        width: 125.0,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {
              if (idUser == currentUserId) {
                Fluttertoast.showToast(
                    msg: 'Você não pode alugar o seu produto');
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CardPage(
                              currentProductId: currentProductId,
                            )));
              }
            },
            icon: Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            label: Text(
              "Lugga!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: corTema,
          ),
        ),
      ),
    );
  }
}
