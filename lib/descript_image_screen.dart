import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class DescriptImageScreen extends StatefulWidget {
  const DescriptImageScreen({super.key});

  @override
  _DescriptImageScreenState createState() => _DescriptImageScreenState();
}

class _DescriptImageScreenState extends State<DescriptImageScreen> {
  File? _image;
  final picker = ImagePicker();
  Uint8List? _decryptedImage;
  final _keyController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _descriptImage() async {
    if (_image == null || _keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma imagem e insira a chave!')),
      );
      return;
    }

    final bytes = _image!.readAsBytesSync();
    final base64Image = base64Encode(bytes);
    final key = _keyController.text;

    final result = await ApiService.descriptImage(base64Image, key);

    setState(() {
      _decryptedImage = base64Decode(result['file']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Imagem descriptografada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descriptografar Imagem')),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _keyController,
                decoration: const InputDecoration(
                  labelText: 'Chave de Descriptografia',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _descriptImage,
              child: const Text('Descriptografar'),
            ),
            if (_decryptedImage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Imagem Descriptografada:'),
                    Image.memory(_decryptedImage!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
