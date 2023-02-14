import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:meau/model/user.dart';
import 'package:meau/pages/chat.dart';
import 'package:meau/pages/drawer.dart';
import 'package:meau/pages/notification_card.dart';

class MyChats extends StatefulWidget {
  static String id = 'chats';

  MyChats({super.key});

  @override
  State<MyChats> createState() => MyChatsState();
}

class MyChatsState extends State<MyChats> {
  List<Widget>? chats = List.empty();
  List<User> owners = List.empty();

  Future<void> getChats() async {
    _database
        .collection("chats")
        .where("participants", arrayContains: _auth.currentUser!.uid)
        .get()
        .then((value) {
      print('chats ${value.docs}');

      var chatTiles = <Widget>[];
      value.docs.forEach((element) {
        var participants = (element.data()["participants"] as List)
            .map((e) => e as String)
            .toList();
        var destId = participants[0] != _auth.currentUser!.uid
            ? participants[0]
            : participants[1];
        var dest = owners.where((owner) => owner.id == destId).first;

        chatTiles.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(otherParticipant: destId)));
          },
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  dest.profilePhotoUrl != null
                      ? CircleAvatar(
                          radius: 32.0,
                          backgroundImage: NetworkImage(dest.profilePhotoUrl!),
                        )
                      : CircleAvatar(
                          radius: 32.0,
                        ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '${dest.name}',
                    ),
                  )
                ]),
              ],
            ),
          ),
        ));
      });

      setState(() {
        chats = chatTiles;
      });
    });
  }

  Future<void> getOwners() async {
    _database.collection("users").get().then((value) {
      var data = value.docs.map((e) => User.fromMap(e.data())).toList();
      setState(() {
        owners = data;
        print('getOwners: $owners');
      });

      // TODO: in case of problems uncomment the line below
      // getChats();
    });
  }

  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _database;

  void initAuth() {
    var auth = firebase_auth.FirebaseAuth.instance;
    setState(() {
      _auth = auth;
    });
    print('Auth initialized');
  }

  void initDatabase() async {
    var db = FirebaseFirestore.instance;
    setState(() {
      _database = db;
    });
    await getOwners();
    await getChats();
    print('Database initialized');
  }

  void initState() {
    super.initState();
    initAuth();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Meus chats'),
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
      body: Center(
          child: Expanded(
        child: SingleChildScrollView(
            child: Column(
          children: chats ?? [],
          mainAxisAlignment: MainAxisAlignment.start,
        )),
      )),
    );
  }
}
