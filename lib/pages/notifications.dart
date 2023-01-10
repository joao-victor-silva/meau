import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Widget> getNotifications() {
    List<Widget> cards = <Card>[];
    for (var i = 0; i < widget.notifications.length; i++) {
      var data = widget.notifications[i];
      cards.add(Card(
          child: Text(
              'O usuário(a) ${data["sourceName"]} está interessado no animal ${data["animalName"]}')));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: Text('NOTIFICAÇÕES'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body:
            SingleChildScrollView(child: Column(children: getNotifications())));
  }
}
