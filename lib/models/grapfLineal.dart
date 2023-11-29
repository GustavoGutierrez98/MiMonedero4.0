import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/models/ingreso.dart';
import 'package:mimonedero/widgets/lineal.dart';

class GraficaLineal extends StatefulWidget {
  @override
  _GraficaLinealState createState() => _GraficaLinealState();
}

class _GraficaLinealState extends State<GraficaLineal> {
  late List<Balance> _balances;

  @override
  void initState() {
    super.initState();
    _loadBalances();
  }

  Future<void> _loadBalances() async {
    final balances = await BalanceDatabase.instance.getAllBalances();
    setState(() {
      _balances = balances;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica Lineal'),
        backgroundColor: Colors.deepOrange,
      ),
      body: _balances != null
          ? LinealCharts(balances: _balances)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
