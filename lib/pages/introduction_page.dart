import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/animals.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/notifications.dart';
import 'package:meau/pages/unauthenticated_page.dart';

class IntroductionPage extends StatefulWidget {
  static String id = 'introduction';

  final FirebaseFirestore database;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  const IntroductionPage({super.key,
    required this.auth,
    required this.database,
    required this.storage});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 136, 201, 191),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('TODOS ANIMAIS'),
              onTap: () async {
                await allAnimals(context);
              },
            ),
            myAnimalsWidget(context),
            notificationsWidget(context),
            logoutWidget(context),
          ],
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 32),

          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 56,
            ),
            const Text(
              'Olá',
              style: TextStyle(
                  fontSize: 72,
                  fontFamily: 'Courgette',
                  color: Color.fromARGB(255, 255, 211, 88)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 52,
            ),
            const Text(
              'Bem vindo ao Meau!\nAqui você pode adotar, doar e ajudar\ncães e gatos com facilidade.\nQual é o seu interesse?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                color: Color.fromARGB(255, 117, 117, 117),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            TextButton(
              onPressed: () {
                widget.auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UnauthenticatedPage(
                                    auth: widget.auth,
                                    database: widget.database,
                                    storage: widget.storage)));
                  }
                });
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('ADOTAR'),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {
                widget.auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UnauthenticatedPage(
                                    auth: widget.auth,
                                    database: widget.database,
                                    storage: widget.storage)));
                  }
                });
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('AJUDAR'),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {
                widget.auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UnauthenticatedPage(
                                    auth: widget.auth,
                                    database: widget.database,
                                    storage: widget.storage)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AnimalSignUpPage(
                                  auth: widget.auth,
                                  database: widget.database,
                                  storage: widget.storage,
                                )));
                  }
                });
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('CADASTRAR ANIMAL'),
            ),
            TextButton(
              onPressed: () async {
                // var animals = <dynamic>[];
                // var result = await database.collection("animals").get();
                var result = await widget.database
                    .collection("animals")
                    .where("owner", isEqualTo: "AeMEAn3iVzVW6FpDPUXOXHPWdwr1")
                    .get();
                var animals = result.docs.map((e) => e.data()).toList();

                // print("animals: ${data.length}");
                Timer(
                    Duration.zero,
                        () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Animals(
                                      title: "Meus animais",
                                      animals: animals,
                                      storage: widget.storage,
                                    ))));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('MEUS ANIMAIS'),
            ),
            TextButton(
              onPressed: () async {
                // var animals = <dynamic>[];
                var result = await widget.database.collection("animals").get();
                // var result = await database.collection("animals").where("owner", isEqualTo: "AeMEAn3iVzVW6FpDPUXOXHPWdwr1").get();
                var animals = result.docs.map((e) => e.data()).toList();

                // print("animals: ${data.length}");
                Timer(
                    Duration.zero,
                        () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Animals(
                                      title: "Animais para adoção",
                                      animals: animals,
                                      storage: widget.storage,
                                    ))));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('ANIMAIS PARA ADOÇÃO'),
            ),
            const SizedBox(
              height: 44,
            ),
            TextButton(
              onPressed: () {
                widget.auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UnauthenticatedPage(
                                    auth: widget.auth,
                                    database: widget.database,
                                    storage: widget.storage)));
                  }
                });
              },
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 136, 201, 191)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('login'),
            ),
            const SizedBox(
              height: 68,
            ),
            const Image(
              image: AssetImage('assets/images/Meau_marca_2.png'),
              width: 122,
              height: 44,
            )
          ],
        ),
      ),
    );
  }

  Future<void> allAnimals(BuildContext context) async {
    var result = await widget.database.collection("animals").get();
    var animals = result.docs.map((e) => e.data()).toList();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            Animals(
              title: "Meus animais",
              animals: animals,
              storage: widget.storage,
            )));
  }

  Widget myAnimalsWidget(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Container();
    }

    return ListTile(
      title: const Text('MEUS ANIMAIS'),
      onTap: () async {
        await myAnimals(context);
      },
    );
  }

  Future<void> myAnimals(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser == null ? "AeMEAn3iVzVW6FpDPUXOXHPWdwr1" : FirebaseAuth.instance.currentUser?.uid;
    var result = await widget.database
        .collection("animals")
        .where("owner", isEqualTo: "$user")
        .get();
    var animals = result.docs.map((e) => e.data()).toList();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            Animals(
              title: "Meus animais",
              animals: animals,
              storage: widget.storage,
            )));
  }

  Widget notificationsWidget(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Container();
    }

    return ListTile(
      title: const Text('NOTIFICAÇÕES'),
      onTap: () async {
        await notifications(context);
      },
    );
  }

  Future<void> notifications(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser == null ? "AeMEAn3iVzVW6FpDPUXOXHPWdwr1" : FirebaseAuth.instance.currentUser?.uid;
    var result = await widget.database
        .collection("notifications")
        .where("target", isEqualTo: "$user")
        .get();
    var notifications = result.docs.map((e) => e.data()).toList();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Notifications(notifications: notifications)));
  }


  Widget logoutWidget(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Container();
    }

    return ListTile(
      title: const Text('LOGOUT'),
      onTap: () async {
        await logout();
      },
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, IntroductionPage.id);
  }
}
