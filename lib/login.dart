import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home.dart';
import './createAccount.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage();
}
/**
**Foi feito a localização por parte do login
**começar a mexer com a parte de cadastro
*!nao mexer com o produto antes do cadastro
*TODO:login automatico com firebase auth
**fazer login apos de cadastrar
**Fazer Merge com o pedro
**Patametros mudados de $user para $currentuserid 
**/

class _LoginPage extends State<LoginPage> {
  bool _obscureText = true;
  String _email, _password,_recovery;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GoogleSignIn kGoogleSignIn = GoogleSignIn();
  final FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  FirebaseUser _user;
  bool isLoading = false;
  bool googleLogin = false, fireLogin = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    googleLogin = await kGoogleSignIn.isSignedIn();
    _user = await kFirebaseAuth.currentUser();
    if (googleLogin == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(currentUserId: prefs.getString('id-usuario'))),
      );
    }
    if (_user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(currentUserId: prefs.getString('id-usuario'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Widget _loginButtons() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              width: 170,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.black87,
                elevation: 10.0,
                child: MaterialButton(
                  onPressed: _login,
                  child: Center(
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: 172,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              shadowColor: Colors.black87,
              //color: Colors.red,
              elevation: 10.0,
              child: MaterialButton(
                onPressed: _googleSignIn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Container(
                            padding: EdgeInsets.all(6),
                            child: Image.asset('assets/googleG.png'))),
                    Center(
                      child: Text(
                        'Entrar com Google',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: new Color.fromARGB(210, 0, 243, 255),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Lugga',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            shadows: <Shadow>[
                              Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 8.0,
                                  color: Colors.black54)
                            ])),
                    SizedBox(height: 24.0),
                    // "Email" form.
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Digite um e-mail!';
                              }
                            },
                            onSaved: (input) => _email = input,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Digite seu email',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: IconTheme(
                                    data: IconThemeData(
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.alternate_email),
                                  )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(100, 0, 243, 255),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    // "Password" form.
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Digite uma senha!';
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            onSaved: (input) => _password = input,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Digite sua senha',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: IconTheme(
                                    data: IconThemeData(
                                      color: Colors.white,
                                    ),
                                    child: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(100, 0, 243, 255),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.only(top: 2.0),
                      child: InkWell(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Form(
                                    key: _formKey2,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: TextFormField(
                                      validator: (input) {
                                        //List<DocumentSnapshot> documents;
                                        //verificaEsqSenha(input).then((val) {
                                          //setState(() {
                                            //documents = val;
                                          //});
                                        //});
                                        if (input.isEmpty) {
                                          return 'Digite um e-mail!';
                                        } //else if (documents.length == 0) {
                                          //return 'Email nao existe';
                                        //}
                                      },
                                      onSaved: (input) => _recovery = input,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.cyan),
                                        ),
                                        hintText: 'Digite seu email',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        suffixIcon: GestureDetector(
                                            onTap: () {},
                                            child: IconTheme(
                                              data: IconThemeData(
                                                color: Colors.black,
                                              ),
                                              child:
                                                  Icon(Icons.email),
                                            )),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.black,
                                        )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    height: 40,
                                    width: 172,
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      shadowColor: Colors.black87,
                                      //color: Colors.red,
                                      elevation: 10.0,
                                      child: MaterialButton(
                                        onPressed: enviarEmail,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                        
                                            Center(
                                              child: Text(
                                                'Enviar Email',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                      ],
                                    ),
                                  )
                                  
                                ],
                              );
                            }),
                        splashColor: Colors.cyan,
                        child: Text('Esqueci minha senha',
                            style: TextStyle(
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: TextDecoration.underline)),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    _loginButtons(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'OU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 170,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: Colors.black87,
                        //color: Colors.red,
                        elevation: 10.0,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreateAccountPage()));
                          },
                          child: Center(
                            child: Text(
                              'Criar uma conta',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                      ),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    final formState = _formKey.currentState;
    if (formState.validate() == true) {
      formState.save();
      try {
        _user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        if (_user != null) {
          final QuerySnapshot result = await Firestore.instance
              .collection('users')
              .where('id-usuario', isEqualTo: _user.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          if (documents.length != 0) {
            await prefs.setString('id-usuario', documents[0]['id-usuario']);
            await prefs.setString('nome', documents[0]['nome']);
            await prefs.setString('foto-url', documents[0]['foto-url']);
            await prefs.setString('email', documents[0]['email']);
          } else {
            Fluttertoast.showToast(msg: 'Usuario nao existente');
            this.setState(() {
              isLoading = false;
            });
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(currentUserId: prefs.getString('id-usuario'))));
        } else {
          Fluttertoast.showToast(msg: 'Usuario nulo');
          this.setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.code);
        this.setState(() {
          isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: formState.toString());
      this.setState(() {
        isLoading = false;
      });
    }
  }

  // Sign in with Google.
  Future<void> _googleSignIn() async {
    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser;

    this.setState(() {
      isLoading = true;
    });
    try {
      googleUser = await kGoogleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseUser firebaseUser =
          await kFirebaseAuth.signInWithCredential(credential);

      if (firebaseUser != null) {
        // Check is already sign up
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('id-usuario', isEqualTo: firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          // Update data to server if new user
          Firestore.instance
              .collection('users')
              .document(firebaseUser.uid)
              .setData({
            'nome': firebaseUser.displayName,
            'foto-url': firebaseUser.photoUrl,
            'id-usuario': firebaseUser.uid,
            'email': firebaseUser.email
          });

          // Write data to local
          _user = firebaseUser;
          await prefs.setString('id-usuario', _user.uid);
          await prefs.setString('nome', _user.displayName);
          await prefs.setString('foto-url', _user.photoUrl);
          await prefs.setString('email', _user.email);
        } else {
          // Write data to local
          await prefs.setString('id-usuario', documents[0]['id-usuario']);
          await prefs.setString('nome', documents[0]['nome']);
          await prefs.setString('foto-url', documents[0]['foto-url']);
          await prefs.setString('email', documents[0]['email']);
        }
        Fluttertoast.showToast(msg: "Sign in success");
        this.setState(() {
          isLoading = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(currentUserId: prefs.getString('id-usuario'))));
      } else {
        Fluttertoast.showToast(msg: "Sign in fail");
        this.setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      this.setState(() {
        isLoading = false;
      });
      print(e.toString());
      Fluttertoast.showToast(
          msg: '${e.toString()}',
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  Future <List<DocumentSnapshot>> verificaEsqSenha(String email) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents;
  }

  Future <void> enviarEmail() async {
    var auth = FirebaseAuth.instance;
    final formState = _formKey2.currentState;
    if (formState.validate() == true) {
      formState.save();
      try{
        auth.sendPasswordResetEmail(email: _recovery,);
        Fluttertoast.showToast(msg: 'foi caraio');
        print('foi');
      }catch(e){
        Fluttertoast.showToast(msg:e.toString());
      }
      
    }
    else{
      print('nao foi');
    }
  }
  /* showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            
                            return Container(
                              
                              decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (input) {
                              List<DocumentSnapshot> documents;
                              verificaEsqSenha(input).then((val){
                                setState(() {
                                  documents = val;
                                });
                              });                              
                              if (input.isEmpty) {
                                return 'Digite um e-mail!';
                              }else if(documents.length ==0){
                                return 'Email nao existe';
                              }
                            },
                            onSaved: (input) => _email = input,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Digite seu email',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: IconTheme(
                                    data: IconThemeData(
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.alternate_email),
                                  )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(100, 0, 243, 255),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                                  MaterialButton(),
                                ],
                              ),
                            );
                          } */
}
