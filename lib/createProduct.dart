import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:via_cep/via_cep.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPage createState() => new _CreateProductPage();
}

class _CreateProductPage extends State<CreateProductPage> {
  //static var cep = new via_cep();
  //var result = cep.searchCEP(_cep, 'json', '');
  bool isLoading;
  SharedPreferences prefs;
  String _title, _description, _categoriaAtual, _latitude, _longitude,_preco;
  var location = Location();
  Map<String, double> userLocation;
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List _categoria = [
    'Categoria',
    'Agro e Industria',
    'Construção',
    'Diversão',
    'Eletrônicos',
    'Ferramentas',
    'Instrumentos',
    'Livros',
    'Móveis',
    'Roupas e Acessórios',
    'Som e Iluminação',
    'Utilitários',
    'Outros'
  ];
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _categoriaAtual = _dropDownMenuItems[0].value;
    getLocation();
    super.initState();
  }

  Future getLocation() async {
    this.setState(() {
      isLoading = true;
    });
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', currentLocation['latitude'].toDouble());
    prefs.setDouble('longitude', currentLocation['longitude'].toDouble());
    latitudeCtrl.text = prefs.get('latitude').toString();
    longitudeCtrl.text = prefs.get('longitude').toString();
    this.setState(() {
      isLoading = false;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in _categoria) {
      items.add(new DropdownMenuItem(value: cat, child: new Text(cat)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text("Criar Anúncio ", //+cep.getLogradouro(),
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.gps_fixed,
              color: Colors.white,
            ),
            tooltip: 'Localização',
            onPressed: () => getLocation(),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            tooltip: 'Camera',
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                              size: 75,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                      margin: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                              validator: (input) {
                                if (input.length < 0) {
                                  return 'Digite o titulo do Anúncio';
                                } else if (input.length > 20) {
                                  return 'Digite um titulo menor';
                                }
                              },
                              onSaved: (input) => _title = input,
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
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Digite a descrição do Anúncio';
                                }
                              },
                              onSaved: (input) => _title = input,
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
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            margin: EdgeInsets.all(10),
                            child: DropdownButtonFormField(
                              value: _categoriaAtual,
                              items: _dropDownMenuItems,
                              onChanged: changedDropDownItem,
                              validator: (input) {
                                if (input.toString().isEmpty) {
                                  return 'Coloque a categoria do Anúncio';
                                }
                                if (input != 'Categorias') {
                                  return 'Coloque a categoria do Anuncio';
                                }
                              },
                              onSaved: (input) => _categoriaAtual = input,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Categoria *',
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    enabled: false,
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Aperte no simbolo do lado superior direito da tela';
                                      }
                                    },
                                    onSaved: (input) => _latitude = input,
                                    controller: latitudeCtrl,
                                    style: TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Aperte no simbolo do lado superior direito da tela',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Aperte no simbolo do lado superior direito da tela');
                                          },
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: Colors.grey,
                                            ),
                                            child: Icon(Icons.location_on),
                                          )),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Aperte no simbolo do lado superior direito da tela';
                                      }
                                    },
                                    onSaved: (input) => _longitude = input,
                                    controller: longitudeCtrl,
                                    enabled: false,
                                    style: TextStyle(color: Colors.grey),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Aperte no simbolo do lado superior direito da tela',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Aperte no simbolo do lado superior direito da tela');
                                          },
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: Colors.grey,
                                            ),
                                            child: Icon(Icons.location_on),
                                          )),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.numberWithOptions(),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Digite o Preço';
                                      }
                                    },
                                    onSaved: (input) => _preco = input,
                                    
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Preço (dia)*',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Digite o preço diario do anuncio');
                                          },
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: Colors.black,
                                            ),
                                            child: Icon(Icons.attach_money),
                                          )),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          ),
        ],
      ),
    );
  }

  void changedDropDownItem(String categoriaSelecionada) {
    setState(() {
      _categoriaAtual = categoriaSelecionada;
    });
  }

/*  Future<Null> procuraCep(String cepDigitado) async {
    var CEP = new via_cep();

    await CEP.searchCEP(cepDigitado, 'json', '');

    // Sucesso
    if (CEP.getResponse() == 200) {
      print('CEP: ' + CEP.getCEP());
      print('Logradouro: ' + CEP.getLogradouro());
      print('Complemento: ' + CEP.getComplemento());
      print('Bairro: ' + CEP.getBairro());
      print('Localidade: ' + CEP.getLocalidade());
      print('UF: ' + CEP.getUF());
      print('Unidade: ' + CEP.getUnidade());
      print('IBGE ' + CEP.getIBGE());
      print('GIA: ' + CEP.getGIA());
      // Falha
    } else {
      print('Código de Retorno: ' + CEP.getResponse().toString());
      print('Erro: ' + CEP.getBody());
    }
  }*/
}
