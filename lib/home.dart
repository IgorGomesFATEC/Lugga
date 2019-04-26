import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

import './about.dart';
import './camera.dart';
import './categoria.dart';
import './chat.dart';
import './createProduct.dart';
import './geolocation.dart';
import './login.dart';
import './product.dart';
import './profile.dart';

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

  //FirebaseUser _user;
  final GoogleSignIn kGoogleSignIn = GoogleSignIn();
  final kFirebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    readLocal();
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
    latitude = prefs.get('latitude') ?? '';
    longitude = prefs.get('longitude') ?? '';

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
                color: Colors.cyan,
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
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
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
                        color: Colors.cyan,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
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
                        color: Colors.cyan,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
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
    if (document['id-usuario'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProductPage()));
          },
          //a
          child: Column(
            children: <Widget>[
              new Card(
                child: new Column(
                  children: <Widget>[
                    new Image.asset(
                      'assets/example.png',
                      fit: BoxFit.cover,
                    ),
                    new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Padding(
                              padding: new EdgeInsets.all(1.0),
                              child: new Text('Nome do produto | R\$24,90',
                                  style: new TextStyle(fontSize: 12.0),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text('Lugga',
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
        actions: <Widget>[
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
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(127, 60, 243, 255),
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
            ListTile(
              title: Text('Meu perfil'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage()));
              },
            ),
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
                        builder: (BuildContext context) => ProductPage()));
              },
            ),
            ListTile(
              title: Text('Chat'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChatScreen()));
              },
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
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
            ListTile(
              title: Text('Sobre'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AboutPage()));
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
                      stream:
                          Firestore.instance.collection('anuncio').snapshots(),
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
                                    mainAxisSpacing: 20, crossAxisCount: 2),
                            scrollDirection: Axis.vertical,
                            semanticChildCount: 2,
                            padding: EdgeInsets.all(10.0),
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.cyan)),
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
