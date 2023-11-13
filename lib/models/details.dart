import 'package:flutter/material.dart';
import 'package:mimonedero/models/ingreso.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:mimonedero/widgets/autoDrawer.dart';

class TransactionDetailScreen extends StatelessWidget {
  final dynamic transaction;

  TransactionDetailScreen(this.transaction);
 

  @override
  Widget build(BuildContext context) {
     String title = '';
    String amount = '';
    String category = '' ;
    String date = '';

    if (transaction is Balance) {
      final balance = transaction as Balance;
      title = 'Ingreso';
      amount = 'Ingreso: \$${(balance.amount).toStringAsFixed(2)}';
      date = 'Fecha: ${balance.date}';
    } else if (transaction is Payment) {
      final payment = transaction as Payment;
      title = 'Pago';
      amount = 'Pago: -\$${(payment.amount).toStringAsFixed(2)}';
      date = 'Fecha: ${payment.date}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del $title'),
      ),
      endDrawer: autoDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(amount, style: TextStyle(color: transaction is Balance ? Colors.green : Colors.red)),
            if (category != null) Text(category),
            Text(date),
          ],
        ),
      ),
    );
  }
}
