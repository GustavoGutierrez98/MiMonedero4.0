import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;

class LinealCharts extends StatelessWidget {
  const LinealCharts({Key? key}) : super(key: key);

  static String? pointerAmount;
  static String? pointerDay;

  @override
  Widget build(BuildContext context) {
    
    final data = [
      Expenses(2, 120),
      Expenses(3, 218),
      Expenses(4, 95),
      Expenses(5, 360),
    ];
     
     List<charts.Series<Expenses, int>> series = [
      charts.Series<Expenses, int>(
       id: 'Lineal',
       domainFn: (v,i) => v.day,
       measureFn: (v,i) => v.expense,
       data: data
      )
      ];


    return Center(
      child: SizedBox(
        height: 350.0,
        child: charts.LineChart(
          series,
          selectionModels: [
            charts.SelectionModelConfig(
              changedListener: (charts.SelectionModel model){
                if(model.hasDatumSelection){
                   pointerAmount = model.selectedSeries[0]
                   .measureFn(model.selectedDatum[0].index)
                   ?.toStringAsFixed(2);
                   pointerDay = model.selectedSeries[0]
                   .domainFn(model.selectedDatum[0].index)
                   ?.toString();
                }
              }
            )
          ],
          behaviors: [
            charts.LinePointHighlighter(
              symbolRenderer: MySymbolRenderer()
            )
          ],
        ),
      ),
    );
  }
}

class MySymbolRenderer extends charts.CircleSymbolRenderer{
  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, 
    {
    List<int>? dashPattern, 
    charts.Color? fillColor, 
    charts.FillPatternType? fillPattern, 
    charts.Color? strokeColor, 
    double? strokeWidthPx
   }) {
    
    super.paint(
      canvas, 
      bounds, 
      dashPattern: dashPattern,  
      fillColor: fillColor,  
      fillPattern: fillPattern,  
      strokeColor: strokeColor, 
      strokeWidthPx: strokeWidthPx
    );

    canvas.drawRect(
      Rectangle(
        bounds.left - 25,
        bounds.top - 35,
        bounds.width +48,
        bounds.height +18

      ),
      fill: charts.ColorUtil.fromDartColor(Colors.orange),
      stroke: charts.ColorUtil.fromDartColor(Colors.black),
      strokeWidthPx: 1
    );

    var myStyle = styles.TextStyle();
    myStyle.fontSize = 10;

    canvas.drawText(
      elements.TextElement(
        'Dia ${LinealCharts.pointerDay} \n ${LinealCharts.pointerAmount}',
        style: myStyle
      ),
      (bounds.left -20).round(),
      (bounds.top -30).round(),
    );
  }
}

class Expenses {
  final int day;
  final double expense;

  Expenses(this.day, this.expense);
}