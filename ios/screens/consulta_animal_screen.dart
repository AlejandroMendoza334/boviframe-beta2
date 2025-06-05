// lib/screens/consulta_animal_screen.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaAnimalScreen extends StatefulWidget {
  const ConsultaAnimalScreen({Key? key}) : super(key: key);

  @override
  State<ConsultaAnimalScreen> createState() => _ConsultaAnimalScreenState();
}

class _ConsultaAnimalScreenState extends State<ConsultaAnimalScreen> {
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _rgnController   = TextEditingController();

  bool _loading       = true;
  String? _errorMsg;
  List<Map<String, dynamic>> _resultados = [];

  @override
  void initState() {
    super.initState();
    // 1) Al entrar a la pantalla, inmediatamente cargamos todas las evaluaciones:
    _cargarTodasLasEvaluaciones();
  }

  @override
  void dispose() {
    _serieController.dispose();
    _rgnController.dispose();
    super.dispose();
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// Carga _todas_ las evaluaciones de animales sin filtrar,
  /// ordenadas por timestamp descendente.
  Future<void> _cargarTodasLasEvaluaciones() async {
    setState(() {
      _loading  = true;
      _errorMsg = null;
      _resultados.clear();
    });

    try {
      // Usamos collectionGroup para traer todos los doc de "evaluaciones_animales"
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('evaluaciones_animales')
          .orderBy('timestamp', descending: true)
          .get();

      final lista = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Agregamos el campo "id" para poder navegar si queremos editar o ver detalle
        data['evalId'] = doc.id;
        return data;
      }).toList();

      setState(() {
        _resultados = lista;
        _loading     = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMsg = 'Error cargando evaluaciones: ${e.message}';
        _loading  = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Error inesperado: $e';
        _loading  = false;
      });
    }
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// Filtra por RGN y/o Serie cuando el usuario pulsa "Buscar".
  /// Si ambos campos están vacíos, vuelve a cargar todo (misma lógica de init).
  Future<void> _buscarAnimales() async {
    final rgnFilter   = _rgnController.text.trim();
    final serieFilter = _serieController.text.trim().toLowerCase();

    // Si ambos filtros están vacíos, recargamos todo:
    if (rgnFilter.isEmpty && serieFilter.isEmpty) {
      _cargarTodasLasEvaluaciones();
      return;
    }

    setState(() {
      _loading  = true;
      _errorMsg = null;
      _resultados.clear();
    });

    try {
      Query query = FirebaseFirestore.instance
          .collectionGroup('evaluaciones_animales');

      // 1) Si hay RGN, aplico el filtro de igualdad
      if (rgnFilter.isNotEmpty) {
        query = query.where('registro', isEqualTo: rgnFilter);
      }

      // 2) Si hay Serie, aplico filtro de rango para “contenga” (útil si buscas subcadenas)
      if (serieFilter.isNotEmpty) {
        // Para hacer un “contains” en Firestore hay que usar rango con '\uf8ff'
        query = query
            .where('numero', isGreaterThanOrEqualTo: serieFilter)
            .where('numero', isLessThanOrEqualTo: '$serieFilter\uf8ff');
      }

      // 3) Finalmente ordeno por timestamp descendente
      query = query.orderBy('timestamp', descending: true);

      final snapshot = await query.get();

      final lista = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['evalId'] = doc.id;
        return data;
      }).toList();

      setState(() {
        _resultados = lista;
        _loading     = false;
      });
    }
    // Si falta índice, Firestore lanzará un FirebaseException con un enlace a crear índice
    on FirebaseException catch (e) {
      setState(() {
        _errorMsg = 'Error al buscar: ${e.message}';
        _loading  = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Error inesperado: $e';
        _loading  = false;
      });
    }
  }

  /// ─────────────────────────────────────────────────────────────────────────
  /// Muestra un modal “Filtros” (ahora mismo solo cierra el modal, pero aquí
  /// podrías agregar dropdowns de Sexo, Estado, etc. en el futuro).
  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtros adicionales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '— Por ahora no hay filtros extra configurados —',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.done),
                label: const Text('Cerrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Animal'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Filtro por Serie / RGN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo “SERIE”
                TextField(
                  controller: _serieController,
                  decoration: const InputDecoration(
                    labelText: 'SERIE',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Campo “RGN”
                TextField(
                  controller: _rgnController,
                  decoration: const InputDecoration(
                    labelText: 'RGN (Registro Animal)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Botón “FILTROS”
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _mostrarFiltros,
                        icon: const Icon(Icons.menu),
                        label: const Text('FILTROS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Botón “BUSCAR”
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _buscarAnimales,
                        icon: const Icon(Icons.search),
                        label: const Text('BUSCAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Mensaje de error (si existe) ───
          if (_errorMsg != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _errorMsg!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // ─── Resultado o indicador de carga ───
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (_resultados.isEmpty
                    ? const Center(child: Text('No se encontraron animales'))
                    : ListView.builder(
                        itemCount: _resultados.length,
                        itemBuilder: (context, index) {
                          final data = _resultados[index];

                          // Decodificar la imagen si existe:
                          Uint8List? imageBytes;
                          final imageBase64 = data['image_base64'] as String?;
                          if (imageBase64 != null && imageBase64.isNotEmpty) {
                            try {
                              imageBytes = base64Decode(imageBase64);
                            } catch (_) {
                              imageBytes = null;
                            }
                          }

                          // “Puntuación general” = promedio de todos los valores EPMURAS
                          double puntuacion = 0;
                          {
                            final epm = data['epmuras'] as Map<String, dynamic>? ?? {};
                            if (epm.isNotEmpty) {
                              double suma = 0;
                              int conteo = 0;
                              epm.forEach((k, v) {
                                final val = double.tryParse(v?.toString() ?? '') ?? 0.0;
                                suma += val;
                                conteo++;
                              });
                              if (conteo > 0) puntuacion = suma / conteo;
                            }
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        imageBytes,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.image_not_supported),
                              title: Text('N° ${data['numero'] ?? '-'}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('RGN: ${data['registro'] ?? '-'}'),
                                  Text('Sesión: ${data['session_id'] ?? '-'}'),
                                  Text('Puntuación: ${puntuacion.toStringAsFixed(2)}'),
                                ],
                              ),
                              onTap: () {
                                // Si el usuario pulsa en un animal, abrimos la pantalla de detalle:
                                Navigator.pushNamed(
                                  context,
                                  '/animal_detail',
                                  arguments: data,
                                );
                              },
                            ),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }
}
