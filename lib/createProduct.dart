import 'package:flutter/material.dart';
import 'package:via_cep/via_cep.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPage createState() => new _CreateProductPage();
}

class _CreateProductPage extends State<CreateProductPage> {
  //static var cep = new via_cep();
  //var result = cep.searchCEP(_cep, 'json', '');

  String _title,_description,_categoriaAtual;
  String _cep = '';
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List _categoria = ['Categoria','Agro e Industria','Construção','Diversão','Eletrônicos','Ferramentas','Instrumentos', 'Livros', 'Móveis', 'Roupas e Acessórios', 'Som e Iluminação', 'Utilitários', 'Outros'];
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _categoriaAtual = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in _categoria) {
      items.add(new DropdownMenuItem(
          value: cat,
          child: new Text(cat)
      ));
    }
    return items;
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true ,
        title: Text("Criar Anuncio ",//+cep.getLogradouro(),
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
      ),
      body: Form(
        child: Column(
          children: <Widget>[
          Container(
          child: Row(
            children: <Widget>[
              IconButton(
              tooltip: 'Camera',
              icon: Icon(Icons.add_a_photo,color: Colors.grey,size: 75,),

              onPressed: (){},
              ),
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
                      return 'Digite o titulo do Anúncio';
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
                      return 'Coloque a categoria do Anúncio';
                    }
                    if(input != 'Categorias'){
                      return 'Coloque a categoria do Anuncio';
                    }
                  },
                  onSaved: (input)=>_categoriaAtual = input,
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
                  //onSaved: (input)=>_cep = input,
                  decoration: InputDecoration.collapsed(
                    hintText: 'CEP *',
                  ),
                  cursorColor: Colors.grey,
                  autocorrect: true,
                  onFieldSubmitted: (String value){
                    setState(() {
                     this._cep = value;
                    });
                    procuraCep(_cep);
                  },
                ),
                ),
              ],
            ),
          ),
          
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(127, 0, 243, 255),
              shadowColor: Colors.black87,
              elevation: 10.0,
              child: MaterialButton(
                onPressed: (){},
                child: Center(
                  child: Text('Entrar',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
              ),
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
  Future<Null> procuraCep(String cepDigitado) async{
    var CEP = new via_cep();
  
    await CEP.searchCEP(cepDigitado, 'json', ''); 
    
    // Sucesso
    if (CEP.getResponse() == 200) { 
      print('CEP: '+CEP.getCEP());
      print('Logradouro: '+CEP.getLogradouro());
      print('Complemento: '+CEP.getComplemento());
      print('Bairro: '+CEP.getBairro());
      print('Localidade: '+CEP.getLocalidade());
      print('UF: '+CEP.getUF());
      print('Unidade: '+CEP.getUnidade());
      print('IBGE '+CEP.getIBGE());
      print('GIA: '+CEP.getGIA());
    // Falha
    } else {
      print('Código de Retorno: '+CEP.getResponse().toString());
      print('Erro: '+CEP.getBody());
    }
  }
}