import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meau/local_user.dart';

class LocalUserSignInPage extends StatefulWidget {
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  const LocalUserSignInPage(
      {super.key, required this.database, required this.auth});

  @override
  State<LocalUserSignInPage> createState() => LocalUserSignInPageState();
}

class LocalUserSignInPageState extends State<LocalUserSignInPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        drawer: const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
            child: Drawer()),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 64.0,
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
                height: 52.0,
              ),
              TextButton(
                onPressed: () {
                  widget.auth
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text)
                      .then(
                          (credential) => {
                                widget.database
                                    .collection("users")
                                    .doc(email.text)
                                    .get()
                                    .then((DocumentSnapshot doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final localUser = LocalUser(
                                      "",
                                      data["fullName"],
                                      data["age"],
                                      data["email"],
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "");
                                  print(
                                      'User: ${localUser.toMap().toString()}');
                                })
                              }, onError: (error) {
                    print('Something went wrong! ${error.toString()}');
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
