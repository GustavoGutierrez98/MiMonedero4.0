import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/models/ingreso.dart';
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
  double currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCurrentBalance();
  }

  // Método para obtener el saldo actual
  void fetchCurrentBalance() async {
    List<Balance> balances = await BalanceDatabase.instance.getAllBalances();
    double totalBalance = 0.0;

    for (Balance balance in balances) {
      totalBalance += balance.amount;
    }

    setState(() {
      currentBalance = totalBalance;
    });
  }

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
            items: const <DropdownMenuItem<String>>[
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
                value: 'VideoJuegos',
                child: Text('VideoJuegos'),
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
              DropdownMenuItem<String>(
                value: 'Cable',
                child: Text('Cable'),
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

            if (paymentAmount > 0 &&
                paymentAmount <= currentBalance &&
                currentBalance > 0) {
              makePayment(paymentAmount, selectedCategory);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pago realizado con éxito.'),
                ),
              );
            } else if (paymentAmount > currentBalance && currentBalance == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('No puedes realizar el pago. Tu saldo actual es 0.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ingrese un monto válido que no exceda su saldo disponible.',
                  ),
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
    );
  }

  void makePayment(double amount, String category) async {
    final newPayment = Payment(
      amount: amount,
      date: DateTime.now().toString(),
      category: selectedPaymentType, // Define or replace selectedPaymentType
      type: category,
    );

    final insertedId = await PaymentDatabase.instance.insertPayment(newPayment);

    if (insertedId != null) {
      // Puedes agregar lógica adicional aquí según tus necesidades
      print('Pago realizado con éxito. ID de pago: $insertedId');
    } else {
      // Puedes manejar el caso donde la inserción del pago falla
      print('Error al realizar el pago. Por favor, inténtalo de nuevo.');
      // Puedes agregar más lógica aquí según tus necesidades
    }
  }
}
