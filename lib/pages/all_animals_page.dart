import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/pages/Drawer.dart';

import 'animal_card.dart';

class AllAnimals extends StatefulWidget {
  static String id = 'all_animals';

  AllAnimals({super.key});

  @override
  State<AllAnimals> createState() => AllAnimalsState();
}

class AllAnimalsState extends State<AllAnimals> {

  List<Animal> animals = List.empty();
  void getAnimals() async {
    _database.collection("animals").get().then((value) {
      var data = value.docs.map((e) => Animal.fromMap(e.data())).toList();
      setState(() {
        animals = data;
      });
    });
  }

  late FirebaseFirestore _database;

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
    initDatabase();
    getAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Todos os animais'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: Center(
          child: SingleChildScrollView(child: Column(children: getAnimalsCards()))
      ),
    );
  }

  List<Widget> getAnimalsCards() {
    List<Widget> cards = <AnimalCard>[];
    for (var i = 0; i < animals.length; i++) {
      cards.add(AnimalCard(
          animal: animals[i]
      ));
    }
    return cards;
  }
}