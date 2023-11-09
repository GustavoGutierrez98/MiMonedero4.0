import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/widgets/navbar.dart'; // Import the database class
import 'package:mimonedero/widgets/filtro_numerico.dart';

class VentanaPago extends StatefulWidget {
  @override
  _VentanaPagoState createState() => _VentanaPagoState();
}

class Payment {
  final int? id;
  final double amount;
  final String date;
  final String category;
  final String type;

  Payment({
    this.id,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'category': category,
      'type': type,
    };
  }
}

class _VentanaPagoState extends State<VentanaPago> {
  double paymentAmount = 0.0;
  String selectedCategory = 'Compras'; // Default category
  String selectedPaymentType = 'Compras';
  String ddb1 = "Alimentos";
  String ddb2 = "Luz";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Realizar Pago'),
      ),
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ingrese el monto del pago:',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                inputFormatters: [MyFilter()],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  paymentAmount = double.tryParse(value) ?? 0.0;
                },
              ),
            ),
            DropdownButton<String>(
              value: selectedPaymentType,
              items: <String>['Compras', 'Servicios'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentType = newValue!;
                });
              },
            ),
            if (selectedPaymentType == 'Compras')
              DropdownButton<String>(
                value: ddb1,
                items: <DropdownMenuItem<String>>[
                  
                  DropdownMenuItem<String>(
                    value: 'Alimentos',
                    child: Text('Alimentos'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Muebles',
                    child: Text('Muebles'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Electrodomésticos',
                    child: Text('Electrodomésticos'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Videojuegos',
                    child: Text('Videojuegos'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Otros',
                    child: Text('Otros'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            if (selectedPaymentType == 'Servicios')
              DropdownButton<String>(
                value: ddb2,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: 'Luz',
                    child: Text('Luz'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Agua',
                    child: Text('Agua'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Internet',
                    child: Text('Internet'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Cable',
                    child: Text('Cable'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Otros2',
                    child: Text('Otros'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ElevatedButton(
              onPressed: () {
                if (paymentAmount > 0) {
                  makePayment(paymentAmount, selectedCategory);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pago realizado con éxito.'),
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ingrese un monto válido.'),
                    ),
                  );
                }
              },
              child: Text('Confirmar Pago'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void makePayment(double amount, String category) async {
    final newPayment = Payment(
        amount: amount,
        date: DateTime.now().toString(),
        category: selectedCategory,
        type: selectedPaymentType);
    final insertedId = await PaymentDatabase.instance.insertPayment(newPayment);
    if (insertedId != null) {
      // Handle successful payment insertion
    } else {
      // Handle the case where payment insertion failed
    }
  }
}
