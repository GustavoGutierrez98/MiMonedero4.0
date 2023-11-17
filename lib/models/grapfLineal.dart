import 'package:flutter/material.dart';
import 'package:mimonedero/models/ingreso.dart';
import 'package:mimonedero/widgets/lineal.dart';

class GraficaLineal extends StatelessWidget {
  final List<Balance> _balances = [
    // inicializa tu lista de balances aquí según tus necesidades
  ];

   GraficaLineal({Key? key, required List<Balance> balances}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LinealCharts(balances: _balances),
    );
  }
}
