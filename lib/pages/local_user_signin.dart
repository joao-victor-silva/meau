import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/local_user.dart';
import 'package:meau/pages/drawer.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/introduction_page.dart';

class SignIn extends StatefulWidget {
  static String id = 'signin';

  SignIn({super.key});

  @override
  State<SignIn> createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final email = TextEditingController();
  final password = TextEditingController();

  late FirebaseAuth _auth;
  late FirebaseFirestore _database;

  void initAuth() {
    var auth = FirebaseAuth.instance;
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
    initAuth();
    initDatabase();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _login() {
    _auth
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .then((credential) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AllAnimals()),
          (route) => false);
    }, onError: (error) {
      print('Something went wrong! ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          title: const Text("Login"),
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
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 64.0,
              ),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 189, 189, 189)),
                ),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 189, 189, 189)),
                ),
              ),
              const SizedBox(
                height: 52.0,
              ),
              TextButton(
                onPressed: () => _login(),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 136, 201, 191)),
                    foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 67, 67, 67)),
                    fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                    textStyle: MaterialStatePropertyAll(
                      TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(255, 67, 67, 67),
                      ),
                    )),
                child: const Text('ENTRAR'),
              ),
              const SizedBox(
                height: 72.0,
              ),
            ],
          ),
        ));
  }
}
