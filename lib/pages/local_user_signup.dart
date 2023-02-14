import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/pages/drawer.dart';
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
  final age = TextEditingController();
  final email = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final phoneNumber = TextEditingController();
  final nickName = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmation = TextEditingController();
  final _picker = ImagePicker();
  XFile? photo;

  dynamic _pickImageError;
  String? _retrieveDataError;

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
    try {
      final imagePicked = await _picker.pickImage(source: source);

      if (imagePicked != null) {
        setState(() {
          photo = imagePicked;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<String> _uploadPhoto(String? userId) async {
    try {
      final storageRef = _storage.ref();
      final userPhotoRef = storageRef.child("users/$userId/profilePhoto.jpg");
      var data = await photo!.readAsBytes();
      var task = await userPhotoRef.putData(data);
      var url = await task.ref.getDownloadURL();
      return url;
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
      user.age = age.text;
      user.email = email.text;
      user.state = state.text;
      user.city = city.text;
      user.address = address.text;
      user.phoneNumber = phoneNumber.text;
      user.nickName = nickName.text;
      user.fcmToken = token;

      _database
          .collection("users")
          .doc(credential.user?.uid)
          .set(user.toMap())
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
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
            shrinkWrap: true,
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
                child: const Text(
                  'INFORMAÇÕES PESSOAIS',
                  style: TextStyle(color: Color(0xff88c9bf)),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: age,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: state,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: city,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: address,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: phoneNumber,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              const SizedBox(
                height: 28.0,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'INFORMAÇÕES DE PERFIL',
                  style: TextStyle(color: Color(0xff88c9bf)),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextField(
                controller: nickName,
                decoration: const InputDecoration(
                  labelText: 'Nome de usuário',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              TextField(
                controller: passwordConfirmation,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmação de senha',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto Regular",
                    color: Color(0xffbdbdbd),
                    backgroundColor: Color(0xfffafafa),
                  ),
                ),
              ),
              const SizedBox(
                height: 28.0,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'FOTO DE PERFIL',
                  style: TextStyle(color: Color(0xff88c9bf)),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              _previewImages(),
              const SizedBox(
                height: 32.0,
              ),
              Container(
                width: 180.0,
                child: TextButton(
                  onPressed: () => _signup(),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 67, 67, 67)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 207, 233, 229))),
                  child: const Text('FAZER CADASTRO',
                      style: TextStyle(fontSize: 12.0)),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _displayPickImageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fonte'),
            content: Text("Escolha a origem da imagem"),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Galeria'),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('Camera'),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (photo != null) {
      return Container(
        width: 132.0,
        height: 132.0,
        child: Image.file(
          File(photo!.path),
        ),
      );
      // return Semantics(
      //   label: 'image_picker_example_picked_images',
      //   child: ListView.builder(
      //     key: UniqueKey(),
      //     itemBuilder: (BuildContext context, int index) {
      //       return Semantics(
      //         label: 'image_picker_example_picked_image',
      //         child: Image.file(
      //           File(photo!.path),
      //           width: 132.0,
      //           height: 132.0,
      //         ),
      //       );
      //     },
      //     itemCount: 1,
      //   ),
      // );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return GestureDetector(
        onTap: () {
          _displayPickImageDialog(context);
        },
        child: Container(
          width: 132.0,
          height: 132.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 44.0, 0.0, 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.control_point,
                  size: 24.0,
                  color: Color(0xff757575),
                ),
                Text(
                  "adicionar foto",
                  style: TextStyle(
                    fontFamily: "Roboto Regular",
                    fontSize: 14.0,
                    color: Color(0xff757575),
                  ),
                ),
              ],
            ),
          ),
          color: Color(0xffe6e7e7),
        ),
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
