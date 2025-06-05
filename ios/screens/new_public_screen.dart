// lib/screens/new_admin_create_screen.dart

import 'dart:io';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Reemplaza esto con el UID real de tu administrador:
  static const String _authorizedUID = 'bnUwRqbqNPQLOyPZD6wZialhyE82';

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _selectedDate = DateTime.now();
  File? _pickedImage;
  String? _imageUrl;
  String _plainContent = '';
  final List<String> _categories = ['General', 'Evento', 'Anuncio', 'Otro'];
  String? _selectedCategory;

  // Muestra un selector de fecha
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Permite al admin seleccionar imagen de la galería
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        _pickedImage = File(img.path);
      });
    }
  }

  // Sube la imagen a Firebase Storage y devuelve la URL
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = 'news_images/${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = _storage.ref().child(fileName);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error subiendo imagen: $e');
      return null;
    }
  }

  // Se ejecuta al pulsar "Guardar Noticia"
  Future<void> _submitForm() async {
    // 1) Validar formulario
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // 2) Verificar que el usuario sea el admin
    final user = _auth.currentUser;
    if (user == null || user.uid != _authorizedUID) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tienes permiso para crear noticias.')),
      );
      return;
    }

    // 3) Mostrar spinner mientras sube la imagen y guarda en Firestore
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 4) Si hay imagen seleccionada, subirla primero
      if (_pickedImage != null) {
        _imageUrl = await _uploadImage(_pickedImage!);
      }

      // 5) Crear el documento en la colección "news"
      await _firestore.collection('news').add({
        'title': _title,
        'content': _plainContent,
        'date': _selectedDate,
        'authorUID': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrl': _imageUrl,
        'category': _selectedCategory ?? 'General',
      });

      // 6) Cerrar el spinner
      Navigator.of(context).pop();

      // 7) Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Noticia creada correctamente')),
      );

      // 8) Regresar a la pantalla anterior (lista de noticias)
      Navigator.of(context).pop();
    } catch (e) {
      // En caso de error, cerrar spinner y mostrar mensaje
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear noticia: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Noticia'),
        backgroundColor: Colors.blue.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Título
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingresa un título' : null,
                onSaved: (v) => _title = v!,
              ),
              const SizedBox(height: 16),

              // Dropdown Categoría
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                value: _selectedCategory,
                onChanged: (v) => setState(() {
                  _selectedCategory = v;
                }),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Selecciona categoría' : null,
              ),
              const SizedBox(height: 16),

              // Vista previa de la imagen (si ya seleccionaste alguna)
              const Text('Imagen destacada', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
              TextButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Seleccionar Imagen'),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 16),

              // Selector de Fecha
              Row(
                children: [
                  Text(
                    'Fecha: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo Contenido (texto plano)
              const Text('Contenido', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Escribe aquí el contenido',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingresa el contenido' : null,
                onSaved: (v) => _plainContent = v!,
              ),
              const SizedBox(height: 24),

              // Botón "Guardar Noticia"
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Guardar Noticia'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
