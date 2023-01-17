import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_details.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/local_user_signup.dart';
import 'package:meau/pages/splash_page.dart';

Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage((message) => _firebaseMessageBackgroundHandler(message));

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User permissions: ${settings.authorizationStatus}');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  late FirebaseFirestore _database;

  late FirebaseAuth _auth;

  late FirebaseStorage _storage;

  late StreamSubscription<User?> user;

  void initState() {
    super.initState();

    // Auth
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is signed out');
      } else {
        print('User is signed in');
      }
    });

    // Notifications
    FirebaseMessaging.instance.getToken().then((value) => {
      print("FCM Token is: $value")
    });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     setState(() {
    //       notificationTitle = message.notification!.title;
    //       notificationBody = message.notification!.body;
    //     });
    //   }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('Opened message: ${message.data}');
    //   if (message.notification != null) {
    //     setState(() {
    //       notificationTitle = message.notification!.title;
    //       notificationBody = message.notification!.body;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

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
              return SplashPage(
                  auth: _auth, database: _database, storage: _storage);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      routes: {
        IntroductionPage.id: (context) => IntroductionPage(
            auth: _auth, database: _database, storage: _storage)
      },
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
