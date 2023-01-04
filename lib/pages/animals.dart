import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_card.dart';

class Animals extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> animals;
  final FirebaseStorage storage;

  const Animals(
      {super.key,
      required this.title,
      required this.animals,
      required this.storage});

  List<Widget> getAnimalsCards() {
    List<Widget> cards = <AnimalCard>[];
    for (var i = 0; i < animals.length; i++) {
      var photoUrl =
          "https://petepop.ig.com.br/wp-content/uploads/2021/06/reproduc%CC%A7a%CC%83o-instagram.jpg";
      cards.add(AnimalCard(
          id: animals[i]["id"] ?? "",
          name: animals[i]['name'] ?? "",
          photoUrl: animals[i]['photoUrl'] ?? photoUrl,
          specie: animals[i]['specie'] ?? "",
          gender: animals[i]['gender'] ?? "",
          size: animals[i]['size'] ?? "")
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: Text(this.title),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body:
            SingleChildScrollView(child: Column(children: getAnimalsCards())));
  }
}
