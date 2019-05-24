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

class CardPage extends StatefulWidget {
  @override
  _CardPage createState() => new _CardPage();
}

class _CardPage extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    //bool isLoading;
    String _numCard, _nome, _valid, _cod;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text("Cadastrar cartão ",
            style: TextStyle(color: Colors.white, shadows: <Shadow>[
              Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54)
            ])),
        backgroundColor: corTema,
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
                          Icon(
                            Icons.payment,
                            color: cinza,
                            size: 75,
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
                            // NUMERO DO CARTÃO
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(style: BorderStyle.solid))),
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                              validator: (input) {
                                if (input.length < 0) {
                                  return 'Digite o número do cartão';
                                } else if (input.length > 20) {
                                  return 'Digite um titulo menor';
                                }
                              },
                              onSaved: (input) => _numCard = input,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Número do cartão *',
                              ),
                              cursorColor: Colors.grey,
                              autocorrect: true,
                            ),
                          ),
                          Container(
                            //NOME E SOBRENOME
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(style: BorderStyle.solid))),
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                              validator: (input) {
                                if (input.length < 0) {
                                  return 'Digite o nome e sobrenome';
                                }
                              },
                              onSaved: (input) => _nome = input,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nomem completo *',
                              ),
                              cursorColor: Colors.grey,
                              autocorrect: true,
                            ),
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
                                        return 'Digite a validade do cartão';
                                      }
                                    },
                                    onSaved: (input) => _valid = input,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'MM/AA *',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Digite a validade do cartão');
                                          },
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: Colors.black,
                                            ),
                                            child: Icon(Icons.date_range),
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
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Digite a validade do cartão';
                                      }
                                    },
                                    onSaved: (input) => _cod = input,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Código de segurança *',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Digite o código de segurança do cartão');
                                          },
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: Colors.black,
                                            ),
                                            child: Icon(
                                                Icons.perm_device_information),
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
                                  onPressed: () {},
                                  child: Center(
                                    child: Text(
                                      'Confirmar Cartão',
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
        ],
      ),
    );
  }
}
