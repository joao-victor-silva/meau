import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meau/pages/Drawer.dart';
import 'package:meau/pages/message_bubble.dart';
import 'package:meau/pages/notification_card.dart';

class Chat extends StatefulWidget {
  final String otherParticipant;

  Chat({super.key, required this.otherParticipant});

  @override
  State<Chat> createState() => ChatState();
}

class ChatState extends State<Chat> {
  CollectionReference? chat;
  List<MessageBubble> messages = List.empty();

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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: Container(child: ListView(children: messages)),
    );
  }
}
