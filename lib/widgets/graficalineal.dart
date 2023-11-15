import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: charts.LineChart(
            _createSampleData(),
            defaultRenderer: charts.LineRendererConfig(
              includePoints: true,
            ),
            animate: true,
            animationDuration: Duration(seconds: 1),
          ),
        ),
      ),
    );
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 2),
      LinearSales(1, 1),
      LinearSales(2, 4),
      LinearSales(4, 2),
      LinearSales(5, 5),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
