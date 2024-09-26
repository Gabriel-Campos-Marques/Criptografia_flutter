import 'package:flutter/material.dart';

import 'cript_image_screen.dart';
import 'descript_image_screen.dart';
import 'steganography_file_screen.dart';
import 'steganography_reveal_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Frontend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Frontend')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CriptImageScreen()),
                );
              },
              child: const Text('Criptografar Imagem'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DescriptImageScreen()),
                );
              },
              child: const Text('Descriptografar Imagem'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SteganographyFileScreen()),
                );
              },
              child: const Text('Esteganografia - Esconder Mensagem'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SteganographyRevealScreen()),
                );
              },
              child: const Text('Esteganografia - Revelar Mensagem'),
            ),
          ],
        ),
      ),
    );
  }
}
