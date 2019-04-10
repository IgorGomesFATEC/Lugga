import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPage createState() => new _CreateProductPage();
}

class _CreateProductPage extends State<CreateProductPage> {
  String _title,_description,_cep,_categoriaAtual;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List _categoria = ['Categorias','adada','adads','srdrtd','bbbb','pppppp'];
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _categoriaAtual = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _categoria) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true ,
        title: Text("Criar Anuncio",
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
      ),
      body: Form(
        child: Column(
          children: <Widget>[
          Container(
          child: Row(
            children: <Widget>[
              IconButton(
              tooltip: 'Camera',
              icon: Icon(Icons.camera_alt,color: Colors.cyan,size: 75,),
              onPressed: (){},
              )
            ],
          ),
        ),
        SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.fromLTRB(0,10,5,10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.fromLTRB(5,15,5,15),
                  margin: EdgeInsets.all(10),
                  child:  TextFormField(
                  validator: (input){
                    if(input.length < 0){
                      return 'Digite o titulo dp Anúncio';
                    }
                    else if(input.length>20){
                      return 'Digite um titulo menor';
                    }
                  },
                  onSaved: (input)=>_title = input,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Titulo*',
                  ),
                  cursorColor: Colors.grey,
                  autocorrect: true,
                  
                ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.fromLTRB(5,15,5,15),
                  margin: EdgeInsets.all(10),
                  child:  TextFormField(
                  validator: (input){
                    if(input.length < 0){
                      return 'Digite a descrição do Anúncio';
                    }
                  },
                  onSaved: (input)=>_title = input,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Descrição *',
                  ),
                  cursorColor: Colors.grey,
                  autocorrect: true,
                  maxLength: 200,
                ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.fromLTRB(5,15,5,15),
                  margin: EdgeInsets.all(10),
                  child:  DropdownButtonFormField(
                  value: _categoriaAtual,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                  validator: (input){
                    if(input.length < 0){
                      return 'Digite o titulo dp Anúncio';
                    }
                    else if(input.length>20){
                      return 'Digite um titulo menor';
                    }
                  },
                  onSaved: (input)=>_title = input,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Categoria *',
                  ),                  
                ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.fromLTRB(5,15,5,15),
                  margin: EdgeInsets.all(10),
                  child:  TextFormField(
                  validator: (input){
                    if(input.length < 0){
                      return 'Digite o CEP';
                    }
                    else if(input.length>9){
                      return 'CEP muito longo';
                    }
                  },
                  onSaved: (input)=>_title = input,
                  decoration: InputDecoration.collapsed(
                    hintText: 'CEP *',
                  ),
                  cursorColor: Colors.grey,
                  autocorrect: true,
                  
                ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
  void changedDropDownItem(String categoriaSelecionada) {
    setState(() {
      _categoriaAtual = categoriaSelecionada;
    });
  }
}