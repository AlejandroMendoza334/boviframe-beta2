// lib/screens/new_admin_create_screen.dart

import 'dart:io';
import 'package:flutter/foundation.dart'; // para kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class NewsAdminCreateScreen extends StatefulWidget {
  const NewsAdminCreateScreen({Key? key}) : super(key: key);

  @override
  State<NewsAdminCreateScreen> createState() => _NewsAdminCreateScreenState();
}

class _NewsAdminCreateScreenState extends State<NewsAdminCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController   = TextEditingController(); // <— control para la URL
  String _plainContent = '';
  File? _pickedImage;
  bool _isSaving = false;

  // Categorías disponibles:
  final List<String> _categories = ['General', 'Evento', 'Anuncio', 'Otro'];
  String _selectedCategory = 'General';

  Future<void> _pickImage() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccionar imagen no está disponible en Web')),
      );
      return;
    }
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    final titleText = _titleController.text.trim();
    final externalUrl = _urlController.text.trim();
    // Si ni título ni contenido ni URL se han facilitado, no se guarda nada:
    if (titleText.isEmpty && externalUrl.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    String? imageUrl;
    if (_pickedImage != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('news_images/$fileName');
      await storageRef.putFile(_pickedImage!);
      imageUrl = await storageRef.getDownloadURL();
    }

    // Armo el mapa a guardar en Firestore:
    final Map<String, dynamic> docData = {
      'title': titleText.isNotEmpty ? titleText : null,
      'content': _plainContent.trim().isNotEmpty ? _plainContent.trim() : null,
      'imageUrl': imageUrl,
      'authorId': user.uid,
      'category': _selectedCategory,
      'timestamp': FieldValue.serverTimestamp(),
      // Guardar la URL externa *solo si* no está vacía:
      if (externalUrl.isNotEmpty) 'url': externalUrl,
    };

    await FirebaseFirestore.instance.collection('news').add(docData);

    setState(() => _isSaving = false);

    // Regreso a la lista pública de noticias:
    Navigator.of(context).pushReplacementNamed('/news_public');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Noticia (Admin)'),
        backgroundColor: Colors.blue.shade400,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo de Título
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: 16),

                // NUEVO: Campo de URL externa
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Importar desde URL (opcional)',
                    hintText: 'https://www.ejemplo.com/articulo.html',
                  ),
                ),
                const SizedBox(height: 16),

                // Drop-down de Categoría
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Botón para seleccionar imagen
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Seleccionar imagen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade200,
                  ),
                  onPressed: _isSaving ? null : _pickImage,
                ),
                const SizedBox(height: 16),

                // Vista previa de la imagen (si hay)
                if (_pickedImage != null)
                  if (kIsWeb)
                    Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text(
                        'Vista previa no disponible en Web',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Image.file(
                      _pickedImage!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                if (_pickedImage != null) const SizedBox(height: 16),

                // Campo de contenido de la noticia (solo si no se va por URL externa)
                TextField(
                  maxLines: 8,
                  enabled: _urlController.text.trim().isEmpty,
                  decoration: InputDecoration(
                    labelText: _urlController.text.trim().isEmpty
                        ? 'Contenido de la noticia'
                        : 'Contenido deshabilitado (se importará desde URL)',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _plainContent = val;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Botón “Guardar Noticia”
                Center(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade200,
                    ),
                    child: const Text('Guardar Noticia'),
                  ),
                ),
              ],
            ),
          ),

          // Loader superpuesto mientras se está guardando
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
