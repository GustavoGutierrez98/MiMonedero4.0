import 'package:flutter/material.dart';
import 'package:mimonedero/widgets/navbar.dart';
import 'package:mimonedero/widgets/pago_widget.dart';
import 'package:mimonedero/widgets/splash_screen.dart'; // Import the database class

class Payment {
  final int? id;
  final double amount;
  final String date;
  final String category;
  final String type;

  Payment({
    this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'category': category,
      'type': type,
    };
  }
  int get year => DateTime.parse(date).year;
  int get month => DateTime.parse(date).month;
}

class VentanaPago extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Realizar Pago'),
      ),
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: PaymentWidget(),
      ),
      floatingActionButton: ElevatedButton(
  onPressed: () {
    // Navegar a la vista del historial de transacciones (BalanceView)
    Navigator.push(
  context,
  MaterialPageRoute(
     builder: (context) => SplashScreen(),
  ),
);
  },
  child: Text('Pagos e Ingresos'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepOrange, 
  ),
),
    );
  }
}