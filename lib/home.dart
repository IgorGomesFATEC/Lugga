import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haversine/haversine.dart';
import 'package:location/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './about.dart';
import './camera.dart';
import './teste.dart';
import './categoria.dart';
import './chat.dart';
import './createProduct.dart';
import './geolocation.dart';
import './login.dart';
import './product.dart';
import './profile.dart';
import './meusChats.dart';
import './const.dart';
import './payment.dart';
import 'myProducts.dart';

class HomePage extends StatefulWidget {
  final String currentUserId;

  HomePage({Key key, @required this.currentUserId}) : super(key: key);

  //final String idLogado;
  //final FirebaseUser user;
  @override
  _HomePageState createState() => _HomePageState(currentUserId: currentUserId);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({Key key, @required this.currentUserId});
  final String currentUserId;

  SharedPreferences prefs;
  //* dados do usuário
  String email = '';
  String foto = '';
  String nome = '';
  double latitude = 0.0;
  double longitude = 0.0;

  var location = Location();
  Map<String, double> userLocation;

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query"; //apagar
  String pesquisa = '';
  var queryResultSet = [];
  var tempSearchStore = [];

  //FirebaseUser _user;
  final GoogleSignIn kGoogleSignIn = GoogleSignIn();
  final kFirebaseAuth = FirebaseAuth.instance;
  Icon _searchIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget _appBarTitle = Text('Lugga',
      style: TextStyle(color: Colors.white, shadows: <Shadow>[
        Shadow(offset: Offset(2.0, 2.0), blurRadius: 8.0, color: Colors.black54)
      ]));
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    readLocal();
  }

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
    });
  }

  Widget _buildSearchField() {
    return new TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Pesquisa...',
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        onSubmitted: (val) {
          initiateSearch(val);
        });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        tooltip: 'Categorias',
        icon: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CategoriaPage()));
        },
      ),
      IconButton(
        tooltip: 'Pesquisa',
        icon: _searchIcon,
        onPressed: _startSearch,
      ),
    ];
  }

  void initiateSearch(value) {
    print(value);
    setState(() {
      pesquisa = value;
    });

/*
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1) + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      searchService(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['nome'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }*/
  }

  Future<QuerySnapshot> searchService(String searchField) async {
    var pesquisa = await Firestore.instance
        .collection('anuncio')
        //.where('titulo', isEqualTo: searchField)
        .getDocuments();

    //if(searchField == Firestore.instance.collection('pesquisas').document('nome')){}
    return pesquisa;
  }

  void readLocal() async {
    this.setState(() {
      isLoading = true;
    });

    getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

    prefs = await SharedPreferences.getInstance();
    nome = prefs.getString('nome') ?? '';
    foto = prefs.getString('foto-url') ?? '';
    email = prefs.getString('email') ?? '';
    latitude = prefs.get('latitude') ?? 0;
    longitude = prefs.get('longitude') ?? 0;

    this.setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(msg: 'LOCALIZAÇÃO: $latitude $longitude');
    print('LOCALIZAÇÃO: $latitude $longitude');
    setState(() {});
  }

  Future getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }

    prefs.setDouble('latitude', currentLocation['latitude']);
    prefs.setDouble('longitude', currentLocation['longitude']);
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: corTema,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Sair do APP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tem certeza que quer sair?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: corTema,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Cancelar',
                      style: TextStyle(
                          color: corTema, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: corTema,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'Sim',
                      style: TextStyle(
                          color: corTema, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        _signOut();
        break;
    }
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    List<String> url = List.from(document['imagens']);
    String titulo = document['titulo'];
    double preco = double.parse(document['preco']);

    final harvesine = new Haversine.fromDegrees(
        latitude1: double.parse(document['latitude']),
        longitude1: double.parse(document['longitude']),
        latitude2: latitude,
        longitude2: longitude);
    double localiza = harvesine.distance() * 0.001;

    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ProductPage(
                        currentProductId: document.documentID,
                      )));
        },
        child: Column(
          children: <Widget>[
            new Card(
              elevation: 7,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10))),
              child: new Column(
                children: <Widget>[
                  url.isNotEmpty
                      ? Container(
                          height: 145,
                          width: 200,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                corTema)),
                                  ),
                                  color: Colors.white.withOpacity(0.8),
                                ),
                            imageUrl: url[0],
                            fit: BoxFit.fill,
                            height: 145,
                            width: 200,
                          ),
                        )
                      : new Image.asset(
                          'assets/img_nao_disp.png',
                          fit: BoxFit.contain,
                          height: 145,
                          width: 200,
                        ),
                  new Container(
                      padding: new EdgeInsets.all(20.0),
                      child: new Row(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: new Text('$titulo |',
                                style: new TextStyle(fontSize: 15.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          new Container(
                            padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: new Text(' R\$$preco',
                                style: new TextStyle(fontSize: 15.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching ? _buildSearchField() : _appBarTitle,
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: corTema,
        actions: _buildActions(),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: corTema,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              accountName: Text(
                '$nome',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                '$email',
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: foto == null || foto == ''
                    ? AssetImage('assets/profile.png')
                    : NetworkImage(foto),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(
                              currentUserId: currentUserId,
                            )));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Meu perfil'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Meus Produtos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyProducts()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Pagamento (Build)'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CardPage()));
              },
            ),
            /*
            ListTile(
              title: Text('Câmera'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CameraPage()));
              },
            ),
            ListTile(
              title: Text('Localização'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => GetLocationPage()));
              },
            ),
            ListTile(
              title: Text('Produto'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProductPage(
                              currentProductId: currentUserId,
                            )));
              },
            ),*/
            Divider(),
            ListTile(
              title: Text('Chat (Build)'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChatScreen()));
              },
            ),
            /*
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),*/
            Divider(),
            ListTile(
              title: Text('Criar anúncio'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateProductPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Sobre'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AboutPage()));
              },
            ),
            /*
            ListTile(
              title: Text('teste'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Teste()));
              },
            ),*/
            Divider(),
            ListTile(
              title: Text('meus chats'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MeusChatsPage(
                              currentUserId: currentUserId,
                            )));
              },
            ),
            ListTile(
                title: Text('Sair'),
                onTap: () {
                  _signOut();
                }),
          ],
        ),
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Container(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.15),
                  ),
                  child: Container(
                    child: StreamBuilder(
                      stream: pesquisa == ''
                          ? Firestore.instance
                              .collection('anuncio')
                              .orderBy('titulo')
                              .where('status', isEqualTo: 1)
                              .snapshots()
                          : Firestore.instance
                              .collection('anuncio')
                              .where('titulo', isEqualTo: pesquisa)
                              .where('status', isEqualTo: 1)
                              .orderBy('titulo')
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.cyan),
                            ),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            scrollDirection: Axis.vertical,
                            semanticChildCount: 2,
                            // padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => buildItem(
                                context, snapshot.data.documents[index]),
                            itemCount: snapshot.data.documents.length,
                          );
                        }
                      },
                    ),
                  )),
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
        onWillPop: onBackPress,
      ),
    );
  }

  Future<Null> _signOut() async {
    this.setState(() {
      isLoading = true;
    });

    var isLogin = await kGoogleSignIn.isSignedIn();
    if (isLogin == true) {
      await kGoogleSignIn.disconnect();
      await kGoogleSignIn.signOut();
    }
    //if(kFirebaseAuth!=null)
    //{
    await kFirebaseAuth.signOut();
    //}

    this.setState(() {
      isLoading = false;
    });

    //setState(() => this._user = null);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}
