import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/models/details.dart';
import 'package:mimonedero/models/ingreso.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class BalanceView extends StatefulWidget {
  final List<Balance> balances;

  BalanceView({required this.balances, required double currentBalance, required List payment});

  @override
  _BalanceViewState createState() => _BalanceViewState();
}



class _BalanceViewState extends State<BalanceView> {
   List<Balance>? _balances;
   List<Payment>? _payments;

  @override
  void initState() {
    super.initState();
    _balances = widget.balances; // Initialize _balances with the passed balances
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final deposits = await BalanceDatabase.instance.getAllBalances();
    final payments = await PaymentDatabase.instance.getAllPayments();

    setState(() {
      _balances = deposits;
      _payments = payments;
    });
  }

  Future<void> generateAndDownloadPDF() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                text: 'Reporte de Ingresos y Pagos',
              ),
             
              // Loop through balances and payments and add them to the PDF
              for (final balance in _balances!) pw.Text('Ingreso: \$${balance.amount.toStringAsFixed(2)}'),
              for (final payment in _payments!) pw.Text('Pago: -\$${payment.amount.toStringAsFixed(2)} - Categoria: ${payment.category} - Tipo: ${payment.type} - Fecha: ${payment.date}'),
            ],
          );
        },
      ),
    );

    // Save the PDF to a file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/income_payments_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF using a PDF viewer (You can implement a PDF viewer using a package like 'flutter_pdfview')
    // For downloading, you can use the 'open_file' package.
    OpenFile.open(file.path);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Ingresos y Pagos'),
      ),
      body: ListView.builder(
 itemCount: (_balances?.length ?? 0) + (_payments?.length ?? 0),
  itemBuilder: (context, index) {
    if (index < (_balances?.length ?? 0)) {
      final balance = _balances?[index];
      if (balance != null) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(balance),
              ),
            );
          },
          child: ListTile(
            title: Text('Ingreso: \$${balance.amount.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.green))
          ),
        );
      }
    } else {
      final payment = _payments?[index - (_balances?.length ?? 0)];
      if (payment != null) {
        return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailScreen(payment),
            ),
          );
        },
   child: ListTile(
              title: Text('Pago: -\$${payment.amount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.red)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fecha: ${payment.date}'),
                  Text('Categoría: ${payment.category}'),
                  Text('Tipo: ${payment.type}'),
                ],
              ),
            ),
      );
      }
    }
  },
  
),
  floatingActionButton: FloatingActionButton(
        onPressed: generateAndDownloadPDF,
        child: Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}