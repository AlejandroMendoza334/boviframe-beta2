import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  Widget buildDashboardButton({
    required BuildContext context,
    required String label,
    required String subtext,
    required String imagePath,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 65),
        height: 170,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtext,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/fondo6.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF009FE3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Image.asset(
                    'assets/icons/logoapp5.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildDashboardButton(
                      context: context,
                      label: 'Epmuras',
                      subtext: 'Aquí puedes Iniciar sesión en las Epmuras',
                      imagePath: 'img/boton_epmuras.jpg',
                      route: '/epmuras',
                    ),
                    buildDashboardButton(
                      context: context,
                      label: 'Consulta',
                      subtext: 'Aquí puedes consultar todo sobre las Epmuras',
                      imagePath: 'img/boton_consulta.png',
                      route: '/consulta',
                    ),
                    buildDashboardButton(
                      context: context,
                      label: 'Índice',
                      subtext: 'Consulta los índices disponibles',
                      imagePath: 'img/boton_indice.jpg',
                      route: '/index',
                    ),
                    buildDashboardButton(
                      context: context,
                      label: 'Estadísticas',
                      subtext: 'Visualiza el desempeño de las evaluaciones',
                      imagePath: 'img/boton_estadisticas.jpg',
                      route: '/stats',
                    ),
                    buildDashboardButton(
                      context: context,
                      label: 'Bases Teóricas',
                      subtext: 'Lee las bases científicas',
                      imagePath: 'img/boton_basesteoricas.jpg',
                      route: '/theory',
                    ),
                    buildDashboardButton(
                      context: context,
                      label: 'Noticias',
                      subtext: 'Últimos eventos e información',
                      imagePath: 'img/boton_noticias.jpg',
                      route: '/news_public',
                    ),
                    buildDashboardButton(
                      context: context,
                      label: 'Configuración',
                      subtext: 'Ajustes y preferencias de la aplicación',
                      imagePath: 'img/boton_publicar.png',
                      route: '/settings',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
