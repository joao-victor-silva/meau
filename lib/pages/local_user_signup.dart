import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/pages/Drawer.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';

class SignUp extends StatefulWidget {
  static String id = 'signup';

  SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final _picker = ImagePicker();
  late XFile photo;

  String? token = "";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
        print("FCM Token: $token");
      });
    });
  }

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
    initAuth();
    initDatabase();
    initStorage();
    getToken();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
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

  Future<String> _uploadPhoto(String? userId) async {
    if (photo == null) {
      return "";
    }

    final storageRef = _storage.ref();
    final userPhotoRef = storageRef.child("users/$userId/profilePhoto.jpg");
    try {
      // userPhotoRef.
      // photo.readAsBytes().then((value) {
      //   userPhotoRef.putData(value).whenComplete(() => {
      //     userPhotoRef.getDownloadURL().toString()
      //   });
      // });
      // userPhotoRef.putData(await photo.readAsBytes()).then((p0) {
      //   return userPhotoRef.getDownloadURL();
      // });
    } on FirebaseException catch (e) {
      print("Couldn't upload user profile photo: ${e.message}");
    }
    return "";
  }

  void _signup() async {
    var user = User();
    _auth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((credential) async {
      if (photo != null) {
        user.profilePhotoUrl = await _uploadPhoto(credential.user?.uid);
      }

      user.id = credential.user?.uid;
      user.name = name.text;
      user.email = email.text;
      user.fcmToken = token;

      _database
          .collection("users")
          .doc(credential.user?.uid)
          .set(user.toMap())
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            // TODO: change here to all animals page
            MaterialPageRoute(builder: (context) => AllAnimals()),
            (route) => false);
      }).onError((error, _) {
        print('Something went wrong! ${error.toString()}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro Pessoal"),
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
              Container(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 207, 233, 229)),
                child: const SizedBox(
                  width: 328,
                  height: 80,
                  child: Text(
                      'As informações preenchidas serão divulgadas\napenas para a pessoal com a qual você realizar\no processo de adoção e/ou apadrinhamento,\napós a informação do processo.',
                      textAlign: TextAlign.center),
                ),
              ),
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
                child: const Text('FAZER CADASTRO',
                    style: TextStyle(fontSize: 12.0)),
              ),
            ],
          ),
        ));
  }
}
