// import 'dart:html';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final Map<String, dynamic> message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => MessageBubbleState();
}

class MessageBubbleState extends State<MessageBubble> {
  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _database;

  static const styleSomebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, right: 50),
    alignment: Alignment.topLeft,
  );

  static const styleMe = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Color.fromARGB(255, 225, 255, 199),
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, left: 50),
    alignment: Alignment.topRight,
  );

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

  @override
  void initState() {
    super.initState();
    initAuth();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message['senderId'] == _auth.currentUser!.uid) {
      return Bubble(
        style: styleMe,
        child: Text(
          widget.message['content'],
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: "Roboto Regular",
            // color: Color(0xffbdbdbd),
          ),
        ),
      );
    }
    return Bubble(
      style: styleSomebody,
      child: Text(
        widget.message['content'],
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: "Roboto Regular",
          // color: Color(0xffbdbdbd),
        ),
      ),
    );
  }
}
