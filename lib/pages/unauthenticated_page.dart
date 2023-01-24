import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/local_user_signup.dart';

class UnauthenticatedPage extends StatelessWidget {
  static String id = 'unauththenticated';

  UnauthenticatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 67, 67, 67),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Cadastro"),
        backgroundColor: const Color.fromARGB(255, 136, 201, 191),
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 88, 155, 155)),
        foregroundColor: const Color.fromARGB(255, 67, 67, 67),
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto Medium',
          fontSize: 20,
          color: Color.fromARGB(255, 67, 67, 67),
        ),
      ),
      drawer: const Drawer(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 32),
          children: <Widget>[
            const SizedBox(
              height: 52,
            ),
            const Text(
              'Ops!',
              style: TextStyle(
                  fontSize: 53,
                  fontFamily: 'Courgette',
                  color: Color.fromARGB(255, 136, 201, 191)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 52,
            ),
            const Text(
              'Você não pode realizar esta ação sem\npossuir um cadastro.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                color: Color.fromARGB(255, 117, 117, 117),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SignUp.id);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 136, 201, 191)),
                  foregroundColor:
                      MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('FAZER CADASTRO'),
            ),
            const SizedBox(
              height: 44,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SignIn.id);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 136, 201, 191)),
                  foregroundColor:
                      MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('FAZER LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}
