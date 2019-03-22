import 'package:flutter/material.dart';

//Páginas
import './about.dart';
import './product.dart';
import './login.dart';
import './config.dart';
import './profile.dart';
import './categoria.dart';
import './geolocation.dart';

void main() 
{
  LuggaApp lugga = new LuggaApp();
  runApp(lugga); 
}

class LuggaApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp
    (
      home: new LoginPage(),
      debugShowCheckedModeBanner: false, 
    );
  }
    
}

class Home extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold
    (
      appBar: AppBar(
        centerTitle: true ,
        title: new Text("Lugga",
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
            onPressed: () async{
              await showSearch();
            },
          ),
          /*PopupMenuButton(
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem(child: Text('Minha conta')),
                PopupMenuItem(child: Text('Historico'))
              ];
            },
          )*/
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
              accountEmail: Text('Seu e-mail'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn3.iconfinder.com/data/icons/web-ui-3/128/Account-2-512.png'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => Home())
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
              title: Text('Câmera'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ProductPage())
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
              title: Text('Meus produtos'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => AboutPage())
                  );
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ConfigPage())
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
            /* Quando o usuário não estiver cadastrado remover o código:
            "currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn3.iconfinder.com/data/icons/web-ui-3/128/Account-2-512.png'),
              ),
              "accountEmail: Text('Seu e-mail')," 
              Alterar:
              "accountName: Text('Seu nome')," para "accountName: Text('Faça login para locar seus produtos'),"

              Deixar apenas esses dois ListTitle:       
              ListTile(
              title: Text('Entrar'),
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
            */   
          ],
        ),
      ),
      body: GridView.count(
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
