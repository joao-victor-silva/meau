import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/model/checkbox_model.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:meau/pages/drawer.dart';
import 'package:meau/widgets/checkbox_widget.dart';
import 'package:uuid/uuid.dart';

class AnimalSignUpPage extends StatefulWidget {
  static String id = 'animal_signup';

  AnimalSignUpPage({super.key});

  @override
  State<AnimalSignUpPage> createState() => AnimalSignUpPageState();
}

class AnimalSignUpPageState extends State<AnimalSignUpPage> {
  final name = TextEditingController();
  AnimalSpecie? specie;
  AnimalGender? gender;
  AnimalSize? size;
  AnimalAge? age;
  List<AnimalBehavior>? behaviours;
  List<AnimalHealth>? healths;
  final illness = TextEditingController();
  List<AnimalAdoptRequirement>? adoptRequirements;
  final about = TextEditingController();

  final _picker = ImagePicker();
  XFile? photo;

  dynamic _pickImageError;
  String? _retrieveDataError;

  final List<CheckBoxModel> behaviorItems = [
    CheckBoxModel(text: "Brincalhão", value: AnimalBehavior.playful.name),
    CheckBoxModel(text: "Tímido", value: AnimalBehavior.shy.name),
    CheckBoxModel(text: "Calmo", value: AnimalBehavior.calm.name),
    CheckBoxModel(text: "Guarda", value: AnimalBehavior.watchful.name),
    CheckBoxModel(text: "Amoroso", value: AnimalBehavior.loving.name),
    CheckBoxModel(text: "Preguiçoso", value: AnimalBehavior.lazy.name),
  ];

  final List<CheckBoxModel> healthItems = [
    CheckBoxModel(text: "Vacinado", value: AnimalHealth.vaccinated.name),
    CheckBoxModel(text: "Vermifugado", value: AnimalHealth.dewormed.name),
    CheckBoxModel(text: "Castrado", value: AnimalHealth.castrated.name),
    CheckBoxModel(text: "Doente", value: AnimalHealth.sick.name),
  ];

  final List<CheckBoxModel> adoptRequirementsItems = [
    CheckBoxModel(text: "Termo de adoção", value: AnimalAdoptRequirement.adoptTerm.name),
    CheckBoxModel(text: "Fotos da casa", value: AnimalAdoptRequirement.housePhotos.name),
    CheckBoxModel(text: "Visita prévia ao animal", value: AnimalAdoptRequirement.previousVisitToTheAnimal.name),
    CheckBoxModel(text: "Acompanamento pós adoção", value: AnimalAdoptRequirement.postAdoptionFollowUps.name),
  ];

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
      var data = await photo!.readAsBytes();
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
    animal.state = AnimalState.toAdopt;
    animal.specie = specie;
    animal.gender = gender;
    animal.size = size;
    animal.age = age;
    animal.illness = illness.text;
    animal.about = about.text;

    behaviours = List.from(behaviorItems.where((item) => item.checked))
        .map((e) => AnimalBehavior.values.byName((e as CheckBoxModel).value))
        .toList();
    animal.behaviors = behaviours;

    healths = List.from(healthItems.where((item) => item.checked))
        .map((e) => AnimalHealth.values.byName((e as CheckBoxModel).value))
        .toList();
    animal.healths = healths;

