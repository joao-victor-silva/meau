import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/local_user_signup.dart';
import 'package:meau/pages/my_animals_page.dart';
import 'package:meau/pages/notifications.dart';

class AppDrawer extends StatefulWidget {

  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _database;

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

  @override
  void initState() {
    super.initState();
    initAuth();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, SignIn.id);
              },
            ),
            ListTile(
              title: const Text('Cadastro'),
              onTap: () {
                Navigator.pushNamed(context, SignUp.id);
              },
            )
          ],
        ),
      );
    }
    
    
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('TODOS ANIMAIS'),
            onTap: () {
              Navigator.pushNamed(context, AllAnimals.id);
            },
          ),
          ListTile(
            title: const Text('MEUS ANIMAIS'),
            onTap: () {
              Navigator.pushNamed(context, MyAnimals.id);
            },
          ),
          ListTile(
            title: const Text('CADASTRAR ANIMAL'),
            onTap: () {
              Navigator.pushNamed(context, AnimalSignUpPage.id);
            },
          ),
          ListTile(
            title: const Text('NOTIFICAÇÕES'),
            onTap: () {
              Navigator.pushNamed(context, Notifications.id);
            },
          ),
          ListTile(
            title: const Text('SAIR'),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => IntroductionPage()),
                      (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

