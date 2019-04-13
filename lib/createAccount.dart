import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pages
import './login.dart';
class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPage createState() => new _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      resizeToAvoidBottomPadding: false,
      backgroundColor: new Color.fromARGB(210, 0, 243, 255),
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
        )
      ), 
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
                'Criar Conta',
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
                    if(input == null){
                      return 'Digite seu e-mail!';
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
            decoration: BoxDecoration(),
            child: Column(
              children: <Widget>[
                TextFormField(
                  onFieldSubmitted: (String value){
                    setState(() {
                     this._password = value; 
                    });
                  },
                  validator: (input){
                    if(input.length<1){
                      return 'Digite uma senha!';
                    }
                  },
                  style: TextStyle(color: Colors.white),
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
          Container(
            padding:EdgeInsets.all(10),
            decoration: BoxDecoration(),
            child: Column(
              children: <Widget>[
                TextFormField(
                  enabled: this._password != null && this._password.isNotEmpty,
                  validator: (input){
                    if(input.length<1){
                      return 'Confirme sua senha!';
                    }
                  },
                  style: TextStyle(color: Colors.white),
                  onSaved: (input)=>_password =input,
                  obscureText: true,
                  decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Confirme sua senha',
                  hintStyle: TextStyle(color: Colors.white),      
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(100, 0, 243, 255),)),
            ),
          ),
              ],
            ),
          ),
          SizedBox(height: 20,),
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
                  signUp();
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
  
   void signUp() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }catch(e){
        print(e.message);
      }
    }
  }
}