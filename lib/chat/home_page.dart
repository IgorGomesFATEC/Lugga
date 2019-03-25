import 'package:flutter/material.dart';
import './chat_screen.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Frenzy Chat"),
        ),
        body: new ChatScreen());
  }
}
