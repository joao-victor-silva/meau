import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:meau/model/user.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/local_user_signup.dart';
import 'package:meau/pages/my_animals_page.dart';
import 'package:meau/pages/my_chats.dart';
import 'package:meau/pages/notifications.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {
  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _database;

  var showUserActions = true;
  var showShortcutActions = true;
  User? _user;

  void initAuth() {
    var auth = firebase_auth.FirebaseAuth.instance;
    setState(() {
      _auth = auth;
    });
    print('Auth initialized');
  }

  void initDatabase() async {
    var db = FirebaseFirestore.instance;
    var data = await db.collection("users").doc(_auth.currentUser!.uid).get();
    var user = await User.fromMap(data.data());
    setState(() {
      _database = db;
      _user = user;
    });
    // print('data: ${data}');
    // print('user: ${user.toMap().toString()}');
    // print('_user: ${_user?.toMap().toString()}');
    // print('name: ${_user?.name}');
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

    return signedDrawer();
  }

  Widget signedDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
              child: ListView(padding: EdgeInsets.zero, children: [
            SizedBox(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 12.0),
                child: _user != null
                    ? CircleAvatar(
                        radius: 32.0,
                        backgroundImage: NetworkImage(_user!.profilePhotoUrl!),
                      )
                    : CircleAvatar(
                        radius: 32.0,
                      ),
                color: Color(0xff88c9bf),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    showUserActions = !showUserActions;
                  });
                },
                child: SizedBox(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _user?.name ?? "Nome",
                          style: TextStyle(
                            fontFamily: "Roboto Medium",
                            fontSize: 14.0,
                            color: Color(0xff434343),
                          ),
                        ),
                        Icon(
                            showUserActions
                                ? Icons.expand_less
                                : Icons.expand_more,
                            size: 24.0)
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    color: Color(0xff88c9bf),
                  ),
                )),
            showUserActions
                ? buildTile('Meus pets', MyAnimals.id)
                : Container(),
            showUserActions
                ? buildTile('Notificações', Notifications.id)
                : Container(),
            showUserActions
                ? buildTile('Meus chats', MyChats.id)
                : Container(),
            GestureDetector(
                onTap: () {
                  setState(() {
                    showShortcutActions = !showShortcutActions;
                  });
                },
                child: SizedBox(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 24.0,
                            ),
                            SizedBox(
                              width: 32.0,
                            ),
                            Text(
                              'Atalhos',
                              style: TextStyle(
                                fontFamily: "Roboto Medium",
                                fontSize: 14.0,
                                color: Color(0xff434343),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                            showShortcutActions
                                ? Icons.expand_less
                                : Icons.expand_more,
                            size: 24.0)
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    color: Color(0xfffee29b),
                  ),
                )),
            showShortcutActions
                ? buildTile('Todos os pets', AllAnimals.id)
                : Container(),
            showShortcutActions
                ? buildTile('Cadastrar um pet', AnimalSignUpPage.id)
                : Container(),
          ])),
          SizedBox(
            height: 48.0,
            width: 304.0,
            child: TextButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => IntroductionPage()),
                    (route) => false);
              },
              child: const Text(
                'Sair',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Roboto Regular",
                  fontSize: 14.0,
                  color: Color(0xff434343),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xff88c9bf)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32.0,
            ),
          ],
        ),
        margin: EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 0.0),
        padding: EdgeInsets.zero,
      ),
      decoration: BoxDecoration(color: Color(0xff88c9bf)),
    );
  }

  Widget buildTile(String title, String routeName) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Roboto Regular",
          fontSize: 14.0,
          color: Color(0xff434343),
        ),
      ),
      tileColor: Color(0xfff7f7f7),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      contentPadding: EdgeInsets.fromLTRB(48.0, 0.0, 0.0, 4.0),
    );
  }
}
