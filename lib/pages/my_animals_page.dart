import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/model/user.dart';
import 'package:meau/pages/drawer.dart';

import 'animal_card.dart';

class MyAnimals extends StatefulWidget {
  static String id = 'my_animals';

  MyAnimals({super.key});

  @override
  State<MyAnimals> createState() => MyAnimalsState();
}

class MyAnimalsState extends State<MyAnimals> {
  List<Animal> animals = List.empty();

  List<Widget>? animalCards = List.empty();

  Future<void> getAnimals() async {
    _database
        .collection("animals")
        .where("ownerId", isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.docs.map((e) => Animal.fromMap(e.data())).toList();
      setState(() {
        animals = data;
        print('getAnimals: $animals');
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

  void initDatabase() async {
    var db = FirebaseFirestore.instance;
    setState(() {
      _database = db;
    });
    await getAnimals();
    await getAnimalsCards();
    print('Database initialized');
  }

  @override
  void initState() {
    super.initState();
    initAuth();
    initDatabase();
    // getAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Meus animais'),
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
          child: SingleChildScrollView(
              child: Column(children: animalCards ?? []))),
    );
  }

  Future<void> getAnimalsCards() async {
    List<Widget> cards = <AnimalCard>[];
    var ownerData =
        await _database.collection("users").doc(_auth.currentUser!.uid).get();
    var owner = User.fromMap(ownerData.data());
    for (var i = 0; i < animals.length; i++) {
      cards.add(AnimalCard(animal: animals[i], owner: owner,));
    }

    setState(() {
      animalCards = cards;
      print("animalsCards: $animalCards");
    });
  }
}
