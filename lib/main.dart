import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/evaluacion_model.dart';
import 'services/database_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/main_menu.dart';
import 'screens/settings_screen.dart';
import 'screens/epmuras/datos_productor.dart';
import 'screens/epmuras/epmuras_screen.dart';
import 'screens/epmuras/new_session_screen.dart';
import 'screens/epmuras/session_details_screen.dart';
import 'screens/epmuras/session_summary_screen.dart';
import 'screens/providers/auth_provider.dart';
import 'screens/providers/session_provider.dart';
import 'screens/providers/theme_provider.dart';
import 'screens/consulta_animal_screen.dart';
import 'screens/consulta_screen.dart';
import 'screens/consulta_finca_screen.dart';
import 'screens/editar_finca_screen.dart';
import 'package:boviframe/screens/epmuras/animal_evaluation_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'screens/epmuras/edit_session_screen.dart';
import 'screens/epmuras/report_screen_certificado.dart';
import 'screens/dashboard_screen.dart';
import 'screens/indice_screen.dart';
import 'screens/epmuras/edit_session_selector.dart';
import 'screens/animal_detail_screen.dart';
import './screens/providers/user_provider.dart';
import './screens/providers/settings_provider.dart';
import 'screens/new_public_screen.dart';
import 'screens/new_detail_screen.dart';
import 'screens/new_admin_create_screen.dart';
import 'screens/new_admin_screen.dart';
import 'screens/new_edit_screen.dart';
import 'screens/bases_teoricas.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase app initialized: ${Firebase.app().name}'); // Debug

  await Hive.initFlutter();
  Hive.registerAdapter(EvaluacionAnimalAdapter());

  tz.initializeTimeZones();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'BOVIFrame',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          routes: {
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/forgot_password': (context) => ForgotPasswordScreen(),
            '/main': (context) => MainMenu(),
            '/news_public': (context) => NewsPublicScreen(),
            '/news_create': (context) => const NewsAdminCreateScreen(),
            '/news_admin': (context) => const NewsAdminScreen(),
            '/main_menu': (context) => MainMenu(),
            '/epmuras': (context) => EpmurasScreen(),
            '/settings': (context) => SettingsScreen(),
            '/session_details': (context) => SessionDetailsScreen(),
            '/consulta': (context) => ConsultaScreen(),
            '/index': (context) => IndiceScreen(),
            '/stats': (context) => DashboardScreen(),
            '/animal_detail': (context) => const AnimalDetailScreen(),
            '/consulta_animal': (context) => ConsultaAnimalScreen(),
            '/consulta_finca': (context) => ConsultaFincaScreen(),
            '/animal_evaluation': (context) => const AnimalEvaluationScreen(),
            '/theory': (context) => const EpmurasInfographicWidget(),
            '/dashboard': (context) => DashboardScreen(),
            '/editar_finca': (context) => EditarFincaScreen(),
            '/edit_session_selector': (context) => EditSessionSelectorScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/new_session') {
              // Si vas a enviar {'sessionId': null}, asegúrate de que NewSessionScreen acepte sessionId nullable:
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder:
                    (_) => NewSessionScreen(
                      sessionId:
                          args != null ? args['sessionId'] as String? : null,
                    ),
              );
            }

            if (settings.name == '/datos_productor') {
              final args = settings.arguments as Map<String, dynamic>;
              final sid = args['sessionId'] as String; // NUNCA puede ser null
              return MaterialPageRoute(
                builder: (_) => DatosProductorScreen(sessionId: sid),
              );
            }

            if (settings.name == '/session_summary') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder:
                    (_) => SessionSummaryScreen(
                      sessionId: args['session_id'],
                      sessionData: args['session_data'],
                    ),
              );
            }
            if (settings.name == '/edit_session') {
              final args = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => EditSessionScreen(sessionId: args),
              );
            }
            if (settings.name == '/news_detail') {
              final docId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => NewsDetailScreen(documentId: docId),
              );
            }

            return null;
          },
          home: SplashScreen(),
        );
      },
    );
  }
}
