import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haversine/haversine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './const.dart';
import './chat.dart';

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
  String currentUserId;
  SharedPreferences prefs;
  //Forma de Pagamento
  String numCard;
  String codCard;
  String validCard;
  String nomeCard;

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
    DocumentSnapshot getDocumentoAnuncio = await Firestore.instance
        .collection('anuncio')
        .document(currentProductId)
        .get();

    idUser = await getDocumentoAnuncio.data['id-user'];
    title = await getDocumentoAnuncio.data['titulo'];
    descricao = await getDocumentoAnuncio.data['descricao'];
    categoria = await getDocumentoAnuncio.data['categoria'];
    periodo = await getDocumentoAnuncio.data['periodo'];
    preco = double.parse(await getDocumentoAnuncio.data['preco']);
    latitudeProd = double.parse(await getDocumentoAnuncio.data['latitude']);
    longitudeProd = double.parse(await getDocumentoAnuncio.data['longitude']);
    //imagens.removeLast();
    //imagens.add(await documento.data['imagens']);
    imagens = List.from(await getDocumentoAnuncio.data['imagens']);

    currentUserId = prefs.getString('id-usuario') ?? '';
    latitudeUser = prefs.getDouble('latitude') ?? 0;
    longitudeUser = prefs.getDouble('longitude') ?? 0;

    nomeCard = prefs.getString('nomeCard');
    codCard = prefs.getString('codCard');
    numCard = prefs.getString('numCard');
    validCard = prefs.getString('validCard');

    var dados = Map<String, dynamic>();
    dados["status"] = 0;

    Firestore.instance
        .collection("anuncio")
        .document(currentProductId)
        .setData(dados, merge: true);

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
    contatoAnunciante = await nomeAnunciante.data['email'];
    fotoUrlAnunciante = await nomeAnunciante.data['foto-url'];

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
          ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(5),
                child: Text(
                  'Produto locado',
                  style: TextStyle(
                      color: cinza, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
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
                                    height: 110,
                                    width: 110,
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
                                    width: 110,
                                    fit: BoxFit.fill,
                                    height: 110,
                                  ),
                      ),
                      Flexible(
                        child: Container(
                          //width: 250,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  'produto: $title',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cinza),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  'Categoria: $categoria',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cinza),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        'Preço: R\$$preco ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: cinza),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                      child: Text(
                                        '($periodo)',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: cinza),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //TODO: anunciante
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(5),
                child: Text(
                  'Anunciante',
                  style: TextStyle(
                      color: cinza, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
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
                        child: fotoUrlAnunciante == null
                            ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          corTema)),
                                ),
                                color: Colors.white)
                            : fotoUrlAnunciante == ""
                                ? Image.asset(
                                    'assets/profile.png',
                                    fit: BoxFit.contain,
                                    width: 110,
                                    height: 110,
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
                                    imageUrl: fotoUrlAnunciante,
                                    fit: BoxFit.fill,
                                    width: 110,
                                    height: 110,
                                  ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  'Nome do Anunciante: $nomeDoAnunciante',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cinza),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  'Email anunciante: $contatoAnunciante',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cinza),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //TODO: modo de pagamento
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(5),
                child: Text(
                  'Forma Pagamento',
                  style: TextStyle(
                      color: cinza, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
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
                                    height: 110,
                                    width: 110,
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
                                    width: 110,
                                    fit: BoxFit.fill,
                                    height: 110,
                                  ),
                      ),
                      Flexible(
                        child: Container(
                          //width: 250,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  'Numero do cartão: $numCard',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cinza),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  'Data de Validade: $validCard',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cinza),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        'Nome: $nomeCard ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: cinza),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                      child: Text(
                                        'Código: $codCard',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: cinza),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
      ),
      floatingActionButton: Container(
        height: 125.0,
        width: 125.0,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                            currentUserId: currentUserId,
                            fotoAnunciante: fotoUrlAnunciante,
                            idAnunciante: idUser,
                            nomeAnunciante: nomeDoAnunciante,
                          )),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            label: Text(
              "Confirmar",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: corTema,
          ),
        ),
      ),
    );
  }

  Future<void> confirmar() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove('numCard');
      await prefs.remove('nomeCard');
      await prefs.remove('validCard');
      await prefs.remove('codCard');

      Fluttertoast.showToast(msg: "Sucesso!!");
      this.setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ComprovantePage(
                    currentProductId: currentProductId,
                  )),
          (Route<dynamic> route) => false);
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
      print(e.toString());
      this.setState(() {
        isLoading = false;
      });
    }
    Fluttertoast.showToast(msg: "Erro a");
    print('Erro');
    this.setState(() {
      isLoading = false;
    });
  }
}
