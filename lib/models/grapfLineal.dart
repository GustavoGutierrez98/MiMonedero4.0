import 'package:flutter/material.dart';
import 'package:mimonedero/widgets/lineal.dart';


class GraficaLineal extends StatelessWidget {
  const GraficaLineal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Grafo lineal'),
        ),
        body: const LinealCharts()

    );
  }
}