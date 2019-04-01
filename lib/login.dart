import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

//pages
import './home.dart';
import './createAccount.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage(); 
}

class _LoginPage extends State<LoginPage> {
  bool _obscureText = true;
  String _email,_password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _loginButtons()
  {
    return Container(
      padding:EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
        Expanded(
          child:Container(
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
                onPressed: _Login,
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
                onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: Image.asset('assets/googleG.png')
                      )
                    ),
                    Center(
                        child: Text('Entrar com Google',
                        style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                        ),
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
        body: Form(
          key: _formKey,
          child: Center( 
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text
              (
                'Lugga',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  shadows: <Shadow>[
                  Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Colors.black54
                )
            ]
                  )
              ),
          SizedBox(height: 24.0),
          // "Email" form.
          Container(
            padding:EdgeInsets.all(10),
            decoration: BoxDecoration(),
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input){
                    if(input.length<1){
                      return 'Digite um e-mail!';
                    }
                  },
                  onSaved: (input)=> _email =input,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Digite seu email',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: GestureDetector(
                    onTap: (){ },
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.white,
                      ),
                      child: Icon(Icons.alternate_email),
                    )
                  ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(100, 0, 243, 255),)),
            ),
          ),
              ],
            ),
          ),
          SizedBox(height: 30.0),
          // "Password" form.
          Container(
            padding:EdgeInsets.all(10),
            decoration: BoxDecoration(
            
          ),
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input){
                    if(input.length<1){
                      return 'Digite uma senha!';
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  onSaved: (input)=>_password =input,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Digite sua senha',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: GestureDetector(
                    onTap: (){
                      setState(() {
                       _obscureText = !_obscureText; 
                      });
                    },
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.white,
                      ),
                      child: Icon(_obscureText ? Icons.visibility:Icons.visibility_off),
                    )
                  ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(100, 0, 243, 255),)),
            ),
          ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
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
                child:Container(
                  margin: EdgeInsets.all(10),
                  child: Divider(
                    color: Colors.white,
                  ),
                ) ,
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
                onPressed: (){
                   Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => CreateAccountPage())
                  );
                },
                child: Center(
                  child: Text('Criar conta',
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
        ) ,
        ),
      );
  }
    Future<void> _Login() async {
    final formState = _formKey.currentState;
    if(formState.validate()==true){
      formState.save();
      try {
        FirebaseUser user =await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email ,password:_password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: user,)));
      } catch (e) {
        print(e.message);
      }
      }
      else{
        print(formState);
      }
    }
}
