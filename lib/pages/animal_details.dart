import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/animal.dart';

class AnimalDetails extends StatelessWidget {
  const AnimalDetails({super.key, required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    var photo =
        "https://firebasestorage.googleapis.com/v0/b/meau-c3971.appspot.com/o/animals%2F${animal.id!}.jpg?alt=media&token=9805742e-61e5-4230-a621-4e36b8462c00";
    if (animal.photoUrls != null && animal.photoUrls!.first.isNotEmpty) {
      photo = animal.photoUrls!.first;
    }
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        children: [
          photo.isNotEmpty
              ? Image(
                  image: NetworkImage(photo),
                )
              : Container(),
          Text(
            animal.name ?? "",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 16,
          ),
          getTextWidget('PORTE', animal.size?.name ?? ""),
          getTextWidget('GENERO', animal.gender?.name ?? ""),
          getTextWidget('TEMPERAMENTO', animal.behaviors?.join(", ") ?? ""),
          getTextWidget('o que ${animal.name!} precisa'.toUpperCase(),
              animal.needs?.join(", ") ?? ""),
          getAdoptButton()
        ],
      ),
    );
  }

  Widget getTextWidget(String title, String value) {
    if (value.isEmpty) return Container();

    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget getAdoptButton() {
    if (FirebaseAuth.instance.currentUser?.uid == animal.ownerId)
      return Container();

    return TextButton(
      onPressed: () async {
        var database = FirebaseFirestore.instance;
        var messaging = FirebaseMessaging.instance;
        var docSnap = await database.collection("users").doc(animal.ownerId!).get();
        var targetToken = docSnap.data()!['fcmToken'].toString();

        var notification = <String, dynamic>{
          "sourceId": FirebaseAuth.instance.currentUser!.uid!,
          "sourceEmail": FirebaseAuth.instance.currentUser!.email!,
          "animalId": animal.id!,
          "animalName": animal.name!,
          "targetId": animal.ownerId!,
          "targetToken": targetToken,
        };

        notification["title"] = "Alguém está interessado na(o) ${animal.name!}";
        notification["body"] = "O usuário ${notification['sourceEmail']} está interessado em adotar o ${notification['animalName']}";

        var sourceToken = await messaging.getToken();
        notification["sourceToken"] = sourceToken;

        sendPushMessage(targetToken, notification);

        database
            .collection("notifications")
            .add(notification)
            .then((value) => {print('notification sent')});
      },
      style: const ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 255, 211, 88)),
          foregroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
          fixedSize: MaterialStatePropertyAll(Size(232, 40)),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              fontSize: 12,
              fontFamily: 'Roboto',
            ),
          )),
      child: const Text('ADOTAR'),
    );
  }

  void sendPushMessage(String token, Map<String, dynamic> notification) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAMqoYe-0:APA91bE0roCBA2WIAIVdMENoR8Rh-s3Hyh9Q_D5VJKYHzSZeE9DU-70oLa5n4mVCgxHwZCyydZMlmxr___DgyOaqDsZS1BLXnw_7CQgxfILxciKfClWwytIt8xAdULfbrWj7KCAz1mL3',
          },
          body: jsonEncode({
            'notification': {
              'title':
                  'Alguém está interessado na(o) ${notification['animalName']}',
              'body':
                  'O usuário ${notification['sourceEmail']} está interessado em adotar o ${notification['animalName']}',
            },
            'priority': 'high',
            'data': notification,
            // can send to other user by setting its token here
            'to': '$token',
          }));
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
