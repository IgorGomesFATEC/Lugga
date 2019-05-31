import 'dart:io';
import 'package:Lugga/const.dart';
import 'package:Lugga/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Chat extends StatelessWidget {
  final String idAnunciante;
  final String fotoAnunciante;
  final String nomeAnunciante;
  final String currentUserId;

  Chat(
      {Key key,
      @required this.idAnunciante,
      @required this.fotoAnunciante,
      @required this.nomeAnunciante,
      @required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            currentUserId: currentUserId,
                          )),
                  (Route<dynamic> route) => false);
            },
          ),
          backgroundColor: corTema,
          title: new Text(
            'Chat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: new ChatScreen(
          idAnunciante: idAnunciante,
          fotoAnunciante: fotoAnunciante,
          nomeAnunciante: nomeAnunciante,
        ));
  }
}

class ChatScreen extends StatefulWidget {
  final String idAnunciante;
  final String fotoAnunciante;
  final String nomeAnunciante;

  ChatScreen(
      {Key key,
      @required this.idAnunciante,
      @required this.fotoAnunciante,
      @required this.nomeAnunciante})
      : super(key: key);
  @override
  State createState() => new ChatScreenState(
      idAnunciante: idAnunciante,
      fotoAnunciante: fotoAnunciante,
      nomeAnunciante: nomeAnunciante);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key,
      @required this.idAnunciante,
      @required this.fotoAnunciante,
      @required this.nomeAnunciante});
  String idAnunciante;
  String nomeAnunciante;
  String fotoAnunciante;

  //controler para texto
  final TextEditingController _textController = new TextEditingController();
  //controler para fazer a list
  final ScrollController listScrollController = new ScrollController();

  //
  SharedPreferences prefs;
  //variavel para ativar o loading
  bool isLoading;
  //variavel da imagem
  File imageFile;
  //variavel para pegar a imagem depois de ser upada
  String imageUrl;
  //variavel para mensagens
  var listMessage;
  //
  String id;
  String nome;
  String foto;
  //
  String groupChatId;

  @override
  void initState() {
    super.initState();

    groupChatId = '';

    isLoading = false;
    imageUrl = '';

    readLocal();
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    nome = prefs.getString('nome') ?? '';
    foto = prefs.getString('foto-url') ?? '';
    id = prefs.getString('id-usuario') ?? '';
    if (id.hashCode <= idAnunciante.hashCode) {
      groupChatId = '$id-$idAnunciante';
    } else {
      groupChatId = '$idAnunciante-$id';
    }
    var documentReference = Firestore.instance
        .collection('chats')
        .document(id)
        .collection(id)
        .document(idAnunciante);
    setState(() {});

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'id-ligado': idAnunciante,
          'foto': fotoAnunciante,
          'nome': nomeAnunciante
        },
      );
    });

    var documentReference2 = Firestore.instance
        .collection('chats')
        .document(idAnunciante)
        .collection(idAnunciante)
        .document(id);
    setState(() {});

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference2,
        {'id-ligado': id, 'foto': foto, 'nome': nome},
      );
    });
  }

  //esse future so sobe a galeria e chama o uploadfile
  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future tiraFoto() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  //Esse future metodo serve para upar a imagem para o storage, dps ele pega a url da imagem e envia para
  //o metodo onSendMessage
  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Isso não é uma imagem!');
    });
  }

  //metodo para o envio de menssagem ele recebe o conteudo e o tipo da menssagem
  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image
    if (content.trim() != '') {
      _textController.clear();

      //cria um mapa dinamico com o firebase para colocar para colocar em um obj ex:(type:1)
      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': idAnunciante,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nada a enviar');
    }
  }

  //widget do texto e dos icones para digitar
  Widget _textComposerWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: corTema,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.photo_camera),
                onPressed: tiraFoto,
                color: corTema,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: new TextField(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    decorationStyle: TextDecorationStyle.wavy),
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Digite sua Mensagem',
                  hintStyle: TextStyle(
                    color: corTema,
                  ),
                ),
                //focusNode: focusNode,
              ),
            ),
          ),
          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(_textController.text, 0),
                color: corTema,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.black, width: 0.5)),
          color: Colors.white),
    );
  }

  //A TELA
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),

            // Input content
            _textComposerWidget(),
          ],
        ),

        // Loading
        buildLoading()
      ],
    );
  }

  //widget para construir o item de acordo com o pedido
  Widget buildItem(int index, DocumentSnapshot document) {
    //nessa parte o app verifica se o 'type' é 0 ou 1 sendo 0 = texto e 1 = imagem e monta seus widget
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: corTema),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              :
              // Image
              Container(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(corTema),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) => Material(
                            child: Image.asset(
                              'assets/img_nao_disp.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                      imageUrl: document['content'],
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
          // Sticker
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: fotoAnunciante == null
                            ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          corTema)),
                                ),
                                color: Colors.white.withOpacity(0.8),
                              )
                            : fotoAnunciante == ""
                                ? Image.asset(
                                    'assets/profile.png',
                                    fit: BoxFit.contain,
                                    height: 35,
                                    width: 35,
                                  )
                                : CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    corTema),
                                          ),
                                          width: 35.0,
                                          height: 35.0,
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                    imageUrl: fotoAnunciante,
                                    width: 35.0,
                                    height: 35.0,
                                    fit: BoxFit.cover,
                                  ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: corTema,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : Container(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(corTema),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                            errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'assets/img_nao_disp.png',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      ),
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(color: cinza, fontSize: 10.0),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

//loading
  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(127, 0, 243, 255),
                )),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  //widget para montar a lista de menssagem
  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(corTema)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(corTema)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
