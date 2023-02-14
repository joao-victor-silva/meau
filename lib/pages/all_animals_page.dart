import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/model/user.dart';
import 'package:meau/pages/drawer.dart';

import 'animal_card.dart';

class AllAnimals extends StatefulWidget {
  static String id = 'all_animals';

  AllAnimals({super.key});

  @override
  State<AllAnimals> createState() => AllAnimalsState();
}

class AllAnimalsState extends State<AllAnimals> {

  List<Animal> animals = List.empty();
  List<User> owners = List.empty();

  List<Widget>? animalCards = List.empty();

  Future<void> getAnimals() async {
    _database.collection("animals").get().then((value) {
      var data = value.docs.map((e) => Animal.fromMap(e.data())).toList();
      setState(() {
        animals = data;
        print('getAnimals: $animals');
      });
    });
  }

  Future<void> getOwners() async {
    _database.collection("users").get().then((value) {
      var data = value.docs.map((e) => User.fromMap(e.data())).toList();
      setState(() {
        owners = data;
        print('getOwners: $owners');
      });
      getAnimalsCards();
    });
  }

  late FirebaseFirestore _database;

  void initDatabase() async {
    var db = FirebaseFirestore.instance;
    setState(() {
      _database = db;
    });
    await getAnimals();
    await getOwners();
    // getAnimalsCards();
    print('Database initialized');
  }

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Todos os animais'),
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
      // appBar: AppBar(
      //   title: Text('Todos os animais'),
      //   actions: [
      //     IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      //   ],
      // ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(children: animalCards ?? []))
      )
      ,
    );
  }

  void getAnimalsCards() {
    List<Widget> cards = <AnimalCard>[];

    for (var i = 0; i < animals.length; i++) {
      var owner = owners.where((e) => e.id == animals[i].ownerId).first;
      cards.add(AnimalCard(
        animal: animals[i],
        owner: owner,
      ));
    }

    setState(() {
      animalCards = cards;
      print("animalsCards: $animalCards");
    });
  }
}