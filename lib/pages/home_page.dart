import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptografia'),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Criptografar imagem'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Descriptografar imagem'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Esteganografar imagem'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Revelar mensagem'),
            ),
          ],
        ),
      ),
    );
  }
}
