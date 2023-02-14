import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/drawer.dart';
import 'package:meau/pages/local_user_signin.dart';
import 'package:meau/pages/unauthenticated_page.dart';

class IntroductionPage extends StatefulWidget {
  static String id = 'introduction';

  IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 136, 201, 191),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 32),

          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 56,
            ),
            const Text(
              'Olá',
              style: TextStyle(
                  fontSize: 72,
                  fontFamily: 'Courgette',
                  color: Color.fromARGB(255, 255, 211, 88)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 52,
            ),
            const Text(
              'Bem vindo ao Meau!\nAqui você pode adotar, doar e ajudar\ncães e gatos com facilidade.\nQual é o seu interesse?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                color: Color.fromARGB(255, 117, 117, 117),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, UnauthenticatedPage.id);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                      MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('ADOTAR'),
            ),
            const SizedBox(
              height: 12,
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, UnauthenticatedPage.id);
            //   },
            //   style: const ButtonStyle(
            //       backgroundColor: MaterialStatePropertyAll(
            //           Color.fromARGB(255, 255, 211, 88)),
            //       foregroundColor:
            //           MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
            //       fixedSize: MaterialStatePropertyAll(Size(232, 40)),
            //       textStyle: MaterialStatePropertyAll(
            //         TextStyle(
            //           fontSize: 12,
            //           fontFamily: 'Roboto',
            //         ),
            //       )),
            //   child: const Text('AJUDAR'),
            // ),
            // const SizedBox(
            //   height: 12,
            // ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, UnauthenticatedPage.id);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                      MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('CADASTRAR ANIMAL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, UnauthenticatedPage.id);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                      MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('MEUS ANIMAIS'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, UnauthenticatedPage.id);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 255, 211, 88)),
                  foregroundColor:
                      MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
                  fixedSize: MaterialStatePropertyAll(Size(232, 40)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('ANIMAIS PARA ADOÇÃO'),
            ),
            const SizedBox(
              height: 44,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SignIn.id);
              },
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 136, 201, 191)),
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  )),
              child: const Text('login'),
            ),
            const SizedBox(
              height: 68,
            ),
            const Image(
              image: AssetImage('assets/images/Meau_marca_2.png'),
              width: 122,
              height: 44,
            )
          ],
        ),
      ),
    );
  }
}
