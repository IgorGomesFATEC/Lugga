import 'package:flutter/material.dart';

//pages
import './main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage(); 
}

class _LoginPage extends State<LoginPage> {
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
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => Home())
                  );
                },
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
            width: 170,
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
              child: GestureDetector(
                onTap: (){},
                child: Center(
                  child: Text('Login com Google',
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
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(   
      resizeToAvoidBottomPadding: false,
      backgroundColor: new Color.fromARGB(210, 0, 243, 255),
      
      
        body: Center(         
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
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Digite se email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          // "Password" form.
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
            
              hintText: 'Digite sua Senha',
              labelText: 'Senha',
            ),
          ),
          SizedBox(height: 20.0),
          _loginButtons(),
          Container(
            margin: EdgeInsets.all(10),
            child: Divider(color: Colors.black45,),
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
              child: GestureDetector(
                onTap: (){},
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
        ),
      );
  }
}