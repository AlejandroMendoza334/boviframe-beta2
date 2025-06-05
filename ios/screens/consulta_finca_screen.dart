import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsultaFincaScreen extends StatefulWidget {
  const ConsultaFincaScreen({Key? key}) : super(key: key);

  @override
  State<ConsultaFincaScreen> createState() => _ConsultaFincaScreenState();
}

class _ConsultaFincaScreenState extends State<ConsultaFincaScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _resultados = [];

  @override
  void initState() {
    super.initState();
    _initYcargar();
  }

  Future<void> _initYcargar() async {
    try {
      // 1) Si no hay usuario autenticado, hacemos login anónimo
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      // 2) Una vez autenticados, cargamos todos los documentos de "datos_productor"
      await _cargarTodasLasFincas();
    } catch (e) {
      setState(() {
        _error = 'Error inicializando/autenticando: $e';
        _loading = false;
      });
    }
  }

  Future<void> _cargarTodasLasFincas() async {
    setState(() {
      _loading = true;
      _error = null;
      _resultados.clear();
    });

    try {
      // Usamos collectionGroup("datos_productor") para leer todas las subcolecciones
      final snapshot = await FirebaseFirestore.instance
          .collectionGroup('datos_productor')
          .get();

      final lista = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'unidad_produccion': data['unidad_produccion'] ?? '',
          'ubicacion': data['ubicacion'] ?? '',
          'estado': data['estado'] ?? '',
          'municipio': data['municipio'] ?? '',
          // opcional: docId o parentPath si los necesitas
          'docId': doc.id,
        };
      }).toList();

      setState(() {
        _resultados = lista;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error cargando fincas: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Fincas'),
        backgroundColor: Colors.blue[800],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            if (_error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _resultados.isEmpty
                      ? const Center(child: Text('No hay datos de productor.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemCount: _resultados.length,
                          itemBuilder: (context, index) {
                            final rec = _resultados[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Unidad de Producción
                                    Row(
                                      children: [
                                        const Icon(Icons.domain, size: 20),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Unidad Producción:',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rec['unidad_produccion']?.toString() ?? '-',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Ubicación
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 20),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Ubicación:',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rec['ubicacion']?.toString() ?? '-',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Estado
                                    Row(
                                      children: [
                                        const Icon(Icons.info_outline, size: 20),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Estado:',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rec['estado']?.toString() ?? '-',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Municipio
                                    Row(
                                      children: [
                                        const Icon(Icons.map_outlined, size: 20),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Municipio:',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rec['municipio']?.toString() ?? '-',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
