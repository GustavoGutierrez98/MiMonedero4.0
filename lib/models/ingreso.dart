import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/widgets/autoDrawer.dart';
import 'package:mimonedero/widgets/filtro_numerico.dart';
import 'package:mimonedero/widgets/navbar.dart';
import 'package:mimonedero/widgets/splash_screen.dart';
// ignore: unused_import
import 'balance_view.dart';

List<Balance> _balances = [];

class IngresoDinero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Mi Monedero Virtual'),
      ),
      endDrawer: autoDrawer(),
      body: MiCartera(),
      bottomNavigationBar: NavBar(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Navegar a la vista del historial de transacciones (BalanceView)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
          );
        },
        child: Text('Dinero Depositado'),
        style: ElevatedButton.styleFrom(
          primary: Colors.deepOrange,
        ),
      ),
    );
  }
}

class Balance {
  final int? id;
  final double amount;
  final String date;

  Balance({
    this.id,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
    };
  }
}

class MiCartera extends StatefulWidget {
  @override
  _MiCarteraState createState() => _MiCarteraState();
}

class _MiCarteraState extends State<MiCartera> {
  double balance = 0.0; // El saldo inicial

  // Función para agregar dinero al monedero
  void depositMoney(double amount) async {
    final newBalance = Balance(amount: amount, date: DateTime.now().toString());
    final insertedId = await BalanceDatabase.instance.insertBalance(newBalance);

    if (insertedId != null) {
      setState(() {
        balance += amount;
        _balances.add(newBalance);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bank2.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Ingrese Saldo:',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .deepOrange, // Establecer el color de fondo a naranja
                ),
                onPressed: () {
                  // cuadro de diálogo para ingresar la cantidad a depositar
                  // Luego, llama a la función depositMoney para actualizar el saldo.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      double amount = 0.0;
                      return AlertDialog(
                        title: Text('Depositar Dinero'),
                        content: TextField(
                          inputFormatters: [MyFilter()],
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            amount = double.tryParse(value) ?? 0.0;
                          },
                        ),
                        actions: <Widget>[
                          // Boton cancelar ventana emergente
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            // Boton para depositar ingreso
                            child: Text('Depositar'),
                            onPressed: () {
                              depositMoney(amount);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Depositar Dinero'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Guardar el saldo actual en una variable
                  final double currentBalance = balance;

                  // Navegar a la vista del historial de transacciones (BalanceView) con el saldo actual
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BalanceView(
                        balances: _balances,
                        currentBalance: currentBalance,
                        payment: [],
                      ),
                    ),
                  );
                },
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                ),
              ),

              //Aquí sí funciona, lmao. El widtet de alineación no funciona porque está dentro de una columna, no al final del Scaffold
            ],
          ),
        ),
      ),
    );
  }
}
