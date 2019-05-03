import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  //controler para texto
  final TextEditingController _textController = new TextEditingController();
  //controler para fazer a list
  final ScrollController listScrollController = new ScrollController();

  //variavel para ativar o loading
  bool isLoading;
  //variavel da imagem
  File imageFile;
  //variavel para pegar a imagem depois de ser upada
  String imageUrl;
  //variavel para mensagens
  var listMessage;

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
                color: Color.fromARGB(127, 0, 243, 255),
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
                color: Color.fromARGB(127, 0, 243, 255),
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: new TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Digite sua Mensagem',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(127, 0, 243, 255),
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
                color: Color.fromARGB(127, 0, 243, 255),
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
    return new Column(
      children: <Widget>[
        new Flexible(
          child: buildListMessage(),
        ),
        new Divider(
          height: 10.0,
        ),
        new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: _textComposerWidget(),
        ),
      ],
    );
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

  //esse future metodo serve para upar a imagem para o storage, dps ele pega a url da imagem e envia para
  //o metodo onSendMessage
  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        imageUrl = downloadUrl;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, 1);
        });
      },
    );
  }

  //metodo para o envio de menssagem ele recebe o conteudo e o tipo da menssagem
  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image
    if (content.trim() != '') {
      _textController.clear();

      //cria um mapa dinamico com o firebase para colocar para colocar em um obj ex:(type:1)
      var dados = Map<String, dynamic>();
      dados['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
      dados['content'] = content;
      dados['type'] = type;

      //grava o mapa no firestore
      Firestore.instance.collection('messages').add(dados);
      //.document(groupChatId)
      //.collection(groupChatId)
      //.document(DateTime.now().millisecondsSinceEpoch.toString());

      /*Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            //'idFrom': id,
            //'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });*/
      //listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nada a enviar');
    }
  }

  //widget para construir o item de acordo com o pedido
  Widget buildItem(int index, DocumentSnapshot document) {
    //TODO quado acabar o produto implementar o id para fazer a rede de chat
    //nessa parte o app verifica se o 'type' é 0 ou 1 sendo 0 = texto e 1 = imagem e monta seus widget
    //if (document['idFrom'] == id) {
    // Right (my message)
    return Row(
      children: <Widget>[
        document['type'] == 0
            // Text
            ? Container(
                child: Text(
                  document['content'],
                  style: TextStyle(color: Colors.black),
                ),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                //margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
              )
            : // Image
            Container(
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(127, 0, 243, 255),
                            ),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                //margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
              ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
    //esse else ele faz o mesmo so que para o lado esquerdo (quem esta enviando)
    /*} else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                                width: 35.0,
                                height: 35.0,
                                padding: EdgeInsets.all(10.0),
                              ),
                          imageUrl: peerAvatar,
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
                        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 1
                        ? Container(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: greyColor2,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Material(
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
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
                          )
                        : Container(
                            child: new Image.asset(
                              'images/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                      style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );*/
    // }
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
    return
        //quando implementar id de duas pessoas usar esse cod comentado
        //child: groupChatId == ''
        //Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
        //firebase que irá mostrar na tela
        StreamBuilder(
      stream: Firestore.instance
          .collection('messages')
          //.document(groupChatId)
          //.collection(groupChatId)
          .orderBy('timestamp', descending: true)
          .limit(800)
          .snapshots(),
      //montando o envio de mensagem
      builder: (context, snapshot) {
        //se nao enviou progress indicator
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
            Color.fromARGB(127, 0, 243, 255),
          )));
        } else {
          //se nao vai montar uma listView e chamar o build item
          listMessage = snapshot.data.documents;
          return ListView.builder(
            padding: EdgeInsets.all(15.0),
            itemBuilder: (context, index) =>
                buildItem(index, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: listScrollController,
          );
        }
      },
    );
  }
}
