import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meau/local_user.dart';

class LocalUserSignUpPage extends StatefulWidget {
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  const LocalUserSignUpPage(
      {super.key, required this.database, required this.auth});

  @override
  State<LocalUserSignUpPage> createState() => LocalUserSignUpPageState();
}

class LocalUserSignUpPageState extends State<LocalUserSignUpPage> {
  final name = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    age.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro Pessoal"),
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
                alignment: Alignment.topLeft,
                child: const Text('INFORMAÇÕES PESSOAIS'),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
              ),
              TextField(
                controller: age,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
              ),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextButton(
                onPressed: () {
                  final user = LocalUser("id", name.text, age.text, email.text,
                      "", "", "", "", "", password.text, "");
                  widget.auth
                      .createUserWithEmailAndPassword(
                          email: user.email, password: user.password)
                      .then((credential) => {
                            widget.database
                                .collection("users")
                                .doc(user.email)
                                .set(user.toMap())
                                .onError((error, _) {
                              print(
                                  'Something went wrong! ${error.toString()}');
                            })
                          });
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 67, 67, 67)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 207, 233, 229))),
                child: const Text('FAZER CADASTRO',
                    style: TextStyle(fontSize: 12.0)),
              ),
            ],
          ),
        ));
  }
}
