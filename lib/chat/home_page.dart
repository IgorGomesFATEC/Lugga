import 'package:flutter/material.dart';
import './chat_screen.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        centerTitle: true ,
        title: new Text('Lugga Chat',
        style: TextStyle(
        color: Colors.white,
        shadows: <Shadow>[
        Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 8.0,
        color: Colors.black54
              )
            ]
          )
        ),

        backgroundColor: new Color.fromARGB(127, 0, 243, 255),
        
        ),
        body: new ChatScreen());
  }
}