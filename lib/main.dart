import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meau',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
      // home: FutureBuilder(
      //   future: _firebaseApp,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       print('You have an error! ${snapshot.error.toString()}');
      //       return const Text('Something went wrong!');
      //     } else if (snapshot.hasData) {
      //       return const MyHomePage(title: 'Flutter Demo Home Page');
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // )
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
