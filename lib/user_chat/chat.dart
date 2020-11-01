import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

import 'change_email_address.dart';
import 'full_photo.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
var loggedInUser;

class ChatScreen extends StatefulWidget {
  static const id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  File imageFile;
  String imageUrl;
  String fileType = "";
  bool isLoading;
  String fileName;
  File file;
  bool isUploaded = true;
  var ch = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('user email" ${loggedInUser.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'others') {
        file = await FilePicker.getFile(
          type: FileType.any,
        );

        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print('file name: $fileName');
        uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
      Flushbar(
        message: "Error Sending Image",
        backgroundColor: Colors.red,
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> uploadFile(File file, String fileName) async {
    StorageReference storageReference;

    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child('chat/images/$fileName');
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    imageUrl = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.image,
              color: Colors.black,
              size: 25.0,
            ),
            tooltip: 'attach image',
            onPressed: () {
              setState(() {
                fileType = 'others';
                ch = 1;
              });
              filePicker(context);
            },
          );
        }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
//                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(
          'Chat: Admin',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blue.shade200, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: ch == 1
                        ? () {
                            _firestore
                                .collection(Provider.of<ChangeEmailAddress>(
                                        context,
                                        listen: false)
                                    .emailAddress)
                                .add({
                                  'sender': loggedInUser.email,
                                  'date': DateTime.now()
                                      .toIso8601String()
                                      .toString(),
                                  'imageUrl': imageUrl,
                                  'ch': ch
                                })
                                .then((value) => print("image Data added"))
                                .catchError((error) =>
                                    print("Failed to add user: $error"));
                            setState(() {
                              ch = 0;
                            });
                          }
                        : null,
                    child: Icon(
                      Icons.image,
                      color: ch == 1 ? Colors.blue.shade800 : Colors.grey,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        ch = 0;
                      });

                      if (messageTextController.text.isNotEmpty) {
                        // print(Provider.of<ChatData>(context, listen: false).phNo);
                        _firestore
                            .collection(Provider.of<ChangeEmailAddress>(context,
                                    listen: false)
                                .emailAddress)
                            .add({
                              'text': messageText,
                              'sender': loggedInUser.email,
                              // 'time': DateTime.now()
                              'date':
                                  DateTime.now().toIso8601String().toString(),
                              'ch': ch
                              //'imageUrl': imageUrl,
                            })
                            .then((value) => print("text Data added"))
                            .catchError(
                                (error) => print("Failed to add user: $error"));
                      }

                      messageTextController.clear();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(Provider.of<ChangeEmailAddress>(context, listen: false)
              .emailAddress)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        print('messages: $messages');
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final messageTime = message.data()['date'];
          final currentUser = loggedInUser.email;
          final imageUrl = message.data()['imageUrl'];
          var ch = message.data()['ch'];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            time: DateTime.parse(messageTime),
            imageUrl: imageUrl,
            ch: ch,
          );

          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.text, this.sender, this.isMe, this.time, this.imageUrl, this.ch});
  final String text;
  final String sender;
  final bool isMe;
  final DateTime time;
  var timeFormat;
  var dayTimeFormat;
  final String imageUrl;
  var ch;
  @override
  Widget build(BuildContext context) {
    timeFormat = DateFormat('jm').format(time);
    dayTimeFormat = DateFormat('yMMMMd').format(time);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$sender $timeFormat $dayTimeFormat",
            style: TextStyle(color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.blue.shade100 : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ch == 1
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl == null
                                ? "https://image.shutterstock.com/image-vector/icon-symbolizing-trying-again-colorful-260nw-457723852.jpg"
                                : imageUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        backgroundColor: Colors.blue.shade800,
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onPressed: () {
                          print("Day: $dayTimeFormat");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                        url: imageUrl == null ? "" : imageUrl,
                                      )));
                        },
                      ),
                    )
                  : Linkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      options: LinkifyOptions(humanize: false),
                      text: text,
                      linkStyle: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.blue),
                      style: TextStyle(
                          color: isMe ? Colors.black : Colors.black54,
                          fontSize: 20.0),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
