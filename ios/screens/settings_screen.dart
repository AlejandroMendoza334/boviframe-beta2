// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedProfession = 'Veterinario';
  final List<String> _professions = [
    'Veterinario',
    'Zootecnista',
    'Agrónomo',
    'Otro',
  ];
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(currentUser.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        final nombre = data['nombre'] ?? '';
        final colegio = data['colegio'] ?? '';
        final ubicacion = data['ubicacion'] ?? '';
        final profesion = data['profesion'] ?? 'Veterinario';
        final email = _user?.email ?? '';

        // 1) Rellenar los TextEditingController de la pantalla
        setState(() {
          _nameController.text = nombre;
          _collegeController.text = colegio;
          _locationController.text = ubicacion;
          _selectedProfession = profesion;
        });

        // 2) Además, guardamos esos tres valores en el SettingsProvider
        Provider.of<SettingsProvider>(context, listen: false).setUserData(
          name: nombre,
          email: email,
          company: ubicacion, // o lo que quieras mapear como “empresa”
        );
      }
    } catch (e) {
      print("❌ Error al cargar datos: $e");
    }
  }

  Future<void> _saveSettings() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final newName = _nameController.text.trim();
      final newColegio = _collegeController.text.trim();
      final newUbica = _locationController.text.trim();
      final newProf = _selectedProfession;
      final newEmail = _user?.email ?? '';

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(currentUser.uid)
          .set({
            'nombre': newName,
            'colegio': newColegio,
            'ubicacion': newUbica,
            'profesion': newProf,
          }, SetOptions(merge: true));

      // Actualizamos el provider con los nuevos valores:
      Provider.of<SettingsProvider>(
        context,
        listen: false,
      ).setUserData(name: newName, email: newEmail, company: newUbica);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración guardada exitosamente')),
      );
    } catch (e, stack) {
      print("❌ Error al guardar configuración: $e");
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar configuración:\n${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre y Apellido'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedProfession,
            items:
                _professions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedProfession = value);
              }
            },
            decoration: const InputDecoration(labelText: 'Profesión'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _collegeController,
            decoration: const InputDecoration(labelText: 'Número de Colegio'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Ubicación, Estado, País',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _user?.email ?? '',
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('Guardar Cambios'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Acerca de BOVIFrame'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // enlaza a tu pantalla “Acerca de”
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
