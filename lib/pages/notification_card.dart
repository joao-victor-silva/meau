import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  State<NotificationCard> createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {
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

  @override
  void initState() {
    super.initState();
    initAuth();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(widget.notification['title']),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.notification['body']),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _database
                        .collection("animals")
                        .doc(widget.notification['animalId'])
                        .set({'ownerId': widget.notification['sourceId']},
                            SetOptions(merge: true));
                  });
                },
                child: Text('Aceitar')),
            TextButton(
                onPressed: () {
                  setState(() {
                    setState(() {
                      // _database
                      //     .collection("notifications")
                      //     .where('sourceId', isEqualTo: widget.notification['sourceId'])
                      //     .where('targetId', isEqualTo: widget.notification['targetId'])
                      //     .where('animalId', isEqualTo: widget.notification['animalId'])
                    });
                  });
                },
                child: Text('Recusar')),
          ]),
        ],
      ),
    );
  }
}
