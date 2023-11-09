import 'package:flutter/material.dart';
import 'package:mimonedero/models/balance_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simula una pausa de 2 segundos antes de navegar a la ventana BalanceView
    Future.delayed(const Duration(seconds: 2), () {
      // Navega a la ventana BalanceView
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BalanceView(balances: [], currentBalance: 0, payment: [],),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Color de fondo de la pantalla de carga
      body: Center(
        child: CircularProgressIndicator(
           valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange), // Cambia el color del círculo de carga a naranja.
        ), // Indicador de carga
      ),
    );
  }
}