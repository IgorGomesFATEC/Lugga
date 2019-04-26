import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
//pages
import './home.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPage createState() => new _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  SharedPreferences prefs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  String _email, _password,_nome;
  bool _obscureText = true, isLoading = false, isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: new Color.fromARGB(210, 0, 243, 255),
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, false),
      )),
      body: Stack(
        children: <Widget>[
          Container(
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Criar Conta',
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

                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Digite seu Nome!';
                                }
                              },
                              onSaved: (input) => _nome = input,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: 'Digite seu Nome*',
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg:'Digite seu nome completo',
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white);
                                    },
                                    child: IconTheme(
                                      data: IconThemeData(
                                        color: Colors.white,
                                      ),
                                      child: Icon(Icons.person),
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
                                  return 'Digite seu e-mail!';
                                }
                              },
                              onSaved: (input) => _email = input,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: 'Digite seu email*',
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(msg:'Digite o seu email',
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white);
                                    },
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
                              onFieldSubmitted: (String value) {
                                setState(() {
                                  this._password = value;
                                });
                              },
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Digite a senha!';
                                }else if(input.length>=1 && input.length<8){
                                  return 'A senha tem que ter no minimo 8 caracteres';
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: 'Digite sua senha*',
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
                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: this._password != null &&
                                  this._password.isNotEmpty && this._password.length>=8,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Confirme sua senha!';
                                }else if(input != _password){
                                  return 'As senhas nao estao iguais';
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              onSaved: (input) => _password = input,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: 'Confirme sua senha*',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromARGB(100, 0, 243, 255),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                              signUp();
                            },
                            child: Center(
                              child: Text(
                                'Criar conta',
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

  void signUp() async {
     prefs = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser firebaseUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

        //*Verificando se existe
        if(firebaseUser != null)
        {
          final QuerySnapshot result = await Firestore.instance.collection('users').where('id',isEqualTo: firebaseUser.uid).getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          //*Criando um novo
          if (documents.length == 0){
            Firestore.instance.collection('users').document(firebaseUser.uid).setData({
              'nome': _nome,
              'foto-url': '',
              'id-usuario': firebaseUser.uid,
              'email': firebaseUser.email
            });

            _user =firebaseUser;
            await prefs.setString('id-usuario', _user.uid);
            await prefs.setString('nome', _nome);
            await prefs.setString('foto-url', '');
            await prefs.setString('email', _user.email); 
          }else{
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
        }else{
           Fluttertoast.showToast(msg: "Sign in fail");
          this.setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        this.setState(() {
          isLoading = false;
         });
        Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.black,textColor: Colors.white);
        print(e.toString());
      }
    }
  }
}
