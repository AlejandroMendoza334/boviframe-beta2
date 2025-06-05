import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AnimalDetailScreen extends StatelessWidget {
  const AnimalDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Uint8List? image;
    final imageBase64 = data['image_base64'];
    if (imageBase64 != null && imageBase64 is String && imageBase64.isNotEmpty) {
      try {
        image = base64Decode(imageBase64);
      } catch (e) {
        print('Error al decodificar imagen: $e');
      }
    }

    final epmuras = (data['epmuras'] as Map<String, dynamic>?) ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Animal'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (image != null)
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      image,
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                ),
              const SizedBox(height: 24),
              _buildSectionCard('Datos Generales', [
                _infoRow('Número', data['numero']),
                _infoRow('Registro', data['registro']),
                _infoRow('Sexo', data['sexo']),
                _infoRow('Estado', data['estado']),
                _infoRow('Peso Nac.', data['peso_nac']),
                _infoRow('Peso Dest.', data['peso_dest']),
                _infoRow('Peso Ajust.', data['peso_ajus']),
              ]),
              const SizedBox(height: 20),
              _buildSectionCard('Evaluación EPMURAS',
                epmuras.entries
                  .map((e) => _infoRow(e.key.toUpperCase(), e.value))
                  .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(value?.toString() ?? 'No disponible'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(height: 24, thickness: 1),
            ...content,
          ],
        ),
      ),
    );
  }
}
