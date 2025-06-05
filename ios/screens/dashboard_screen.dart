import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> evaluaciones = [];
  int totalAnimales = 0;
  int totalSesiones = 0;
  Map<String, double> promedios = {};
  List<Map<String, dynamic>> topAnimales = [];
  List<Map<String, dynamic>> bottomAnimales = [];

  @override
  void initState() {
    super.initState();
    cargarEvaluaciones();
  }

  Future<void> cargarEvaluaciones() async {
  try {
    // 1) Obtener todos los documentos de “sesiones”
    final sesionesSnapshot = await FirebaseFirestore.instance
        .collection('sesiones')
        .get();

    // 2) Para cada doc en “sesiones”, leer su subcolección “evaluaciones_animales”
    final List<Map<String, dynamic>> todosLosDatos = [];

    for (final sesDoc in sesionesSnapshot.docs) {
      // path: /sesiones/{sesDoc.id}/evaluaciones_animales
      final evalSubSnapshot = await FirebaseFirestore.instance
          .collection('sesiones')
          .doc(sesDoc.id)
          .collection('evaluaciones_animales')
          .get();

      // Extraemos los mapas de datos y los agregamos a nuestra lista
      final datosDeEstaSes = evalSubSnapshot.docs
          .map((e) => e.data() as Map<String, dynamic>)
          .toList();

      todosLosDatos.addAll(datosDeEstaSes);
    }

    // Ahora `todosLosDatos` es la lista combinada de todas las subcolecciones
    // … el resto del cálculo (promedios, índices, etc.) lo haces sobre todosLosDatos

    final sesionesCount = sesionesSnapshot.docs.length;
    final datos = todosLosDatos; // renombramos para reutilizar tu lógica
    final letras = ['E', 'P', 'M', 'U', 'R', 'A', 'S'];
    final nuevosPromedios = {for (var letra in letras) letra: 0.0};
    for (var letra in letras) {
      nuevosPromedios[letra] = datos
              .map((e) {
                final valor = e['epmuras']?[letra];
                return valor is int
                    ? valor
                    : int.tryParse(valor?.toString() ?? '0') ?? 0;
              })
              .fold(0.0, (a, b) => a + b) /
          (datos.isEmpty ? 1 : datos.length);
    }

    final evaluacionesConIndice = datos.map((animal) {
      final e = animal['epmuras']?['E'];
      final p = animal['epmuras']?['P'];
      final m = animal['epmuras']?['M'];

      final ev = e is int ? e : int.tryParse(e?.toString() ?? '0') ?? 0;
      final pv = p is int ? p : int.tryParse(p?.toString() ?? '0') ?? 0;
      final mv = m is int ? m : int.tryParse(m?.toString() ?? '0') ?? 0;
      final indice = ev + pv + mv;

      return {
        ...animal,
        'indice': indice,
        'nombre': animal['numero'] ?? '-',
      };
    }).toList()
      ..sort((a, b) => b['indice'].compareTo(a['indice']));

    if (!mounted) return;
    setState(() {
      evaluaciones = evaluacionesConIndice;
      totalAnimales = datos.length;
      totalSesiones = sesionesCount;
      promedios = nuevosPromedios;
      topAnimales = evaluacionesConIndice.take(3).toList();
      bottomAnimales = evaluacionesConIndice.reversed.take(3).toList();
    });
  } catch (e) {
    if (!mounted) return;
    setState(() {
      evaluaciones = [];
    });
    debugPrint('❌ Error al cargar evaluaciones: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header corregido para evitar overflow
            Container(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
              width: double.infinity,
              color: Colors.blue[800],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Dashboard General',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Resumen de evaluaciones realizadas',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Cuerpo principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: evaluaciones.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCard(
                              title: 'Animales Evaluados',
                              value: '$totalAnimales',
                              icon: Icons.pets,
                              color: Colors.indigo,
                            ),
                            _buildCard(
                              title: 'Total de Sesiones',
                              value: '$totalSesiones',
                              icon: Icons.event_note,
                              color: Colors.teal,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Promedios EPMURAS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                                height: 200,
                                child: promedios.isEmpty
                                    ? const Center(
                                        child:
                                            Text('No hay datos de promedios'))
                                    : _buildBarChart()),
                            const SizedBox(height: 20),
                            const Text(
                              'Top 3 Mejores Animales',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ...topAnimales.map(_buildAnimalCard),
                            const SizedBox(height: 20),
                            const Text(
                              'Top 3 Peores Animales',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ...bottomAnimales.map(_buildAnimalCard),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildAnimalCard(Map<String, dynamic> a) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(a['nombre'] ?? '-',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Índice: ${a['indice']?.toStringAsFixed(1) ?? '0.0'}'),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: promedios.entries.map((entry) {
          return BarChartGroupData(
            x: entry.key.codeUnitAt(0),
            barRods: [
              BarChartRodData(
                toY: entry.value,
                width: 18,
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(String.fromCharCode(value.toInt())),
              ),
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }
}
