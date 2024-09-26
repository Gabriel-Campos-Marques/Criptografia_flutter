import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class CriptImageScreen extends StatefulWidget {
  const CriptImageScreen({super.key});

  @override
  _CriptImageScreenState createState() => _CriptImageScreenState();
}

class _CriptImageScreenState extends State<CriptImageScreen> {
  File? _image;
  final picker = ImagePicker();
  String sKey = '';
  final TextEditingController _controller = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveImage(String base64Image) async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Escolha onde salvar a imagem criptografada',
      fileName: 'encrypted_image.png',
    );

    if (result != null) {
      final bytes = base64Decode(base64Image);
      final file = File(result);
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Imagem criptografada salva com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleção de local cancelada.')),
      );
    }
  }

  Future<void> _criptImage() async {
    if (_image == null) return;
    final bytes = _image!.readAsBytesSync();
    final base64Image = base64Encode(bytes);
    final result = await ApiService.criptImage(base64Image);
    setState(() {
      sKey = result['key'];
      _controller.text = sKey;
      _saveImage(result['file']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criptografar Imagem')),
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
              onPressed: _criptImage,
              child: const Text('Criptografar'),
            ),
            TextField(
              controller: _controller,
            )
          ],
        ),
      ),
    );
  }
}
