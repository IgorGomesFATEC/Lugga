import 'package:flutter/material.dart';

//pages
import './main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage(); 
}

class _LoginPage extends State<LoginPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
        body: Center(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text
              (
                'Login',
                style: TextStyle(fontSize: 50)
              ),
          SizedBox(height: 24.0),
          // "Email" form.
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.email),
              hintText: 'Digite se email',
              labelText: 'E-mail',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 24.0),
          // "Password" form.
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.lock_outline),
              hintText: 'Digite sua Senha',
              labelText: 'Senha',
            ),
          ),
          SizedBox(height: 24.0),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlineButton(
                child: Text('Entrar'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => Home())
                  );
                },
              )
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.red,
                child: Text('Entrar com o google'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => Home())
                  );
                },
              )
            ],
          ),
          Divider(),
           ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                child: Text('Criar Conta'),
                onPressed: (){},
              )
            ],
          ),
        ],
          ),
        ),
        
      );
  }
}