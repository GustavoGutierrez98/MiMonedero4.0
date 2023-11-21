import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:line_icons/line_icons.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:mimonedero/widgets/graficalineal.dart';

class DonutGraphPage extends StatefulWidget {
  @override
  _DonutGraphPageState createState() => _DonutGraphPageState();
}

class _DonutGraphPageState extends State<DonutGraphPage> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gráficos'),
        ),
        body: Container(
          child: _buildDonutChart(),
        )
        /*
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: Center(
              child: IconButton(
                icon: _isExpanded
                    ? Icon(Icons.pie_chart)
                    : Icon(Icons.show_chart),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
          ),
          if (_isExpanded)
            Expanded(
              child:
                  _buildDonutChart(), // Mostrar la gráfica de dona cuando está expandido
            ),
        ],
      ),*/
        );
  }

  Widget _buildDonutChart() {
    return FutureBuilder<List<PieChartSectionData>>(
      future: fetchUserPaymentHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return PieChart(
            PieChartData(
              sections: snapshot.data!,
              sectionsSpace: 0,
              centerSpaceRadius: 75,
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

Future<List<PieChartSectionData>> fetchUserPaymentHistory() async {
  // Replace this with the actual method to fetch the user's payment history
  // You should retrieve payment data and calculate percentages based on payment types
  List<Payment> userPayments = await PaymentDatabase.instance.getAllPayments();

  Map<String, double> paymentTypeCounts = Map<String, double>();

  // Calculate the count for each payment type
  userPayments.forEach((payment) {
    paymentTypeCounts.update(payment.type, (value) => value + 1,
        ifAbsent: () => 1);
  });

  // Calculate the total count of payments
  double totalCount = userPayments.length.toDouble();

  // Calculate percentages
  List<PieChartSectionData> sections = paymentTypeCounts.entries
      .map((entry) => PieChartSectionData(
            color: getColorForPaymentType(entry.key),
            value: entry.value / totalCount * 100,
            title:
                '${entry.key}\n${(entry.value / totalCount * 100).toStringAsFixed(1)}%',
            radius: 90,
            badgeWidget: Container(
              margin: EdgeInsets.only(top: 50),
              child: getIconForPaymentType(entry.key),
            ),
          ))
      .toList();

  return sections;
}

Color getColorForPaymentType(String paymentType) {
  // Define colors for different payment types
  // Add more cases if needed
  switch (paymentType) {
    case 'Videojuegos':
      return Colors.deepPurple;
    case 'Electrodomésticos':
      return const Color.fromARGB(255, 243, 33, 33);
    case 'Alimentos':
      return Colors.orange;
    case 'Internet':
      return Colors.purple;
    case 'Luz':
      return Colors.green;
    case 'Agua':
      return const Color.fromARGB(255, 39, 166, 229);
    case 'Muebles':
      return Colors.yellow;
    case 'Cable':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}

Widget getIconForPaymentType(String paymentType) {
  // Define icons for different payment types
  // Add more cases if needed
  switch (paymentType) {
    case 'Videojuegos':
      return Icon(LineIcons.gamepad, color: Colors.white);
    case 'Electrodomésticos':
      return Icon(LineIcons.television, color: Colors.white);
    case 'Alimentos':
      return Icon(LineIcons.pizzaSlice, color: Colors.white);
    case 'Internet':
      return Icon(LineIcons.wifi, color: Colors.white);
    case 'Luz':
      return Icon(LineIcons.lightbulb, color: Colors.white);
    case 'Agua':
      return Icon(LineIcons.tint, color: Colors.white);
    case 'Muebles':
      return Icon(LineIcons.couch, color: Colors.white);
    case 'Cable':
      return Icon(LineIcons.television, color: Colors.white);
    default:
      return Icon(LineIcons.questionCircle, color: Colors.white);
  }
}
