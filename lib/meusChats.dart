import 'package:Lugga/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './chat.dart';

class MeusChatsPage extends StatefulWidget {
  final String currentUserId;

  MeusChatsPage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _MeusChatsPage createState() =>
      new _MeusChatsPage(currentUserId: currentUserId);
}

class _MeusChatsPage extends State<MeusChatsPage> {
  _MeusChatsPage({Key key, @required this.currentUserId});
  String currentUserId;

  bool isLoading = false;

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: document['foto'] == null
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(corTema)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : document['foto'] == ""
                      ? Image.asset(
                          'assets/profile.png',
                          fit: BoxFit.contain,
                          height: 50,
                          width: 50,
                        )
                      : CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(corTema),
                                ),
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(15.0),
                              ),
                          imageUrl: document['foto'],
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Nickname: ${document['nome']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        currentUserId: currentUserId,
                        fotoAnunciante: document['foto'],
                        idAnunciante: document['id-ligado'],
                        nomeAnunciante: document['nome'],
                      )));
        },
        color: Colors.grey[200],
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
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
          title: new Text("Meus Chat's",
              style: TextStyle(color: Colors.white, shadows: <Shadow>[
                Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    color: Colors.black54)
              ])),
          backgroundColor: corTema),
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('chats')
                  .document(currentUserId)
                  .collection(currentUserId)
                  .orderBy('nome')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(corTema),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),

          // Loading
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(corTema)),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
