import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_details.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/local_user_signup.dart';
import 'package:meau/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  late FirebaseFirestore _database;
  late FirebaseAuth _auth;
  late FirebaseStorage _storage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meau',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AnimalDetails(
      //   photoUrl: '',
      //   // photoUrl: "https://petepop.ig.com.br/wp-content/uploads/2021/06/reproduc%CC%A7a%CC%83o-instagram.jpg",
      //   name: 'Caramelo',
      //   temperamento: 'Bagunceira',
      //   needs: 'Carinho e atenção',
      //   size: "médio",
      //   gender: "fêmea",
      // ),
      home: FutureBuilder(
          future: _firebaseApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('You have an error! ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              _database = FirebaseFirestore.instance;
              _auth = FirebaseAuth.instance;
              _storage = FirebaseStorage.instance;
              // return LocalUserSignUpPage(
              //   database: _database,
              //   auth: _auth,
              // );
              // return LocalUserSignInPage(database: _database, auth: _auth);
              // return AnimalSignUpPage(database: _database, auth: _auth);
              return SplashPage(auth: _auth, database: _database, storage: _storage);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
