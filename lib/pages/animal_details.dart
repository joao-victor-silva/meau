import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalDetails extends StatelessWidget {
  const AnimalDetails({super.key, required this.photoUrl, required this.name, required this.temperamento, required this.needs, required this.size, required this.gender, required this.id, required this.ownerId, required this.ownerToken});

  final String photoUrl;
  final String id;
  final String name;
  final String temperamento;
  final String needs;
  final String size;
  final String gender;
  final String ownerId;
  final String ownerToken;

  @override
  Widget build(BuildContext context) {
    var photo = photoUrl;
    if (id.isNotEmpty) {
      photo = "https://firebasestorage.googleapis.com/v0/b/meau-c3971.appspot.com/o/animals%2F$id.jpg?alt=media&token=9805742e-61e5-4230-a621-4e36b8462c00";
    }
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        children: [
          photo.isNotEmpty ? Image(
            image: NetworkImage(photo),
          ) : Container(),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16,),
          getTextWidget('PORTE', size),
          getTextWidget('GENERO', gender),
          getTextWidget('TEMPERAMENTO', temperamento),
          getTextWidget('o que $name precisa'.toUpperCase(), needs),
          getAdoptButton()
        ],
      ),
    );
  }

  Widget getTextWidget(String title, String value) {
    if (value.isEmpty)
      return Container();

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
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }

  Widget getAdoptButton() {
    if (FirebaseAuth.instance.currentUser?.uid == ownerId)
      return Container();

    return TextButton(
      onPressed: () {
        var database = FirebaseFirestore.instance;
        var messaging = FirebaseMessaging.instance;

        Map<String, String> notification = {
          "target": ownerId,
          "animalName": name,
          "sourceName": FirebaseAuth.instance.currentUser!.email!,
          "source": FirebaseAuth.instance.currentUser!.uid!,
        };

        messaging.getToken().then((token) => {
          messaging.sendMessage(messageType: "", data: notification).then((value) => {})
        });

        database
            .collection("notifications").add(notification).then((value) => {
              print('notification sent')
        });
      },
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 255, 211, 88)),
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
}
