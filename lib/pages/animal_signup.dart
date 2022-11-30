import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  const AnimalSignUpPage(
      {super.key, required this.database, required this.auth});

  @override
  State<AnimalSignUpPage> createState() => AnimalSignUpPageState();
}

class AnimalSignUpPageState extends State<AnimalSignUpPage> {
  final name = TextEditingController();
  AnimalType? specie = AnimalType.dog;
  AnimalGender? gender = AnimalGender.female;
  AnimalSize? size = AnimalSize.small;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
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
                onPressed: () {
                  final animal = <String, dynamic>{
                    "name": name.text,
                    "specie": specie.toString(),
                    "gender": gender.toString(),
                  };
                  widget.database
                      .collection("animals")
                      .add(animal)
                      .then((DocumentReference doc) {
                    print('Animal ${name.text} saved on database');
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
