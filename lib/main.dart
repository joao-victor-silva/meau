import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meau/pages/all_animals_page.dart';
import 'package:meau/pages/animal_details.dart';
import 'package:meau/pages/animal_signup.dart';
import 'package:meau/pages/introduction_page.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/local_user_signup.dart';
import 'package:meau/pages/my_animals_page.dart';
import 'package:meau/pages/notifications.dart';
import 'package:meau/pages/splash_page.dart';
import 'package:meau/pages/unauthenticated_page.dart';

Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseMessageBackgroundHandler(message));

  // runApp(MyHomePage());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  late StreamSubscription<User?> user;

  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? token = "";

  Future<void> requestPermissions() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User permissions: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
        print("FCM Token: $token");
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Auth
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out');
      } else {
        print('User is signed in');
      }
    });

    // Notifications
    // FirebaseMessaging.instance
    //     .getToken()
    //     .then((value) => {print("FCM Token is: $value")});

    requestPermissions();

    setupFlutterNotifications();

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    getToken();
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser == null ? IntroductionPage.id : AllAnimals.id,
      routes: {
        IntroductionPage.id: (context) => IntroductionPage(),
        UnauthenticatedPage.id: (context) => UnauthenticatedPage(),
        SignIn.id: (context) => SignIn(),
        SignUp.id: (context) => SignUp(),
        AllAnimals.id: (context) => AllAnimals(),
        MyAnimals.id: (context) => MyAnimals(),
        Notifications.id: (context) => Notifications(),
        AnimalSignUpPage.id: (context) => AnimalSignUpPage(),
      },
      home: IntroductionPage(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Meau',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     // home: AnimalDetails(
  //     //   photoUrl: '',
  //     //   // photoUrl: "https://petepop.ig.com.br/wp-content/uploads/2021/06/reproduc%CC%A7a%CC%83o-instagram.jpg",
  //     //   name: 'Caramelo',
  //     //   temperamento: 'Bagunceira',
  //     //   needs: 'Carinho e atenção',
  //     //   size: "médio",
  //     //   gender: "fêmea",
  //     // ),
  //     home: FutureBuilder(
  //         future: _firebaseApp,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasError) {
  //             return Text('You have an error! ${snapshot.error.toString()}');
  //           } else if (snapshot.hasData) {
  //             _database = FirebaseFirestore.instance;
  //             _auth = FirebaseAuth.instance;
  //             _storage = FirebaseStorage.instance;
  //             // return LocalUserSignUpPage(
  //             //   database: _database,
  //             //   auth: _auth,
  //             // );
  //             // return LocalUserSignInPage(database: _database, auth: _auth);
  //             // return AnimalSignUpPage(database: _database, auth: _auth);
  //             return SplashPage(
  //                 auth: _auth, database: _database, storage: _storage);
  //           } else {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }
  //         }),
  //     routes: {
  //       IntroductionPage.id: (context) => IntroductionPage(
  //           auth: _auth, database: _database, storage: _storage)
  //     },
  //   );
  // }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late AndroidNotificationChannel channel;
//
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   String? token = "";
//
//   Future<void> requestPermissions() async {
//     FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     print('User permissions: ${settings.authorizationStatus}');
//   }
//
//   Future<void> setupFlutterNotifications() async {
//     channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       importance: Importance.high,
//       enableVibration: true,
//     );
//
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     /// Create an Android Notification Channel.
//     ///
//     /// We use this channel in the `AndroidManifest.xml` file to override the
//     /// default FCM channel to enable heads up notifications.
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     /// Update the iOS foreground notification presentation options to allow
//     /// heads up notifications.
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   void showFlutterNotification(RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null && !kIsWeb) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: 'launch_background',
//           ),
//         ),
//       );
//     }
//   }
//
//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) {
//       setState(() {
//         token = value;
//         print("FCM Token: $token");
//       });
//     });
//   }
//
//   void sendPushMessage(String token) async {
//     try {
//       await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization':
//                 'key=AAAAMqoYe-0:APA91bE0roCBA2WIAIVdMENoR8Rh-s3Hyh9Q_D5VJKYHzSZeE9DU-70oLa5n4mVCgxHwZCyydZMlmxr___DgyOaqDsZS1BLXnw_7CQgxfILxciKfClWwytIt8xAdULfbrWj7KCAz1mL3',
//           },
//           body: jsonEncode({
//             'notification': {
//               'title': 'Test title',
//               'body': 'Test body',
//             },
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'id': '1',
//               'status': 'done',
//             },
//             // can send to other user by setting its token here
//             'to': '$token',
//           }));
//       print('FCM request for device sent!');
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     requestPermissions();
//
//     setupFlutterNotifications();
//
//     FirebaseMessaging.onMessage.listen(showFlutterNotification);
//
//     getToken();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Sample",
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Sample"),
//         ),
//         body: Center(
//           child: GestureDetector(
//               onTap: () {
//                 sendPushMessage(token!);
//               },
//               child: Text('Sample')),
//         ),
//       ),
//     );
//   }
// }
