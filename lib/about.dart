import 'package:flutter/material.dart';

//pages
import './main.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState  createState() => new _AboutPageState();    
}

class _AboutPageState extends State<AboutPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Lugga"),
        backgroundColor: Colors.blueAccent,

        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: Icon(Icons.search),
            onPressed: () async{
              await showSearch();
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem(child: Text('Minha conta')),
                PopupMenuItem(child: Text('Historico'))
              ];
            },
          )
        ],
      ),
   );
  }
}