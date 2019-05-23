import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './const.dart';
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
  List<String> imagesUrl = [];
  List<File> images = [];
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
    super.initState();
    _dropDownMenuItemsCAT = getDropDownMenuItemsCAT();
    _categoriaAtual = _dropDownMenuItemsCAT[0].value;
    _dropDownMenuItemsPER = getDropDownMenuItemsPER();
    _periodoAtual = _dropDownMenuItemsPER[0].value;
    getLocation();
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
      images.add(imageFile);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        setState(() {
          imagesUrl.add(downloadUrl);
          print(imagesUrl.length);
          isLoading = false;
        });
      },
    );
    setState(() {
      isLoading = false;
    });
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
        //backgroundColor: Colors.cyan[300],
        backgroundColor: corTema,
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
                          images.length == 0
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.all(10),
                                  child: Image.file(
                                    images[images.length - 1],
                                    height: 110,
                                    width: 110,
                                  ),
                                ),

                          //Text('${_photos}'),
                          IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: cinza,
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
                              onSaved: (input) => _description = input,
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
                                if (input == 'Categorias') {
                                  return 'Coloque a categoria do Anuncio!!';
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
                                    },
                                    onSaved: (input) => _periodoAtual = input,
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Categoria *',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 5, 243, 255),
                                shadowColor: Colors.black87,
                                elevation: 10.0,
                                child: MaterialButton(
                                  onPressed: () {
                                    _publicaAnuncio();
                                  },
                                  child: Center(
                                    child: Text(
                                      'Confirmar Anúncio',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
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

  Future<void> _publicaAnuncio() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    final formState = _formKey.currentState;
    if (formState.validate() == true) {
      formState.save();
      try {
        if (images.isNotEmpty) {
          await uploadFile();
        }
        var dados = Map<String, dynamic>();

        String uid = prefs.getString('id-usuario') ?? '';
        dados["categoria"] = _categoriaAtual;
        dados["descricao"] = _description;
        dados["latitude"] = _latitude;
        dados["longitude"] = _longitude;
        dados["imagens"] = imagesUrl;
        dados["titulo"] = _title;
        dados["preco"] = _preco;
        dados["periodo"] = _periodoAtual;
        dados["id-anuncio"] = '';
        dados["id-user"] = uid;
        Firestore.instance.collection('anuncio').add(dados);

        Fluttertoast.showToast(msg: "Sucesso!!");
        this.setState(() {
          isLoading = false;
        });
        //Navigator.push(
        //  context,
        //MaterialPageRoute(
        //  builder: (context) => HomePage(currentUserId: uid)));
      } catch (e) {
        Fluttertoast.showToast(msg: "${e.toString()}");
        print(e.toString());
        this.setState(() {
          isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Erro ao criar o anuncio");
      print('Erro');
      this.setState(() {
        isLoading = false;
      });
    }
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
