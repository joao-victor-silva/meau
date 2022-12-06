import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/unauthenticated_page.dart';

class IntroductionPage extends StatelessWidget {
  final FirebaseFirestore database;
  final FirebaseAuth auth;

  const IntroductionPage({super.key, required this.auth, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 136, 201, 191),
      ),
      drawer: const Drawer(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 32),
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
                auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnauthenticatedPage(auth: auth, database: database)));
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
                auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnauthenticatedPage(auth: auth, database: database)));
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
                auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnauthenticatedPage(auth: auth, database: database)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnimalSignUpPage(auth: auth, database: database)));
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
            const SizedBox(
              height: 44,
            ),
            TextButton(
              onPressed: () {
                auth.authStateChanges().listen((User? user) {
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocalUserSignInPage(auth: auth, database: database)));
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
}