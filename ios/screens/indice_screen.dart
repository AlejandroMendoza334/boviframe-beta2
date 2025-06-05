// lib/screens/indice_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class IndiceScreen extends StatefulWidget {
  @override
  _IndiceScreenState createState() => _IndiceScreenState();
}

class _IndiceScreenState extends State<IndiceScreen> {
  /// Cada elemento tendrá:
  /// {
  ///   'sessionId': String,
  ///   'sessionData': Map<String, dynamic>,      // datos del documento /sesiones/{sessionId}
  ///   'productorData': Map<String, dynamic>?,   // datos de /sesiones/{sessionId}/datos_productor/info
  ///   'evaluaciones': List<Map<String, dynamic>> // array con cada documento de evaluaciones_animales
  /// }
  List<Map<String, dynamic>> sesionesConDetalle = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSesionesConDetalle();
  }

  Future<void> _loadSesionesConDetalle() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // 1) Obtener todas las sesiones
      final sesionesSnapshot = await firestore.collection('sesiones').get();

      final List<Map<String, dynamic>> temp = [];

      // 2) Para cada sesión, leemos datos_productor/info y todas las evaluaciones
      for (final sesionDoc in sesionesSnapshot.docs) {
        final sessionId = sesionDoc.id;
        final sessionData = sesionDoc.data();

        // 2.1) Leer datos del productor (si existe)
        DocumentSnapshot<Map<String, dynamic>> prodSnapshot;
        Map<String, dynamic>? productorData;
        try {
          prodSnapshot = await firestore
              .collection('sesiones')
              .doc(sessionId)
              .collection('datos_productor')
              .doc('info')
              .get();
          if (prodSnapshot.exists) {
            productorData = prodSnapshot.data();
          }
        } catch (_) {
          productorData = null;
        }

        // 2.2) Leer todas las evaluaciones de esa sesión
        final evalsSnapshot = await firestore
            .collection('sesiones')
            .doc(sessionId)
            .collection('evaluaciones_animales')
            .orderBy('timestamp', descending: true)
            .get();

        final List<Map<String, dynamic>> listaEvaluaciones = [];
        for (final evalDoc in evalsSnapshot.docs) {
          final dataEval = evalDoc.data();
          dataEval['evalId'] = evalDoc.id;          // guardo el ID de la evaluación
          listaEvaluaciones.add(dataEval);
        }

        temp.add({
          'sessionId': sessionId,
          'sessionData': sessionData,
          'productorData': productorData,           // puede quedar null si no existe
          'evaluaciones': listaEvaluaciones,        // lista (posiblemente vacía)
        });
      }

      setState(() {
        sesionesConDetalle = temp;
        _loading = false;
      });
    } catch (e) {
      // Si hay error, se lo indicamos al usuario y ponemos la lista vacía
      print('❌ Error al cargar sesiones: $e');
      setState(() {
        sesionesConDetalle = [];
        _loading = false;
      });
    }
  }

  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '-';
    final dt = ts.toDate();
    return '${dt.day.toString().padLeft(2, '0')}/'
           '${dt.month.toString().padLeft(2, '0')}/'
           '${dt.year} ${dt.hour.toString().padLeft(2, '0')}:'
           '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Índice de Sesiones y Evaluaciones'),
        backgroundColor: Colors.blue[800],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : sesionesConDetalle.isEmpty
              ? const Center(
                  child: Text('No hay sesiones registradas.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sesionesConDetalle.length,
                  itemBuilder: (context, index) {
                    final sesion = sesionesConDetalle[index];
                    final sessionId = sesion['sessionId'] as String;
                    final sessionData =
                        sesion['sessionData'] as Map<String, dynamic>;
                    final productorData =
                        sesion['productorData'] as Map<String, dynamic>?;
                    final evaluaciones =
                        sesion['evaluaciones'] as List<Map<String, dynamic>>;

                    // Para la cabecera de la sesión podemos mostrar, por ejemplo:
                    // - sessionData['userId'] o cualquier campo que uses
                    // - productorData['unidad_produccion'], productorData['estado'], etc.
                    // - Fecha de creación (sessionData['timestamp'])
                    final fechaSesion = sessionData['timestamp'] is Timestamp
                        ? _formatTimestamp(sessionData['timestamp'])
                        : '-';

                    String fincaNombre = '-';
                    if (productorData != null &&
                        productorData['unidad_produccion'] != null &&
                        (productorData['unidad_produccion'] as String).trim().isNotEmpty) {
                      fincaNombre = productorData['unidad_produccion'];
                    }

                    String fincaUbicacion = '-';
                    if (productorData != null &&
                        productorData['ubicacion'] != null &&
                        (productorData['ubicacion'] as String).trim().isNotEmpty) {
                      fincaUbicacion = productorData['ubicacion'];
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      child: ExpansionTile(
                        // ICONO Y TÍTULO DE LA SESIÓN
                        leading: const Icon(Icons.home_repair_service,
                            color: Colors.blue),
                        title: Text(
                          fincaNombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Ubicación: $fincaUbicacion\n'
                            'Fecha: $fechaSesion'),
                        childrenPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          // ▸ Mostrar datos del productor
                          const SizedBox(height: 8),
                          if (productorData != null) ...[
                            const Text(
                              '─── Datos del Productor ───',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            _buildDatoFila('Unidad producción',
                                productorData['unidad_produccion'] ?? '-'),
                            _buildDatoFila(
                                'Ubicación', productorData['ubicacion'] ?? '-'),
                            _buildDatoFila('Estado', productorData['estado'] ?? '-'),
                            _buildDatoFila(
                                'Municipio', productorData['municipio'] ?? '-'),
                            const SizedBox(height: 12),
                          ] else ...[
                            const Text(
                              '─ No se encontraron datos del productor ─',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // ▸ Mostrar listado de evaluaciones
                          Text(
                            '─── Evaluaciones (${evaluaciones.length}) ───',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          if (evaluaciones.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'No hay evaluaciones para esta sesión.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: evaluaciones.length,
                              separatorBuilder: (context, i) =>
                                  const Divider(height: 20),
                              itemBuilder: (context, i) {
                                final ev = evaluaciones[i];
                                final numero = ev['numero'] ?? '-';
                                final registro = ev['registro'] ?? '-';
                                final pesoNac = ev['peso_nac'] ?? '-';
                                final fechaEval = ev['timestamp'] is Timestamp
                                    ? _formatTimestamp(ev['timestamp'])
                                    : '-';

                                // Mini-thumbnail de la foto (si existe)
                                Widget iconFoto = const SizedBox(width: 48);
                                if (ev['image_base64'] != null) {
                                  try {
                                    final bytes =
                                        base64Decode(ev['image_base64']);
                                    iconFoto = ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.memory(
                                        bytes,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } catch (_) {
                                    iconFoto = const SizedBox(width: 48);
                                  }
                                }

                                // Mostrar valores sumarios de EPMURAS (por ejemplo):
                                String epmSumario = '';
                                if (ev['epmuras'] is Map<String, dynamic>) {
                                  final epm = ev['epmuras'] as Map<String, dynamic>;
                                  // Solo mostramos algo como "E:3 P:4 M:2 ..."
                                  epmSumario = epm.entries
                                      .map((e) => '${e.key}:${e.value}')
                                      .join('  ');
                                }

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: iconFoto,
                                  title: Text(
                                    'N° $numero  ·  RGN $registro',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text('Peso Nac.: $pesoNac    Fecha: $fechaEval'),
                                      const SizedBox(height: 2),
                                      Text(
                                        'EPMURAS: $epmSumario',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Si quieres navegar a editar esa evaluación:
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   '/editar_evaluacion',
                                    //   arguments: {
                                    //     'sessionId': sessionId,
                                    //     'evalId': ev['evalId'],
                                    //     'initialData': ev
                                    //   },
                                    // );
                                  },
                                );
                              },
                            ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildDatoFila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$etiqueta: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}
