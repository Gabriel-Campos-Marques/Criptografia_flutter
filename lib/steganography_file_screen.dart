import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class SteganographyFileScreen extends StatefulWidget {
  const SteganographyFileScreen({super.key});

  @override
  _SteganographyFileScreenState createState() =>
      _SteganographyFileScreenState();
}

class _SteganographyFileScreenState extends State<SteganographyFileScreen> {
  File? _image;
  final picker = ImagePicker();
  final _messageController = TextEditingController();
  Uint8List? _steganographyImage;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _steganographyFile() async {
    if (_image == null || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selecione uma imagem e insira a mensagem!')),
      );
      return;
    }

    final bytes = _image!.readAsBytesSync();
    final base64Image = base64Encode(bytes);
    final message = _messageController.text;

    final result = await ApiService.steganographyFile(base64Image, message);

    _steganographyImage = base64Decode(result['file']);

    // Prompt user to choose a directory to save the file
    await _chooseDirectoryAndSaveFile(_steganographyImage!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Imagem processada e salva com sucesso!')),
    );
  }

  Future<void> _chooseDirectoryAndSaveFile(Uint8List fileData) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Escolha o local para salvar a imagem',
      fileName: 'steganography_image.png',
    );

    if (outputFile != null) {
      final file = File(outputFile);
      await file.writeAsBytes(fileData);
      print('File saved at $outputFile');
    } else {
      print('Save operation was canceled.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esteganografia - Esconder Mensagem')),
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
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Mensagem para Esconder',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _steganographyFile,
              child: const Text('Processar Esteganografia'),
            ),
            if (_steganographyImage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Imagem com Esteganografia:'),
                    Image.memory(_steganographyImage!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
