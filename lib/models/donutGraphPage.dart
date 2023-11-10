import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class donutGraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gráfico de Dona'),
        ),
        body: Center(
          child: SfCircularChart(
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: getData(),
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                //innerRadius: '50%', // para darle un espacio en blanco al centro
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChartData> getData() {
    return [
      ChartData('Luz', 15),
      ChartData('Agua', 10),
      ChartData('Internet', 8),
      ChartData('Alimentos', 12),
      ChartData('Muebles', 10),
      ChartData('Electrodomésticos', 7),
      ChartData('Videojuegos', 5),
      ChartData('Otros', 33),
    ];
  }
}

class ChartData {
  ChartData(this.category, this.value);

  final String category;
  final double value;
}
