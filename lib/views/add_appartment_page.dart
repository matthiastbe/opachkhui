import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/auth_service.dart';

class AddApartmentPage extends StatefulWidget {
  final String token;

  AddApartmentPage({required this.token});

  @override
  _AddApartmentPageState createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends State<AddApartmentPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _addApartment() async {
    if (_image == null) {
      print('No image selected.');
      return;
    }

    AuthService wpService = AuthService(baseUrl: 'http://10.0.2.2/opachki');

    final imageId = await wpService.uploadImage(widget.token, _image!);

    if (imageId != null) {
      final postId = await wpService.createPostWithImage(
        widget.token,
        _titleController.text,
        _contentController.text,
        imageId,
      );

      if (postId != null) {
        print('Post created successfully with ID: $postId');
        // Reset form
        _titleController.clear();
        _contentController.clear();
        setState(() {
          _image = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Appartement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            _image == null
                ? Text('Aucune image sélectionnée.')
                : Image.file(_image!),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Choisir une image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addApartment,
              child: Text('Ajouter l\'appartement'),
            ),
          ],
        ),
      ),
    );
  }
}
