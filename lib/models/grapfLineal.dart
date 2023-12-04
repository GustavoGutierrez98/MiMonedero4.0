import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/models/ingreso.dart';
import 'package:mimonedero/widgets/lineal.dart';

class GraficaLineal extends StatefulWidget {
  @override
  _GraficaLinealState createState() => _GraficaLinealState();
}

class _GraficaLinealState extends State<GraficaLineal> {
  late Future<List<Balance>> _balancesFuture;

  @override
  void initState() {
    super.initState();
    _balancesFuture = _loadBalances();
  }

  Future<List<Balance>> _loadBalances() async {
    final balances = await BalanceDatabase.instance.getAllBalances();
    return balances;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica Lineal'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder(
        future: _balancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los balances'),
            );
          } else {
            List<Balance> balances = snapshot.data as List<Balance>;
            return LinealCharts(balances: balances);
          }
        },
      ),
    );
  }
}
