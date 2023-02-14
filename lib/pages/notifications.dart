import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:meau/pages/drawer.dart';
import 'package:meau/pages/notification_card.dart';

class Notifications extends StatefulWidget {
  static String id = 'notifications';

  Notifications({super.key});

  @override
  State<Notifications> createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  List<Widget> notifications = List.empty();

  void getNotifications() async {
    _database.collection("notifications")
        .where("targetId", isEqualTo: _auth.currentUser!.uid)
        .get().then((value) {
      var data = value.docs.map((e) => NotificationCard(notification: e.data())).toList();
      setState(() {
        notifications = data;
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
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Notificações'),
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
      body: Center(
        child: SingleChildScrollView(child: Column(children: notifications))
      ),
    );
  }
}
