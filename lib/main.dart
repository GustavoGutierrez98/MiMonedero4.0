import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mimonedero/login_widget.dart';
import 'package:mimonedero/models/ingreso.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:mimonedero/models/pantalla_principal.dart';
import 'package:mimonedero/utils.dart';
import 'package:timezone/data/latest.dart' as tzdata;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('drawable/mimonedero');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tzdata.initializeTimeZones();

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static const String title = 'Setup Firebase';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainPage(),
        routes: {
          'home': (_) => HomePage(),
          'ingreso': (_) => IngresoDinero(),
          'pago': (_) => VentanaPago(),
        },
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Algo salio mal!'));
            } else if (snapshot.hasData) {
              // return IngresoDinero();
              return const HomePage();
            } else {
              return const LoginWidget();
            }
          }));
}