import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:line_icons/line_icons.dart';

class DonutGraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: Text('Gráfico de Dona'),
  ),
  body: Center(
    child: Container(
      margin: EdgeInsets.only(top: 0), // Ajusta la cantidad de píxeles para mover la dona hacia arriba
      child: PieChart(
        PieChartData(
          sections: getData(),
          sectionsSpace: 0,
          centerSpaceRadius: 110,
        ),
      ),
    ),
  ),
);
  }

  List<PieChartSectionData> getData() {
    return [
      PieChartSectionData(
  color: const Color(0xff0293ee),
  value: 12.5,
  title: 'Luz\n12.5%',
  radius: 90,
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50), // Ajusta la cantidad de píxeles para mover el icono hacia abajo
    child: Icon(
      LineIcons.lightbulb,
      color: Colors.white,
    ),
  ),
),
PieChartSectionData(
  color: const Color(0xfff8b250),
  value: 12.5,
  title: 'Agua\n12.5%',
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50), // Ajusta la cantidad de píxeles para mover el icono hacia abajo
    child: Icon(
      LineIcons.tint,
      color: Colors.white,
    ),
  ),
  radius: 90,
),
      PieChartSectionData(
       color: const Color(0xff845bef),
       value: 12.5,
       title: 'Internet\n12.5%',
       radius: 90,
        badgeWidget: Container(
         margin: EdgeInsets.only(top: 50),  // Ajusta la cantidad de píxeles para mover el icono hacia abajo
          child: Icon(
           LineIcons.wifi,
         color: Colors.white,
           ),
         ),
      ),
      PieChartSectionData(
  color: const Color(0xff13d38e),
  value: 12.5,
  title: 'Alimentos\n12.5%',
  radius: 90,
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50),
    child: Icon(
      LineIcons.pizzaSlice,
      color: Colors.white,
    ),
  ),
),
PieChartSectionData(
  color: const Color(0xff845bef),
  value: 12.5,
  title: 'Muebles\n12.5%',
  radius: 90,
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50),
    child: Icon(
      LineIcons.couch,
      color: Colors.white,
    ),
  ),
),
PieChartSectionData(
  color: const Color(0xffee9333),
  value: 12.5,
  title: 'Electrodomésticos\n12.5%',
  radius: 90,
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50),
    child: Icon(
      LineIcons.television,
      color: Colors.white,
    ),
  ),
),
PieChartSectionData(
  color: const Color(0xff29c7ac),
  value: 12.5,
  title: 'Videojuegos\n12.5%',
  radius: 90,
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50),
    child: Icon(
      LineIcons.gamepad,
      color: Colors.white,
    ),
  ),
),
PieChartSectionData(
  color: Color.fromARGB(255, 6, 236, 98),
  value: 12.5,
  title: 'Otros\n12.5%',
  badgeWidget: Container(
    margin: EdgeInsets.only(top: 50),
    child: Icon(
      LineIcons.shoppingCart,
      color: Colors.white,
    ),
  ),
  radius: 90,
),
    ];
  }
}