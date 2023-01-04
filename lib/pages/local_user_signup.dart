import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/local_user.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:image_picker/image_picker.dart';

class LocalUserSignUpPage extends StatefulWidget {
  final FirebaseFirestore database;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  const LocalUserSignUpPage(
      {super.key,
      required this.database,
      required this.auth,
      required this.storage});

  @override
  State<LocalUserSignUpPage> createState() => LocalUserSignUpPageState();
}

class LocalUserSignUpPageState extends State<LocalUserSignUpPage> {
  final name = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final _picker = ImagePicker();
  late XFile photo;

  @override
  void dispose() {
    name.dispose();
    age.dispose();
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

    final storageRef = widget.storage.ref();
    final userPhotoRef = storageRef.child("users/$userId/profilePhoto.jpg");
    try {
      userPhotoRef.putData(await photo.readAsBytes());
      return userPhotoRef.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Couldn't upload user profile photo: ${e.message}");
    }
    return "";
  }

  void _signup() async {
    var user = LocalUser("id", name.text, age.text, email.text, "", "", "", "",
        "", password.text, "");
    widget.auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((credential) async {
      if (photo != null) {
        user.photo = await _uploadPhoto(credential.user?.uid);
      }
      widget.database
          .collection("users")
          .doc(credential.user?.uid)
          .set(user.toMap())
          .then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => IntroductionPage(
                      auth: widget.auth,
                      database: widget.database,
                      storage: widget.storage,
                    )));
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
        drawer: const Drawer(),
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
