import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:meau/model/user.dart';
import 'package:meau/pages/drawer.dart';
import 'package:meau/pages/message_bubble.dart';
import 'package:http/http.dart' as http;
// import 'package:meau/pages/notification_card.dart';

class Chat extends StatefulWidget {
  final String otherParticipant;

  Chat({super.key, required this.otherParticipant});

  @override
  State<Chat> createState() => ChatState();
}

class ChatState extends State<Chat> {
  CollectionReference? chat;
  List<MessageBubble> messages = List.empty();

  final _textController = TextEditingController();

  void getChat() {
    _database
        .collection("chats")
        .where("participants", whereIn: [
          [_auth.currentUser!.uid, widget.otherParticipant],
          [widget.otherParticipant, _auth.currentUser!.uid]
        ])
        .get()
        .then((value) {
          print('chat ${value.docs}');
          value.docs.forEach((element) {
            setState(() {
              chat = _database
                  .collection("chats")
                  .doc(element.id)
                  .collection("messages");
            });
          });

          if (chat == null) {
            _database.collection("chats").add(<String, dynamic>{
              "participants": [
                _auth.currentUser!.uid,
                widget.otherParticipant,
              ],
            }).then((value) {
              chat = value.collection("messages");
            });
          }

          getMessages();
        });
  }

  void getMessages() async {
    // chat!.orderBy("sentAt", descending: true).limit(40).get();

    // chat!.limitToLast(40).get().then((value) {
    chat!.get().then((value) {
      setState(() {
        // messages = value.docs.forEach((e) => MessageBubble.fromDocumentSnapshot(e)).toList();
        setState(() {
          messages = value.docs
              .map((e) =>
                  MessageBubble(message: (e.data() as Map<String, dynamic>)))
              .toList();
        });
      });
    });
  }

  Future<void> sendMessage() async {
    if (chat == null) {
      return;
    }

    var message = <String, String>{
      "senderId": _auth.currentUser!.uid,
      "sentAt": DateTime.now().toString(),
      "content": _textController.text,
    };

    await chat!.add(message);
    _textController.text = "";

    var messaging = FirebaseMessaging.instance;
    var docSnap = await _database.collection("users").doc(widget.otherParticipant).get();
    var dest = User.fromMap(docSnap.data());

    docSnap = await _database.collection("users").doc(_auth.currentUser!.uid).get();
    var source = User.fromMap(docSnap.data());

    // var notification = <String, dynamic>{
    //   "sourceId": FirebaseAuth.instance.currentUser!.uid!,
    //   "sourceEmail": FirebaseAuth.instance.currentUser!.email!,
    //   "animalId": animal.id!,
    //   "animalName": animal.name!,
    //   "targetId": animal.ownerId!,
    //   "targetToken": targetToken,
    // };
    //
    // notification["title"] = "Alguém está interessado na(o) ${animal.name!}";
    // notification["body"] = "O usuário ${notification['sourceEmail']} está interessado em adotar o ${notification['animalName']}";
    //
    // var sourceToken = await messaging.getToken();
    // notification["sourceToken"] = sourceToken;

    sendPushMessage(dest.fcmToken!, source.name!, message["content"]!);

    // getMessages();
  }

  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _database;

  void initAuth() {
    var auth = firebase_auth.FirebaseAuth.instance;
    setState(() {
      _auth = auth;
    });
    print('Auth initialized');
  }

  void initDatabase() {
    var db = FirebaseFirestore.instance;
    setState(() {
      _database = db;
    });
    print('Database initialized');
  }

  void initState() {
    super.initState();
    initAuth();
    initDatabase();
    getChat();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: const Color.fromARGB(255, 207, 233, 229),
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 136, 201, 191)),
        foregroundColor: const Color.fromARGB(255, 67, 67, 67),
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto Medium',
          fontSize: 20,
          color: Color.fromARGB(255, 67, 67, 67),
        ),
      ),
      // body: Container(child: ListView(children: messages)),
      body: Column(children: [
        chat == null ?
        Expanded(child: ListView(padding: EdgeInsets.zero, children: messages)) :
        Expanded(child: StreamBuilder(
          stream: chat!.orderBy("sentAt").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return MessageBubble(message: (doc.data() as Map<String, dynamic>));
                },
              );
            }

            return Container();
          },
        )),
        SizedBox(
            // height: 48.0,
            // width: 304.0,
            child: Container(
                color: Color(0xfffafafa),
                 padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Mensagem",
                            hintMaxLines: 1,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 0.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                                width: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: InkWell(
                        child: Icon(
                          Icons.send,
                          color: Color(0xff88c9bf),
                          size: 24,
                        ),
                        onTap: () async {
                          if (_textController.text.trim() != '') {
                            // TODO: send message here!
                            await sendMessage();
                            // _textController.text = '';
                          }
                        },
                      ),
                    ),
                  ],
                )))
      ]),
    );
  }

  void sendPushMessage(String token, String sourceName, String content) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
            'key=AAAAMqoYe-0:APA91bE0roCBA2WIAIVdMENoR8Rh-s3Hyh9Q_D5VJKYHzSZeE9DU-70oLa5n4mVCgxHwZCyydZMlmxr___DgyOaqDsZS1BLXnw_7CQgxfILxciKfClWwytIt8xAdULfbrWj7KCAz1mL3',
          },
          body: jsonEncode({
            'notification': {
              'title': '$sourceName',
              'body': '$content',
            },
            'priority': 'high',
            'data': <String, String>{
              "content": content,
            },
            // can send to other user by setting its token here
            'to': '$token',
          }));
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
