import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './profile.dart';
import './geolocation.dart';
import './about.dart';
import './camera.dart';
import './chat.dart';
import './login.dart';
import './categoria.dart';
import './product.dart';
import './createProduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.user}) : super(key: key);

  final FirebaseUser user;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser _user;
  final kFirebaseAuth = FirebaseAuth.instance;
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
                'Seu nome',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                '${widget.user.email}',
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.png'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
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
      body: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: List.generate(50, (index) {
            return Container(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.15),
                  ),
                  child: Container(
                    child: new Column(
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
                                        child: new Text(
                                            'Nome do produto | R\$24,90',
                                            style:
                                                new TextStyle(fontSize: 12.0),
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
                  )),
            );
          })),
    );
  }

  Future<Null> _signOut() async {
    kFirebaseAuth.signOut();
    setState(() => this._user = null);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
