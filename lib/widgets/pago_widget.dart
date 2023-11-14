import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:mimonedero/widgets/filtro_numerico.dart';

class PaymentWidget extends StatefulWidget {
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  var _controller = TextEditingController();
  double paymentAmount = 0.0;
  String selectedCategory = 'Alimentos'; // Default category
  String selectedPaymentType = 'Compras';

  @override
  Widget build(BuildContext context) {
    return Column(
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
            //Texto aquí
            controller: _controller,
            inputFormatters: [MyFilter()],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                paymentAmount = double.tryParse(value) ?? 0.0;
              });
            },
          ),
        ),
        DropdownButton<String>(
          value: selectedPaymentType,
          items: <String>['Compras', 'Servicios']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedPaymentType = newValue!;
              selectedCategory =
                  (selectedPaymentType == 'Compras') ? 'Alimentos' : 'Luz';
            });
          },
        ),
        if (selectedPaymentType == 'Compras')
          DropdownButton<String>(
            value: selectedCategory,
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
              // Add more items as needed
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
          ),
        if (selectedPaymentType == 'Servicios')
          DropdownButton<String>(
            value: selectedCategory,
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
              // Add more items as needed
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
          ),
        ElevatedButton(
          onPressed: () {
            _controller.clear();
            if (paymentAmount > 0) {
              makePayment(paymentAmount, selectedCategory);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pago realizado con éxito.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ingrese un monto válido.'),
                ),
              );
            }
            //Limpiar el campo de texto y cerrar el teclado numérico
          },
          child: Text('Confirmar Pago'),
          style: ElevatedButton.styleFrom(
            primary: Colors.deepOrange,
          ),
        ),
      ],
    );
  }

  void makePayment(double amount, String category) async {
    final newPayment = Payment(
      amount: amount,
      date: DateTime.now().toString(),
      category: selectedPaymentType,
      type: category,
    );
    final insertedId = await PaymentDatabase.instance.insertPayment(newPayment);
    if (insertedId != null) {
      // Handle successful payment insertion
    } else {
      // Handle the case where payment insertion failed
    }
  }
}
