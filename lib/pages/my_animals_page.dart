import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/pages/Drawer.dart';

import 'animal_card.dart';

class MyAnimals extends StatefulWidget {
  static String id = 'my_animals';

  MyAnimals({super.key});

  @override
  State<MyAnimals> createState() => MyAnimalsState();
}

class MyAnimalsState extends State<MyAnimals> {
  List<Animal> animals = List.empty();
  void getAnimals() async {
    _database.collection("animals")
      .where("ownerId", isEqualTo: _auth.currentUser!.uid)
        .get().then((value) {
      var data = value.docs.map((e) => Animal.fromMap(e.data())).toList();
      setState(() {
        animals = data;
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

  @override
  void initState() {
    super.initState();
    initAuth();
    initDatabase();
    getAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Meus animais'),
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