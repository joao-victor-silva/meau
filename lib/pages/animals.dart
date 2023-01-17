import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_card.dart';

class Animals extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> animals;
  final FirebaseStorage storage;

  const Animals(
      {super.key,
      required this.title,
      required this.animals,
      required this.storage});

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> {
  List<Widget> getAnimalsCards() {
    List<Widget> cards = <AnimalCard>[];
    for (var i = 0; i < widget.animals.length; i++) {
      var photoUrl =
          "https://petepop.ig.com.br/wp-content/uploads/2021/06/reproduc%CC%A7a%CC%83o-instagram.jpg";
      cards.add(AnimalCard(
          id: widget.animals[i]["id"] ?? "",
          name: widget.animals[i]['name'] ?? "",
          photoUrl: widget.animals[i]['photoUrl'] ?? photoUrl,
          specie: widget.animals[i]['specie'] ?? "",
          gender: widget.animals[i]['gender'] ?? "",
          size: widget.animals[i]['size'] ?? "",
          ownerId: widget.animals[i]['owner'] ?? "",
          ownerToken: widget.animals[i]['ownerToken'] ?? "")
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
          title: Text(this.widget.title),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body:
            SingleChildScrollView(child: Column(children: getAnimalsCards())));
  }
}
