import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  @override
  _CategoriaPage createState() => new _CategoriaPage();    
}

class _CategoriaPage extends State<CategoriaPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Categorias"),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
      ),
            body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Agro e Industria'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Construção'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Diversão'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Eletrônicos'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Ferramentas'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Instrumentos'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Livros'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Móveis'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Roupas e Acessórios'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Som e Iluminação'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Utilitários'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Outros'),
              onTap: (){},
            ),           
          ],
        ),
      );
  }
}