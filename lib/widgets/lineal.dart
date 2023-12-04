import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;
import 'package:mimonedero/models/ingreso.dart';
import 'package:intl/intl.dart';

class LinealCharts extends StatelessWidget {
  final List<Balance> balances;

  const LinealCharts({Key? key, required this.balances}) : super(key: key);

  static String? pointerAmount;
  static String? pointerDay;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Balance, DateTime>> series = [
      charts.Series<Balance, DateTime>(
        id: 'Lineal',
        domainFn: (balance, _) => DateTime.parse(balance.date),
        measureFn: (balance, _) => balance.amount,
        data: balances,
      )
    ];

    return Center(
      child: SizedBox(
        height: 350.0,
        child: charts.TimeSeriesChart(
          series,
          selectionModels: [
            charts.SelectionModelConfig(
              changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection) {
                  pointerAmount = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index)
                      ?.toStringAsFixed(2);
                  pointerDay = model.selectedSeries[0]
                      .domainFn(model.selectedDatum[0].index)
                      ?.toString();
                }
              },
            )
          ],
          behaviors: [
            charts.LinePointHighlighter(symbolRenderer: MySymbolRenderer()),
          ],
        ),
      ),
    );
  }
}

class MySymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int>? dashPattern,
    charts.Color? fillColor,
    charts.FillPatternType? fillPattern,
    charts.Color? strokeColor,
    double? strokeWidthPx,
  }) {
    super.paint(
      canvas,
      bounds,
      dashPattern: dashPattern,
      fillColor: fillColor,
      fillPattern: fillPattern,
      strokeColor: strokeColor,
      strokeWidthPx: strokeWidthPx,
    );

    // Extracting date and time separately
    DateTime selectedDate = LinealCharts.pointerDay != null
        ? DateTime.parse(LinealCharts.pointerDay!)
        : DateTime.now();

    String formattedDate = DateFormat.yMd().format(selectedDate);
    String formattedTime = DateFormat.Hm().format(selectedDate);

    // Displaying the separated date and time in the tooltip
    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawRect(
      Rectangle(
        bounds.left - 25,
        bounds.top - 35,
        bounds.width + 80,
        bounds.height + 30,
      ),
      fill: charts.ColorUtil.fromDartColor(Colors.deepOrange),
      stroke: charts.ColorUtil.fromDartColor(Colors.black),
      strokeWidthPx: 1,
    );

    canvas.drawText(
      elements.TextElement(
        'Fecha: $formattedDate\nHora: $formattedTime\nMonto: ${LinealCharts.pointerAmount}',
        style: myStyle,
      ),
      (bounds.left - 20).round(),
      (bounds.top - 30).round(),
    );
  }
}

class Expenses {
  final int day;
  final double expense;

  Expenses(this.day, this.expense);
}
