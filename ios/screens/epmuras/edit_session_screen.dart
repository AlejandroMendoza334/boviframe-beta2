import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_app_scaffold.dart';

class EditSessionScreen extends StatefulWidget {
  final String sessionId;

  const EditSessionScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  State<EditSessionScreen> createState() => _EditSessionScreenState();
}

class _EditSessionScreenState extends State<EditSessionScreen> {
  Map<String, dynamic>? _sessionData;
  List<QueryDocumentSnapshot>? _evaluaciones;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
  try {
    // 1) Obtener datos de la sesión
    final sessionSnap = await FirebaseFirestore.instance
        .collection('sesiones')
        .doc(widget.sessionId)
        .get();
    
    // 2) Obtener las evaluaciones que están DENTRO de esta sesión (subcolección)
    final evalsSnap = await FirebaseFirestore.instance
        .collection('sesiones')
        .doc(widget.sessionId)
        .collection('evaluaciones_animales')
        .get();

    if (!mounted) return;
    setState(() {
      _sessionData = sessionSnap.data();
      _evaluaciones = evalsSnap.docs;
      _loading = false;
    });
  } catch (e) {
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar: $e')),
    );
  }
}


  Future<void> _eliminarSesion() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('¿Eliminar sesión?'),
        content: Text('Esto eliminará la sesión y todas sus evaluaciones.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      for (var eval in _evaluaciones ?? []) {
        await eval.reference.delete();
      }
      await FirebaseFirestore.instance.collection('sesiones').doc(widget.sessionId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Sesión eliminada')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al eliminar: $e')),
      );
    }
  }

  Future<void> _cambiarEstadoSesion() async {
    final nuevoEstado = _sessionData?['estado'] == 'cerrada' ? 'activa' : 'cerrada';
    await FirebaseFirestore.instance
        .collection('sesiones')
        .doc(widget.sessionId)
        .update({'estado': nuevoEstado});

    setState(() {
      _sessionData?['estado'] = nuevoEstado;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nuevoEstado == 'cerrada'
            ? '✅ Sesión cerrada correctamente.'
            : '✅ Sesión reabierta.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      currentIndex: 2,
      title: 'Editar Sesión',
      showBackButton: true,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _sessionData == null
              ? Center(child: Text('No se encontró la sesión'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unidad de Producción:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _sessionData?['productor']?['unidad_produccion'] ?? '-',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Evaluaciones (${_evaluaciones?.length ?? 0}):',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _evaluaciones?.length ?? 0,
                          itemBuilder: (context, index) {
                            final data = _evaluaciones![index].data() as Map<String, dynamic>;
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(Icons.pets, color: Colors.blue[700]),
                                title: Text(data['numero'] ?? 'Sin número'),
                                subtitle: Text('Registro: ${data['registro'] ?? 'N/A'}'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _cambiarEstadoSesion,
                        icon: Icon(
                          _sessionData?['estado'] == 'cerrada' ? Icons.lock_open : Icons.lock,
                        ),
                        label: Text(
                          _sessionData?['estado'] == 'cerrada'
                              ? 'Reabrir sesión'
                              : 'Cerrar sesión',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _eliminarSesion,
                        icon: Icon(Icons.delete),
                        label: Text('Eliminar Sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
