import 'package:flutter/material.dart';

//paginas
import './about.dart';
import './login.dart';

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
        
        title: Text("Lugga"),

        backgroundColor: Colors.blueAccent,

        actions: <Widget>[
          IconButton(
            tooltip: 'Categorias',
            icon: Icon(Icons.filter_list),
            onPressed: (){},
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
              accountName: Text('Brenda Ribon'),
              accountEmail: Text('brenda s2 Pedro'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(''),
              ),
            ),
            ListTile(
              title: Text('Pagina Principal'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => Home())
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
      body: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        children: List.generate(100, (index){
          return Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 3.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
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