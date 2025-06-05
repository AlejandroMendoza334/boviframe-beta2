import 'package:flutter/material.dart';
import '../../widgets/custom_app_scaffold.dart';

class NewSessionScreen extends StatelessWidget {
  final String? sessionId;

  const NewSessionScreen({Key? key, required this.sessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      currentIndex: 2, // EPMURAS
      title: 'Nueva Sesión',
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          children: [
            _buildSectionButton(
              context,
              label: 'Datos Productor',
              onTap: () => Navigator.pushNamed(
                context,
                '/datos_productor',
                arguments: {'sessionId': sessionId},
              ),
              highlighted: true,
            ),
            const SizedBox(height: 16),
            _buildSectionButton(
              context,
              label: 'Evaluación',
              onTap: () => Navigator.pushNamed(
                context,
                '/animal_evaluation',
                arguments: {'sessionId': sessionId},
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionButton(
              context,
              label: 'Reporte',
              onTap: () => Navigator.pushNamed(
                context,
                '/report_screen',
                arguments: {'sessionId': sessionId},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool highlighted = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 3,
          backgroundColor: highlighted ? Colors.blue[800] : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: highlighted ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
