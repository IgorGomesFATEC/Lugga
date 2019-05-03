import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  String _title,
      _description,
      _categoriaAtual,
      _periodoAtual,
      _latitude,
      _longitude,
      _preco;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var location = Location();
  Map<String, double> userLocation;
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();
  List<String> _photos = [];
  List images;
  File imageFile;
  List<DropdownMenuItem<String>> _dropDownMenuItemsCAT;
  List<DropdownMenuItem<String>> _dropDownMenuItemsPER;
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
  List _periodo = ['Diário', 'Semanal', 'Mensal'];

  @override
  void initState() {
    _dropDownMenuItemsCAT = getDropDownMenuItemsCAT();
    _categoriaAtual = _dropDownMenuItemsCAT[0].value;
    _dropDownMenuItemsPER = getDropDownMenuItemsPER();
    _periodoAtual = _dropDownMenuItemsPER[0].value;
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

  List<DropdownMenuItem<String>> getDropDownMenuItemsCAT() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in _categoria) {
      items.add(new DropdownMenuItem(value: cat, child: new Text(cat)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsPER() {
    List<DropdownMenuItem<String>> items = new List();
    for (String per in _periodo) {
      items.add(new DropdownMenuItem(value: per, child: new Text(per)));
    }
    return items;
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        _photos.add(downloadUrl);
        for (var i = 0; i < _photos.length; i++) {
          print('array: ' + _photos[i]);
          images = List.generate(_photos.length, (x) => imageAtual(_photos[i]));
        }
        setState(() {
          isLoading = false;
          //onSendMessage(imageUrl, 1);
        });
      },
    );
    setState(() {
      isLoading = false;
      //onSendMessage(imageUrl, 1);
    });
  }

  Widget imageAtual(String url) {
    return Container(
      child: Material(
        child: CachedNetworkImage(
          imageUrl: url,
          width: 110.0,
          height: 110.0,
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        clipBehavior: Clip.hardEdge,
      ),
      //margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
    );
  }

//!
  Widget _buildProductItem(BuildContext context, int index) {
    return Image.network(
      images[0],
      width: 110.0,
      height: 110.0,
      fit: BoxFit.contain,
    );
  }

  Widget _arrayPhotos(String url) {
    return Container(
      child: Material(
        child: CachedNetworkImage(
          imageUrl: url,
          width: 110.0,
          height: 110.0,
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        clipBehavior: Clip.hardEdge,
      ),
    );
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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          _photos.length == 0
                              ? Container()
                              : _arrayPhotos(_photos[_photos.length - 1]),

                          //Text('${_photos}'),
                          IconButton(
                            tooltip: 'Camera',
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                              size: 75,
                            ),
                            onPressed: getImage,
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(style: BorderStyle.solid))),
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
                                border: Border(
                                    bottom:
                                        BorderSide(style: BorderStyle.solid))),
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
                                border: Border(
                                    bottom:
                                        BorderSide(style: BorderStyle.solid))),
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            margin: EdgeInsets.all(10),
                            child: DropdownButtonFormField(
                              value: _categoriaAtual,
                              items: _dropDownMenuItemsCAT,
                              onChanged: changedDropDownItemCAT,
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
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextFormField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Digite o Preço';
                                      }
                                    },
                                    onSaved: (input) => _preco = input,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Preço (dia)*',
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
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              style: BorderStyle.solid))),
                                  padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                                  margin: EdgeInsets.all(10),
                                  child: DropdownButtonFormField(
                                    value: _periodoAtual,
                                    items: _dropDownMenuItemsPER,
                                    onChanged: changedDropDownItemPER,
                                    validator: (input) {
                                      if (input.toString().isEmpty) {
                                        return 'Coloque a categoria do Anúncio';
                                      }
                                      if (input != 'Categorias') {
                                        return 'Coloque a categoria do Anuncio';
                                      }
                                    },
                                    onSaved: (input) => _periodoAtual = input,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Categoria *',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
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

  void changedDropDownItemCAT(String categoriaSelecionada) {
    setState(() {
      _categoriaAtual = categoriaSelecionada;
    });
  }

  void changedDropDownItemPER(String periodoSelecionado) {
    setState(() {
      _periodoAtual = periodoSelecionado;
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
