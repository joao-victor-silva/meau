import 'package:flutter/material.dart';
import 'package:meau/pages/introduction_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToIntroduction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 136, 201, 191),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Meau_malha.png"),
            fit: BoxFit.cover,
            opacity: 0.45,
          )
        ),
        child: const Center(
          child: Image(
            image: AssetImage("assets/images/Meau_marca.png"),
            width: 276,
            height: 100,
          ),
        ),
      ),
      // body: Center(
      //   child: Text('Splash screen'),
      // ),
    );
  }

  void _navigateToIntroduction() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const IntroductionPage()));
    });
  }
}