    adoptRequirements = List.from(adoptRequirementsItems.where((item) => item.checked))
        .map((e) => AnimalAdoptRequirement.values.byName((e as CheckBoxModel).value))
        .toList();
    animal.adoptRequirements = adoptRequirements;

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
          leading: const BackButton(),
          title: Text('Cadastro do Animal'),
          backgroundColor: const Color(0xffffd358),
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Color(0xfff7a800)),
          foregroundColor: const Color.fromARGB(255, 67, 67, 67),
          titleTextStyle: const TextStyle(
            fontFamily: 'Roboto Medium',
            fontSize: 20,
            color: Color.fromARGB(255, 67, 67, 67),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                "Adoção",
                style: TextStyle(
                  fontFamily: "Roboto Medium",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Color(0xff434343),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                child: const Text(
                  'NOME DO ANIMAL',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Nome do animal',
                  labelStyle: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 14.0,
                    color: Color(0xffbdbdbd),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                child: const Text(
                  'FOTO DO ANIMAL',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              const SizedBox(
                height: 20.0,
              ),
              // TODO: Image picker here
              _previewImages(),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                child: const Text(
                  'ESPÉCIE',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio<AnimalSpecie>(
                          value: AnimalSpecie.dog,
                          groupValue: specie,
                          onChanged: ((AnimalSpecie? value) {
                            setState(() {
                              specie = value;
                            });
                          })),
                      const Text(
                        'Cachorro',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AnimalSpecie>(
                          value: AnimalSpecie.cat,
                          groupValue: specie,
                          onChanged: ((AnimalSpecie? value) {
                            setState(() {
                              specie = value;
                            });
                          })),
                      const Text(
                        'Gato',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: const Text(
                  'SEXO',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio<AnimalGender>(
                          value: AnimalGender.female,
                          groupValue: gender,
                          onChanged: ((AnimalGender? value) {
                            setState(() {
                              gender = value;
                            });
                          })),
                      const Text(
                        'Fêmea',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AnimalGender>(
                          value: AnimalGender.male,
                          groupValue: gender,
                          onChanged: ((AnimalGender? value) {
                            setState(() {
                              gender = value;
                            });
                          })),
                      const Text(
                        'Macho',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: const Text(
                  'PORTE',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio<AnimalSize>(
                          value: AnimalSize.small,
                          groupValue: size,
                          onChanged: ((AnimalSize? value) {
                            setState(() {
                              size = value;
                            });
                          })),
                      const Text(
                        'Pequeno',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AnimalSize>(
                          value: AnimalSize.medium,
                          groupValue: size,
                          onChanged: ((AnimalSize? value) {
                            setState(() {
                              size = value;
                            });
                          })),
                      const Text(
                        'Médio',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AnimalSize>(
                          value: AnimalSize.big,
                          groupValue: size,
                          onChanged: ((AnimalSize? value) {
                            setState(() {
                              size = value;
                            });
                          })),
                      const Text(
                        'Grande',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: const Text(
                  'IDADE',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio<AnimalAge>(
                          value: AnimalAge.young,
                          groupValue: age,
                          onChanged: ((AnimalAge? value) {
                            setState(() {
                              age = value;
                            });
                          })),
                      const Text(
                        'Filhote',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AnimalAge>(
                          value: AnimalAge.adult,
                          groupValue: age,
                          onChanged: ((AnimalAge? value) {
                            setState(() {
                              age = value;
                            });
                          })),
                      const Text(
                        'Adulto',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AnimalAge>(
                          value: AnimalAge.old,
                          groupValue: age,
                          onChanged: ((AnimalAge? value) {
                            setState(() {
                              age = value;
                            });
                          })),
                      const Text(
                        'Idoso',
                        style: TextStyle(
                          fontFamily: "Roboto Regular",
                          fontSize: 14.0,
                          color: Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: const Text(
                  'TEMPERAMENTO',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(children: [
                CheckboxWidget(item: behaviorItems[0]),
                CheckboxWidget(item: behaviorItems[1]),
                CheckboxWidget(item: behaviorItems[2]),
              ]),
              Row(children: [
                CheckboxWidget(item: behaviorItems[3]),
                CheckboxWidget(item: behaviorItems[4]),
                CheckboxWidget(item: behaviorItems[5]),
              ]),
              Container(
                child: const Text(
                  'SAÚDE',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(children: [
                CheckboxWidget(item: healthItems[0]),
                CheckboxWidget(item: healthItems[1]),
              ]),
              Row(children: [
                CheckboxWidget(item: healthItems[2]),
                CheckboxWidget(item: healthItems[3]),
              ]),
              TextField(
                controller: illness,
                decoration: const InputDecoration(
                  labelText: 'Doenças do animal',
                  labelStyle: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 14.0,
                    color: Color(0xffbdbdbd),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                child: const Text(
                  'EXIGẾNCIAS PARA ADOÇÃO',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Row(children: [
                CheckboxWidget(item: adoptRequirementsItems[0]),
              ]),
              Row(children: [
                CheckboxWidget(item: adoptRequirementsItems[1]),
              ]),
              Row(children: [
                CheckboxWidget(item: adoptRequirementsItems[2]),
              ]),
              Row(children: [
                CheckboxWidget(item: adoptRequirementsItems[3]),
              ]),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                child: const Text(
                  'SOBRE O ANIMAL',
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 12.0,
                    color: Color(0xfff7a800),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              TextField(
                controller: about,
                decoration: const InputDecoration(
                  labelText: 'Compartilhe a história do animal',
                  labelStyle: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 14.0,
                    color: Color(0xffbdbdbd),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () => _signup(),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 67, 67, 67)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffffd358))),
                child: const Text('COLOCAR PARA ADOÇÃO',
                    style: TextStyle(fontSize: 12.0)),
              ),
            ],
          ),
        ));
  }

  Future<void> _displayPickImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fonte'),
            content: Text("Escolha a origem da imagem"),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Galeria'),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('Camera'),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (photo != null) {
      return Container(
        width: 132.0,
        height: 132.0,
        child: Image.file(
          File(photo!.path),
        ),
      );
      // return Semantics(
      //   label: 'image_picker_example_picked_images',
      //   child: ListView.builder(
      //     key: UniqueKey(),
      //     itemBuilder: (BuildContext context, int index) {
      //       return Semantics(
      //         label: 'image_picker_example_picked_image',
      //         child: Image.file(
      //           File(photo!.path),
      //           width: 132.0,
      //           height: 132.0,
      //         ),
      //       );
      //     },
      //     itemCount: 1,
      //   ),
      // );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return GestureDetector(
        onTap: () {
          _displayPickImageDialog(context);
        },
        child: Container(
          width: 132.0,
          height: 132.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 44.0, 0.0, 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.control_point,
                  size: 24.0,
                  color: Color(0xff757575),
                ),
                Text(
                  "adicionar foto",
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 14.0,
                    color: Color(0xff757575),
                  ),
                ),
              ],
            ),
          ),
          color: Color(0xffe6e7e7),
        ),
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
