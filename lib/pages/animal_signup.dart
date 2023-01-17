import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:uuid/uuid.dart';

enum AnimalType {
  cat,
  dog,
}

enum AnimalGender {
  female,
  male,
}

enum AnimalSize {
  small,
  medium,
  big,
}

class AnimalSignUpPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore database;
  final FirebaseStorage storage;

  const AnimalSignUpPage(
      {super.key, required this.auth, required this.database, required this.storage});

  @override
  State<AnimalSignUpPage> createState() => AnimalSignUpPageState();
}

class AnimalSignUpPageState extends State<AnimalSignUpPage> {
  final name = TextEditingController();
  AnimalType? specie = AnimalType.dog;
  AnimalGender? gender = AnimalGender.female;
  AnimalSize? size = AnimalSize.small;
  final _picker = ImagePicker();
  late XFile photo;
  String? userNotificationToken = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) => {
      setState(() {
        userNotificationToken = token;
      })
    });
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

    final storageRef = widget.storage.ref();
    final animalPhotoRef = storageRef.child("animals/$id.jpg");
    try {
      animalPhotoRef.putData(await photo.readAsBytes());
      String url = await animalPhotoRef.getDownloadURL();
      print('image url: $url');
      return url;
    } on FirebaseException catch (e) {
      print("Couldn't upload animal photo: ${e.message}");
      return "";
    }
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
                      Radio<AnimalType>(
                        value: AnimalType.dog,
                        groupValue: specie,
                        onChanged: ((AnimalType? value) {
                          setState(() {
                            specie = value;
                          });
                        })),
                    ], 
                  ),
                  Row(
                    children: [
                      const Text('Gato'),
                      Radio<AnimalType>(
                        value: AnimalType.cat,
                        groupValue: specie,
                        onChanged: ((AnimalType? value) {
                          setState(() {
                            specie = value;
                          });
                        })),
                    ],
                  ),
                ],
              ),
              // Container(
              //   alignment: Alignment.topLeft,
              //   child: const Text('SEXO'),
              // ),
              // Row(
              //   children: [
              //     ListTile(
              //       title: const Text('Fêmea'),
              //       leading: Radio(
              //           value: AnimalGender.female,
              //           groupValue: gender,
              //           onChanged: ((AnimalGender? value) {
              //             setState(() {
              //               gender = value;
              //             });
              //           })),
              //     ),
              //     ListTile(
              //       title: const Text('Macho'),
              //       leading: Radio(
              //           value: AnimalGender.male,
              //           groupValue: gender,
              //           onChanged: ((AnimalGender? value) {
              //             setState(() {
              //               gender = value;
              //             });
              //           })),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 32.0,
              // ),
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
                onPressed: () async {
                  final uuid = Uuid();
                  final id = uuid.v4();
                  Map<String, dynamic> animal = {
                    "id": id,
                    "name": name.text,
                    "specie": specie.toString(),
                    "gender": gender.toString(),
                    "needs": "Precisa de muita atenção pois é muito baguneeiro e gosta de bricar.",
                    "owner": widget.auth.currentUser?.uid,
                    "ownerToken": userNotificationToken?? ""
                  };
                  if (photo != null) {
                    animal['photoUrl'] = await _uploadPhoto(id);
                  }
                  widget.database
                      .collection("animals")
                      .doc(id)
                      .set(animal)
                      .then((value) async {
                    print('Animal ${name.text} saved on database');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IntroductionPage(auth: widget.auth, database: widget.database, storage: widget.storage,)));
                    await widget.auth.signOut();
                  }).onError((error, stackTrace) {
                    print('Something went wrong! ${error.toString()}');
                  });
                },
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
