import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:uuid/uuid.dart';

class AnimalSignUpPage extends StatefulWidget {
  static String id = 'animal_signup';
  AnimalSignUpPage({super.key});

  @override
  State<AnimalSignUpPage> createState() => AnimalSignUpPageState();
}

class AnimalSignUpPageState extends State<AnimalSignUpPage> {
  final name = TextEditingController();
  AnimalSpecie? specie = AnimalSpecie.cat;
  AnimalGender? gender = AnimalGender.female;
  AnimalSize? size = AnimalSize.small;
  final _picker = ImagePicker();
  late XFile photo;

  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _database;
  late FirebaseStorage _storage;

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

  void initStorage() {
    var storage = FirebaseStorage.instance;
    setState(() {
      _storage = storage;
    });
    print('Storage initialized');
  }

  @override
  void initState() {
    super.initState();
    initAuth();
    initDatabase();
    initStorage();
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final imagePicked = await _picker.pickImage(source: source);

    if (imagePicked != null) {
      setState(() {
        photo = imagePicked;
      });
    }
  }

  Future<String> _uploadPhoto(String id) async {
    if (photo == null) {
      print("No photo");
      return "";
    }

    try {
      final storageRef = _storage.ref();
      var animalPhotoRef = storageRef.child("animals/$id.jpg");
      var data = await photo.readAsBytes();
      var task = await animalPhotoRef.putData(data);
      var url = await task.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print("Couldn't upload animal photo: ${e.message}");
    }
    return "";
  }

  void _signup() async {
    final uuid = Uuid();
    final id = uuid.v4();

    var animal = Animal();
    animal.id = id;
    animal.name = name.text;
    animal.specie = specie;
    animal.gender = gender;
    animal.ownerId = _auth.currentUser!.uid;
    animal.photoUrls = List.empty(growable: true);

    if (photo != null) {
      var url = await _uploadPhoto(id);
      animal.photoUrls?.add(url);
    }

    _database
        .collection("animals")
        .doc(id)
        .set(animal.toMap())
        .then((value) async {
      print('Animal ${name.text} saved on database');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AllAnimals()),
          (route) => false);
    }).onError((error, stackTrace) {
      print('Something went wrong! ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro do Animal"),
        ),
        drawer: const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
            child: Drawer()),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 28.0,
              ),
              Container(
                child: const Text('NOME DO ANIMAL'),
                alignment: Alignment.topLeft,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Nome do animal',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text('ESPÉCIE'),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const Text('Cachorro'),
                      Radio<AnimalSpecie>(
                          value: AnimalSpecie.dog,
                          groupValue: specie,
                          onChanged: ((AnimalSpecie? value) {
                            setState(() {
                              specie = value;
                            });
                          })),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Gato'),
                      Radio<AnimalSpecie>(
                          value: AnimalSpecie.cat,
                          groupValue: specie,
                          onChanged: ((AnimalSpecie? value) {
                            setState(() {
                              specie = value;
                            });
                          })),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _pickImage(ImageSource.camera),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 67, 67, 67)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 207, 233, 229))),
                child: const Text('CAMERA', style: TextStyle(fontSize: 12.0)),
              ),
              TextButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 67, 67, 67)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 207, 233, 229))),
                child: const Text('GALERIA', style: TextStyle(fontSize: 12.0)),
              ),
              TextButton(
                onPressed: () => _signup(),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 67, 67, 67)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 207, 233, 229))),
                child: const Text('COLOCAR PARA ADOÇÃO',
                    style: TextStyle(fontSize: 12.0)),
              ),
            ],
          ),
        ));
  }
}
