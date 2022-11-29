import 'package:flutter/material.dart';

class LocalUserSignUpPage extends StatefulWidget {
  const LocalUserSignUpPage({super.key});

  @override
  State<LocalUserSignUpPage> createState() => LocalUserSignUpPageState();
}

class LocalUserSignUpPageState extends State<LocalUserSignUpPage> {
  final formController = TextEditingController();

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro Pessoal"),
      ),
      body: Center(
        child: Text("Here"),
      ),
    );
  }
}