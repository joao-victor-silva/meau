import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_card.dart';

class Notifications extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;

  Notifications({super.key, required this.notifications});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String? notificationTitle, notificationBody;

  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((value) => {
      print("FCM Token is: $value")
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notificationTitle = message.notification!.title;
          notificationBody = message.notification!.body;
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Opened message: ${message.data}');
      print('Message: ${message.toMap().toString()}');
      if (message.notification != null) {
        setState(() {
          notificationTitle = message.notification!.title;
          notificationBody = message.notification!.body;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: Text('Notificações'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${notificationTitle != null ? notificationTitle : "Notification Title Goes Here"}",
                style: TextStyle(
                    fontSize: 28,
                    color: Color.fromARGB(255, 79, 79, 79),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${notificationBody != null ? notificationBody : "Notification Body Goes Here"}",
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 79, 79, 79),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
    );
  }

  Widget acceptButton() {
    // if (notificationTitle != null) {
    //   return TextButton(onPressed: () {
    //     var db = FirebaseFirestore.instance;
    //     db.
    //   }, child: Text('Aceitar'));
    // }

    return Container();
  }

  Widget declineButton() {
    if (notificationTitle != null) {
      return TextButton(onPressed: () {
        setState(() {
          notificationTitle = null;
          notificationBody = null;
        });
      }, child: Text('Recusar'));
    }

    return Container();
  }
}
