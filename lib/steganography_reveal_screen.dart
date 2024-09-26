import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class SteganographyRevealScreen extends StatefulWidget {
  const SteganographyRevealScreen({super.key});

  @override
  _SteganographyRevealScreenState createState() =>
      _SteganographyRevealScreenState();
}

class _SteganographyRevealScreenState extends State<SteganographyRevealScreen> {
  File? _image;
  final picker = ImagePicker();
  String? _revealedMessage;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _revealMessage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma imagem!')),
      );
      return;
    }

    final bytes = _image!.readAsBytesSync();
    final base64Image = base64Encode(bytes);

    final result = await ApiService.steganographyReveal(base64Image);

    setState(() {
      _revealedMessage = result['message'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensagem revelada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esteganografia - Revelar Mensagem')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('Nenhuma imagem selecionada.')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Selecionar Imagem'),
            ),
            ElevatedButton(
              onPressed: _revealMessage,
              child: const Text('Revelar Mensagem'),
            ),
            if (_revealedMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Mensagem Revelada: $_revealedMessage',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
