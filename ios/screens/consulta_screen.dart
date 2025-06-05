import 'package:flutter/material.dart';
import 'consulta_animal_screen.dart';
import 'consulta_finca_screen.dart';

class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({Key? key}) : super(key: key);

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  // Este índice indica qué pestaña del BottomNavigationBar está activa.
  // Para "Buscar" dejamos currentIndex = 1 (segunda posición, ya que Home=0).
  int _currentIndex = 1;

  // Lista de rutas que correspondan con cada ítem del BottomNavigationBar:
  final List<String> _rutas = [
    '/main_menu',  // ítem 0: Home / Menú principal
    '/consulta',   // ítem 1: Buscar (esta pantalla)
    '/epmuras',    // ítem 2: EPMURAS
    '/index',      // ítem 3: Índices
    '/settings',   // ítem 4: Más / Configuración
  ];

  void _onTapNav(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);

    // Redirigir a la ruta correspondiente, reemplazando la pila actual:
    Navigator.pushReplacementNamed(context, _rutas[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONSULTA PÚBLICA'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─── Botón "Consultar Animal" ───
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConsultaAnimalScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.pets, color: Colors.white),
              label: const Text(
                'CONSULTAR ANIMAL',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─── Botón "Consultar Finca" ───
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConsultaFincaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text(
                'CONSULTAR FINCA',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),

      // ─── Bottom Navigation Bar ───
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,   // Color del ítem seleccionado
        unselectedItemColor: Colors.grey[600],
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'EPMURAS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Índices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}
