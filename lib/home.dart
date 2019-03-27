import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//pages
import './profile.dart';
import './geolocation.dart';
import './about.dart';
import './product.dart';
import './chat/home_page.dart';
import './login.dart';
import './categoria.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.user
    }) : super(key: key);

  final FirebaseUser user;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold
    (
      appBar: AppBar(
        centerTitle: true ,
        title: new Text('Lugga',
        style: TextStyle(
        color: Colors.white,
        shadows: <Shadow>[
        Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 8.0,
        color: Colors.black54
              )
            ]
          )
        ),

        backgroundColor: new Color.fromARGB(127, 0, 243, 255),

        actions: <Widget>[
          IconButton(
            tooltip: 'Categorias',
            icon: Icon(Icons.filter_list),
            onPressed: (){Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => CategoriaPage())
                  );},
          ),
          IconButton(
            tooltip: 'Search',
            icon: Icon(Icons.search),
            onPressed: () {
            },
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
              accountName: Text('Seu nome'),
              accountEmail: Text('${widget.user.email}'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn3.iconfinder.com/data/icons/web-ui-3/128/Account-2-512.png'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => HomePage())
                  );
              },
            ),
            ListTile(
              title: Text('Meu perfil'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage())
                  );
              },
            ),
            ListTile(
              title: Text('Câmera'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ProductPage())
                  );
              },
            ),
            ListTile(
              title: Text('Localização'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => GetLocationPage())
                  );
              },
            ),
            ListTile(
              title: Text('Chat'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ChatPage())
                  );
              },
            ),
            ListTile(
              title: Text('Login'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage())
                  );
              },
            ),
            ListTile(
              title: Text('Sobre'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => AboutPage())
                  );
              },
            ),
          ],
        ),
      ),
      body:GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,  
        children: List.generate(50, (index){
          return Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: 
              Text(
                'Item $index',
                style:Theme.of(context).textTheme.headline,
                ),
            ),
          );
        })
      ),
    );
  }
}